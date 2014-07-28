Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaG1Mb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaG1MbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:31:25 -0400
Message-ID: <53D6425B.40009@redhat.com>
Date: Mon, 28 Jul 2014 14:30:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Drysdale <drysdale@google.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <871tt796i0.fsf@x220.int.ebiederm.org>
In-Reply-To: <871tt796i0.fsf@x220.int.ebiederm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2014 23:04, Eric W. Biederman ha scritto:
>> The most significant aspect of Capsicum is associating *rights* with
>> (some) file descriptors, so that the kernel only allows operations on an
>> FD if the rights permit it.  This allows userspace applications to
>> sandbox themselves by tightly constraining what's allowed with both
>> input and outputs; for example, tcpdump might restrict itself so it can
>> only read from the network FD, and only write to stdout.
>>
>> The kernel thus needs to police the rights checks for these file
>> descriptors (referred to as 'Capsicum capabilities', completely
>> different than POSIX.1e capabilities), and the best place to do this is
>> at the points where a file descriptor from userspace is converted to a
>> struct file * within the kernel.
>>
>>   [Policing the rights checks anywhere else, for example at the system
>>   call boundary, isn't a good idea because it opens up the possibility
>>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>>   changed (as openat/close/dup2 are allowed in capability mode) between
>>   the 'check' at syscall entry and the 'use' at fget() invocation.]
>>
>> However, this does lead to quite an invasive change to the kernel --
>> every invocation of fget() or similar functions (fdget(),
>> sockfd_lookup(), user_path_at(),...) needs to be annotated with the
>> rights associated with the specific operations that will be performed on
>> the struct file.  There are ~100 such invocations that need
>> annotation.
> 
> And it is silly.  Roughly you just need a locking version of
> fcntl(F_SETFL).
> 
> That is make the restriction in the struct file not in the fd to file
> lookup.

No, they have to be in the file descriptor.  The same file descriptor
can be dup'ed and passed with different capabilities to different processes.

Say you pass an eventfd to a process with SCM_RIGHTS, and you want to
only allow the process to write to it.

>> 4) New System Calls
>> -------------------
>>
>> To allow userspace applications to access the Capsicum capability
>> functionality, I'm proposing two new system calls: cap_rights_limit(2)
>> and cap_rights_get(2).  I guess these could potentially be implemented
>> elsewhere (e.g. as fcntl(2) operations?) but the changes seem
>> significant enough that new syscalls are warranted.
>>
>>   [FreeBSD 10.x actually includes six new syscalls for manipulating the
>>   rights associated with a Capsicum capability -- the capability rights
>>   can police that only specific fcntl(2) or ioctl(2) commands are
>>   allowed, and FreeBSD sets these with distinct syscalls.]
> 
> ioctls?  In a sandbox?  Ick.

KVM?  X11?  Both of them use loads of ioctls.  I'm less sure of the
benefit of picking which fcntls to allow.

Paolo

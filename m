Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaGDHDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaGDHDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:03:48 -0400
Message-ID: <53B651C5.80602@redhat.com>
Date: Fri, 04 Jul 2014 09:03:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>
CC: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <53B51E81.4090700@redhat.com> <20140703183927.GA1629@google.com>
In-Reply-To: <20140703183927.GA1629@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il 03/07/2014 20:39, David Drysdale ha scritto:
> On Thu, Jul 03, 2014 at 11:12:33AM +0200, Paolo Bonzini wrote:
>> Given Linux's previous experience with BPF filters, what do you
>> think about attaching specific BPF programs to file descriptors?
>> Then whenever a syscall is run that affects a file descriptor, the
>> BPF program for the file descriptor (attached to a struct file* as
>> in Capsicum) would run in addition to the process-wide filter.
>
> That sounds kind of clever, but also kind of complicated.
>
> Off the top of my head, one particular problem is that not all
> fd->struct file conversions in the kernel are completely specified
> by an enclosing syscall and the explicit values of its parameters.
>
> For example, the actual contents of the arguments to io_submit(2)
> aren't visible to a seccomp-bpf program (as it can't read the __user
> memory for the iocb structures), and so it can't distinguish a
> read from a write.

I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
/O_RDWR.   You could do it by running the file descriptor's seccomp-bpf 
program once per iocb with synthesized syscall numbers and argument 
vectors.

BTW, there's one thing I'm not sure I understand (because my knowledge 
of VFS is really only cursory).  Are the capabilities associated to the 
file _descriptor_ (a la F_GETFD/SETFD) or _description_ 
(F_GETFL/SETFL)?!?

If it is the former, there is some value in read/write capabilities 
because you could for example block a child process from reading an 
eventfd and simulate the two file descriptors returned by pipe(2).  But 
if it is the latter, it looks like an important usability problem in 
the Capsicum model.  (Granted, it's just about usability---in the end 
it does exactly what it's meant and documented to do).

> Also, there could potentially be some odd interactions with file
> descriptors passed between processes, if the BPF program relies
> on assumptions about the environment of the original process.  For
> example, what happens if an x86_64 process passes a filter-attached
> FD to an ia32 process?  Given that the syscall numbers are
> arch-specific, I guess that means the filter program would have
> to include arch-specific branches for any possible variant.

This is the same for using seccompv2 to limit child processes, no?  So 
there may be a problem but it has to be solved anyway by libseccomp.

> More generally, I suspect that keeping things simpler will end
> up being more secure.  Capsicum was based on well-studied ideas
> from the world of object capability-based security, and I'd be
> nervous about adding complications that take us further away from
> that.

True.

> That mapping would also need be kept closely in sync with the kernel
> and other system libraries -- if a new syscall is added and libc (or
> some other library) started using it, the equivalent BPF chunks would
> need to be updated to cope.

Again, this is the same problem that has to be solved for process-wide 
seccompv2.

>>>  [Capsicum also includes 'capability mode', which locks down the
>>>  available syscalls so the rights restrictions can't just be bypassed
>>>  by opening new file descriptors; I'll describe that separately later.]
>>
>> This can also be implemented in userspace via seccomp and
>> PR_SET_NO_NEW_PRIVS.
>
> Well, mostly (and in fact I've got an attempt to do exactly that at
> https://github.com/google/capsicum-test/blob/dev/linux-bpf-capmode.c).
>
> [..] there's one awkward syscall case.  In capability mode we'd like
> to prevent processes from sending signals with kill(2)/tgkill(2)
> to other processes, but they should still be able to send themselves
> signals.  For example, abort(3) generates:
>   tgkill(gettid(), gettid(), SIGABRT)
>
> Only allowing kill(self) is hard to encode in a seccomp-bpf program, at
> least in a way that survives forking.

I guess the thread id could be added as a special seccomp-bpf argument 
(ancillary datum?).

> Finally, capability mode also turns on strict-relative lookups
> process-wide; in other words, every openat(dfd, ...) operation
> acts as though it has the O_BENEATH_ONLY flag set, regardless of
> whether the dfd is a Capsicum capability.  I can't see a way to
> do that with a BPF program (although it would be possible to add
> a filter that polices the requirement to include O_BENEATH_ONLY
> rather than implicitly adding it).

That can be a new prctl (one that PR_SET_NO_NEW_PRIVS would lock up). 
It seems useful independent of Capsicum, and the Linux APIs tend to be 
fine-grained more often than coarse-grained.

>>>  [Policing the rights checks anywhere else, for example at the system
>>>  call boundary, isn't a good idea because it opens up the possibility
>>>  of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>>>  changed (as openat/close/dup2 are allowed in capability mode) between
>>>  the 'check' at syscall entry and the 'use' at fget() invocation.]
>>
>> In the case of BPF filters, I wonder if you could stash the BPF
>> "environment" somewhere and then use it at fget() invocation.
>> Alternatively, it can be reconstructed at fget() time, similar to
>> your introduction of fgetr().
>
> Stashing something at syscall entry to be referred to later always
> makes me worry about TOCTOU vulnerabilities, but the details might
> be OK in this case (given that no check occurs at syscall entry)...

Yeah, that was pretty much the idea.  But I was cautious enough to 
label it with "I wonder"...

Paolo

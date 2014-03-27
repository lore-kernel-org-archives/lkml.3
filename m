Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaC0NeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:34:00 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59320 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaC0Nd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:33:58 -0400
Message-ID: <533428BF.8090007@gmail.com>
Date: Thu, 27 Mar 2014 15:33:51 +0200
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Florian Weimer <fweimer@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Jim Lieb <jlieb@panasas.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net> <53342258.8000304@redhat.com>
In-Reply-To: <53342258.8000304@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 03:06 PM, Florian Weimer wrote:
> On 03/27/2014 02:02 PM, Jeff Layton wrote:
> 
>>> This interface does not address the long-term lack of POSIX
>>> compliance in setuid and friends, which are required to be
>>> process-global and not thread-specific (as they are on the kernel
>>> side).
>>>
>>> glibc works around this by reserving a signal and running set*id on
>>> every thread in a special signal handler.  This is just crass, and it
>>> is likely impossible to restore the original process state in case of
>>> partial failure.  We really need kernel support to perform the
>>> process-wide switch in an all-or-nothing manner.
>>>
>>
>> I disagree. We're treading new ground here with this syscall. It's
>> not defined by POSIX so we're under no obligation to follow its silly
>> directives in this regard. Per-process cred switching doesn't really
>> make much sense in this day and age, IMO. Wasn't part of the spec was
>> written before threading existed
> 
> Okay, then we need to add a separate set of system calls.
> 

separate set of system calls is exactly what we do not need. The syscalls
are all per thread.

What we do need is a new set of glibc APIs to follow what everyone
who cares does now. Because no body uses the current code - setuid
and friends - The huge majority of utilities are just single threaded
and could careless. The few threaded apps that do use setuid and friends
use the SYSCALL directly.

Both samba and Ganesha have their own define of setthread_uid/setthread_gid/
setthread_groops. and avoid glibc as a plague.

man setuid should be saying DEPRECATED, EMULATED and SIGNAL NOT SAFE
and be done with it POSIX or no POSIX who cares?

and a new well define set is to be defined by glibc implemented easily
not only on Linux (MACOX FreeBSD are the same as linux)

And that is that

> I really, really want to get rid of that signal handler mess in glibc, 
> with its partial failures.
> 

I would not spend one second on an API no one uses. As I said most
users are single threaded and could care less. Few threaded users
already do direct syscalls

>> The per-process credential switching is pretty universally a pain in
>> the ass for anyone who wants to write something like a threaded file
>> server. Jeremy Allison had to jump through some rather major hoops to
>> work around it for Samba [1]. I think we want to strive to make this a
>> per-task credential switch and ignore that part of the POSIX spec.
> 
> Yeah, I get that, setfsuid/setfsgid already behaves this way.
> 
> (Current directory and umask are equally problematic, but it's possible 
> to avoid most issues.)
> 
>> That said, I think we will need to understand and document what we
>> expect to occur if someone does this new switch_creds(fd) call and then
>> subsequently calls something like setuid(), if only to ensure that we
>> don't get blindsided by it.
> 
> Currently, from the kernel perspective, this is not really a problem 
> because the credentials are always per-task.  It's just that a 
> conforming user space needs the process-wide credentials.
> 

Please show me one user of that and declare it brain dead.
POSIX or not it just does not have any real programming mining
at all. Plain and simple. Even if you made  process-wide credentials
atomic it would still mean nothing.

That said. I second Jeff's point of Jim's implementation doing
all we really need. It is fast and simple and can give us all
we need and with a single added SYSCALL. The patch is already
out there. I thought it was even considered for inclusion through
Al viro.

Cheers
Boaz


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaC0NGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbaC0NGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:06:41 -0400
Message-ID: <53342258.8000304@redhat.com>
Date: Thu, 27 Mar 2014 14:06:32 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Andy Lutomirski <luto@amacapital.net>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net>
In-Reply-To: <20140327060225.4f4caa5a@ipyr.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 02:02 PM, Jeff Layton wrote:

>> This interface does not address the long-term lack of POSIX
>> compliance in setuid and friends, which are required to be
>> process-global and not thread-specific (as they are on the kernel
>> side).
>>
>> glibc works around this by reserving a signal and running set*id on
>> every thread in a special signal handler.  This is just crass, and it
>> is likely impossible to restore the original process state in case of
>> partial failure.  We really need kernel support to perform the
>> process-wide switch in an all-or-nothing manner.
>>
>
> I disagree. We're treading new ground here with this syscall. It's
> not defined by POSIX so we're under no obligation to follow its silly
> directives in this regard. Per-process cred switching doesn't really
> make much sense in this day and age, IMO. Wasn't part of the spec was
> written before threading existed

Okay, then we need to add a separate set of system calls.

I really, really want to get rid of that signal handler mess in glibc, 
with its partial failures.

> The per-process credential switching is pretty universally a pain in
> the ass for anyone who wants to write something like a threaded file
> server. Jeremy Allison had to jump through some rather major hoops to
> work around it for Samba [1]. I think we want to strive to make this a
> per-task credential switch and ignore that part of the POSIX spec.

Yeah, I get that, setfsuid/setfsgid already behaves this way.

(Current directory and umask are equally problematic, but it's possible 
to avoid most issues.)

> That said, I think we will need to understand and document what we
> expect to occur if someone does this new switch_creds(fd) call and then
> subsequently calls something like setuid(), if only to ensure that we
> don't get blindsided by it.

Currently, from the kernel perspective, this is not really a problem 
because the credentials are always per-task.  It's just that a 
conforming user space needs the process-wide credentials.

-- 
Florian Weimer / Red Hat Product Security Team

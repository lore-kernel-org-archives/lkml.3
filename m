Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbbACXGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 18:06:51 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46761 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbACXGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 18:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150103223644.GB27979@amd>
References: <20150102194616.GA27538@amd> <54A7103E.6020500@nod.at>
 <20150102222936.GA29018@amd> <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
 <20150102224646.GB29018@amd> <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
 <20150102225420.GC29018@amd> <54A72306.2050908@nod.at> <20150102230837.GA4482@amd>
 <54A7BA45.1050005@nod.at> <20150103223644.GB27979@amd>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 3 Jan 2015 15:06:27 -0800
Message-ID: <CALCETrWBHJ52YjowqJ7S90bXvkw_B1VxbkSDKpyjwC1WYvGE3w@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
To: Pavel Machek <pavel@ucw.cz>
Cc: Richard Weinberger <richard@nod.at>, Jiri Kosina <jkosina@suse.cz>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2015 at 2:36 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
>> >> No. This is not what this patch does.
>> >>
>> >>> But changing glibc to do sleep(30); abort(); instead of abort(); to
>> >>> slow down bruteforcing of canaries makes some kind of sense... and
>> >>> should be ok by default.
>> >>
>> >> As I saidn only focusing one the specific stack canary case is not enough.
>> >
>> > Ok, so I am now saying "adding random delays to the kernel, hoping
>> > they slow attacker down" is bad idea. Feel free to add my NAK to the
>> > patch.
>>
>> The patch does not add random delays nor is hope involved.
>>
>> It has a very clear purpose, it makes brute force attacks to forking
>> services unattractive.
>> Exploits often use the fact that after fork() the child has the same memory
>> as the parent and therefore an attacker can start fruitful brute force attacks
>> to brute stack canaries, offsets, etc. as the new child will always have mostly
>> the same memory layout as before.
>>
>> But I'll happily add your NAK to this series.
>
> Please do.
>
>> > If really neccessary, "kill_me_slowly()" syscall would be acceptable,
>> > but it seems just sleep(); abort(); combination is enough.
>>
>> The goal of the patch is not to protect only against brute forcing the stack canary.
>> It should protect against all kind of brute forcing using forking services.
>>
>> > glibc should cover 99% cases where this matters, please just fix glibc,
>> > others will follow.
>>
>> There are a lot of systems out there without glibc.
>
> Only "interesting" systems that are without glibc are androids, and
> they usually run very old kernels.
>
> If you implement sleep() in glibc, distros will enable it and you'll
> protect all the desktop users.

As an attempt to help end this particular line of debate: putting the
sleep in glibc won't work.  The point isn't to make the crashed
process crash more slowly; it's to limit the rate at which *new*
siblings can be forked and crashed as a canary or ASLR brute-force
probe.  IOW, adding a sleep call to glibc slows down the wrong thing.
Also, trying to get libc to take action on a plain old segfault is a
giant mess, because it involves mucking with signal handling, which
glibc really has no business doing by default.

Also, this patch is missing a bit, I think.  We really want to control
the total rate of crashes.  This patch imposes a delay per crash, but
AFAICS it would still be possible for an attacker to coerce a forking
server to fork, say, 10k children, then probe all of them, then wait
30 seconds and repeat.

--Andy

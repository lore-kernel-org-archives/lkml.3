Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaDBUFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:05:15 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39505 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaDBUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404022146530.14882@ionos.tec.linutronix.de>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org>
	<alpine.DEB.2.02.1404022146530.14882@ionos.tec.linutronix.de>
Date: Wed, 2 Apr 2014 22:05:12 +0200
Message-ID: <CAFLxGvyBgKQLvSUcbn3EqcEomUgY85PXJBM7JoMKiyizt66gYA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 9:50 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 2 Apr 2014, Andrew Morton wrote:
>> On Wed, 2 Apr 2014 14:42:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> > It has come to our attention that a system running a specific user
>> > space init program will not boot if you add "debug" to the kernel
>> > command line. What happens is that the user space tool parses the
>> > kernel command line, and if it sees "debug" it will spit out so much
>> > information that the system fails to boot. This basically renders the
>> > "debug" option for the kernel useless.
>> >
>> > This bug has been reported to the developers of said tool
>> > here:
>> >
>> >   https://bugs.freedesktop.org/show_bug.cgi?id=76935
>> >
>> > The response is:
>> >
>> > "Generic terms are generic, not the first user owns them."
>> >
>> > That is, the "debug" statement on the *kernel* command line is not
>> > owned by the kernel just because it was the first user of it, and
>> > they refuse to fix their bug.
>> >
>> > Well, my response is, we OWN the kernel command line, and as such, we
>> > can keep the users from seeing stuff on it if we so choose. And with
>> > that, I propose this patch, which hides "debug" from /proc/cmdline,
>> > such that we don't have to worry about tools parsing for it and causing
>> > hardship for those trying to debug the kernel.
>> >
>>
>> I had to check the date on this but surprisingly, it's all post
>> April 1.
>>
>> --- a/fs/read_write.c~a
>> +++ a/fs/read_write.c
>> @@ -513,6 +513,8 @@ SYSCALL_DEFINE3(read, unsigned int, fd,
>>       struct fd f = fdget_pos(fd);
>>       ssize_t ret = -EBADF;
>>
>> +     BUG_ON(!strcmp(current->comm, "systemd"));
>
> Can we make that strncmp(current->comm, "systemd", 7) please? So we
> catch the systemd-xxx stuff as well!
>
> Otherwise Acked-by-me
>
>           tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

While we are here, can we please also talk about the !cgroup situation?
https://bugs.freedesktop.org/show_bug.cgi?id=74589

A segfaulting systemd on CONFIG_CGROUPS=n is no fun.

-- 
Thanks,
//richard

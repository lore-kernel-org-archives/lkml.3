Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaINJNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:13:16 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:45661 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaINJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140914055450.GB296@x4>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
Date: Sun, 14 Sep 2014 11:13:12 +0200
X-Google-Sender-Auth: 9Q0jVljGb1znyA4W5PlnY0FToPw
Message-ID: <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
Subject: Re: Weird character in kernel message
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 7:54 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2014.09.14 at 07:09 +0200, Markus Trippelsdorf wrote:
>> Just noticed this today:
>>
>> Sep 14 06:51:57 x4 kernel: [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
>>
>> in hex:
>> 20 01 34 43 45 3A 20
>>
>> Must be a recent regression.
>
> It looks like a combination of commit 504d58745c9ca and commit
> 458df9fd4815b causes the issue.
> 458df9fd4815b changed the loglevel of printk_deferred to a hardcoded
> KERN_WARNING. And 504d58745c9ca changed the printk in
> kernel/time/clockevents.c to printk_deferred.
> But now the KERN_WARNING loglevel of printk_deferred in
> kernel/time/clockevents.c is redundant and responsible for the weird
> 01 34 character combination (KERN_SOH "4").

vprintk_emit() has:

        if (in_sched)
                text_len = scnprintf(text, sizeof(textbuf),
                                     KERN_WARNING "[sched_delayed] ");

        text_len += vscnprintf(text + text_len,
                               sizeof(textbuf) - text_len, fmt, args);

Hence if in_sched, "[sched_delayed] " is inserted before the printed
message. As most printed messages have a KERN_* prefix, this
prefix now ends up in the middle of the message, causing the issue.

A simple solution is to print a newline after the "[sched_delayed]", but
this will break the line.

Better, but more complicated, would be to remove the KERN_* prefix
(if it exists) from the next message if in_sched is set.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

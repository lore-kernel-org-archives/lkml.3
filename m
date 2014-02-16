Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaBPX7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:59:54 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34326 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBPX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <CF26B239.2E7B4%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
	<CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
	<CF26B239.2E7B4%dbanerje@akamai.com>
Date: Sun, 16 Feb 2014 15:59:51 -0800
X-Google-Sender-Auth: puVQShdJTJm7PF6ooArjOYvR0ew
Message-ID: <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Banerjee, Debabrata" <dbanerje@akamai.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 3:23 PM, Banerjee, Debabrata
<dbanerje@akamai.com> wrote:
>
> The explanation is: the loops look identical but they are not. When a
> record is printed first, its size can expand due to adding the prefix and
> timestamp. The second loop is calculating len with the first line printed
> possibly changing every iteration.

That still makes zero sense.

The size should damn well not change, because we *should* be calling
it with the exact same flags. If the size changes, something is wrong.
The logic is:

 - first traverse all log indexes to find out the total length

 - then traverse *again* all the indexes, until you have traversed
enough that the remainder fits in the given buffer size.

For this to make sense, that second pass absolutely *has* to use the
exact same lengths as the first pass did. Otherwise the whole logic is
totally broken.

Now, *once* you have found the right record (so that the rest should
fit), the problem is that the *third* loop (that traverses that "rest"
part) is now done with a "prev" value that does not match the original
"let's figure out the size".

So my suspicion is that the *real* bug is that

    prev = 0;

before that *third* loop, because it means that the first time through
that loop (when we did *not* reset "seq/idx" to the beginning, we use
the wrong "prev" value.

So my (totally and utterly untested, and obviously whitespace-damaged)
suggested patch would be something along the lines of this:

    diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
    index b1d255f04135..053c3c1a4061 100644
    --- a/kernel/printk/printk.c
    +++ b/kernel/printk/printk.c
    @@ -1076,7 +1076,6 @@ static int syslog_print_all(char __user
*buf, int size, bool clear)
                    next_seq = log_next_seq;

                    len = 0;
    -               prev = 0;
                    while (len >= 0 && seq < next_seq) {
                            struct printk_log *msg = log_from_idx(idx);
                            int textlen;

because at least this makes sense. It means that "prev" is only zero
when we start from "clear_idx", at all other times it's actually the
msg->flags of the previous message.

But maybe I'm missing something. That code really is messy. But
clearing "prev" there in the middle really looks wrong to me.

               Linus

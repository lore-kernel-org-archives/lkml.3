Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBPT2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:28:39 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:48034 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBPT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:28:37 -0500
MIME-Version: 1.0
In-Reply-To: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
Date: Sun, 16 Feb 2014 11:28:36 -0800
X-Google-Sender-Auth: PY_i8hEGicGXR4VfAzQc-bJnxm0
Message-ID: <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Debabrata Banerjee <dbanerje@akamai.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, dbavatar@gmail.com, johunt@akamai.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Kay and Greg, since the original code is from commit
7ff9554bb578 ("printk: convert byte-buffer to variable-length record
buffer") and all the "prev" flag tweaks end up building on top of
that.

The whole "prev flags" is messed up, and LOG_CONT is done very confusingly.

Why are *those* particular two "prev = msg->flags" incorrect, when
every other case where we walk the messages they are required?

The code/logic makes no sense. You remove the "prev = msg->flags" at
line 1070, when the *identical* loop just above it has it. So now the
two loops count the number of characters differently. That makes no
sense.

So I don't think this fixes the fundamental problem. I'm more inclined
to believe that LOG_CONT is wrongly set somewhere, for example because
a continuation wasn't actually originally printed due to coming from
different users or something like that.

Or at the very least I want a coherent explanation why one loop would
do this and the other would not, and why counting up *different*
numbers could possibly make sense.

Because as it is, there clearly is some problem, but the patch does
not look sensible to me.

                 Linus

On Thu, Feb 13, 2014 at 8:42 PM, Debabrata Banerjee <dbanerje@akamai.com> wrote:
> Found another buffer overflow in this code that was introduced by
> e3756477aec028427fec767957c0d4b6cfb87208 trying to solve a related overflow.
>
> strace still shows a problem:
>
>         syslog(0x3, 0x7fffd65375d0, 0x1000)     = 4107
>
> The first record output was in the middle of a LOG_CONT line:
>
>         <4>[    2.974999] 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
>
> This happens because when discarding records to be less than len, every line it
> subtracts should be the first line which means prev should be 0. Otherwise for
> example it won't include the prefix len if the last line was a LOG_CONT
> record, which however will be printed because there won't be a previous line.
> This patch makes sure enough records are discarded to be under len.
>
> CC: stable@vger.kernel.org
> Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
> ---
>  kernel/printk/printk.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b1d255f..c1722d5 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1067,7 +1067,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
>                         struct printk_log *msg = log_from_idx(idx);
>
>                         len -= msg_print_text(msg, prev, true, NULL, 0);
> -                       prev = msg->flags;
>                         idx = log_next(idx);
>                         seq++;
>                 }
> @@ -2780,7 +2779,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
>                 l -= msg_print_text(msg, prev, true, NULL, 0);
>                 idx = log_next(idx);
>                 seq++;
> -               prev = msg->flags;
>         }
>
>         /* last message in next interation */
> --
> 1.8.3.4
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab3INCvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:51:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59238 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3INCva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:51:30 -0400
X-Nat-Received: from [202.181.97.72]:55122 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379127005.12511
To: keescook@chromium.org, joe@perches.com
Cc: linux@horizon.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130913195335.18955.qmail@science.horizon.com>
	<1379111268.2066.22.camel@joe-AO722>
	<CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
In-Reply-To: <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
Message-Id: <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 14 Sep 2013 11:49:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13092013 #11048944, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> 3- some callers of seq_printf (incorrectly) use the return value as a
> length indication

Are there really?

Is somebody using the return value from seq_printf() like

  pos = snprintf(buf, sizeof(buf) - 1, "%s", foo);
  snprintf(buf + pos, sizeof(buf) - 1 - pos, "%s", bar);

? Since the caller cannot pass the return value from seq_printf() like

  pos = seq_printf(m, "%s", foo);
  seq_printf(m + pos, "%s", bar);

, I wonder who would interpret the return value as a length indication.

Even bad code which has never tested failure case, the authors should already
know that "seq_printf() returns 0 on success case".

I think that

	pos += seq_printf(m, "%s", foo);
	pos += seq_printf(m, "%s", bar);

is used as the equivalent to

	if (seq_printf(m, "%s", foo))
		pos = -1;
	if (seq_printf(m, "%s", bar))
		pos = -1;

.

Joe Perches wrote:
> @@ -174,8 +171,8 @@ static int dbg_show_state(struct seq_file *s, void *p)
>  	int pos = 0;
>  
>  	/* basic device status */
> -	pos += seq_printf(s, "DMA engine status\n");
> -	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
> +	seq_puts(s, "DMA engine status\n");
> +	seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
>  
>  	return pos;
>  }

As I described above, I think this change breaks the functionality.
We need to change like

  -	pos += seq_printf(s, "DMA engine status\n");
  -	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
  +	pos |= seq_puts(s, "DMA engine status\n");
  +	pos |= seq_printf(s, "\tChannel number: %d\n", num_dma_channels);

or

  -	pos += seq_printf(s, "DMA engine status\n");
  -	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
  +	seq_puts(s, "DMA engine status\n");
  +	seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
   
  - 	return pos;
  +	return seq_overflow(s) : -1 : 0;

for keeping the functionality.

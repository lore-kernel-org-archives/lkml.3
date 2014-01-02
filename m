Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaABWzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:55:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaABWzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:55:49 -0500
Date: Thu, 2 Jan 2014 14:55:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun KS <arunks.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, tj@kernel.org,
        fweisbec@gmail.com, paul.gortmaker@windriver.com
Subject: Re: [PATCH] printk: flush conflicting continuation line
Message-Id: <20140102145548.f3fe2c3fd3ea706ed388685c@linux-foundation.org>
In-Reply-To: <CAKZGPAMmtDNYQfMnujG9pozkn=xd8=9hoB++8avqxgbYomvhTQ@mail.gmail.com>
References: <CAKZGPAMmtDNYQfMnujG9pozkn=xd8=9hoB++8avqxgbYomvhTQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jan 2014 17:44:06 +0530 Arun KS <arunks.linux@gmail.com> wrote:

> >From d751f9a0cb6329ae3171f6e1cb85e4a3aa792d73 Mon Sep 17 00:00:00 2001
> From: Arun KS <arun.ks@broadcom.com>
> Date: Wed, 1 Jan 2014 17:24:46 +0530
> Subject: printk: flush conflicting continuation line
> 
> An earlier newline was missing and current print is from different task.
> In this scenario flush the continuation line and store this line seperatly.
> 
> This patch fix the below scenario of timestamp interleaving,
> <6>[   28.154370 ] read_word_reg : reg[0x 3], reg[0x 4]  data [0x 642]
> <6>[   28.155428 ] uart disconnect
> <6>[   31.947341 ] dvfs[cpufreq.c<275>]:plug-in cpu<1> done
> <4>[   28.155445 ] UART detached : send switch state 201
> <6>[   32.014112 ] read_reg : reg[0x 3] data[0x21]
> 
> ...
>
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1604,7 +1604,10 @@ asmlinkage int vprintk_emit(int facility, int level,
>   if (!(lflags & LOG_PREFIX))
>   stored = cont_add(facility, level, text, text_len);
>   cont_flush(LOG_NEWLINE);
> - }
> + /* Flush conflicting buffer. An earlier newline was missing
> + * and current print is from different task */
> + } else if (cont.len && cont.owner != current)
> + cont_flush(LOG_NEWLINE);
> 
>   if (!stored)
>   log_store(facility, level, lflags, 0,

Your email client makes a horrid mess of the patches :(

I *think* it's right.  But the code can be significantly simplified and
optimised.  Please review:

	} else {
		bool stored = false;

		/*
		 * If an earlier newline was missing and it was the same task,
		 * either merge it with the current buffer and flush, or if
		 * there was a race with interrupts (prefix == true) then just
		 * flush it out and store this line separately.
		 * If the preceding printk was from a different task and missed
		 * a newline, flush and append the newline.
		 */
		if (cont.len) {
			if (cont.owner == current && !(lflags & LOG_PREFIX))
				stored = cont_add(facility, level, text,
						  text_len);
			cont_flush(LOG_NEWLINE);
		}

		if (!stored)
			log_store(facility, level, lflags, 0,
				  dict, dictlen, text, text_len);
	}



--- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix
+++ a/kernel/printk/printk.c
@@ -1595,15 +1595,15 @@ asmlinkage int vprintk_emit(int facility
 		 * either merge it with the current buffer and flush, or if
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
+		 * If the preceding printk was from a different task and missed
+		 * a newline, flush and append the newline.
 		 */
-		if (cont.len && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
-			cont_flush(LOG_NEWLINE);
-		/* Flush conflicting buffer. An earlier newline was missing
-		* and current print is from different task */
-		} else if (cont.len && cont.owner != current)
+		if (cont.len) {
+			if (cont.owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(facility, level, text,
+						  text_len);
 			cont_flush(LOG_NEWLINE);
+		}
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
_


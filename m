Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaJZPE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 11:04:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:52315 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaJZPEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 11:04:55 -0400
Date: Sun, 26 Oct 2014 16:04:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Silverman <bsilver16384@gmail.com>
cc: austin.linux@gmail.com, linux-kernel@vger.kernel.org, darren@dvhart.com,
        peterz@infradead.org
Subject: Re: [PATCH v2] futex: fix a race condition between REQUEUE_PI and
 task death
In-Reply-To: <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
Message-ID: <alpine.DEB.2.11.1410261601060.5308@nanos>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com> <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Brian Silverman wrote:
> @@ -64,6 +64,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/freezer.h>
>  #include <linux/bootmem.h>
> +#include <linux/lockdep.h>

Already included.
  
>   * PI futexes can not be requeued and must remove themself from the
>   * hash bucket. The hash bucket lock (i.e. lock_ptr) is held on entry
>   * and dropped here.
> + * Must be called with the hb lock held.

It's already required that the hb lock, i.e. q->lock_ptr is held on
entry. So there is no point for adding hb to the interface. We rather
add "struct spin_lock *lock" to free_pi_state() and hand in
q->lock_ptr from here and &hb2->lock from requeue_pi.

I take the immediate bugfix and strip out this debug stuff for
now. Care to resend this part?

Thanks,

	tglx

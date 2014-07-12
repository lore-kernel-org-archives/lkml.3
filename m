Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaGLT26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:28:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:33273 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaGLT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:28:52 -0400
Date: Sat, 12 Jul 2014 21:28:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
In-Reply-To: <318411977.13587.1405176797949.JavaMail.zimbra@efficios.com>
Message-ID: <alpine.DEB.2.10.1407122124130.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <318411977.13587.1405176797949.JavaMail.zimbra@efficios.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014, Mathieu Desnoyers wrote:
> I'm perhaps missing something here, but what happens with the
> following scenario ?
> 
> Initial conditions:
> 
> tkf->seq = 0
> tkf->base[0] and tkf->base[1] are initialized.
> 
> CPU 0                                      CPU 1
> ------------                               ----------------
> update:
>   tkf->seq++
>   smb_wmb()
>   tkf->seq++ (reordered before update)
>                                            reader:
>                                            seq = tkf->seq (reads 2)
>                                            smp_rmb()
>                                            idx = seq & 0x01
>                                            now = now(tkf->base[idx]   (reads base[0])
>   update(tkf->base[0], tk) (racy concurrent update)
>                                            smp_rmb()
>                                            while (seq != tkf->seq) (they are equal)
> 
> So AFAIU, we end up returning a corrupted value. Adding a
> smp_wmb() between update of base[0] and increment of seq,
> as well as between update of base[1] and the _following_
> increment of seq (next update call) would fix this.
> 
> Thoughts ?

Well, the actual implementation does:

+       /* Force readers off to base[1] */
+       raw_write_seqcount_begin(&tkf->seq);
+
+       /* Update base[0] */
+       base->clock = clk;
+       base->cycle_last = clk->cycle_last;
+       base->base = tbase;
+       base->shift = shift;
+       base->mult = mult;
+
+       /* Force readers back to base[0] */
+       raw_write_seqcount_end(&tkf->seq);
+
+       /* Update base[1] */
+       base++;
+       base->clock = clk;
+       base->cycle_last = clk->cycle_last;
+       base->base = tbase;
+       base->shift = shift;
+       base->mult = mult;

Where raw_write_seqcount_begin/raw_write_seqcount_end provides the
required memory barriers.

Sure I should update the documentaion ....

Thanks,

	tglx

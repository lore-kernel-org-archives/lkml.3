Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3KKTen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:34:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:43321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3KKTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:34:35 -0500
Date: Mon, 11 Nov 2013 20:34:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
 <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de> <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
 <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com> <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Thomas Gleixner wrote:
> Not what you would expect, right?

Finally found the issue. The patch below fixes the problem here. The
little missing detail is, that I zapped GET_CURRENT() assuming blindly
that this is only needed for the preempt_count hackery. But in fact
the world and some more depends on it which leads to interesting
explosions.

Thanks,

	tglx
----
Index: linux-2.6/arch/m68k/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/entry.S
+++ linux-2.6/arch/m68k/kernel/entry.S
@@ -274,6 +274,7 @@ do_delayed_trace:
 
 ENTRY(auto_inthandler)
 	SAVE_ALL_INT
+	GET_CURRENT(%d0)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 	subw	#VEC_SPUR,%d0
@@ -297,6 +298,7 @@ ret_from_interrupt:
 
 ENTRY(user_inthandler)
 	SAVE_ALL_INT
+	GET_CURRENT(%d0)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 user_irqvec_fixup = . + 2
@@ -313,6 +315,7 @@ user_irqvec_fixup = . + 2
 
 ENTRY(bad_inthandler)
 	SAVE_ALL_INT
+	GET_CURRENT(%d0)
 
 	movel	%sp,%sp@-
 	jsr	handle_badint


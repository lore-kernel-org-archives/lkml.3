Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3BELPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:15:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:48560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3BELPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:15:32 -0500
Date: Tue, 5 Feb 2013 12:15:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Leonid Shatz <leonid.shatz@ravellosystems.com>
cc: "'Izik Eidus'" <izik.eidus@ravellosystems.com>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] fix hrtimer_enqueue_reprogram race
In-Reply-To: <03b201ce038f$4a2db840$de8928c0$@ravellosystems.com>
Message-ID: <alpine.LFD.2.02.1302051155350.11905@ionos>
References: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com> <alpine.LFD.2.02.1302051138370.11905@ionos> <03b201ce038f$4a2db840$de8928c0$@ravellosystems.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonid,

On Tue, 5 Feb 2013, Leonid Shatz wrote:

Please stop top posting!

> The explanation were submitted as possible scenario which could explain how
> the bug in kernel could happen and it does not mean that serious designer
> could do exactly that. As I said before, it's also possible that a race
> between hrtimer_cancel and hrtimer_start can trigger the bug. The idea is to
> have kernel more robust.

I'm not against making the kernel more robust and I already applied
the patch.

> There are already locks used inside hrtimer code, so why should
> users of the hrtimer add another layer of locks and get involved in
> the intricacy of which cases are protected by internal hrtimer lock
> and which are not?

Groan. The hrtimer locks are there to protect the internal data
structures of the hrtimer code and to ensure that hrtimer functions
are proper protected against concurrent running callbacks. But that
does not give you any kind of protection versus multiple users of your
hrtimer resource.

Look at the following scenario:

CPU0	     	    CPU1

hrtimer_cancel()
		    hrtimer_start()
teardown_crap()
		    hrtimer_callback() runs

That's probably not what you want and magic serialization in the
hrtimer code does not help at all.

There is also no protection against:

CPU0  	      	    CPU1

hrtimer_cancel()
		    hrtimer_start()
hrtimer_forward()

Which leaves the hrtimer enqueued on CPU1 with a wrong expiry value.

So while concurrent hrtimer_start() is protected, other things are
not. So do we need to create a list of functions which can be abused
by a programmer without proper protection of the resource and which
not?

If you want to use any kind of resource (including hrtimers)
concurrently you better have proper serialization in that
code. Everything else is voodoo programming of the worst kind.

Thanks,

	tglx

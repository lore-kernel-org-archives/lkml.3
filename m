Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423084Ab3FUOcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:32:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:39692 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422890Ab3FUOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:32:32 -0400
Date: Fri, 21 Jun 2013 16:32:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] hrtimers: provide a hrtimers_late_resume() call
In-Reply-To: <51C447E3.9030009@citrix.com>
Message-ID: <alpine.DEB.2.02.1306211610100.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-2-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de> <51C447E3.9030009@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, David Vrabel wrote:
> On 21/06/13 08:53, Thomas Gleixner wrote:
> > This is the completely wrong approach. If an architecture does not
> > shut down the non boot cpus on suspend, then this wants to be handled
> > in the core code and not in some random arch specific driver.
> 
> Agreed.  Does the following meet your requirements?

Indeed. That's looks way more reasonable. Though...

> hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
> as the other CPUs will be stopped with IRQs disabled.  Instead, defer
> the call to the next softirq.

that's just working by chance and not by design as there is no
guarantee that the next interrupt, which invokes the softirq, will
arrive in time. So you want to make sure that an interrupt arrives.

Invoking retrigger_next_event(NULL) from hrtimer_resume() should do
the trick.

Thanks,

	tglx

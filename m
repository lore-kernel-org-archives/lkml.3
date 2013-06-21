Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946036Ab3FUVAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:00:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:41506 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945933Ab3FUVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:00:44 -0400
Date: Fri, 21 Jun 2013 23:00:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4] clocksource:arm_global_timer: Add ARM global timer
 support.
In-Reply-To: <51C4913F.2020608@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1306212250450.4013@ionos.tec.linutronix.de>
References: <1371820267-12099-1-git-send-email-srinivas.kandagatla@st.com> <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de> <51C4913F.2020608@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, Stephen Boyd wrote:

> On 06/21/13 08:56, Thomas Gleixner wrote:
> >
> >> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
> >> +{
> >> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
> > What kind of construct is this?
> >
> > You are using request_percpu_irq() and the device id is pointing to
> > per cpu memory. Why do you need this horrible pointer indirection?
> >
> > Because a lot of other ARM code uses the same broken construct?
> 
> This is an artifact of the ARM local timer API. I have been trying for a

No, it's not an artifact. It's a copy and paste issue. Looking at
drivers/clocksource/arm_arch_timer.c

        arch_timer_evt = alloc_percpu(struct clock_event_device);
...
	err = request_percpu_irq(ppi, arch_timer_handler_virt,
                                 "arch_timer", arch_timer_evt);

This code is correct and it does not need any of the changes.

Doing it with the pointer madness is just wrong, nothing else. Even if
there is a historic reason why the pointer juggling was necessary at
some point, it's obviously not needed anymore.

And historic crap is no justification for brainlessly copied code.

Thanks,

	tglx



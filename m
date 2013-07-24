Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3GXMuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:50:18 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40127 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3GXMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:50:16 -0400
Date: Wed, 24 Jul 2013 13:50:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kevin Hilman <khilman@linaro.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, linux-kernel@vger.kernel.org,
        Naga Venkata Srikanth V <vnv.srikanth@samsung.com>,
        Oleg_Kosheliev <oleg.kosheliev@ti.com>
Subject: Re: [PATCH 1/4] mfd: twl6030-irq: migrate to IRQ threaded handler
Message-ID: <20130724125011.GM26801@laptop>
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com>
 <1374595624-15054-2-git-send-email-grygorii.strashko@ti.com>
 <20130724104945.GH26801@laptop>
 <51EFC072.9070702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51EFC072.9070702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+	if (ret) {
> >>+		pr_warn("%s: I2C error %d reading PIH ISR\n", __func__, ret);
> >
> >Does the user really care which function we're returning from.
> >
> >Would it be better if you replace '__func__' with the device name?
> 
> This module hasn't been converted to the device yet:(
> (I mean "interrupt-controller").
> But I'm thinking about it as the next step :) and then It will be
> absolutely reasonable change to replace pr_*() with dev_*() and
> remove __func__.

I don't mean anything as compicated as that for 'this' patch. (NB: See my
comment in subsequent patches about creating a 'struct twl6030' where
you could store 'struct dev'.) In this patch I mean litterally
replacing "%s: ", with "tw16030_irq: ". Simples. :)

> Now, the pointer on "dev" (in our case "twl-core" device) isn't passed
> in IRQ handler, so It can't be used here.
> 
> Of course it can be done, but would it make code better?
> My opinion - no.

> >>+	if (sts.bytes[2] & 0x10)
> >>+		sts.bytes[2] |= 0x08;
> >>
> >>-		for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
> >>-			local_irq_disable();
> >>-			if (sts.int_sts & 0x1) {
> >>-				int module_irq = twl6030_irq_base +
> >>+	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
> >>+		if (sts.int_sts & 0x1) {
> >
> >I'm a little confused by this. Where does sts.int_sts come from?
> 
> See my comment above, pls

Okay, that's my fault for not understanding unions properly as I've
never had to use one, but now I do, thanks.

> >>@@ -437,10 +386,13 @@ int twl6030_exit_irq(void)
> >>  {
> >>  	unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
> >>
> >>-	if (twl6030_irq_base) {
> >>+	if (!twl6030_irq_base) {
> >>  		pr_err("twl6030: can't yet clean up IRQs?\n");
> >>  		return -ENOSYS;
> >>  	}
> >>+
> >>+	free_irq(twl_irq, NULL);
> >>+
> >
> >If request_threaded_irq() fails, isn't there a chance that
> >twl6030_irq_base will be allocated, but twl_irq will still be
> >undefined?
> 
> Yes. A mess is here (historically:), thanks. Will use twl_irq
> instead of twl6030_irq_base (I did it, actually, in patch [3]:).

Yes, I saw it. It would be better if you still fixed up this patch to
be correct though. Even if you break it out and add it as [PATCH 1/x].

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaCLAYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:24:03 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:59218 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755722AbaCLAYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:24:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12296:12438:12517:12519:12740:13972:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clam95_7a03b6338815f
X-Filterd-Recvd-Size: 4377
Message-ID: <1394583837.28839.19.camel@joe-AO722>
Subject: Re: [PATCH] power: add an API to log wakeup reasons
From: Joe Perches <joe@perches.com>
To: Ruchi Kandoi <kandoiruchi@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ghackmann@google.com, john.stultz@linaro.org,
        Todd Poynor <toddpoynor@google.com>
Date: Tue, 11 Mar 2014 17:23:57 -0700
In-Reply-To: <CAL8qYTNejOB8NJLsvV8nFisGyd9v8gR=nC9pKGDGc=nujo7SNw@mail.gmail.com>
References: <1394503322-25210-1-git-send-email-kandoiruchi@google.com>
	 <3827847.Gih6ie3Ah6@vostro.rjw.lan>
	 <CAL8qYTNejOB8NJLsvV8nFisGyd9v8gR=nC9pKGDGc=nujo7SNw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 17:02 -0700, Ruchi Kandoi wrote:
> This API would be called from the platform specific code,
[]
> This is already in use on some Android devices. We are trying to make
> this a generic API which could be called by other platforms as well,
> standardizing the format in which the info is
> logged in dmesg and the format of the info exported to userspace for
> collecting power management statistics.


logging comments:

> >> diff --git a/kernel/power/wakeup_reason.c b/kernel/power/wakeup_reason.c
[]
> >> @@ -0,0 +1,140 @@

Please add the standard

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include

to prefix this with either "power: " or "wakeup_reason: "
(it depends on how the makefile was written, I don't see it)

> >> +#include <linux/wakeup_reason.h>
> >> +#include <linux/kernel.h>

[]

> >> +void log_wakeup_reason(int irq)
> >> +{
> >> +     struct irq_desc *desc;
> >> +     desc = irq_to_desc(irq);
> >> +     if (desc && desc->action && desc->action->name)
> >> +             printk(KERN_INFO "Resume caused by IRQ %d, %s\n", irq,
> >> +                             desc->action->name);
> >> +     else
> >> +             printk(KERN_INFO "Resume caused by IRQ %d\n", irq);

	if (desc && desc->action && desc->action->name)
		pr_info("Resume caused by IRQ %d, %s\n",
			irq, desc->action->name);
	else
		pr_info("Resume caused by IRQ %d\n", irq);

> >> +     if (irqcount == MAX_WAKEUP_REASON_IRQS) {
> >> +             spin_unlock(&resume_reason_lock);
> >> +             printk(KERN_WARNING "Resume caused by more than %d IRQs\n",
> >> +                             MAX_WAKEUP_REASON_IRQS);

		pr_warn("Resume caused by more than %d IRQs\n",
			MAX_WAKEUP_REASON_IRQS);

> >> +             return;
> >> +     }
> >> +
> >> +     irq_list[irqcount++] = irq;
> >> +     spin_unlock(&resume_reason_lock);
> >> +}

I'd probably write this with:

	if (irqcount >= MAX_REASON_IRQS) {

[]

> >> +int __init wakeup_reason_init(void)
> >> +{
> >> +     int retval;
> >> +     spin_lock_init(&resume_reason_lock);
> >> +     retval = register_pm_notifier(&wakeup_reason_pm_notifier_block);
> >> +     if (retval)
> >> +             printk(KERN_WARNING "[%s] failed to register PM notifier %d\n",
> >> +                             __func__, retval);

Kernel style generally uses function names emitted as "%s: ", __func__
not putting function name in brackets.  I suggest using that style:

		pr_warn("%s: failed to register PM notifier %d\n",
			__func__, retval);

> >> +
> >> +     wakeup_reason = kobject_create_and_add("wakeup_reasons", kernel_kobj);
> >> +     if (!wakeup_reason) {
> >> +             printk(KERN_WARNING "[%s] failed to create a sysfs kobject\n",
> >> +                             __func__);

		pr_warn("%s: failed to create a sysfs kobject\n", __func___);

> >> +             return 1;
> >> +     }
> >> +     retval = sysfs_create_group(wakeup_reason, &attr_group);
> >> +     if (retval) {
> >> +             kobject_put(wakeup_reason);
> >> +             printk(KERN_WARNING "[%s] failed to create a sysfs group %d\n",
> >> +                             __func__, retval);

		pr_warn("%s: failed to create a sysfs group %d\n",
			__func___, retval);



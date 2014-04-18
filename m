Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaDRVRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaDRVRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:17:51 -0400
Message-ID: <1397855863.2704.5.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
From: Adam Williamson <awilliam@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jin Yao <yao.jin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Fri, 18 Apr 2014 14:17:43 -0700
In-Reply-To: <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 16:44 -0400, Benjamin Tissoires wrote:
> On Wed, Apr 16, 2014 at 8:05 AM, Jin Yao <yao.jin@linux.intel.com> wrote:
> > A crash is triggered on the ASUS T100TA Baytrail-T because of a irq
> > descriptor conflict. There are two gpio triggered acpi events in this
> > device, GPIO 6 and 18. These gpios are translated to irqs by calling
> > gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
> > irq_create_mapping will take care of allocating the irq descriptor, taking
> > the first available number starting from the given value (6 in our case).
> > The 0-15 are already reserved by legacy ISA code, so it gets the first
> > free irq descriptor which is number 16. The i915 driver also uses irq 16,
> > it loads later than gpio and crashes in probe.
> >
> > The bug is reported here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=68291
> 
> Adam, the reporter of this bug told me that his touchscreen was broken
> in its tablet.
> I strongly suspect this patch to be the root cause of this, because
> the touchscreen uses i2c_hid. i2c_hid relies on an IRQ declared in the
> DSDT when it is acpi enumerated, and since the inclusion of this
> patch, no irq are triggered from a driver point of view.
> 
> Adam should still confirm that the revert of the patch makes the
> touchscreen back alive, but if I understood correctly the bug report,
> without the patch, his tablet oopses at boot.

if IRQ allocation is enabled, yeah. What I can do is test with the
#68291 patch dropped and IRQ allocation disabled in pinctrl-baytrail.c -
as is done in Doug Johnson's patch,
http://dougvj.net/baytrail_gpio_quirk.patch , for #67921 , with these
two blocks:

@@ -532,8 +535,8 @@ static int byt_gpio_probe(struct platform_device
*pdev)
 		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
 		return ret;
 	}
-
 	/* set up interrupts  */
+/*
 	irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_rc && irq_rc->start) {
 		hwirq = irq_rc->start;
@@ -548,7 +551,7 @@ static int byt_gpio_probe(struct platform_device
*pdev)
 
 		irq_set_handler_data(hwirq, vg);
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
-	}
+	}*/
 
 	pm_runtime_enable(dev);
 

so, I'll do a test of that setup, and see how it goes.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net


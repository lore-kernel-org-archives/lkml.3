Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaHRBoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:44:16 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37634 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHRBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:44:13 -0400
Date: Mon, 18 Aug 2014 09:44:04 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 02/12] PCI: OF: Parse and map the IRQ when adding the
 PCI device.
Message-ID: <20140818014404.GA11354@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
 <20140814145804.GA5586@richard>
 <20140814154959.GG25761@e106497-lin.cambridge.arm.com>
 <20140815085632.GA4954@richard>
 <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081801-8256-0000-0000-000000CD8907
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:30:52AM +0100, Liviu Dudau wrote:
>On Fri, Aug 15, 2014 at 09:56:32AM +0100, Wei Yang wrote:
>> On Thu, Aug 14, 2014 at 04:49:59PM +0100, Liviu Dudau wrote:
>> >On Thu, Aug 14, 2014 at 03:58:04PM +0100, Wei Yang wrote:
>> >> On Tue, Aug 12, 2014 at 05:25:15PM +0100, Liviu Dudau wrote:
>> >> >Enhance the default implementation of pcibios_add_device() to
>> >> >parse and map the IRQ of the device if a DT binding is available.
>> >> >
>> >> >Cc: Bjorn Helgaas <bhelgaas@google.com>
>> >> >Cc: Grant Likely <grant.likely@linaro.org>
>> >> >Cc: Rob Herring <robh+dt@kernel.org>
>> >> >Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> >> >---
>> >> > drivers/pci/pci.c | 3 +++
>> >> > 1 file changed, 3 insertions(+)
>> >> >
>> >> >diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> >> >index 1c8592b..29d1775 100644
>> >> >--- a/drivers/pci/pci.c
>> >> >+++ b/drivers/pci/pci.c
>> >> >@@ -17,6 +17,7 @@
>> >> > #include <linux/spinlock.h>
>> >> > #include <linux/string.h>
>> >> > #include <linux/log2.h>
>> >> >+#include <linux/of_pci.h>
>> >> > #include <linux/pci-aspm.h>
>> >> > #include <linux/pm_wakeup.h>
>> >> > #include <linux/interrupt.h>
>> >> >@@ -1453,6 +1454,8 @@ EXPORT_SYMBOL(pcim_pin_device);
>> >> >  */
>> >> > int __weak pcibios_add_device(struct pci_dev *dev)
>> >> > {
>> >> >+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>> >> >+
>> >> > 	return 0;
>> >> > }
>> >> 
>> >> Liviu,
>> >> 
>> >> For this, my suggestion is to add arch dependent function to setup the irq
>> >> line for pci devices. I can't find an obvious reason this won't work on other
>> >> archs, but maybe this will hurt some of them?
>> >
>> >Hi Wei,
>> >
>> >I'm not sure I understand your point. Architectures that support OF will obviously
>> >benefit from this common approach, and for the other ones the function is empty
>> >so it will not change existing behaviour. If you are suggesting that I should
>> >create a new API that each architecture could go and implement for setting up the
>> >IRQ line then I would agree that it would be nice to have that, but the question
>> >is how many architectures are outside OF that need this?
>> 
>> My suggestion is to define the pcibios_add_device() for arm arch, like the one
>> in arch/powerpc/kernel/pci-common.c. If my understanding is correct, this
>> patch set address the pci bus setup mostly on arm arch.
>
>And also arm64 at the least.
>
>> 
>> For those archs not support OF, this function is empty and has no effect. I
>> agree on this one.
>> 
>> For those archs rely on OF, we still have two cases:
>>     1. they would have implement this function like powerpc
>
>Actually, powerpc seems to be the only OF platform reimplementing this function.
>s390 and x86 are not OF platforms.
>
>>     2. have other way to fix it up,  otherwise how it works now?
>
>Don't forget that my patchset aims to replace existing house-made code with a more
>generic version. When architectures and platforms switch to my code they will have
>to add this back in their code if it's needed.
>
>> If my assumption is correct, this change will either have no effect, or fix up
>> the irq line the second time. Not harmful, but not necessary.
>
>Well, it will become necessary as old code gets dismantled and converted towards
>this patchset. To give you an example that I'm familiar with, for arch/arm the
>host bridge drivers have moved into drivers/pci/host, but they still depend/use
>the bios32 infrastructure that takes care of setting up the irq. When they switch
>to my version they would have to go and debug the "irq not being assigned" issue
>and it is quite likely that some of the people doing the conversion will complain
>about my code rather than understanding the issue. What I'm trying to do is to
>make switching to my patchset as painless as possible, with a cleanup to remove
>redundant operations coming after the switchover.
>

This means this is a temporary version for the switchover period and will be
reverted after switchover?

>Does that sound like a reasonable plan?
>
>Best regards,
>Liviu
>
>> 
>> I am not familiar with other arch, so the second case is my deduction. If this
>> is not correct, please let me know.
>> 
>> >
>> >If I understood you correctly, it is a nice idea but slightly outside the scope
>> >of my current patchset.
>> >
>> >Best regards,
>> >Liviu
>> >
>> >> 
>> >> >
>> >> >-- 
>> >> >2.0.4
>> >> >
>> >> >--
>> >> >To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> >> >the body of a message to majordomo@vger.kernel.org
>> >> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> 
>> >> -- 
>> >> Richard Yang
>> >> Help you, Help me
>> >> 
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> 
>> >
>> 
>> -- 
>> Richard Yang
>> Help you, Help me
>> 
>> 
>
>-- 
>====================
>| I would like to |
>| fix the world,  |
>| but they're not |
>| giving me the   |
> \ source code!  /
>  ---------------
>    ¯\_(ツ)_/¯

-- 
Richard Yang
Help you, Help me


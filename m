Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaGOP2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:28:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:36266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbaGOP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,666,1400050800"; 
   d="scan'208";a="570151461"
Message-ID: <53C54876.5090606@linux.intel.com>
Date: Tue, 15 Jul 2014 23:27:50 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86 platforms
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com> <20140714172642.GA12920@laptop.dumpdata.com> <20140714194133.GA22857@laptop.dumpdata.com>
In-Reply-To: <20140714194133.GA22857@laptop.dumpdata.com>
Content-Type: multipart/mixed;
 boundary="------------000209040300010602040808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000209040300010602040808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Konrad,
	Thanks for testing the patch set! After analyzing the log
files, I feel something is wrong with the Radeon driver. With good
configuration, IRQ18 is shared by OHCI controllers and Radeon GPU
card. With bad configuration, only OHCI controllers are bound to
IRQ18. Radeon GPU card may have been bound to another wrong IRQ,
which then causes the interrupt storm.
	But I have no hardware available to verify the hypothesis,
so could you please help to apply the attached patch and run the
test again?
	Thanks!
	Gerry

On 2014/7/15 3:41, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 14, 2014 at 01:26:42PM -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Jun 25, 2014 at 04:40:31PM +0800, Jiang Liu wrote:
>>> This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
>>> hotplug on x86 platforms. It's based on tip/x86/apic.
>>>
>>> You may pull it from 
>>> https://github.com/jiangliu/linux.git ioapic/hotplug_v3
>>
>> With this patchset (on top of 3.16-rc5) my USB driver gets notified
>> it has interrupts but it thinks it does not have to acknowledge any.
>> I can only reproduce this under a 32-bit arch so far.
>>
>> Please see the good.log and the bad.log 
> 
> tglx asked for apic=debug on the line, so here they are again with
> those parameters.
> 
> Please note that the 'good.log' this time is
>  3.16-rc6 + tip/master + tip/x86/apic
> 
> And 'bad.log' is:
> 
>  3.16-rc6 + tip/master + tip/x86/apic + ioapic/hotplug_v3
> 

--------------000209040300010602040808
Content-Type: text/plain; charset=gb18030;
 name="tmp2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tmp2.patch"

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 9d2ebd5fd9aa..4b30023ccefe 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -404,6 +404,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	char *link = NULL;
 	char link_desc[16];
 	int rc;
+	int irq = 0;
 
 	pin = dev->pin;
 	if (!pin) {
@@ -413,8 +414,11 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 	}
 
-	if (dev->irq > 0)
-		return 0;
+	if (dev->irq > 0) {
+		dev_warn(&dev->dev, "already assigned IRQ%d\n", dev->irq);
+		irq = dev->irq;
+		//return 0;
+	}
 
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry) {
@@ -459,6 +463,8 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return rc;
 	}
 	dev->irq = rc;
+	if (irq != dev->irq)
+		dev_warn(&dev->dev, "assigned new IRQ%d\n", dev->irq);
 
 	if (link)
 		snprintf(link_desc, sizeof(link_desc), " -> Link[%s]", link);
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 16807afab362..be1c133eac5b 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -287,6 +287,8 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 	INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
 
 	rdev->irq.installed = true;
+	dev_warn(&rdev->ddev->pdev->dev, "Radeon device interrupt IRQ%d\n",
+		 rdev->ddev->pdev->irq);
 	r = drm_irq_install(rdev->ddev, rdev->ddev->pdev->irq);
 	if (r) {
 		rdev->irq.installed = false;

--------------000209040300010602040808--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaKFIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:25:40 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:51212 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKFIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:25:39 -0500
Message-ID: <545B3071.6040904@laposte.net>
Date: Thu, 06 Nov 2014 09:25:21 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Lu, Aaron" <aaron.lu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com> <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com> <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com> <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7B96@SHSMSX101.ccr.corp.intel.com> <545B08DF.2090608@intel.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7CC3@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01EB7CC3@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrhedvgdduleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfpfgfogfftkfevteeunffgnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkfffhfgggvffufhgjtgfgsehtkegrtddtfeejnecuhfhrohhmpeeurghrthhouceomhhishhtvghrrdhfrhgvvghmrghnsehlrghpohhsthgvrdhnvghtqeenucffohhmrghinhepphgtihdrtgdqqddqrg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried your patch and it doesn't work,

I think you have forgotten something, maybe you need also to modify the
file /drivers/ata/ahci.c and not only /drivers/ata/pata_jmicron.c

don't forget that I have a JMB363/368 SATA/IDE controller PCIe, which is
both a SATA and IDE controller in one PCie card, and a IDE hardisk is
connected on this JMB363/368 SATA/IDE controller PCIe,

for now the patch who works is this :

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2046,7 +2046,17 @@ void pci_pm_init(struct pci_dev *dev)
 	pm_runtime_forbid(&dev->dev);
 	pm_runtime_set_active(&dev->dev);
 	pm_runtime_enable(&dev->dev);
-	device_enable_async_suspend(&dev->dev);
+	
+     /*
+      * The JMicron chip 361/363/368 contains one SATA controller and
+      * one PATA controller, they are brother-relation ship in PCI tree,
+      * but for powering on these both controller, we must follow the
+      * sequence one by one, otherwise one of them can not be powered on
+      * successfully, so here we disable the async suspend method for
+      * Jmicron chip.
+      */
+     if (dev->vendor != PCI_VENDOR_ID_JMICRON)
+         device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;

 	dev->pm_cap = 0;


Le 06/11/2014 07:39, Liu, Chuansheng a écrit :
> 

> diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
> index 47e418b..9e85f86 100644
> --- a/drivers/ata/pata_jmicron.c
> +++ b/drivers/ata/pata_jmicron.c
> @@ -158,6 +158,21 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
>         return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
>  }
>  
> +/*
> + * For JMicron chips, we need to disable the async_suspend method, otherwise
> + * they will hit the power-on issue when doing device resume, add one quick
> + * solution to disable the async_suspend method.
> + */
> +static void pci_async_suspend_fixup(struct pci_dev *pdev)
> +{
> +       /*
> +        * disabling the async_suspend method for JMicron chips to
> +        * avoid device resuming issue.
> +        */
> +       device_disable_async_suspend(&pdev->dev);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, pci_async_suspend_fixup);
> +
>  static const struct pci_device_id jmicron_pci_tbl[] = {
>         { PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>           PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
> 
> Barto,
> Could you have a try on your side? Thanks.
> 
> 

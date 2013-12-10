Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LJBz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:55:27 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50022 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3LJBz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:55:26 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBA1sbfj032704, This message is accepted by code: ctloc85258
Message-ID: <52A674E0.2080407@realsil.com.cn>
Date: Tue, 10 Dec 2013 09:56:48 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: wwang <wei_wang@realsil.com.cn>, Samuel Ortiz <sameo@linux.intel.com>,
        Francis Moreau <francis.moro@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran> <52A670E4.5050501@realsil.com.cn>
In-Reply-To: <52A670E4.5050501@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis:
On 12/10/2013 09:39 AM, wwang wrote:
> which is based on Thomas' patch. 

Can you help us test this patch, we disable irq while suspend here.

 From 6b2bd6d85780bfd8d4fe5289aee1b09dd655d2d4 Mon Sep 17 00:00:00 2001
From: Micky Ching <micky_ching@realsil.com.cn>
Date: Thu, 5 Dec 2013 16:44:19 +0800
Subject: [PATCH] mfd: rtsx: fix pci remove panic while resuming

On some special condition, when resume from suspend, the rtsx_pci will
being removed. And card insert/remove interrupt triggered during
removing, this will cause kernel panic, since in card detect work will
read pci register but device is no longer exist.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
  drivers/mfd/rtsx_pcr.c |   21 ++++++++++++++++-----
  1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 11e20af..efdd9b9 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1228,14 +1228,14 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)

      pcr->remove_pci = true;

-    cancel_delayed_work(&pcr->carddet_work);
-    cancel_delayed_work(&pcr->idle_work);
+    cancel_delayed_work_sync(&pcr->carddet_work);
+    cancel_delayed_work_sync(&pcr->idle_work);

      mfd_remove_devices(&pcidev->dev);

      dma_free_coherent(&(pcr->pci->dev), RTSX_RESV_BUF_LEN,
              pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
-    free_irq(pcr->irq, (void *)pcr);
+    free_irq(pcr->irq, pcr);
      if (pcr->msi_en)
          pci_disable_msi(pcr->pci);
      iounmap(pcr->remap_addr);
@@ -1268,8 +1268,13 @@ static int rtsx_pci_suspend(struct pci_dev 
*pcidev, pm_message_t state)
      handle = pci_get_drvdata(pcidev);
      pcr = handle->pcr;

-    cancel_delayed_work(&pcr->carddet_work);
-    cancel_delayed_work(&pcr->idle_work);
+    spin_lock_irq(&pcr->lock);
+    rtsx_pci_writel(pcr, RTSX_BIER, 0);
+    pcr->bier = 0;
+    spin_unlock_irq(&pcr->lock);
+    cancel_delayed_work_sync(&pcr->carddet_work);
+    cancel_delayed_work_sync(&pcr->idle_work);
+    free_irq(pcr->irq, pcr);

      mutex_lock(&pcr->pcr_mutex);

@@ -1295,6 +1300,12 @@ static int rtsx_pci_resume(struct pci_dev *pcidev)
      handle = pci_get_drvdata(pcidev);
      pcr = handle->pcr;

+    ret = rtsx_pci_acquire_irq(pcr);
+    if (ret < 0)
+        return ret;
+    synchronize_irq(pcr->irq);
+    rtsx_pci_enable_bus_int(pcr);
+
      mutex_lock(&pcr->pcr_mutex);

      pci_set_power_state(pcidev, PCI_D0);
-- 
1.7.9.5


-- 
Best Regards
Micky.


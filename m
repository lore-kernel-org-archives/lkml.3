Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3K2JDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:03:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:60506 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2JDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:03:10 -0500
Date: Fri, 29 Nov 2013 10:02:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Francis Moreau <francis.moro@gmail.com>
cc: Jingoo Han <jg1.han@samsung.com>, "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
In-Reply-To: <52985041.5050000@gmail.com>
Message-ID: <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Francis Moreau wrote:
> Since it seems to be related to rtsx driver or its upper layer, could
> the folks involved in this area have a look to this issue please ?

I'm not involved, but looking at the debug objects backtrace it's
related to the delayed work in rtsx.

Does the untested patch below cure the issue?

Thanks,

	tglx

Index: linux-2.6/drivers/mfd/rtsx_pcr.c
===================================================================
--- linux-2.6.orig/drivers/mfd/rtsx_pcr.c
+++ linux-2.6/drivers/mfd/rtsx_pcr.c
@@ -1227,15 +1227,15 @@ static void rtsx_pci_remove(struct pci_d
 	struct rtsx_pcr *pcr = handle->pcr;
 
 	pcr->remove_pci = true;
+	free_irq(pcr->irq, (void *)pcr);
 
-	cancel_delayed_work(&pcr->carddet_work);
-	cancel_delayed_work(&pcr->idle_work);
+	cancel_delayed_work_sync(&pcr->carddet_work);
+	cancel_delayed_work_sync(&pcr->idle_work);
 
 	mfd_remove_devices(&pcidev->dev);
 
 	dma_free_coherent(&(pcr->pci->dev), RTSX_RESV_BUF_LEN,
 			pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
-	free_irq(pcr->irq, (void *)pcr);
 	if (pcr->msi_en)
 		pci_disable_msi(pcr->pci);
 	iounmap(pcr->remap_addr);
 

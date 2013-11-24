Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3KXNbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 08:31:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37514 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3KXNbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 08:31:14 -0500
Date: Sun, 24 Nov 2013 14:31:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131124133110.GD4208@pd.tnic>
References: <20131117195358.GO27323@pd.tnic>
 <24318767.PoCLxGCZH4@vostro.rjw.lan>
 <528FCE57.2000805@gmail.com>
 <2363041.q8n2SXViVK@vostro.rjw.lan>
 <alpine.DEB.2.02.1311222322480.30673@ionos.tec.linutronix.de>
 <5291C948.1080305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5291C948.1080305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 10:39:20AM +0100, Francis Moreau wrote:
> This looks like it was a good idea.
> 
> The kernel now outputs the following traces after resuming.
> 
> [   26.973928] WARNING: CPU: 0 PID: 4 at lib/debugobjects.c:260
> debug_print_object+0x83/0xa0()
> [   26.973932] ODEBUG: free active (active state 0) object type:
> timer_list hint: delayed_work_timer_fn+0x0/0x20

Just a stab in the dark, does the below fix it?

--
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 11e20afbdcac..e65a12dd6e20 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1228,8 +1228,8 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)
 
 	pcr->remove_pci = true;
 
-	cancel_delayed_work(&pcr->carddet_work);
-	cancel_delayed_work(&pcr->idle_work);
+	cancel_delayed_work_sync(&pcr->carddet_work);
+	cancel_delayed_work_sync(&pcr->idle_work);
 
 	mfd_remove_devices(&pcidev->dev);
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaKER6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:58:50 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:56170 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaKER6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:58:47 -0500
Message-ID: <545A6547.1030709@laposte.net>
Date: Wed, 05 Nov 2014 18:58:31 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: bhelgaas@google.com, aaron.lu@intel.com, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com> <20141105163159.GE14386@htj.dyndns.org>
In-Reply-To: <20141105163159.GE14386@htj.dyndns.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrhedvgddugecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucenucfjughrpefkfffhfgggvffufhgjtgfgsehtkegrtddtfeehnecuhfhrohhmpeeurghrthhouceomhhishhtvghrrdhfrhgvvghmrghnsehlrghpohhsthgvrdhnvghtqeenucffohhmrghinhepphgtihdrtgdqqddqrg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried the patch, it solves the problem,

but I had to change the patch in order to be compatible with 3.18rc3
source code :

patching file drivers/pci/pci.c
Hunk #1 FAILED at 2046.
1 out of 1 hunk FAILED -- saving rejects to file drivers/pci/pci.c.rej

here is the correct patch for kernel 3.18rc3 source code :

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


Le 05/11/2014 17:31, Tejun Heo a écrit :
> On Wed, Nov 05, 2014 at 09:07:45AM +0800, Chuansheng Liu wrote:
>> The JMicron chip 361/363/368 contains one SATA controller and
>> one PATA controller, they are brother-relation ship in PCI tree,
>> but for powering on these both controller, we must follow the
>> sequence one by one, otherwise one of them can not be powered on
>> successfully.
>>
>> So here we disable the async suspend method for Jmicron chip.
>>
>> Cc: stable@vger.kernel.org # 3.15+
>> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> 
> Applied to libata/for-3.18-fixes.
> 
> Thanks.
> 

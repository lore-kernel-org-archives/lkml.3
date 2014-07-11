Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaGKGkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:40:17 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:38612 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaGKGkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:40:16 -0400
Date: Fri, 11 Jul 2014 10:39:14 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-parport <linux-parport@lists.infradead.org>,
        Heiko Andreas Sommer <hsommer@eso.org>, matwey.kornilov@gmail.com
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
In-Reply-To: <20140710174320.GA24664@kroah.com>
Message-ID: <alpine.LRH.2.00.1407111032170.17648@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru> <20140709212910.GB26562@kroah.com> <alpine.LRH.2.00.1407101045510.25305@lnfm1.sai.msu.ru> <20140710170954.GB23544@kroah.com> <CAJs94Eao-ujjZevjptf5hhmkS742HdUVafP4avHR3gx0WzuSTw@mail.gmail.com>
 <20140710174320.GA24664@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Or did I read the patch incorrectly?
>>
>> Maybe I've implemented something incorrectly? I think I suggested
>> exactly inverse thing: the check is disabled only when the option is
>> touched by user:
>>
>> !force_epp && intel_bug_present(pb) <=> intel_bug_present(pb) (given
>> that force_epp is false)
>
> I don't understand, care to just resend the patches? I really don't
> remember what the patch said...

The patch is in bottom of this message. My suggestion was that people 
suffering from false positives will set the option to TRUE, and other 
won't touch it.

>>> Why not implement Alan's suggestion?
>>
>> Why not, if you are fine with it. Are you sure that PPro was turning point?
>
> If Alan says so, I believe him :)

Ok, then I believe you, I will go to reimplement it in Alan's way.


>From cf37d0cc4d51da5c0b368e1f5ab05082c041d1e1 Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Wed, 25 Jun 2014 01:08:45 +0400
Subject: [PATCH 2/2] Add force_epp module option for parport_pc.

The detection of Intel EPP bug is known to produce much false positives.
The new option is introduced to force enable EPP in spite of the test result.

Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
  drivers/parport/parport_pc.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index a6eaafb..fb7530d 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -105,6 +105,9 @@ static int user_specified;
         (defined(CONFIG_PARPORT_1284) && defined(CONFIG_PARPORT_PC_FIFO))
  static int verbose_probing;
  #endif
+#ifdef CONFIG_PARPORT_1284
+static int force_epp;
+#endif
  static int pci_registered_parport;
  static int pnp_registered_parport;

@@ -1764,7 +1767,7 @@ static int parport_EPP_supported(struct parport *pb)
  		return 0;  /* No way to clear timeout */

  	/* Check for Intel bug. */
-	if (intel_bug_present(pb))
+	if (!force_epp && intel_bug_present(pb))
  		return 0;

  	pb->modes |= PARPORT_MODE_EPP;
@@ -3147,6 +3150,10 @@ module_param_array(dma, charp, NULL, 0);
  MODULE_PARM_DESC(verbose_probing, "Log chit-chat during initialisation");
  module_param(verbose_probing, int, 0644);
  #endif
+#ifdef CONFIG_PARPORT_1284
+MODULE_PARM_DESC(force_epp, "Force EPP enabling when buggy hardware found by the module checks");
+module_param(force_epp, int, 0);
+#endif
  #ifdef CONFIG_PCI
  static char *init_mode;
  MODULE_PARM_DESC(init_mode,
-- 
1.8.1.4


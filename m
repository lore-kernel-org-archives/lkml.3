Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaBLPfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:35:21 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:12246 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBLPfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:35:20 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9gNPpyI0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1 of 1]: musb: fixed a potential NULL pointer dereference.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140212142945.GA9172@kroah.com>
Date: Wed, 12 Feb 2014 16:35:12 +0100
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D56478EB-6936-4DFC-94F9-2A9A3CC217F1@goldelico.com>
References: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com> <20140212142945.GA9172@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 12.02.2014 um 15:29 schrieb Greg Kroah-Hartman:

> On Wed, Feb 12, 2014 at 11:08:22AM +0100, Dr. H. Nikolaus Schaller wrote:
>> fixed a potential NULL pointer dereference.
>> 
>>    Rationale:
>>    this is the only location in the musb driver where the
>>    otg->gadget pointer is dereferenced. Assuming that it
>>    is never NULL is not only potentially unsafe but was
>>    observed in the wild on a GTA04 (OMAP3/TPS65950 based
>>    board) when trying to boot a device tree based 3.14-rc2
>>    kernel with USB cable plugged in.
>> 
>>    DT boot appears to modify the order in which components
>>    (gadget driver) are loaded and linked and therefore
>>    an early musb interrupt triggers with a NULL gadget
>>    pointer ending in a kernel panic.
>> 
>>    Since a non-existing gadget can never be "active" we
>>    simply use a 0 value for musb->is_active.
>> 
>>    Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> 
> Please don't attach patches, our tools don't like them at all.

Sorry. That was by accident. Here is the patch appended.

> 
> And shouldn't we fix the root problem here, not just gloss over the fact
> that this pointer is NULL at this point in time?  Fixing the real issue
> should be the correct solution, right?

Well,
I must admit that I have no idea what the root cause could be 
(because I neither know the musb nor the gadget subsystems)
or if it is intended and just something in the initialization
sequence has changed.

I have done one more test and it appears to be in a non-device-tree
3.14-rc1 as well. We did not see it in a 3.12.7 kernel on the same hardware.

> 
> thanks,
> 
> greg k-h


BR,
Nikolaus Schaller

---
 drivers/usb/musb/musb_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index df3f65d..f68afef 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -653,7 +653,8 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				break;
 		case OTG_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
-			musb->is_active = otg->gadget->b_hnp_enable;
+			musb->is_active =
+				otg->gadget ? otg->gadget->b_hnp_enable : 0;
 			if (musb->is_active) {
 				musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
-- 
1.7.7.4


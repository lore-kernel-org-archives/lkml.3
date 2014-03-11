Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaCKOA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:00:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45342 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaCKOAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:00:25 -0400
Date: Tue, 11 Mar 2014 14:00:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
Message-ID: <20140311140023.GA3556@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org>
 <20140304000904.GA6623@srcf.ucam.org>
 <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
 <20140308024016.GA24685@srcf.ucam.org>
 <CAMxnaaXQgE4gvfw7ocO4yTqGYvTTo+jwCde5caXpWJ8i1chDqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <CAMxnaaXQgE4gvfw7ocO4yTqGYvTTo+jwCde5caXpWJ8i1chDqg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 02:08:55PM +0100, Andreas Noever wrote:

> That seems to do it. I was afraid that setting OSDW globally would
> affect other parts (USB?) But that does not seem to be the case.

I think it results in the USB ports coming up in XHCI mode by default, 
but we can handle that. There's one other thing - the battery switches 
from being a control method battery to being an SBS one, and Apple's 
implementation seems to break our driver. I've got a trivial patch that 
makes it work (attached).

> What is the reason for clearing the PME flag?

It looks like the PME flag gets cleared on the _OSC route in non-Darwin 
mode? I'll go back and check that to make sure.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0021-ACPI-Don-t-re-select-SBS-battery-if-it-s-already-sel.patch"

>From 2a8ffff11f91aad146916ca14c768ebc407865aa Mon Sep 17 00:00:00 2001
From: Matthew Garrett <matthew.garrett@nebula.com>
Date: Mon, 10 Mar 2014 14:44:55 -0400
Subject: [PATCH 21/28] ACPI: Don't re-select SBS battery if it's already
 selected

The existing SBS code explicitly sets the selected battery in the SBS
manager regardless of whether the battery in question is already selected.
This causes bus timeouts on Apple hardware. Check for this case and avoid
it.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/sbs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index dbd4849..c386505 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -470,17 +470,25 @@ static struct device_attribute alarm_attr = {
 static int acpi_battery_read(struct acpi_battery *battery)
 {
 	int result = 0, saved_present = battery->present;
-	u16 state;
+	u16 state, selected, desired;
 
 	if (battery->sbs->manager_present) {
 		result = acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
 				ACPI_SBS_MANAGER, 0x01, (u8 *)&state);
 		if (!result)
 			battery->present = state & (1 << battery->id);
-		state &= 0x0fff;
-		state |= 1 << (battery->id + 12);
-		acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
-				  ACPI_SBS_MANAGER, 0x01, (u8 *)&state, 2);
+		/*
+		 * Don't switch battery if the correct one is already selected
+		 */
+		selected = state & 0xf000;
+		desired = 1 << (battery->id + 12);
+		if (selected != desired) {
+			state &= 0x0fff;
+			state |= desired;
+			acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
+					 ACPI_SBS_MANAGER, 0x01,
+					 (u8 *)&state, 2);
+		}
 	} else if (battery->id == 0)
 		battery->present = 1;
 	if (result || !battery->present)
-- 
1.8.5.3


--d6Gm4EdcadzBjdND--

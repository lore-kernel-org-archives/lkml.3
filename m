Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaGHTXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:23:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54215 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Philipp Wolfer" <ph.wolfer@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.303430243@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 068/125] Input: elantech - don't set bit 1 of reg_10
 when the no_hw_res quirk is set
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit fb4f8f568a9def02240ef9bf7aabd246dc63a081 upstream.

The touchpad on the GIGABYTE U2442 not only stops communicating when we try
to set bit 3 (enable real hardware resolution) of reg_10, but on some BIOS
versions also when we set bit 1 (enable two finger mode auto correct).

I've asked the original reporter of:
https://bugzilla.kernel.org/show_bug.cgi?id=61151

To check that not setting bit 1 does not lead to any adverse effects on his
model / BIOS revision, and it does not, so this commit fixes the touchpad
not working on these versions by simply never setting bit 1 for laptop
models with the no_hw_res quirk.

Reported-and-tested-by: James Lademann <jwlademann@gmail.com>
Tested-by: Philipp Wolfer <ph.wolfer@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/elantech.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -801,7 +801,7 @@ static int elantech_set_absolute_mode(st
 		if (etd->set_hw_resolution)
 			etd->reg_10 = 0x0b;
 		else
-			etd->reg_10 = 0x03;
+			etd->reg_10 = 0x01;
 
 		if (elantech_write_reg(psmouse, 0x10, etd->reg_10))
 			rc = -1;
@@ -1225,7 +1225,8 @@ static int elantech_reconnect(struct psm
 }
 
 /*
- * Some hw_version 3 models go into error state when we try to set bit 3 of r10
+ * Some hw_version 3 models go into error state when we try to set
+ * bit 3 and/or bit 1 of r10.
  */
 static const struct dmi_system_id no_hw_res_dmi_table[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)


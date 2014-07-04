Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbaGDWnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:43:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031163AbaGDWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Wolfer <ph.wolfer@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 05/46] Input: elantech - dont set bit 1 of reg_10 when the no_hw_res quirk is set
Date: Fri,  4 Jul 2014 15:19:09 -0700
Message-Id: <20140704221602.519903094@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elantech.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -819,7 +819,7 @@ static int elantech_set_absolute_mode(st
 		if (etd->set_hw_resolution)
 			etd->reg_10 = 0x0b;
 		else
-			etd->reg_10 = 0x03;
+			etd->reg_10 = 0x01;
 
 		if (elantech_write_reg(psmouse, 0x10, etd->reg_10))
 			rc = -1;
@@ -1320,7 +1320,8 @@ static int elantech_reconnect(struct psm
 }
 
 /*
- * Some hw_version 3 models go into error state when we try to set bit 3 of r10
+ * Some hw_version 3 models go into error state when we try to set
+ * bit 3 and/or bit 1 of r10.
  */
 static const struct dmi_system_id no_hw_res_dmi_table[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)



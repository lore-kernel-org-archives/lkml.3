Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaCMFRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 01:17:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38682 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaCMFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 01:17:39 -0400
From: Masood Mehmood <ody.guru@gmail.com>
To: gregkh@linuxfoundation.org
Cc: eng.linux@digi.com, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: Fixed sparse error: same symbol redeclared with different type
Date: Wed, 12 Mar 2014 20:55:44 -0700
Message-Id: <1394682944-3134-1-git-send-email-ody.guru@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse reported dgap_do_fep_load is redeclared with different type. while
fixing, I noticed __user attribute is used incorrectly in declaration.
There is no need to define __user for firware->data.

Replaced the __user with 'const uchar *' from function dgap_do_fep_load and
did the same for function dgap_do_bios_load.

Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
---
 drivers/staging/dgap/dgap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d00283a..ab81479 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -210,9 +210,8 @@ static uint dgap_config_get_useintr(struct board_t *bd);
 static uint dgap_config_get_altpin(struct board_t *bd);
 
 static int dgap_ms_sleep(ulong ms);
-static void dgap_do_bios_load(struct board_t *brd, uchar __user *ubios,
-				int len);
-static void dgap_do_fep_load(struct board_t *brd, uchar __user *ufep, int len);
+static void dgap_do_bios_load(struct board_t *brd, const uchar *ubios, int len);
+static void dgap_do_fep_load(struct board_t *brd, const uchar *ufep, int len);
 #ifdef DIGI_CONCENTRATORS_SUPPORTED
 static void dgap_do_conc_load(struct board_t *brd, uchar *uaddr, int len);
 #endif
@@ -935,7 +934,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 				fw_info[card_type].bios_name);
 			return ret;
 		}
-		dgap_do_bios_load(brd, (char *)fw->data, fw->size);
+		dgap_do_bios_load(brd, fw->data, fw->size);
 		release_firmware(fw);
 
 		/* Wait for BIOS to test board... */
@@ -953,7 +952,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 				fw_info[card_type].fep_name);
 			return ret;
 		}
-		dgap_do_fep_load(brd, (char *)fw->data, fw->size);
+		dgap_do_fep_load(brd, fw->data, fw->size);
 		release_firmware(fw);
 
 		/* Wait for FEP to load on board... */
@@ -4349,7 +4348,7 @@ static int dgap_tty_register_ports(struct board_t *brd)
  * Copies the BIOS code from the user to the board,
  * and starts the BIOS running.
  */
-static void dgap_do_bios_load(struct board_t *brd, uchar __user *ubios, int len)
+static void dgap_do_bios_load(struct board_t *brd, const uchar *ubios, int len)
 {
 	uchar *addr;
 	uint offset;
@@ -4425,7 +4424,7 @@ static void dgap_do_wait_for_bios(struct board_t *brd)
  * Copies the FEP code from the user to the board,
  * and starts the FEP running.
  */
-static void dgap_do_fep_load(struct board_t *brd, uchar *ufep, int len)
+static void dgap_do_fep_load(struct board_t *brd, const uchar *ufep, int len)
 {
 	uchar *addr;
 	uint offset;
-- 
1.8.3.1


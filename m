Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaI2NLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:11:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64715 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaI2NLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:11:08 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] dell-wmi: Fix access out of memory
Date: Mon, 29 Sep 2014 15:10:51 +0200
Message-Id: <1411996251-13455-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch driver dell-wmi is trying to access elements of dynamically
allocated array without checking array size. This can lead to memory corruption
or kernel panic. This patch adds missing checks for array size.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
This patch should be probably applied to stable kernel trees as it fixing
possible memory corruption.
---
 drivers/platform/x86/dell-wmi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 390e8e3..25721bf 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -163,18 +163,24 @@ static void dell_wmi_notify(u32 value, void *context)
 		const struct key_entry *key;
 		int reported_key;
 		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
+		int buffer_size = obj->buffer.length/2;
 
-		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
+		if (buffer_size >= 2 && dell_new_hk_type && buffer_entry[1] != 0x10) {
 			pr_info("Received unknown WMI event (0x%x)\n",
 				buffer_entry[1]);
 			kfree(obj);
 			return;
 		}
 
-		if (dell_new_hk_type || buffer_entry[1] == 0x0)
+		if (buffer_size >= 3 && (dell_new_hk_type || buffer_entry[1] == 0x0))
 			reported_key = (int)buffer_entry[2];
-		else
+		else if (buffer_size >= 2)
 			reported_key = (int)buffer_entry[1] & 0xffff;
+		else {
+			pr_info("Received unknown WMI event\n");
+			kfree(obj);
+			return;
+		}
 
 		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
 							reported_key);
-- 
1.7.9.5


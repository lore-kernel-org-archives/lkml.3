Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaKYKon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:44:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaKYKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 254/254] dell-wmi: Fix access out of memory
Date: Tue, 25 Nov 2014 10:40:04 +0000
Message-Id: <1416912004-5928-255-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

commit a666b6ffbc9b6705a3ced704f52c3fe9ea8bf959 upstream.

Without this patch, dell-wmi is trying to access elements of dynamically
allocated array without checking the array size. This can lead to memory
corruption or a kernel panic. This patch adds the missing checks for
array size.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/dell-wmi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 390e8e33d5e3..25721bf20092 100644
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
2.1.0


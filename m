Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3INPEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 11:04:00 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44699 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab3INPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 11:03:58 -0400
From: Elad Wexler <elad.wexler@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Elad Wexler <elad.wexler@gmail.com>
Subject: [PATCH] Drivers: char: misc: 'misc_deregister()' changed the 'mutex_unlock' logic upon an error
Date: Sat, 14 Sep 2013 18:02:11 +0300
Message-Id: <1379170931-23517-1-git-send-email-elad.wexler@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elad Wexler <elad.wexler@gmail.com>

This change improves code readability & is less error-prone.
For example: case adding more error paths one should remember to call 'mutex_unlock'

Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
---
 drivers/char/misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 190d442..dd91726 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -193,8 +193,8 @@ int misc_register(struct miscdevice * misc)
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
 		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
 		if (i >= DYNAMIC_MINORS) {
-			mutex_unlock(&misc_mtx);
-			return -EBUSY;
+			err =  -EBUSY;
+			goto out;
 		}
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
@@ -203,8 +203,8 @@ int misc_register(struct miscdevice * misc)
 
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == misc->minor) {
-				mutex_unlock(&misc_mtx);
-				return -EBUSY;
+				err = -EBUSY;
+				goto out;
 			}
 		}
 	}
-- 
1.8.3.1


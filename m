Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaDTJW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 05:22:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52189 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaDTJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 05:22:19 -0400
Message-ID: <1397985057.12169.7.camel@vash.home>
Subject: [PATCH 1/1] staging: android: Fix warning cast removes address
 space of expression
From: Camille Bordignon <camille.bordignon@gmail.com>
To: arve@android.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Sun, 20 Apr 2014 11:10:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning "cast removes address space of expression"
Add lost flag "__user" due to cast

Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
---
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..952c4ae 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2683,16 +2683,21 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
-		if (size != sizeof(struct binder_version)) {
+	case BINDER_VERSION: {
+		struct binder_version __user *bv = ubuf;
+
+		if (size != sizeof(*bv)) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+				&bv->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto err;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3LPOVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:21:53 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64815 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:21:51 -0500
From: xqx12 <s2exqx@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, chyyuu@gmail.com, xuyongjiande@gmail.com,
        xqx12 <xiaoqixue_1@163.com>
Subject: [PATCH] tty: an overflow of multiplication in drivers/tty/cyclades.c
Date: Mon, 16 Dec 2013 22:21:36 +0800
Message-Id: <1387203696-10759-1-git-send-email-xiaoqixue_1@163.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is an overflow in the code :
cyz_polling_cycle = (arg * HZ) / 1000,
the multiplicator arg comes from user, so it may be an overflow if
arg is a big number. And the value of cyc_polling_cycle will be
wrong when it is used next time.

Reported-by: Qixue Xiao <xiaoqixue_1@163.com>
Suggested-by: Yongjian Xu <xuyongjiande@gmail.com>
Suggested-by: Yu Chen <chyyuu@gmail.com>
Signed-off-by: Qixue Xiao <xiaoqixue_1@163.com>
---
 drivers/tty/cyclades.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index cfeec97..7eec1c5 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -2728,7 +2728,8 @@ cy_ioctl(struct tty_struct *tty,
 		break;
 #ifndef CONFIG_CYZ_INTR
 	case CYZSETPOLLCYCLE:
+		if (arg > LONG_MAX / HZ)
+			return -ENODEV;
 		cyz_polling_cycle = (arg * HZ) / 1000;
 		break;
 	case CYZGETPOLLCYCLE:
-- 
1.7.9.5


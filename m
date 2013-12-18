Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3LRBAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:00:50 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61049 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3LRBAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:00:48 -0500
From: xqx12 <s2exqx@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, chyyuu@gmail.com, xuyongjiande@gmail.com,
        xqx12 <xiaoqixue_1@163.com>
Subject: [PATCH] tty: an overflow of multiplication in drivers/tty/cyclades.c
Date: Wed, 18 Dec 2013 09:00:29 +0800
Message-Id: <1387328429-15172-1-git-send-email-xiaoqixue_1@163.com>
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
 drivers/tty/cyclades.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 33f83fe..a57bb5a 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -2709,6 +2709,8 @@ cy_ioctl(struct tty_struct *tty,
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3H2H53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:57:29 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33064 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3H2H52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:57:28 -0400
From: Oleksandr Kozaruk <alkhozar@gmail.com>
To: gregkh@linuxfoundation.org, chao.bi@intel.com,
        yongjun_wei@trendmicro.com.cn
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: misc: ti-st: fix potential race if st_kim_start fails
Date: Thu, 29 Aug 2013 10:55:48 +0300
Message-Id: <1377762948-13545-1-git-send-email-oleksandr.kozaruk@globallogic.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If st_kim_start() fails registered protocols should be removed. This is
done by calling st_reg_complete(), which as comment states is called
with spin lock held. But in st_register() when st_kim_start fails it
is called without holding spin lock, creating possibility of concurrent
access to st_gdata data members.
Hold spin lock while calling st_reg_complete if st_kim_start() fails.

Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@globallogic.com>
---
 drivers/misc/ti-st/st_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 0a14280..8d64b68 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -562,7 +562,9 @@ long st_register(struct st_proto_s *new_proto)
 			if ((st_gdata->protos_registered != ST_EMPTY) &&
 			    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 				pr_err(" KIM failure complete callback ");
+				spin_lock_irqsave(&st_gdata->lock, flags);
 				st_reg_complete(st_gdata, err);
+				spin_unlock_irqrestore(&st_gdata->lock, flags);
 				clear_bit(ST_REG_PENDING, &st_gdata->st_state);
 			}
 			return -EINVAL;
-- 
1.8.1.2


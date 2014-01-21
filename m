Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaAUVZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50703 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAUVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 27/73] drivers/clk: don't use module_init in clk-nomadik.c which is non-modular
Date: Tue, 21 Jan 2014 16:22:30 -0500
Message-ID: <1390339396-3479-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk-nomadik.o is built for ARCH_NOMADIK -- which is bool, and
hence this code is either present or absent.  It will never be
modular, so using module_init as an alias for __initcall can be
somewhat misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/clk/clk-nomadik.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/clk-nomadik.c b/drivers/clk/clk-nomadik.c
index 6a934a5..5be9b9f 100644
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -500,8 +500,7 @@ static int __init nomadik_src_clk_init_debugfs(void)
 			    NULL, NULL, &nomadik_src_clk_debugfs_ops);
 	return 0;
 }
-
-module_init(nomadik_src_clk_init_debugfs);
+device_initcall(nomadik_src_clk_init_debugfs);
 
 #endif
 
-- 
1.8.4.1


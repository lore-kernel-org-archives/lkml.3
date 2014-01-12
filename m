Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaALRin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:38:43 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47851 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaALRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:38:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] drivers/char: don't use module_init in non-modular ttyprintk.c
Date: Sun, 12 Jan 2014 12:37:56 -0500
Message-ID: <1389548276-30606-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TTY_PRINTK option is bool, and hence this code is either
present or absent.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[resending with lkml on the Cc list this time.]

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index d5d2e4a985aa..daea84c41743 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -216,4 +216,4 @@ error:
 	ttyprintk_driver = NULL;
 	return ret;
 }
-module_init(ttyprintk_init);
+device_initcall(ttyprintk_init);
-- 
1.8.5.2


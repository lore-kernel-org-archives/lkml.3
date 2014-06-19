Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbaFSUcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:32:14 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:63980 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:32:12 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 16:32:12 EDT
From: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>,
        Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>,
        John Crispin <blogic@openwrt.org>,
        Qais Yousef <Qais.Yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
Subject: [PATCH 1/1] MIPS: APRP: Fix an issue when device_create() fails.
Date: Thu, 19 Jun 2014 16:30:23 -0400
Message-Id: <1403209823-6376-1-git-send-email-sebastien.bourdelin@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a call to device_create() fails for a channel during the initialize
loop, we need to clean the devices entries already created before
leaving.

Signed-off-by: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
---
 arch/mips/kernel/rtlx-cmp.c | 3 +++
 arch/mips/kernel/rtlx-mt.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/mips/kernel/rtlx-cmp.c b/arch/mips/kernel/rtlx-cmp.c
index 758fb3c..d26dcc4 100644
--- a/arch/mips/kernel/rtlx-cmp.c
+++ b/arch/mips/kernel/rtlx-cmp.c
@@ -77,6 +77,9 @@ int __init rtlx_module_init(void)
 		dev = device_create(mt_class, NULL, MKDEV(major, i), NULL,
 				    "%s%d", RTLX_MODULE_NAME, i);
 		if (IS_ERR(dev)) {
+			while (i--)
+				device_destroy(mt_class, MKDEV(major, i));
+
 			err = PTR_ERR(dev);
 			goto out_chrdev;
 		}
diff --git a/arch/mips/kernel/rtlx-mt.c b/arch/mips/kernel/rtlx-mt.c
index 5a66b97..cb95470 100644
--- a/arch/mips/kernel/rtlx-mt.c
+++ b/arch/mips/kernel/rtlx-mt.c
@@ -103,6 +103,9 @@ int __init rtlx_module_init(void)
 		dev = device_create(mt_class, NULL, MKDEV(major, i), NULL,
 				    "%s%d", RTLX_MODULE_NAME, i);
 		if (IS_ERR(dev)) {
+			while (i--)
+				device_destroy(mt_class, MKDEV(major, i));
+
 			err = PTR_ERR(dev);
 			goto out_chrdev;
 		}
-- 
1.8.3.4


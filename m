Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3LHLcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 06:32:36 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39423 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3LHLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 06:32:34 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        raghavendra.kt@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] xen/debugfs: Check debugfs initialization before using it
Date: Sun,  8 Dec 2013 19:31:02 +0800
Message-Id: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should check debugfs initialization with debugfs_initialized() before using it,
Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
functions would be ERR_PTR(-ENODEV), checking with NULL will not work.

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 arch/x86/xen/debugfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
index c8377fb..85c0e0e 100644
--- a/arch/x86/xen/debugfs.c
+++ b/arch/x86/xen/debugfs.c
@@ -9,12 +9,18 @@ static struct dentry *d_xen_debug;
 
 struct dentry * __init xen_init_debugfs(void)
 {
+	if (!debugfs_initialized()) {
+		d_xen_debug = NULL;
+		goto nodebugfs;
+	}
+
 	if (!d_xen_debug) {
 		d_xen_debug = debugfs_create_dir("xen", NULL);
 
 		if (!d_xen_debug)
 			pr_warning("Could not create 'xen' debugfs directory\n");
 	}
+nodebugfs:
 
 	return d_xen_debug;
 }
-- 
1.8.3.4 (Apple Git-47)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaDALHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:07:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDALHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:07:51 -0400
Date: Tue, 1 Apr 2014 04:07:39 -0700
From: tip-bot for Dimitri Sivanich <tipbot@zytor.com>
Message-ID: <tip-fe455b17de6c881eecf4f9784c3b0483a5e3d19e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sivanich@sgi.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sivanich@sgi.com
In-Reply-To: <20140331152320.GA31495@sgi.com>
References: <20140331152320.GA31495@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Fix conditional in gru_exit()
Git-Commit-ID: fe455b17de6c881eecf4f9784c3b0483a5e3d19e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe455b17de6c881eecf4f9784c3b0483a5e3d19e
Gitweb:     http://git.kernel.org/tip/fe455b17de6c881eecf4f9784c3b0483a5e3d19e
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Mon, 31 Mar 2014 10:23:20 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 1 Apr 2014 12:10:45 +0200

x86/UV: Fix conditional in gru_exit()

Fix supported system conditional in gru_exit(), in preparation for UV3.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Link: http://lkml.kernel.org/r/20140331152320.GA31495@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/misc/sgi-gru/grufile.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 0535d1e..104a05f 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -6,7 +6,7 @@
  * This file supports the user system call for file open, close, mmap, etc.
  * This also incudes the driver initialization code.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2008-2014 Silicon Graphics, Inc.  All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -58,6 +58,11 @@ static int max_user_cbrs, max_user_dsr_bytes;
 
 static struct miscdevice gru_miscdev;
 
+static int gru_supported(void)
+{
+	return is_uv_system() &&
+		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE);
+}
 
 /*
  * gru_vma_close
@@ -518,7 +523,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
+	if (!gru_supported())
 		return 0;
 
 #if defined CONFIG_IA64
@@ -573,7 +578,7 @@ exit0:
 
 static void __exit gru_exit(void)
 {
-	if (!is_uv_system())
+	if (!gru_supported())
 		return;
 
 	gru_teardown_tlb_irqs();

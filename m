Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaJIQC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:02:29 -0400
Received: from mail-pa0-f65.google.com ([209.85.220.65]:62739 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaJIQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:02:21 -0400
Message-ID: <5436B188.3070608@gmail.com>
Date: Fri, 10 Oct 2014 02:32:16 +1030
From: Daniel Cotton <danielcotton.mailinglists@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: axboe@fb.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] mtip32xx: Fix incorrect warning
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent mtip32xx block driver from showing a warning at load time 
("Error creating debugfs parent") when debugfs is not included in
the kernel. If debugfs is included, show the error code. Fixes bug
55831 in the Bugzilla.

Signed-off-by: Daniel Cotton <danielcotton.patches@gmail.com>
---
  drivers/block/mtip32xx/mtip32xx.c | 11 +++++++----
  1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c 
b/drivers/block/mtip32xx/mtip32xx.c
index 5c8e7fe..1124c61 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4686,16 +4686,19 @@ static int __init mtip_init(void)
  	mtip_major = error;

  	dfs_parent = debugfs_create_dir("rssd", NULL);
-	if (IS_ERR_OR_NULL(dfs_parent)) {
-		pr_warn("Error creating debugfs parent\n");
+	if (IS_ERR_OR_NULL(dfs_parent) && PTR_ERR(dfs_parent) != -ENODEV) {
+		pr_warn("Error creating debugfs parent, error code: %ld\n",
+			PTR_ERR(dfs_parent));
  		dfs_parent = NULL;
  	}
  	if (dfs_parent) {
  		dfs_device_status = debugfs_create_file("device_status",
  					S_IRUGO, dfs_parent, NULL,
  					&mtip_device_status_fops);
-		if (IS_ERR_OR_NULL(dfs_device_status)) {
-			pr_err("Error creating device_status node\n");
+		if (IS_ERR_OR_NULL(dfs_device_status) &&
+		    PTR_ERR(dfs_device_status) != -ENODEV) {
+			pr_err("Error creating device_status node, error code: %ld\n",
+				PTR_ERR(dfs_device_status));
  			dfs_device_status = NULL;
  		}
  	}

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946334Ab3BHLmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:42:08 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:42439 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946307Ab3BHLmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:42:06 -0500
From: Tommi Rantala <tt.rantala@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: davej@redhat.com, Bill Pemberton <wfp5p@virginia.edu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 1/2] staging: dgrp: use correct release op for /proc/dgrp/info
Date: Fri,  8 Feb 2013 13:41:25 +0200
Message-Id: <1360323686-14845-1-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trinity (the syscall fuzzer) discovered that reading /proc/dgrp/info was
leaking some memory. Fix by using the correct release op in info_proc_file_ops.

unreferenced object 0xffff88003b6696e0 (size 32):
  comm "cat", pid 2321, jiffies 4294705179 (age 29.434s)
  hex dump (first 32 bytes):
    40 79 1c 81 ff ff ff ff 60 79 1c 81 ff ff ff ff  @y......`y......
    50 79 1c 81 ff ff ff ff b0 62 89 81 ff ff ff ff  Py.......b......
  backtrace:
    [<ffffffff81c7e3b1>] kmemleak_alloc+0x21/0x50
    [<ffffffff811955cb>] kmem_cache_alloc_trace+0x11b/0x190
    [<ffffffff811c87dc>] single_open+0x3c/0xc0
    [<ffffffff81896495>] info_proc_open+0x15/0x20
    [<ffffffff8120c6d7>] proc_reg_open+0xb7/0x160
    [<ffffffff811a1a5c>] do_dentry_open+0x1cc/0x280
    [<ffffffff811a296a>] finish_open+0x4a/0x60
    [<ffffffff811b14d7>] do_last+0xb07/0xdb0
    [<ffffffff811b1842>] path_openat+0xc2/0x4f0
    [<ffffffff811b1cac>] do_filp_open+0x3c/0xa0
    [<ffffffff811a2dcc>] do_sys_open+0x11c/0x1c0
    [<ffffffff811a2e8c>] sys_open+0x1c/0x20
    [<ffffffff81ca3d69>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 drivers/staging/dgrp/dgrp_specproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index c214078..aff6707c 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -102,7 +102,7 @@ static struct file_operations info_proc_file_ops = {
 	.open	 = info_proc_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
-	.release = seq_release,
+	.release = single_release,
 };
 
 static struct file_operations nodeinfo_proc_file_ops = {
-- 
1.8.1


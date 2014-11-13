Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbaKMTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:27 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:51936 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945AbaKMTZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:21 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 07/16] hyperv: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:13 -0500
Message-Id: <1415906662-4576-8-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/hyperv.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 08cfaff..06418b1 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -127,13 +127,12 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 			  u32 *read, u32 *write)
 {
 	u32 read_loc, write_loc, dsize;
-
-	smp_read_barrier_depends();
+	struct hv_ring_buffer_info *rbi_p = lockless_dereference(rbi);
 
 	/* Capture the read/write indices before they changed */
-	read_loc = rbi->ring_buffer->read_index;
-	write_loc = rbi->ring_buffer->write_index;
-	dsize = rbi->ring_datasize;
+	read_loc = rbi_p->ring_buffer->read_index;
+	write_loc = rbi_p->ring_buffer->write_index;
+	dsize = rbi_p->ring_datasize;
 
 	*write = write_loc >= read_loc ? dsize - (write_loc - read_loc) :
 		read_loc - write_loc;
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaA0U2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:28:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:51743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbaA0U2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,731,1384329600"; 
   d="scan'208";a="471628392"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 2/2] mei: don't unset read cb ptr on reset
Date: Mon, 27 Jan 2014 22:27:24 +0200
Message-Id: <1390854444-30650-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390854444-30650-1-git-send-email-tomas.winkler@intel.com>
References: <1390854444-30650-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Don't set read callback to NULL during reset as
this leads to memory leak of both cb and its buffer.
The memory is correctly freed during mei_release.

The memory leak is detectable by kmemleak if
application has open read call while system is going through
suspend/resume.

unreferenced object 0xecead780 (size 64):
  comm "AsyncTask #1", pid 1018, jiffies 4294949621 (age 152.440s)
  hex dump (first 32 bytes):
    00 01 10 00 00 02 20 00 00 bf 30 f1 00 00 00 00  ...... ...0.....
    00 00 00 00 00 00 00 00 36 01 00 00 00 70 da e2  ........6....p..
  backtrace:
    [<c1a60aec>] kmemleak_alloc+0x3c/0xa0
    [<c131ed56>] kmem_cache_alloc_trace+0xc6/0x190
    [<c16243c9>] mei_io_cb_init+0x29/0x50
    [<c1625722>] mei_cl_read_start+0x102/0x360
    [<c16268f3>] mei_read+0x103/0x4e0
    [<c1324b09>] vfs_read+0x89/0x160
    [<c1324d5f>] SyS_read+0x4f/0x80
    [<c1a7b318>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff
unreferenced object 0xe2da7000 (size 512):
  comm "AsyncTask #1", pid 1018, jiffies 4294949621 (age 152.440s)
  hex dump (first 32 bytes):
    00 6c da e2 7c 00 00 00 00 00 00 00 c0 eb 0c 59  .l..|..........Y
    1b 00 00 00 01 00 00 00 02 10 00 00 01 00 00 00  ................
  backtrace:
    [<c1a60aec>] kmemleak_alloc+0x3c/0xa0
    [<c131f127>] __kmalloc+0xe7/0x1d0
    [<c162447e>] mei_io_cb_alloc_resp_buf+0x2e/0x60
    [<c162574c>] mei_cl_read_start+0x12c/0x360
    [<c16268f3>] mei_read+0x103/0x4e0
    [<c1324b09>] vfs_read+0x89/0x160
    [<c1324d5f>] SyS_read+0x4f/0x80
    [<c1a7b318>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 8bf2034..23455c7 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -926,7 +926,6 @@ void mei_cl_all_disconnect(struct mei_device *dev)
 	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
 		cl->state = MEI_FILE_DISCONNECTED;
 		cl->mei_flow_ctrl_creds = 0;
-		cl->read_cb = NULL;
 		cl->timer_count = 0;
 	}
 }
-- 
1.8.5.3


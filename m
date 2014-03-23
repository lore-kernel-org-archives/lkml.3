Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaCWFoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 01:44:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37130 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaCWFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 01:44:23 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH for v3.15] media: davinci: vpfe: make sure all the buffers unmapped and released
Date: Sun, 23 Mar 2014 11:14:11 +0530
Message-Id: <1395553451-21249-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch makes sure that it terminates if any IO in
progress and also makes sure that all the buffers are unmapped.
It was observed that with several runs of application the application
sometimes failed to allocate memory, This patch makes sure it
all the buffers are released.

Using kmemleak it was found that buffer were not released, this patch
fixes following issue,

 echo scan > /sys/kernel/debug/kmemleak
  Kernel message reads:
      memleak: 3 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

Then,
     cat /sys/kernel/debug/kmemleak

  unreferenced object 0xc564a480 (size 192):
  comm "mttest", pid 764, jiffies 4294945878 (age 487.160s)
  hex dump (first 32 bytes):
    00 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
    00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
  backtrace:
    [<c00a98dc>] create_object+0x10c/0x28c
    [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
    [<c00a67c0>] __kmalloc+0x11c/0x1d4
    [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
    [<c02b6194>] videobuf_alloc_vb+0x38/0x80
    [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
    [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
    [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
    [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
    [<c02aae90>] v4l_reqbufs+0x50/0x54
    [<c02aab54>] __video_do_ioctl+0x260/0x2c4
    [<c02a9dd4>] video_usercopy+0xf0/0x310
    [<c02aa008>] video_ioctl2+0x14/0x1c
    [<c02a562c>] v4l2_ioctl+0x104/0x14c
    [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
    [<c00bd5b4>] SyS_ioctl+0x44/0x64
unreferenced object 0xc564ac00 (size 192):
  comm "mttest", pid 764, jiffies 4294945878 (age 487.160s)
  hex dump (first 32 bytes):
    01 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
    00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
  backtrace:
    [<c00a98dc>] create_object+0x10c/0x28c
    [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
    [<c00a67c0>] __kmalloc+0x11c/0x1d4
    [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
    [<c02b6194>] videobuf_alloc_vb+0x38/0x80
    [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
    [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
    [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
    [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
    [<c02aae90>] v4l_reqbufs+0x50/0x54
    [<c02aab54>] __video_do_ioctl+0x260/0x2c4
    [<c02a9dd4>] video_usercopy+0xf0/0x310
    [<c02aa008>] video_ioctl2+0x14/0x1c
    [<c02a562c>] v4l2_ioctl+0x104/0x14c
    [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
    [<c00bd5b4>] SyS_ioctl+0x44/0x64
unreferenced object 0xc564a180 (size 192):
  comm "mttest", pid 764, jiffies 4294945880 (age 487.140s)
  hex dump (first 32 bytes):
    02 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
    00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
  backtrace:
    [<c00a98dc>] create_object+0x10c/0x28c
    [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
    [<c00a67c0>] __kmalloc+0x11c/0x1d4
    [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
    [<c02b6194>] videobuf_alloc_vb+0x38/0x80
    [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
    [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
    [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
    [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
    [<c02aae90>] v4l_reqbufs+0x50/0x54
    [<c02aab54>] __video_do_ioctl+0x260/0x2c4
    [<c02a9dd4>] video_usercopy+0xf0/0x310
    [<c02aa008>] video_ioctl2+0x14/0x1c
    [<c02a562c>] v4l2_ioctl+0x104/0x14c
    [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
    [<c00bd5b4>] SyS_ioctl+0x44/0x64

Reported-by: Jimmy Ho <jimmygge@gmail.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 9474f4a..ac6c8c6 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -734,6 +734,8 @@ static int vpfe_release(struct file *file)
 		}
 		vpfe_dev->io_usrs = 0;
 		vpfe_dev->numbuffers = config_params.numbuffers;
+		videobuf_stop(&vpfe_dev->buffer_queue);
+		videobuf_mmap_free(&vpfe_dev->buffer_queue);
 	}
 
 	/* Decrement device usrs counter */
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaKKBrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:47:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:27159 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:47:36 -0500
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] init:add boot option "initramfs_packnum"
Date: Tue, 11 Nov 2014 09:42:14 +0800
Message-ID: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the development phase, we usually enlarge initrd-end to reserve more
memory than the initfs zip exactly occupied. Then we can easily add or delete
files in zip package, without generate fdt again and again. But unfortunately,
if too many zeros followed initfs zip, it will take a long time to break the
loop.

while (!message && len) {
        ... ...
        if (!*buf) {
		buf++;
                ... ...
                continue;
        }

So, use the boot option "initramfs_packnum" to specify how many zip packages
in each initrd area. When the specified number of packages decompressed in one
area, immediately terminate the loop. Have no impact on current use by default.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 init/initramfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/init/initramfs.c b/init/initramfs.c
index ad1bd77..356764f 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -446,12 +446,24 @@ static unsigned long my_inptr; /* index of next byte to be processed in inbuf */

 #include <linux/decompress/generic.h>

+/* zero and negative means packages number is unlimited */
+static int initramfs_packnum __initdata;
+
+static __init int setup_initramfs_packnum(char *str)
+{
+	get_option(&str, &initramfs_packnum);
+
+	return 0;
+}
+early_param("initramfs_packnum", setup_initramfs_packnum);
+
 static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 {
 	long written;
 	decompress_fn decompress;
 	const char *compress_name;
 	static __initdata char msg_buf[64];
+	int packnum = initramfs_packnum;

 	header_buf = kmalloc(110, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
@@ -500,6 +512,9 @@ static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 		this_header = saved_offset + my_inptr;
 		buf += my_inptr;
 		len -= my_inptr;
+
+		if (!(--packnum))
+			break;
 	}
 	dir_utime();
 	kfree(name_buf);
--
1.8.0



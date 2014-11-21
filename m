Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbaKUDrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 22:47:24 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:55663 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKUDrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 22:47:22 -0500
Message-ID: <546EB5A2.5050604@huawei.com>
Date: Fri, 21 Nov 2014 11:46:42 +0800
From: leizhen <thunder.leizhen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Fwd: [PATCH 1/1] init:add boot option "initramfs_packnum"
References: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com>
In-Reply-To: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com>
X-Forwarded-Message-Id: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi erverbody! What about your opinion?

I run "scripts/get_maintainer.pl -f init/", but it displays no maintainer.
So this time, I added all people the result listed and added famous Linus Torvalds.

This patch is useful and no harmful.


-------- Original Message --------
Subject: [PATCH 1/1] init:add boot option "initramfs_packnum"
Date: Tue, 11 Nov 2014 09:42:14 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, Mark Rustad <mark.d.rustad@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>, Zhen Lei <thunder.leizhen@huawei.com>

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



.





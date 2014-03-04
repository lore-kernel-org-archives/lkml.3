Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaCDUE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaCDUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 21/97] 9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers
Date: Tue,  4 Mar 2014 12:03:34 -0800
Message-Id: <20140304200346.771642798@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Yao <ryao@gentoo.org>

[ Upstream commit b6f52ae2f0d32387bde2b89883e3b64d88b9bfe8 ]

The 9p-virtio transport does zero copy on things larger than 1024 bytes
in size. It accomplishes this by returning the physical addresses of
pages to the virtio-pci device. At present, the translation is usually a
bit shift.

That approach produces an invalid page address when we read/write to
vmalloc buffers, such as those used for Linux kernel modules. Any
attempt to load a Linux kernel module from 9p-virtio produces the
following stack.

[<ffffffff814878ce>] p9_virtio_zc_request+0x45e/0x510
[<ffffffff814814ed>] p9_client_zc_rpc.constprop.16+0xfd/0x4f0
[<ffffffff814839dd>] p9_client_read+0x15d/0x240
[<ffffffff811c8440>] v9fs_fid_readn+0x50/0xa0
[<ffffffff811c84a0>] v9fs_file_readn+0x10/0x20
[<ffffffff811c84e7>] v9fs_file_read+0x37/0x70
[<ffffffff8114e3fb>] vfs_read+0x9b/0x160
[<ffffffff81153571>] kernel_read+0x41/0x60
[<ffffffff810c83ab>] copy_module_from_fd.isra.34+0xfb/0x180

Subsequently, QEMU will die printing:

qemu-system-x86_64: virtio: trying to map MMIO memory

This patch enables 9p-virtio to correctly handle this case. This not
only enables us to load Linux kernel modules off virtfs, but also
enables ZFS file-based vdevs on virtfs to be used without killing QEMU.

Special thanks to both Avi Kivity and Alexander Graf for their
interpretation of QEMU backtraces. Without their guidence, tracking down
this bug would have taken much longer. Also, special thanks to Linus
Torvalds for his insightful explanation of why this should use
is_vmalloc_addr() instead of is_vmalloc_or_module_addr():

https://lkml.org/lkml/2014/2/8/272

Signed-off-by: Richard Yao <ryao@gentoo.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_virtio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -340,7 +340,10 @@ static int p9_get_mapped_pages(struct vi
 		int count = nr_pages;
 		while (nr_pages) {
 			s = rest_of_page(data);
-			pages[index++] = kmap_to_page(data);
+			if (is_vmalloc_addr(data))
+				pages[index++] = vmalloc_to_page(data);
+			else
+				pages[index++] = kmap_to_page(data);
 			data += s;
 			nr_pages--;
 		}



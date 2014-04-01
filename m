Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaDAQsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:48:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaDAQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Yao <ryao@gentoo.org>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 02/86] 9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers
Date: Tue,  1 Apr 2014 09:07:15 -0700
Message-Id: <1396368519-12728-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/9p/trans_virtio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index fd05c81..f6aaae2 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -326,7 +326,10 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
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
-- 
1.8.3.2


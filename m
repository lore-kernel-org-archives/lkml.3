Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaGVWil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:38:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaGVW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 036/116] uio: we cannot mmap unaligned page contents
Date: Tue, 22 Jul 2014 15:20:47 -0700
Message-Id: <1406067727-19683-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b65502879556d041b45104c6a35abbbba28c8f2d upstream.

In commit 7314e613d5ff ("Fix a few incorrectly checked
[io_]remap_pfn_range() calls") the uio driver started more properly
checking the passed-in user mapping arguments against the size of the
actual uio driver data.

That in turn exposed that some driver authors apparently didn't realize
that mmap can only work on a page granularity, and had tried to use it
with smaller mappings, with the new size check catching that out.

So since it's not just the user mmap() arguments that can be confused,
make the uio mmap code also verify that the uio driver has the memory
allocated at page boundaries in order for mmap to work.  If the device
memory isn't properly aligned, we return

  [ENODEV]
    The fildes argument refers to a file whose type is not supported by mmap().

as per the open group documentation on mmap.

Reported-by: Holger Brunck <holger.brunck@keymile.com>
Acked-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/uio/uio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 96f1359..9981b9b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -655,6 +655,8 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 		return -EINVAL;
 	mem = idev->info->mem + mi;
 
+	if (mem->addr & ~PAGE_MASK)
+		return -ENODEV;
 	if (vma->vm_end - vma->vm_start > mem->size)
 		return -EINVAL;
 
-- 
1.9.1


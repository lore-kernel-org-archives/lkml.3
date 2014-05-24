Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaEXNum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:50:42 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35741 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:50:41 -0400
Subject: [PATCH RFC] proc/pid/mem: implement SEEK_DATA and SEEK_HOLE
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 17:50:35 +0400
Message-ID: <20140524135035.32281.93663.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lseek(fd, addr, SEEK_DATA) adjust file offset to the start address of next VMA,
or to addr if this address is allocated.

lseek(fd, addr, SEEK_HOLE) adjust file offset to the end address of VMA which
addr belongs to, or to addr itself if there is hole.

This way SEEK_HOLE reports a virtual zero-length hole between each contiguous
VMAs. This hack seems completely legit and allows to simplify implementation
(there is no function for finding next hole in VMAs' tree, walking along
 ->vm_next might be expensive) This also gives more information about layout.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

---

I have no practical use for this, just found this interesting.
---
 fs/proc/base.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0..aba4b47 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -769,13 +769,40 @@ static ssize_t mem_write(struct file *file, const char __user *buf,
 
 loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
+	struct mm_struct *mm = file->private_data;
+	struct vm_area_struct *vma;
+
 	switch (orig) {
-	case 0:
+	case SEEK_SET:
 		file->f_pos = offset;
 		break;
-	case 1:
+	case SEEK_CUR:
 		file->f_pos += offset;
 		break;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+			return -ENXIO;
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, offset);
+		if (vma) {
+			if (orig == SEEK_DATA) {
+				if (offset >= vma->vm_start)
+					file->f_pos = offset;
+				else
+					file->f_pos = vma->vm_start;
+			} else {
+				if (offset < vma->vm_start)
+					file->f_pos = offset;
+				else
+					file->f_pos = vma->vm_end;
+			}
+		}
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+		if (!vma)
+			return -ENXIO;
+		break;
 	default:
 		return -EINVAL;
 	}


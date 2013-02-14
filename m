Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab3BNKM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48712 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3BNKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:24 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 07/13] vmcore: modify read_vmcore() to read buffer on 2nd
 kernel
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:21 +0900
Message-ID: <20130214101221.22466.97636.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a given vmcore object has VMCORE_2ND_KERNEL type, target data is in
the buffer on 2nd kernel.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   64 ++++++++++++++++++++++++++----------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 77e0a0e..4125a65 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -146,8 +146,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
-	u64 start, nr_bytes;
-	struct vmcore *curr_m = NULL;
+	struct vmcore *m;
 
 	if (buflen == 0 || *fpos >= vmcore_size)
 		return 0;
@@ -173,39 +172,38 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 			return acc;
 	}
 
-	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
-	if (!curr_m)
-        	return -EINVAL;
-	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-		tsz = buflen;
-
-	/* Calculate left bytes in current memory segment. */
-	nr_bytes = (curr_m->size - (start - curr_m->paddr));
-	if (tsz > nr_bytes)
-		tsz = nr_bytes;
-
-	while (buflen) {
-		tmp = read_from_oldmem(buffer, tsz, &start, 1);
-		if (tmp < 0)
-			return tmp;
-		buflen -= tsz;
-		*fpos += tsz;
-		buffer += tsz;
-		acc += tsz;
-		if (start >= (curr_m->paddr + curr_m->size)) {
-			if (curr_m->list.next == &vmcore_list)
-				return acc;	/*EOF*/
-			curr_m = list_entry(curr_m->list.next,
-						struct vmcore, list);
-			start = curr_m->paddr;
+	list_for_each_entry(m, &vmcore_list, list) {
+		if (*fpos < m->offset + m->size) {
+			tsz = m->offset + m->size - *fpos;
+			if (buflen < tsz)
+				tsz = buflen;
+			switch (m->type) {
+			case VMCORE_OLD_MEMORY: {
+				u64 paddr = m->paddr + *fpos - m->offset;
+
+				tmp = read_from_oldmem(buffer, tsz, &paddr, 1);
+				if (tmp < 0)
+					return tmp;
+				break;
+			}
+			case VMCORE_2ND_KERNEL:
+				if (copy_to_user(buffer,
+						 m->buf + (*fpos - m->offset),
+						 tsz))
+					return -EFAULT;
+				break;
+			}
+			buflen -= tsz;
+			*fpos += tsz;
+			buffer += tsz;
+			acc += tsz;
+
+			/* leave now if filled buffer already */
+			if (buflen == 0)
+				return acc;
 		}
-		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-			tsz = buflen;
-		/* Calculate left bytes in current memory segment. */
-		nr_bytes = (curr_m->size - (start - curr_m->paddr));
-		if (tsz > nr_bytes)
-			tsz = nr_bytes;
 	}
+
 	return acc;
 }
 


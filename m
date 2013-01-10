Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3AQBET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:04:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39000 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3AQBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:04:15 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RFC PATCH v1 3/3] vmcore: read vmcore through direct mapping region
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 20:59:51 +0900
Message-ID: <20130110115951.645.20633.stgit@localhost6.localdomain6>
In-Reply-To: <20130110115615.645.56499.stgit@localhost6.localdomain6>
References: <20130110115615.645.56499.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now regions represented by vmcore are mapped through direct mapping
region. We reads requested memory through direct mapping region
instead of using ioremap.

Notice that we still keep read_from_oldmem that uses ioremap because
we need to use it when reading elf headers to make vmcore_list in
vmcore initialization.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index aa14570..1c6259e 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,49 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/* Reads a page from the oldmem device from given offset. */
+static ssize_t read_from_oldmem_noioremap(char *buf, size_t count,
+					  u64 *ppos, int userbuf)
+{
+        unsigned long pfn, offset;
+        size_t nr_bytes;
+        ssize_t read = 0;
+
+        if (!count)
+                return 0;
+
+        offset = (unsigned long)(*ppos % PAGE_SIZE);
+        pfn = (unsigned long)(*ppos / PAGE_SIZE);
+
+        do {
+                if (count > (PAGE_SIZE - offset))
+                        nr_bytes = PAGE_SIZE - offset;
+                else
+                        nr_bytes = count;
+
+                /* If pfn is not ram, return zeros for sparse dump files */
+                if (pfn_is_ram(pfn) == 0)
+                        memset(buf, 0, nr_bytes);
+                else {
+                        void *vaddr = pfn_to_kaddr(pfn);
+
+                        if (userbuf) {
+                                if (copy_to_user(buf, vaddr + offset, nr_bytes))
+                                        return -EFAULT;
+                        } else
+                                memcpy(buf, vaddr + offset, nr_bytes);
+                }
+                *ppos += nr_bytes;
+                count -= nr_bytes;
+                buf += nr_bytes;
+                read += nr_bytes;
+                ++pfn;
+                offset = 0;
+        } while (count);
+
+        return read;
+}
+
 /* Maps vmcore file offset to respective physical address in memroy. */
 static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 					struct vmcore **m_ptr)
@@ -553,7 +596,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		tsz = nr_bytes;
 
 	while (buflen) {
-		tmp = read_from_oldmem(buffer, tsz, &start, 1);
+		tmp = read_from_oldmem_noioremap(buffer, tsz, &start, 1);
 		if (tmp < 0)
 			return tmp;
 		buflen -= tsz;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3AQBEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:04:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39695 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3AQBEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:04:06 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RFC PATCH v1 1/3] vmcore: Add function to merge memory mapping of
 vmcore
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 20:59:40 +0900
Message-ID: <20130110115940.645.27943.stgit@localhost6.localdomain6>
In-Reply-To: <20130110115615.645.56499.stgit@localhost6.localdomain6>
References: <20130110115615.645.56499.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmcore_list has memory map information in the 1st kernel, each of
which represents position and size of the objects like:

  1) NT_PRSTATUS x the number of lcpus
  2) VMCOREINFO
  3) kernel code
  4) copy of the first 640kB memory
  5) System RAM entries

where in /proc/vmcore, 1) and 2) are visible as a single PT_NOTE
entry, and 5) as PT_LOAD entries.

This mapping is never exclusive. For example, any of 1), 2) and 4) is
always contained in one of the System RAM entries.

I add function oldmem_merge_vmcore_list that merges ranges represented
by vmcore_list and makes a merged list in oldmem_list.

We'll remap ranges represented by oldmem_list in direct mapping region
in the patch set that follows this patch.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0d5071d..405b5e2 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -27,6 +27,11 @@
  */
 static LIST_HEAD(vmcore_list);
 
+/* Remap chunks of contiguous memory represented by this list in
+ * direct mapping region.
+ */
+static LIST_HEAD(oldmem_list);
+
 /* Stores the pointer to the buffer containing kernel elf core headers. */
 static char *elfcorebuf;
 static size_t elfcorebuf_sz;
@@ -137,6 +142,84 @@ static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 	return 0;
 }
 
+static struct vmcore* __init get_new_element(void);
+
+static int
+oldmem_merge_vmcore_list_one(struct vmcore *r, struct list_head *new_list)
+{
+	unsigned long m_start, m_end, n_start, n_end;
+	struct vmcore _m, *m, *n, *new;
+
+	m = &_m;
+	m->paddr = r->paddr;
+	m->size = r->size;
+	m->offset = r->offset;
+
+retry:
+	list_for_each_entry(n, new_list, list) {
+
+		m_start = m->paddr;
+		m_end = m->paddr + m->size - 1;
+
+		n_start = n->paddr;
+		n_end = n->paddr + n->size - 1;
+
+		/* not mergeable */
+		if (((m_start < n_start) && (m_end < n_start))
+		    || ((n_start < m_start) && (n_end < m_start)))
+			continue;
+
+		/* merge n to m */
+		m->paddr = min(m->paddr, n->paddr);
+		m->size = max(m_end, n_end) - min(m_start, n_start) + 1;
+		m->offset = min(m->offset, n->offset);
+
+		/* n is no longer useful, delete it */
+		list_del(&n->list);
+		kfree(n);
+
+		goto retry;
+	}
+
+	/* there's no map in new_list to merge m, create new element */
+	new = get_new_element();
+	if (!new)
+		return -ENOMEM;
+
+	new->paddr = m->paddr;
+	new->size = m->size;
+	new->offset = m->offset;
+
+	list_add_tail(&new->list, new_list);
+
+	return 0;
+}
+
+static int
+oldmem_merge_vmcore_list(struct list_head *vc_list, struct list_head *om_list)
+{
+	struct vmcore *m;
+	int ret;
+
+	list_for_each_entry(m, vc_list, list) {
+		printk("vmcore: [mem %016llx-%016llx]\n",
+		       m->paddr, m->paddr + m->size - 1);
+	}
+
+	list_for_each_entry(m, vc_list, list) {
+		ret = oldmem_merge_vmcore_list_one(m, om_list);
+		if (ret < 0)
+			return ret;
+	}
+
+	list_for_each_entry(m, om_list, list) {
+		printk("vmcore: [oldmem %016llx-%016llx]\n",
+		       m->paddr, m->paddr + m->size - 1);
+	}
+
+	return 0;
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */


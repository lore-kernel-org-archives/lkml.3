Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3CSCbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58468 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab3CSCbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:41 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:29 +0900
Message-ID: <20130316040228.15064.28019.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's some vmcore object that doesn't satisfy page-size boundary
requirement, remap_pfn_range() fails to remap it to user-space.

Objects that posisbly don't satisfy the requirement are ELF note
segments only. The memory chunks corresponding to PT_LOAD entries are
guaranteed to satisfy page-size boundary requirement by the copy from
old memory to buffer in 2nd kernel done in later patch.

This patch doesn't copy each note segment into the 2nd kernel since
they amount to so large in total if there are multiple CPUs. For
example, current maximum number of CPUs in x86_64 is 5120, where note
segments exceed 1MB with NT_PRSTATUS only.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2a0f885..0077a9a 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -38,6 +38,8 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+static bool support_mmap_vmcore;
+
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
  * The called function has to take care of module refcounting.
@@ -911,6 +913,7 @@ static int __init parse_crash_elf_headers(void)
 static int __init vmcore_init(void)
 {
 	int rc = 0;
+	struct vmcore *m;
 
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
 	if (!(is_vmcore_usable()))
@@ -921,6 +924,25 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
+	/* If some object doesn't satisfy PAGE_SIZE boundary
+	 * requirement, mmap_vmcore() is not exported to
+	 * user-space. */
+	support_mmap_vmcore = true;
+	list_for_each_entry(m, &vmcore_list, list) {
+		u64 paddr;
+
+		if (m->flag & MEM_TYPE_CURRENT_KERNEL)
+			paddr = (u64)__pa(m->buf);
+		else
+			paddr = m->paddr;
+
+		if ((m->offset & ~PAGE_MASK) || (paddr & ~PAGE_MASK)
+		    || (m->size & ~PAGE_MASK)) {
+			support_mmap_vmcore = false;
+			break;
+		}
+	}
+
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;


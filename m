Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaIKVQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:16:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbaIKVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:16:31 -0400
Date: Thu, 11 Sep 2014 14:16:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: introduce VM_BUG_ON_MM
Message-Id: <20140911141629.e24f7fa5a2ec2401d4f3b429@linux-foundation.org>
In-Reply-To: <1410032326-4380-2-git-send-email-sasha.levin@oracle.com>
References: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com>
	<1410032326-4380-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Sep 2014 15:38:45 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Very similar to VM_BUG_ON_PAGE and VM_BUG_ON_VMA, dump struct_mm
> when the bug is hit.
> 
> ...
>
> +void dump_mm(const struct mm_struct *mm)
> +{
> +	printk(KERN_ALERT

I'm not sure why we should use KERN_ALERT here - KERN_EMERG is for
"system is unusable", which is a fair descrition of a post-BUG kernel,
yes?

> +		"mm %p mmap %p seqnum %d task_size %lu\n"
> +#ifdef CONFIG_MMU
> +		"get_unmapped_area %p\n"
> +#endif

This printk is rather hilarious.  I can't think of a better way apart
from a great string of individual printks.

And maybe we should use individual printks - dump_mm() presently uses
114 bytes of stack for that printk and that's somewhat of a concern
considering the situations when it will be called.


How's this look?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/debug.c: use pr_emerg()

- s/KERN_ALERT/pr_emerg/: we're going BUG so let's maximize the changes
  of getting the message out.

- convert debug.c to pr_foo()

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN mm/debug.c~mm-debugc-use-pr_emerg mm/debug.c
--- a/mm/debug.c~mm-debugc-use-pr_emerg
+++ a/mm/debug.c
@@ -57,7 +57,7 @@ static void dump_flags(unsigned long fla
 	unsigned long mask;
 	int i;
 
-	printk(KERN_ALERT "flags: %#lx(", flags);
+	pr_emerg("flags: %#lx(", flags);
 
 	/* remove zone id */
 	flags &= (1UL << NR_PAGEFLAGS) - 1;
@@ -69,24 +69,23 @@ static void dump_flags(unsigned long fla
 			continue;
 
 		flags &= ~mask;
-		printk("%s%s", delim, names[i].name);
+		pr_cont("%s%s", delim, names[i].name);
 		delim = "|";
 	}
 
 	/* check for left over flags */
 	if (flags)
-		printk("%s%#lx", delim, flags);
+		pr_cont("%s%#lx", delim, flags);
 
-	printk(")\n");
+	pr_cont(")\n");
 }
 
 void dump_page_badflags(struct page *page, const char *reason,
 		unsigned long badflags)
 {
-	printk(KERN_ALERT
-	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
-		page, atomic_read(&page->_count), page_mapcount(page),
-		page->mapping, page->index);
+	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+		  page, atomic_read(&page->_count), page_mapcount(page),
+		  page->mapping, page->index);
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
 	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
 	if (reason)
@@ -152,8 +151,7 @@ static const struct trace_print_flags vm
 
 void dump_vma(const struct vm_area_struct *vma)
 {
-	printk(KERN_ALERT
-		"vma %p start %p end %p\n"
+	pr_emerg("vma %p start %p end %p\n"
 		"next %p prev %p mm %p\n"
 		"prot %lx anon_vma %p vm_ops %p\n"
 		"pgoff %lx file %p private_data %p\n",
@@ -168,8 +166,7 @@ EXPORT_SYMBOL(dump_vma);
 
 void dump_mm(const struct mm_struct *mm)
 {
-	printk(KERN_ALERT
-		"mm %p mmap %p seqnum %d task_size %lu\n"
+	pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"
 #ifdef CONFIG_MMU
 		"get_unmapped_area %p\n"
 #endif
_


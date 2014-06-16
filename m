Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaFPKaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:30:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43971 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbaFPKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:30:44 -0400
Date: Mon, 16 Jun 2014 18:30:36 +0800
From: Real Name <enjoymindful@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
Message-ID: <20140616103036.GA3999@name>
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
 <539C1964.4050504@nod.at>
 <20140616032852.GA1763@name>
 <539E93B9.5070407@nod.at>
 <20140616081238.GA1840@name>
 <20140616082855.GB1840@name>
 <CAMuHMdV9SA0zZz0u=VKWWXNRL186hunrMYuZ=RUcAjqRes8r8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <CAMuHMdV9SA0zZz0u=VKWWXNRL186hunrMYuZ=RUcAjqRes8r8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 11:15:23AM +0200, Geert Uytterhoeven wrote:
> On Mon, Jun 16, 2014 at 10:28 AM, Real Name <enjoymindful@gmail.com> wrote:
> >> > >> Can you please include in the changelog the commit sha1 which made the old init_maps() obsolete?

hi,

The commit sha1 had been included as required. Please review the attached patch. 
I only update the changlog of the patch.

thanks
> >
> > I think we need find out which commit deleted the line "mem_map = map;" in init_maps function.
> 
> 
> v2.6.12-rc1
> 
> commit 5678d7fc97ac75f7401ce77897773cc0bb3afee5

Geert, thank you.

> Author: Dave Hansen <haveblue@us.ibm.com>
> Date:   Sun Mar 13 00:22:56 2005 -0800
> 
>     [PATCH] no arch-specific mem_map init
> 

--envbJBWh7q8WU6mo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-UML-delete-unnecessary-bootmem-struct-page-array.patch"

>From 29e5e83f8f3988ea1396d61b4d5764e7904f82c5 Mon Sep 17 00:00:00 2001
From: Honggang Li <enjoymindful@gmail.com>
Date: Mon, 16 Jun 2014 18:05:47 +0800
Subject: [PATCH] UML delete unnecessary bootmem struct page array

1) uml kernel bootmem managed through bootmem_data->node_bootmem_map,
not the struct page array, so the array is unnecessary.

2) the bootmem struct page array has been pointed by a *local* pointer,
struct page *map, in init_maps function. The array can be accessed only
in init_maps's scope. As a result, uml kernel wastes about 1% of total
memory.

3) commit 5678d7fc97ac75f7401ce77897773cc0bb3afee5 obsoleted
the init_maps function.

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 arch/um/include/shared/mem_user.h |  2 +-
 arch/um/kernel/physmem.c          | 32 ++++++--------------------------
 arch/um/kernel/um_arch.c          |  7 +------
 3 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/arch/um/include/shared/mem_user.h b/arch/um/include/shared/mem_user.h
index 46384ac..cb84414 100644
--- a/arch/um/include/shared/mem_user.h
+++ b/arch/um/include/shared/mem_user.h
@@ -49,7 +49,7 @@ extern int iomem_size;
 extern int init_mem_user(void);
 extern void setup_memory(void *entry);
 extern unsigned long find_iomem(char *driver, unsigned long *len_out);
-extern int init_maps(unsigned long physmem, unsigned long iomem,
+extern void mem_total_pages(unsigned long physmem, unsigned long iomem,
 		     unsigned long highmem);
 extern unsigned long get_vm(unsigned long len);
 extern void setup_physmem(unsigned long start, unsigned long usable,
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index 30fdd5d..549ecf3 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -22,39 +22,19 @@ EXPORT_SYMBOL(high_physmem);
 
 extern unsigned long long physmem_size;
 
-int __init init_maps(unsigned long physmem, unsigned long iomem,
+void __init mem_total_pages(unsigned long physmem, unsigned long iomem,
 		     unsigned long highmem)
 {
-	struct page *p, *map;
-	unsigned long phys_len, phys_pages, highmem_len, highmem_pages;
-	unsigned long iomem_len, iomem_pages, total_len, total_pages;
-	int i;
-
-	phys_pages = physmem >> PAGE_SHIFT;
-	phys_len = phys_pages * sizeof(struct page);
-
-	iomem_pages = iomem >> PAGE_SHIFT;
-	iomem_len = iomem_pages * sizeof(struct page);
+	unsigned long phys_pages, highmem_pages;
+	unsigned long iomem_pages, total_pages;
 
+	phys_pages    = physmem >> PAGE_SHIFT;
+	iomem_pages   = iomem   >> PAGE_SHIFT;
 	highmem_pages = highmem >> PAGE_SHIFT;
-	highmem_len = highmem_pages * sizeof(struct page);
-
-	total_pages = phys_pages + iomem_pages + highmem_pages;
-	total_len = phys_len + iomem_len + highmem_len;
 
-	map = alloc_bootmem_low_pages(total_len);
-	if (map == NULL)
-		return -ENOMEM;
-
-	for (i = 0; i < total_pages; i++) {
-		p = &map[i];
-		memset(p, 0, sizeof(struct page));
-		SetPageReserved(p);
-		INIT_LIST_HEAD(&p->lru);
-	}
+	total_pages   = phys_pages + iomem_pages + highmem_pages;
 
 	max_mapnr = total_pages;
-	return 0;
 }
 
 void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 6043c76..dbd5bda 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -338,12 +338,7 @@ int __init linux_main(int argc, char **argv)
 	start_vm = VMALLOC_START;
 
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
-	if (init_maps(physmem_size, iomem_size, highmem)) {
-		printf("Failed to allocate mem_map for %Lu bytes of physical "
-		       "memory and %Lu bytes of highmem\n", physmem_size,
-		       highmem);
-		exit(1);
-	}
+	mem_total_pages(physmem_size, iomem_size, highmem);
 
 	virtmem_size = physmem_size;
 	stack = (unsigned long) argv;
-- 
1.8.3.1


--envbJBWh7q8WU6mo--

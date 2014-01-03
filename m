Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaACSDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:03:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:48215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbaACSCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:02:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,599,1384329600"; 
   d="scan'208";a="461309836"
Subject: [PATCH 7/9] mm: slub: abstract out double cmpxchg option
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux-foundation.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 03 Jan 2014 10:02:00 -0800
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
In-Reply-To: <20140103180147.6566F7C1@viggo.jf.intel.com>
Message-Id: <20140103180200.88E3228F@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I found this useful to have in my testing.  I would like to have
it available for a bit, at least until other folks have had a
chance to do some testing with it.

We should probably just pull the help text and the description
out of this so that folks are not prompted for it instead of
ripping it out entirely.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/include/linux/mm_types.h |    3 +--
 linux.git-davehans/init/Kconfig             |    2 +-
 linux.git-davehans/mm/slub.c                |    9 +++------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_types.h~abstract-out-slub-double-cmpxchg-operation include/linux/mm_types.h
--- linux.git/include/linux/mm_types.h~abstract-out-slub-double-cmpxchg-operation	2014-01-02 15:28:04.382877603 -0800
+++ linux.git-davehans/include/linux/mm_types.h	2014-01-02 15:28:04.391878008 -0800
@@ -38,8 +38,7 @@ struct slub_data {
 		 * all of the above counters in one chunk.
 		 * The actual counts are never accessed via this.
 		 */
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_SLUB_ATTEMPT_CMPXCHG_DOUBLE)
 		unsigned long counters;
 #else
 		/*
diff -puN init/Kconfig~abstract-out-slub-double-cmpxchg-operation init/Kconfig
--- linux.git/init/Kconfig~abstract-out-slub-double-cmpxchg-operation	2014-01-02 15:28:04.384877693 -0800
+++ linux.git-davehans/init/Kconfig	2014-01-02 15:28:04.392878053 -0800
@@ -841,7 +841,7 @@ config SLUB_CPU_PARTIAL
 
 config SLUB_ATTEMPT_CMPXCHG_DOUBLE
 	default y
-	depends on SLUB && HAVE_CMPXCHG_DOUBLE
+	depends on SLUB && HAVE_CMPXCHG_DOUBLE && HAVE_ALIGNED_STRUCT_PAGE
 	bool "SLUB: attempt to use double-cmpxchg operations"
 	help
 	  Some CPUs support instructions that let you do a large double-word
diff -puN mm/slub.c~abstract-out-slub-double-cmpxchg-operation mm/slub.c
--- linux.git/mm/slub.c~abstract-out-slub-double-cmpxchg-operation	2014-01-02 15:28:04.386877783 -0800
+++ linux.git-davehans/mm/slub.c	2014-01-02 15:28:04.394878143 -0800
@@ -368,8 +368,7 @@ static inline bool __cmpxchg_double_slab
 		const char *n)
 {
 	VM_BUG_ON(!irqs_disabled());
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_SLUB_ATTEMPT_CMPXCHG_DOUBLE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&slub_data(page)->freelist, &slub_data(page)->counters,
 			freelist_old, counters_old,
@@ -404,8 +403,7 @@ static inline bool cmpxchg_double_slab(s
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_SLUB_ATTEMPT_CMPXCHG_DOUBLE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&slub_data(page)->freelist, &slub_data(page)->counters,
 			freelist_old, counters_old,
@@ -3085,8 +3083,7 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_SLUB_ATTEMPT_CMPXCHG_DOUBLE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
_

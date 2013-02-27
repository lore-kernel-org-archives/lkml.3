Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab3B0Bjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:39:41 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33394
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507Ab3B0Bjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:39:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Kim Phillips <kim.phillips@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] dtc: import latest upstream dtc
Date: Tue, 26 Feb 2013 19:36:14 -0600
Message-ID: <1361928975-29395-2-git-send-email-kim.phillips@freescale.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
References: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates scripts/dtc to upstream dtc commit 27cdc1b
"Added license header to dtc/libfdt/fdt.h and libfdt_env.h"
from git://git.jdl.com/software/dtc.git.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 scripts/dtc/dtc.c               |   3 --
 scripts/dtc/fdtdump.c           |  29 +----------
 scripts/dtc/libfdt/fdt.c        |   2 +-
 scripts/dtc/libfdt/fdt.h        |  93 +++++++++++++++++++++++++++--------
 scripts/dtc/libfdt/fdt_ro.c     |   7 ++-
 scripts/dtc/libfdt/fdt_rw.c     |   4 +-
 scripts/dtc/libfdt/fdt_sw.c     |   4 +-
 scripts/dtc/libfdt/fdt_wip.c    |   2 +-
 scripts/dtc/libfdt/libfdt.h     |  48 ++++++++++++-------
 scripts/dtc/libfdt/libfdt_env.h | 104 +++++++++++++++++++++++++++++++++++-----
 scripts/dtc/srcpos.c            |   6 +--
 scripts/dtc/util.c              |  57 +++++++++++++++++++---
 scripts/dtc/util.h              |  22 +++++++--
 13 files changed, 279 insertions(+), 102 deletions(-)

diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index a375683..d40e220 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -201,9 +201,6 @@ int main(int argc, char *argv[])
 	if (minsize && padsize)
 		die("Can't set both -p and -S\n");
 
-	if (minsize)
-		fprintf(stderr, "DTC: Use of \"-S\" is deprecated; it will be removed soon, use \"-p\" instead\n");
-
 	if (depname) {
 		depfile = fopen(depname, "w");
 		if (!depfile)
diff --git a/scripts/dtc/fdtdump.c b/scripts/dtc/fdtdump.c
index 207a46d..03ea429 100644
--- a/scripts/dtc/fdtdump.c
+++ b/scripts/dtc/fdtdump.c
@@ -8,8 +8,8 @@
 #include <string.h>
 #include <ctype.h>
 
-#include <fdt.h>
 #include <libfdt_env.h>
+#include <fdt.h>
 
 #include "util.h"
 
@@ -17,31 +17,6 @@
 #define PALIGN(p, a)	((void *)(ALIGN((unsigned long)(p), (a))))
 #define GET_CELL(p)	(p += 4, *((const uint32_t *)(p-4)))
 
-static void print_data(const char *data, int len)
-{
-	int i;
-	const char *p = data;
-
-	/* no data, don't print */
-	if (len == 0)
-		return;
-
-	if (util_is_printable_string(data, len)) {
-		printf(" = \"%s\"", (const char *)data);
-	} else if ((len % 4) == 0) {
-		printf(" = <");
-		for (i = 0; i < len; i += 4)
-			printf("0x%08x%s", fdt32_to_cpu(GET_CELL(p)),
-			       i < (len - 4) ? " " : "");
-		printf(">");
-	} else {
-		printf(" = [");
-		for (i = 0; i < len; i++)
-			printf("%02x%s", *p++, i < len - 1 ? " " : "");
-		printf("]");
-	}
-}
-
 static void dump_blob(void *blob)
 {
 	struct fdt_header *bph = blob;
@@ -137,7 +112,7 @@ static void dump_blob(void *blob)
 		p = PALIGN(p + sz, 4);
 
 		printf("%*s%s", depth * shift, "", s);
-		print_data(t, sz);
+		utilfdt_print_data(t, sz);
 		printf(";\n");
 	}
 }
diff --git a/scripts/dtc/libfdt/fdt.c b/scripts/dtc/libfdt/fdt.c
index e56833a..57faba3 100644
--- a/scripts/dtc/libfdt/fdt.c
+++ b/scripts/dtc/libfdt/fdt.c
@@ -92,7 +92,7 @@ const void *fdt_offset_ptr(const void *fdt, int offset, unsigned int len)
 
 uint32_t fdt_next_tag(const void *fdt, int startoffset, int *nextoffset)
 {
-	const uint32_t *tagp, *lenp;
+	const fdt32_t *tagp, *lenp;
 	uint32_t tag;
 	int offset = startoffset;
 	const char *p;
diff --git a/scripts/dtc/libfdt/fdt.h b/scripts/dtc/libfdt/fdt.h
index 48ccfd9..526aedb 100644
--- a/scripts/dtc/libfdt/fdt.h
+++ b/scripts/dtc/libfdt/fdt.h
@@ -1,48 +1,99 @@
 #ifndef _FDT_H
 #define _FDT_H
+/*
+ * libfdt - Flat Device Tree manipulation
+ * Copyright (C) 2006 David Gibson, IBM Corporation.
+ * Copyright 2012 Kim Phillips, Freescale Semiconductor.
+ *
+ * libfdt is dual licensed: you can use it either under the terms of
+ * the GPL, or the BSD license, at your option.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Alternatively,
+ *
+ *  b) Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *     1. Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *     2. Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+ *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+ *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
+ *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
 
 #ifndef __ASSEMBLY__
 
 struct fdt_header {
-	uint32_t magic;			 /* magic word FDT_MAGIC */
-	uint32_t totalsize;		 /* total size of DT block */
-	uint32_t off_dt_struct;		 /* offset to structure */
-	uint32_t off_dt_strings;	 /* offset to strings */
-	uint32_t off_mem_rsvmap;	 /* offset to memory reserve map */
-	uint32_t version;		 /* format version */
-	uint32_t last_comp_version;	 /* last compatible version */
+	fdt32_t magic;			 /* magic word FDT_MAGIC */
+	fdt32_t totalsize;		 /* total size of DT block */
+	fdt32_t off_dt_struct;		 /* offset to structure */
+	fdt32_t off_dt_strings;		 /* offset to strings */
+	fdt32_t off_mem_rsvmap;		 /* offset to memory reserve map */
+	fdt32_t version;		 /* format version */
+	fdt32_t last_comp_version;	 /* last compatible version */
 
 	/* version 2 fields below */
-	uint32_t boot_cpuid_phys;	 /* Which physical CPU id we're
+	fdt32_t boot_cpuid_phys;	 /* Which physical CPU id we're
 					    booting on */
 	/* version 3 fields below */
-	uint32_t size_dt_strings;	 /* size of the strings block */
+	fdt32_t size_dt_strings;	 /* size of the strings block */
 
 	/* version 17 fields below */
-	uint32_t size_dt_struct;	 /* size of the structure block */
+	fdt32_t size_dt_struct;		 /* size of the structure block */
 };
 
 struct fdt_reserve_entry {
-	uint64_t address;
-	uint64_t size;
+	fdt64_t address;
+	fdt64_t size;
 };
 
 struct fdt_node_header {
-	uint32_t tag;
+	fdt32_t tag;
 	char name[0];
 };
 
 struct fdt_property {
-	uint32_t tag;
-	uint32_t len;
-	uint32_t nameoff;
+	fdt32_t tag;
+	fdt32_t len;
+	fdt32_t nameoff;
 	char data[0];
 };
 
 #endif /* !__ASSEMBLY */
 
 #define FDT_MAGIC	0xd00dfeed	/* 4: version, 4: total size */
-#define FDT_TAGSIZE	sizeof(uint32_t)
+#define FDT_TAGSIZE	sizeof(fdt32_t)
 
 #define FDT_BEGIN_NODE	0x1		/* Start node: full name */
 #define FDT_END_NODE	0x2		/* End node */
@@ -51,10 +102,10 @@ struct fdt_property {
 #define FDT_NOP		0x4		/* nop */
 #define FDT_END		0x9
 
-#define FDT_V1_SIZE	(7*sizeof(uint32_t))
-#define FDT_V2_SIZE	(FDT_V1_SIZE + sizeof(uint32_t))
-#define FDT_V3_SIZE	(FDT_V2_SIZE + sizeof(uint32_t))
+#define FDT_V1_SIZE	(7*sizeof(fdt32_t))
+#define FDT_V2_SIZE	(FDT_V1_SIZE + sizeof(fdt32_t))
+#define FDT_V3_SIZE	(FDT_V2_SIZE + sizeof(fdt32_t))
 #define FDT_V16_SIZE	FDT_V3_SIZE
-#define FDT_V17_SIZE	(FDT_V16_SIZE + sizeof(uint32_t))
+#define FDT_V17_SIZE	(FDT_V16_SIZE + sizeof(fdt32_t))
 
 #endif /* _FDT_H */
diff --git a/scripts/dtc/libfdt/fdt_ro.c b/scripts/dtc/libfdt/fdt_ro.c
index 02b6d68..50007f6 100644
--- a/scripts/dtc/libfdt/fdt_ro.c
+++ b/scripts/dtc/libfdt/fdt_ro.c
@@ -322,7 +322,7 @@ const void *fdt_getprop(const void *fdt, int nodeoffset,
 
 uint32_t fdt_get_phandle(const void *fdt, int nodeoffset)
 {
-	const uint32_t *php;
+	const fdt32_t *php;
 	int len;
 
 	/* FIXME: This is a bit sub-optimal, since we potentially scan
@@ -515,8 +515,7 @@ int fdt_node_offset_by_phandle(const void *fdt, uint32_t phandle)
 	return offset; /* error from fdt_next_node() */
 }
 
-static int _fdt_stringlist_contains(const char *strlist, int listlen,
-				    const char *str)
+int fdt_stringlist_contains(const char *strlist, int listlen, const char *str)
 {
 	int len = strlen(str);
 	const char *p;
@@ -542,7 +541,7 @@ int fdt_node_check_compatible(const void *fdt, int nodeoffset,
 	prop = fdt_getprop(fdt, nodeoffset, "compatible", &len);
 	if (!prop)
 		return len;
-	if (_fdt_stringlist_contains(prop, len, compatible))
+	if (fdt_stringlist_contains(prop, len, compatible))
 		return 0;
 	else
 		return 1;
diff --git a/scripts/dtc/libfdt/fdt_rw.c b/scripts/dtc/libfdt/fdt_rw.c
index 24437df..fdba618 100644
--- a/scripts/dtc/libfdt/fdt_rw.c
+++ b/scripts/dtc/libfdt/fdt_rw.c
@@ -339,7 +339,7 @@ int fdt_add_subnode_namelen(void *fdt, int parentoffset,
 	int nodelen;
 	int err;
 	uint32_t tag;
-	uint32_t *endtag;
+	fdt32_t *endtag;
 
 	FDT_RW_CHECK_HEADER(fdt);
 
@@ -366,7 +366,7 @@ int fdt_add_subnode_namelen(void *fdt, int parentoffset,
 	nh->tag = cpu_to_fdt32(FDT_BEGIN_NODE);
 	memset(nh->name, 0, FDT_TAGALIGN(namelen+1));
 	memcpy(nh->name, name, namelen);
-	endtag = (uint32_t *)((char *)nh + nodelen - FDT_TAGSIZE);
+	endtag = (fdt32_t *)((char *)nh + nodelen - FDT_TAGSIZE);
 	*endtag = cpu_to_fdt32(FDT_END_NODE);
 
 	return offset;
diff --git a/scripts/dtc/libfdt/fdt_sw.c b/scripts/dtc/libfdt/fdt_sw.c
index 55ebebf..f422754 100644
--- a/scripts/dtc/libfdt/fdt_sw.c
+++ b/scripts/dtc/libfdt/fdt_sw.c
@@ -153,7 +153,7 @@ int fdt_begin_node(void *fdt, const char *name)
 
 int fdt_end_node(void *fdt)
 {
-	uint32_t *en;
+	fdt32_t *en;
 
 	FDT_SW_CHECK_HEADER(fdt);
 
@@ -213,7 +213,7 @@ int fdt_property(void *fdt, const char *name, const void *val, int len)
 int fdt_finish(void *fdt)
 {
 	char *p = (char *)fdt;
-	uint32_t *end;
+	fdt32_t *end;
 	int oldstroffset, newstroffset;
 	uint32_t tag;
 	int offset, nextoffset;
diff --git a/scripts/dtc/libfdt/fdt_wip.c b/scripts/dtc/libfdt/fdt_wip.c
index 6025fa1..c5bbb68 100644
--- a/scripts/dtc/libfdt/fdt_wip.c
+++ b/scripts/dtc/libfdt/fdt_wip.c
@@ -74,7 +74,7 @@ int fdt_setprop_inplace(void *fdt, int nodeoffset, const char *name,
 
 static void _fdt_nop_region(void *start, int len)
 {
-	uint32_t *p;
+	fdt32_t *p;
 
 	for (p = start; (char *)p < ((char *)start + len); p++)
 		*p = cpu_to_fdt32(FDT_NOP);
diff --git a/scripts/dtc/libfdt/libfdt.h b/scripts/dtc/libfdt/libfdt.h
index 73f4975..130789a 100644
--- a/scripts/dtc/libfdt/libfdt.h
+++ b/scripts/dtc/libfdt/libfdt.h
@@ -582,7 +582,7 @@ const char *fdt_get_alias_namelen(const void *fdt,
  * value of the property named 'name' in the node /aliases.
  *
  * returns:
- *	a pointer to the expansion of the alias named 'name', of it exists
+ *	a pointer to the expansion of the alias named 'name', if it exists
  *	NULL, if the given alias or the /aliases node does not exist
  */
 const char *fdt_get_alias(const void *fdt, const char *name);
@@ -816,6 +816,20 @@ int fdt_node_check_compatible(const void *fdt, int nodeoffset,
 int fdt_node_offset_by_compatible(const void *fdt, int startoffset,
 				  const char *compatible);
 
+/**
+ * fdt_stringlist_contains - check a string list property for a string
+ * @strlist: Property containing a list of strings to check
+ * @listlen: Length of property
+ * @str: String to search for
+ *
+ * This is a utility function provided for convenience. The list contains
+ * one or more strings, each terminated by \0, as is found in a device tree
+ * "compatible" property.
+ *
+ * @return: 1 if the string is found in the list, 0 not found, or invalid list
+ */
+int fdt_stringlist_contains(const char *strlist, int listlen, const char *str);
+
 /**********************************************************************/
 /* Write-in-place functions                                           */
 /**********************************************************************/
@@ -882,8 +896,8 @@ int fdt_setprop_inplace(void *fdt, int nodeoffset, const char *name,
 static inline int fdt_setprop_inplace_u32(void *fdt, int nodeoffset,
 					  const char *name, uint32_t val)
 {
-	val = cpu_to_fdt32(val);
-	return fdt_setprop_inplace(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt32_t tmp = cpu_to_fdt32(val);
+	return fdt_setprop_inplace(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
@@ -917,8 +931,8 @@ static inline int fdt_setprop_inplace_u32(void *fdt, int nodeoffset,
 static inline int fdt_setprop_inplace_u64(void *fdt, int nodeoffset,
 					  const char *name, uint64_t val)
 {
-	val = cpu_to_fdt64(val);
-	return fdt_setprop_inplace(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt64_t tmp = cpu_to_fdt64(val);
+	return fdt_setprop_inplace(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
@@ -993,13 +1007,13 @@ int fdt_begin_node(void *fdt, const char *name);
 int fdt_property(void *fdt, const char *name, const void *val, int len);
 static inline int fdt_property_u32(void *fdt, const char *name, uint32_t val)
 {
-	val = cpu_to_fdt32(val);
-	return fdt_property(fdt, name, &val, sizeof(val));
+	fdt32_t tmp = cpu_to_fdt32(val);
+	return fdt_property(fdt, name, &tmp, sizeof(tmp));
 }
 static inline int fdt_property_u64(void *fdt, const char *name, uint64_t val)
 {
-	val = cpu_to_fdt64(val);
-	return fdt_property(fdt, name, &val, sizeof(val));
+	fdt64_t tmp = cpu_to_fdt64(val);
+	return fdt_property(fdt, name, &tmp, sizeof(tmp));
 }
 static inline int fdt_property_cell(void *fdt, const char *name, uint32_t val)
 {
@@ -1154,8 +1168,8 @@ int fdt_setprop(void *fdt, int nodeoffset, const char *name,
 static inline int fdt_setprop_u32(void *fdt, int nodeoffset, const char *name,
 				  uint32_t val)
 {
-	val = cpu_to_fdt32(val);
-	return fdt_setprop(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt32_t tmp = cpu_to_fdt32(val);
+	return fdt_setprop(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
@@ -1189,8 +1203,8 @@ static inline int fdt_setprop_u32(void *fdt, int nodeoffset, const char *name,
 static inline int fdt_setprop_u64(void *fdt, int nodeoffset, const char *name,
 				  uint64_t val)
 {
-	val = cpu_to_fdt64(val);
-	return fdt_setprop(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt64_t tmp = cpu_to_fdt64(val);
+	return fdt_setprop(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
@@ -1296,8 +1310,8 @@ int fdt_appendprop(void *fdt, int nodeoffset, const char *name,
 static inline int fdt_appendprop_u32(void *fdt, int nodeoffset,
 				     const char *name, uint32_t val)
 {
-	val = cpu_to_fdt32(val);
-	return fdt_appendprop(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt32_t tmp = cpu_to_fdt32(val);
+	return fdt_appendprop(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
@@ -1331,8 +1345,8 @@ static inline int fdt_appendprop_u32(void *fdt, int nodeoffset,
 static inline int fdt_appendprop_u64(void *fdt, int nodeoffset,
 				     const char *name, uint64_t val)
 {
-	val = cpu_to_fdt64(val);
-	return fdt_appendprop(fdt, nodeoffset, name, &val, sizeof(val));
+	fdt64_t tmp = cpu_to_fdt64(val);
+	return fdt_appendprop(fdt, nodeoffset, name, &tmp, sizeof(tmp));
 }
 
 /**
diff --git a/scripts/dtc/libfdt/libfdt_env.h b/scripts/dtc/libfdt/libfdt_env.h
index 213d7fb..9dea97d 100644
--- a/scripts/dtc/libfdt/libfdt_env.h
+++ b/scripts/dtc/libfdt/libfdt_env.h
@@ -1,29 +1,111 @@
 #ifndef _LIBFDT_ENV_H
 #define _LIBFDT_ENV_H
+/*
+ * libfdt - Flat Device Tree manipulation
+ * Copyright (C) 2006 David Gibson, IBM Corporation.
+ * Copyright 2012 Kim Phillips, Freescale Semiconductor.
+ *
+ * libfdt is dual licensed: you can use it either under the terms of
+ * the GPL, or the BSD license, at your option.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Alternatively,
+ *
+ *  b) Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *     1. Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *     2. Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+ *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+ *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
+ *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
 
 #include <stddef.h>
 #include <stdint.h>
 #include <string.h>
 
-#define EXTRACT_BYTE(n)	((unsigned long long)((uint8_t *)&x)[n])
-static inline uint16_t fdt16_to_cpu(uint16_t x)
+#ifdef __CHECKER__
+#define __force __attribute__((force))
+#define __bitwise __attribute__((bitwise))
+#else
+#define __force
+#define __bitwise
+#endif
+
+typedef uint16_t __bitwise fdt16_t;
+typedef uint32_t __bitwise fdt32_t;
+typedef uint64_t __bitwise fdt64_t;
+
+#define EXTRACT_BYTE(x, n)	((unsigned long long)((uint8_t *)&x)[n])
+#define CPU_TO_FDT16(x) ((EXTRACT_BYTE(x, 0) << 8) | EXTRACT_BYTE(x, 1))
+#define CPU_TO_FDT32(x) ((EXTRACT_BYTE(x, 0) << 24) | (EXTRACT_BYTE(x, 1) << 16) | \
+			 (EXTRACT_BYTE(x, 2) << 8) | EXTRACT_BYTE(x, 3))
+#define CPU_TO_FDT64(x) ((EXTRACT_BYTE(x, 0) << 56) | (EXTRACT_BYTE(x, 1) << 48) | \
+			 (EXTRACT_BYTE(x, 2) << 40) | (EXTRACT_BYTE(x, 3) << 32) | \
+			 (EXTRACT_BYTE(x, 4) << 24) | (EXTRACT_BYTE(x, 5) << 16) | \
+			 (EXTRACT_BYTE(x, 6) << 8) | EXTRACT_BYTE(x, 7))
+
+static inline uint16_t fdt16_to_cpu(fdt16_t x)
+{
+	return (__force uint16_t)CPU_TO_FDT16(x);
+}
+static inline fdt16_t cpu_to_fdt16(uint16_t x)
 {
-	return (EXTRACT_BYTE(0) << 8) | EXTRACT_BYTE(1);
+	return (__force fdt16_t)CPU_TO_FDT16(x);
 }
-#define cpu_to_fdt16(x) fdt16_to_cpu(x)
 
-static inline uint32_t fdt32_to_cpu(uint32_t x)
+static inline uint32_t fdt32_to_cpu(fdt32_t x)
 {
-	return (EXTRACT_BYTE(0) << 24) | (EXTRACT_BYTE(1) << 16) | (EXTRACT_BYTE(2) << 8) | EXTRACT_BYTE(3);
+	return (__force uint32_t)CPU_TO_FDT32(x);
+}
+static inline fdt32_t cpu_to_fdt32(uint32_t x)
+{
+	return (__force fdt32_t)CPU_TO_FDT32(x);
 }
-#define cpu_to_fdt32(x) fdt32_to_cpu(x)
 
-static inline uint64_t fdt64_to_cpu(uint64_t x)
+static inline uint64_t fdt64_to_cpu(fdt64_t x)
+{
+	return (__force uint64_t)CPU_TO_FDT64(x);
+}
+static inline fdt64_t cpu_to_fdt64(uint64_t x)
 {
-	return (EXTRACT_BYTE(0) << 56) | (EXTRACT_BYTE(1) << 48) | (EXTRACT_BYTE(2) << 40) | (EXTRACT_BYTE(3) << 32)
-		| (EXTRACT_BYTE(4) << 24) | (EXTRACT_BYTE(5) << 16) | (EXTRACT_BYTE(6) << 8) | EXTRACT_BYTE(7);
+	return (__force fdt64_t)CPU_TO_FDT64(x);
 }
-#define cpu_to_fdt64(x) fdt64_to_cpu(x)
+#undef CPU_TO_FDT64
+#undef CPU_TO_FDT32
+#undef CPU_TO_FDT16
 #undef EXTRACT_BYTE
 
 #endif /* _LIBFDT_ENV_H */
diff --git a/scripts/dtc/srcpos.c b/scripts/dtc/srcpos.c
index 246ab4b..c20bc53 100644
--- a/scripts/dtc/srcpos.c
+++ b/scripts/dtc/srcpos.c
@@ -297,9 +297,9 @@ srcpos_verror(struct srcpos *pos, char const *fmt, va_list va)
 
        srcstr = srcpos_string(pos);
 
-       fprintf(stdout, "Error: %s ", srcstr);
-       vfprintf(stdout, fmt, va);
-       fprintf(stdout, "\n");
+       fprintf(stderr, "Error: %s ", srcstr);
+       vfprintf(stderr, fmt, va);
+       fprintf(stderr, "\n");
 }
 
 void
diff --git a/scripts/dtc/util.c b/scripts/dtc/util.c
index 2422c34..b081fa8 100644
--- a/scripts/dtc/util.c
+++ b/scripts/dtc/util.c
@@ -72,7 +72,7 @@ char *join_path(const char *path, const char *name)
 int util_is_printable_string(const void *data, int len)
 {
 	const char *s = data;
-	const char *ss;
+	const char *ss, *se;
 
 	/* zero length is not */
 	if (len == 0)
@@ -82,13 +82,19 @@ int util_is_printable_string(const void *data, int len)
 	if (s[len - 1] != '\0')
 		return 0;
 
-	ss = s;
-	while (*s && isprint(*s))
-		s++;
+	se = s + len;
 
-	/* not zero, or not done yet */
-	if (*s != '\0' || (s + 1 - ss) < len)
-		return 0;
+	while (s < se) {
+		ss = s;
+		while (s < se && *s && isprint(*s))
+			s++;
+
+		/* not zero, or not done yet */
+		if (*s != '\0' || s == ss)
+			return 0;
+
+		s++;
+	}
 
 	return 1;
 }
@@ -329,3 +335,40 @@ int utilfdt_decode_type(const char *fmt, int *type, int *size)
 		return -1;
 	return 0;
 }
+
+void utilfdt_print_data(const char *data, int len)
+{
+	int i;
+	const char *p = data;
+	const char *s;
+
+	/* no data, don't print */
+	if (len == 0)
+		return;
+
+	if (util_is_printable_string(data, len)) {
+		printf(" = ");
+
+		s = data;
+		do {
+			printf("\"%s\"", s);
+			s += strlen(s) + 1;
+			if (s < data + len)
+				printf(", ");
+		} while (s < data + len);
+
+	} else if ((len % 4) == 0) {
+		const uint32_t *cell = (const uint32_t *)data;
+
+		printf(" = <");
+		for (i = 0; i < len; i += 4)
+			printf("0x%08x%s", fdt32_to_cpu(cell[i]),
+			       i < (len - 4) ? " " : "");
+		printf(">");
+	} else {
+		printf(" = [");
+		for (i = 0; i < len; i++)
+			printf("%02x%s", *p++, i < len - 1 ? " " : "");
+		printf("]");
+	}
+}
diff --git a/scripts/dtc/util.h b/scripts/dtc/util.h
index c8eb45d..543a173 100644
--- a/scripts/dtc/util.h
+++ b/scripts/dtc/util.h
@@ -57,12 +57,14 @@ extern char *xstrdup(const char *s);
 extern char *join_path(const char *path, const char *name);
 
 /**
- * Check a string of a given length to see if it is all printable and
- * has a valid terminator.
+ * Check a property of a given length to see if it is all printable and
+ * has a valid terminator. The property can contain either a single string,
+ * or multiple strings each of non-zero length.
  *
  * @param data	The string to check
  * @param len	The string length including terminator
- * @return 1 if a valid printable string, 0 if not */
+ * @return 1 if a valid printable string, 0 if not
+ */
 int util_is_printable_string(const void *data, int len);
 
 /*
@@ -150,4 +152,18 @@ int utilfdt_decode_type(const char *fmt, int *type, int *size);
 	"\tOptional modifier prefix:\n" \
 	"\t\thh or b=byte, h=2 byte, l=4 byte (default)\n";
 
+/**
+ * Print property data in a readable format to stdout
+ *
+ * Properties that look like strings will be printed as strings. Otherwise
+ * the data will be displayed either as cells (if len is a multiple of 4
+ * bytes) or bytes.
+ *
+ * If len is 0 then this function does nothing.
+ *
+ * @param data	Pointers to property data
+ * @param len	Length of property data
+ */
+void utilfdt_print_data(const char *data, int len);
+
 #endif /* _UTIL_H */
-- 
1.8.1.4



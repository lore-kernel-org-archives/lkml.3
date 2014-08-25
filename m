Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaHYIUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:20:35 -0400
Received: from ozlabs.org ([103.22.144.67]:46150 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbaHYIUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:20:33 -0400
Date: Mon, 25 Aug 2014 18:20:31 +1000
From: Anton Blanchard <anton@samba.org>
To: sukadev@linux.vnet.ibm.com, mpe@ellerman.id.au,
        aneesh.kumar@linux.vnet.ibm.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf symbols: symbol to section name mapping broken with
 debuginfo files
Message-ID: <20140825182031.2b209f27@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elf_sec__is_a and elf_sec__name maps a symbol back to its section name.
It does this by getting the Elf_Scn *, which contains an offset into
the strings section.

At the moment we use the Elf_Scn * from the runtime object and the
section strings from the debuginfo object, which is wrong. They are not
required to match, for example:

# readelf --string-dump=.shstrtab /lib/x86_64-linux-gnu/libc-2.19.so | md5sum
55ec050a37f64db113b42979a18a40ef  -

# readelf --string-dump=.shstrtab /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.19.so | md5sum
5ba4e37aae29b48418297f0c5b76b797  -

This issue was first found on ppc64le, where PLT entries (which are
labels with no type) were not getting resolved to symbols.

This looks to have been introduced in 261360b6e90a (perf symbols:
Convert dso__load_syms to take 2 symsrc's)

Cc: stable@vger.kernel.org # 3.8+
Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/tools/perf/util/symbol-elf.c
===================================================================
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -569,6 +569,7 @@ int symsrc__init(struct symsrc *ss, stru
 	GElf_Ehdr ehdr;
 	Elf *elf;
 	int fd;
+	Elf_Scn *sec_strndx;
 
 	fd = open(name, O_RDONLY);
 	if (fd < 0)
@@ -618,6 +619,14 @@ int symsrc__init(struct symsrc *ss, stru
 	if (ss->opdshdr.sh_type != SHT_PROGBITS)
 		ss->opdsec = NULL;
 
+	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	if (sec_strndx == NULL)
+		goto out_elf_end;
+
+	ss->secstrs = elf_getdata(sec_strndx, NULL);
+	if (ss->secstrs == NULL)
+		goto out_elf_end;
+
 	if (dso->kernel == DSO_TYPE_USER) {
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
@@ -687,7 +696,7 @@ int dso__load_sym(struct dso *dso, struc
 	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
 	struct dso *curr_dso = dso;
-	Elf_Data *symstrs, *secstrs;
+	Elf_Data *symstrs;
 	uint32_t nr_syms;
 	int err = -1;
 	uint32_t idx;
@@ -695,7 +704,7 @@ int dso__load_sym(struct dso *dso, struc
 	GElf_Shdr shdr;
 	Elf_Data *syms, *opddata = NULL;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx;
+	Elf_Scn *sec;
 	Elf *elf;
 	int nr = 0;
 	bool remap_kernel = false, adjust_kernel_syms = false;
@@ -736,13 +745,6 @@ int dso__load_sym(struct dso *dso, struc
 	if (symstrs == NULL)
 		goto out_elf_end;
 
-	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
-	if (sec_strndx == NULL)
-		goto out_elf_end;
-
-	secstrs = elf_getdata(sec_strndx, NULL);
-	if (secstrs == NULL)
-		goto out_elf_end;
 
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
@@ -821,10 +823,10 @@ int dso__load_sym(struct dso *dso, struc
 
 		gelf_getshdr(sec, &shdr);
 
-		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
+		if (is_label && !elf_sec__is_a(&shdr, runtime_ss->secstrs, map->type))
 			continue;
 
-		section_name = elf_sec__name(&shdr, secstrs);
+		section_name = elf_sec__name(&shdr, runtime_ss->secstrs);
 
 		/* On ARM, symbols for thumb functions have 1 added to
 		 * the symbol address as a flag - remove it */
Index: b/tools/perf/util/symbol.h
===================================================================
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -215,6 +215,8 @@ struct symsrc {
 	size_t dynsym_idx;
 	GElf_Shdr dynshdr;
 
+	Elf_Data *secstrs;
+
 	bool adjust_symbols;
 	bool is_64_bit;
 #endif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3IVKRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:17:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab3IVKQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:16:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354085"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 04/10] perf tools: workaround objdump difficulties with kcore
Date: Sun, 22 Sep 2013 13:22:12 +0300
Message-Id: <1379845338-29637-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

objdump fails to annotate module symbols when looking
at kcore.  Workaround this by extracting object code
from kcore and putting it in a temporary file for
objdump to use instead.  The temporary file is created
to look like kcore but contains only the function
being disassembled.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/annotate.c       |  21 ++++
 tools/perf/util/symbol-elf.c     | 221 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c |   9 ++
 tools/perf/util/symbol.h         |  14 +++
 4 files changed, 265 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f7bdc01..a65e3fc 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -879,6 +879,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	FILE *file;
 	int err = 0;
 	char symfs_filename[PATH_MAX];
+	struct kcore_extract kce;
+	bool delete_extract = false;
 
 	if (filename) {
 		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
@@ -940,6 +942,23 @@ fallback:
 	pr_debug("annotating [%p] %30s : [%p] %30s\n",
 		 dso, dso->long_name, sym, sym->name);
 
+	if (dso__is_kcore(dso)) {
+		kce.kcore_filename = symfs_filename;
+		kce.addr = map__rip_2objdump(map, sym->start);
+		kce.offs = sym->start;
+		kce.len = sym->end + 1 - sym->start;
+		if (!create_kcore_extract(&kce)) {
+			delete_extract = true;
+			strncpy(symfs_filename, kce.extract_filename,
+				sizeof(symfs_filename));
+			if (free_filename) {
+				free(filename);
+				free_filename = false;
+			}
+			filename = symfs_filename;
+		}
+	}
+
 	snprintf(command, sizeof(command),
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
@@ -972,6 +991,8 @@ fallback:
 
 	pclose(file);
 out_free_filename:
+	if (delete_extract)
+		delete_kcore_extract(&kce);
 	if (free_filename)
 		free(filename);
 	return err;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a7b9ab5..79b27fc7 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1002,6 +1002,227 @@ int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
 	return err;
 }
 
+static int copy_bytes(int from, off_t from_offs, int to, off_t to_offs, u64 len)
+{
+	char buf[page_size];
+	ssize_t r;
+	size_t n;
+
+	if (lseek(to, to_offs, SEEK_SET) != to_offs)
+		return -1;
+
+	if (lseek(from, from_offs, SEEK_SET) != from_offs)
+		return -1;
+
+	while (len) {
+		n = sizeof(buf);
+		if (len < n)
+			n = len;
+		/* Use read because mmap won't work on proc files */
+		r = read(from, buf, n);
+		if (r < 0)
+			return -1;
+		if (!r)
+			break;
+		n = r;
+		r = write(to, buf, n);
+		if (r < 0)
+			return -1;
+		if ((size_t)r != n)
+			return -1;
+		len -= n;
+	}
+	return 0;
+}
+
+struct kcore {
+	int fd;
+	int elfclass;
+	Elf *elf;
+	GElf_Ehdr ehdr;
+};
+
+static int kcore_open(const char *filename, struct kcore *kcore)
+{
+	GElf_Ehdr *ehdr;
+
+	kcore->fd = open(filename, O_RDONLY);
+	if (kcore->fd == -1)
+		return -1;
+
+	kcore->elf = elf_begin(kcore->fd, ELF_C_READ, NULL);
+	if (!kcore->elf)
+		goto out_close;
+
+	kcore->elfclass = gelf_getclass(kcore->elf);
+	if (kcore->elfclass == ELFCLASSNONE)
+		goto out_end;
+
+	ehdr = gelf_getehdr(kcore->elf, &kcore->ehdr);
+	if (!ehdr)
+		goto out_end;
+
+	return 0;
+
+out_end:
+	elf_end(kcore->elf);
+out_close:
+	close(kcore->fd);
+	return -1;
+}
+
+static int kcore_new(char *filename, struct kcore *kcore, int elfclass,
+		     bool temp)
+{
+	GElf_Ehdr *ehdr;
+
+	kcore->elfclass = elfclass;
+
+	if (temp)
+		kcore->fd = mkstemp(filename);
+	else
+		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL, 0400);
+	if (kcore->fd == -1)
+		return -1;
+
+	kcore->elf = elf_begin(kcore->fd, ELF_C_WRITE, NULL);
+	if (!kcore->elf)
+		goto out_close;
+
+	if (!gelf_newehdr(kcore->elf, elfclass))
+		goto out_end;
+
+	ehdr = gelf_getehdr(kcore->elf, &kcore->ehdr);
+	if (!ehdr)
+		goto out_end;
+
+	return 0;
+
+out_end:
+	elf_end(kcore->elf);
+out_close:
+	close(kcore->fd);
+	unlink(filename);
+	return -1;
+}
+
+static void kcore_close(struct kcore *kcore)
+{
+	elf_end(kcore->elf);
+	close(kcore->fd);
+}
+
+static int kcore_copy_hdr(struct kcore *from, struct kcore *to, size_t count)
+{
+	GElf_Ehdr *ehdr = &to->ehdr;
+	GElf_Ehdr *kehdr = &from->ehdr;
+
+	memcpy(ehdr->e_ident, kehdr->e_ident, EI_NIDENT);
+	ehdr->e_type      = kehdr->e_type;
+	ehdr->e_machine   = kehdr->e_machine;
+	ehdr->e_version   = kehdr->e_version;
+	ehdr->e_entry     = 0;
+	ehdr->e_shoff     = 0;
+	ehdr->e_flags     = kehdr->e_flags;
+	ehdr->e_phnum     = count;
+	ehdr->e_shentsize = 0;
+	ehdr->e_shnum     = 0;
+	ehdr->e_shstrndx  = 0;
+
+	if (from->elfclass == ELFCLASS32) {
+		ehdr->e_phoff     = sizeof(Elf32_Ehdr);
+		ehdr->e_ehsize    = sizeof(Elf32_Ehdr);
+		ehdr->e_phentsize = sizeof(Elf32_Phdr);
+	} else {
+		ehdr->e_phoff     = sizeof(Elf64_Ehdr);
+		ehdr->e_ehsize    = sizeof(Elf64_Ehdr);
+		ehdr->e_phentsize = sizeof(Elf64_Phdr);
+	}
+
+	if (!gelf_update_ehdr(to->elf, ehdr))
+		return -1;
+
+	if (!gelf_newphdr(to->elf, count))
+		return -1;
+
+	return 0;
+}
+
+static int kcore_add_phdr(struct kcore *kcore, int index, off_t offset,
+			  u64 addr, u64 len)
+{
+	GElf_Phdr gphdr;
+	GElf_Phdr *phdr;
+
+	phdr = gelf_getphdr(kcore->elf, index, &gphdr);
+	if (!phdr)
+		return -1;
+
+	phdr->p_type	= PT_LOAD;
+	phdr->p_flags	= PF_R | PF_W | PF_X;
+	phdr->p_offset	= offset;
+	phdr->p_vaddr	= addr;
+	phdr->p_paddr	= 0;
+	phdr->p_filesz	= len;
+	phdr->p_memsz	= len;
+	phdr->p_align	= page_size;
+
+	if (!gelf_update_phdr(kcore->elf, index, phdr))
+		return -1;
+
+	return 0;
+}
+
+static off_t kcore_write(struct kcore *kcore)
+{
+	return elf_update(kcore->elf, ELF_C_WRITE);
+}
+
+int create_kcore_extract(struct kcore_extract *kce)
+{
+	struct kcore kcore;
+	struct kcore extract;
+	size_t count = 1;
+	int index = 0, err = -1;
+	off_t offset = page_size, sz;
+
+	if (kcore_open(kce->kcore_filename, &kcore))
+		return -1;
+
+	strcpy(kce->extract_filename, PERF_KCORE_EXTRACT);
+	if (kcore_new(kce->extract_filename, &extract, kcore.elfclass, true))
+		goto out_kcore_close;
+
+	if (kcore_copy_hdr(&kcore, &extract, count))
+		goto out_extract_close;
+
+	if (kcore_add_phdr(&extract, index, offset, kce->addr, kce->len))
+		goto out_extract_close;
+
+	sz = kcore_write(&extract);
+	if (sz < 0 || sz > offset)
+		goto out_extract_close;
+
+	if (copy_bytes(kcore.fd, kce->offs, extract.fd, offset, kce->len))
+		goto out_extract_close;
+
+	err = 0;
+
+out_extract_close:
+	kcore_close(&extract);
+	if (err)
+		unlink(kce->extract_filename);
+out_kcore_close:
+	kcore_close(&kcore);
+
+	return err;
+}
+
+void delete_kcore_extract(struct kcore_extract *kce)
+{
+	unlink(kce->extract_filename);
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 3a802c3..0330163 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -308,6 +308,15 @@ int file__read_maps(int fd __maybe_unused, bool exe __maybe_unused,
 	return -1;
 }
 
+int create_kcore_extract(struct kcore_extract *kce __maybe_unused)
+{
+	return -1;
+}
+
+void delete_kcore_extract(struct kcore_extract *kce __maybe_unused)
+{
+}
+
 void symbol__elf_init(void)
 {
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index a2543f0..54f3ed0 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -256,4 +256,18 @@ typedef int (*mapfn_t)(u64 start, u64 len, u64 pgoff, void *data);
 int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
 		    bool *is_64_bit);
 
+#define PERF_KCORE_EXTRACT "/tmp/perf-kcore-XXXXXX"
+
+struct kcore_extract {
+	char *kcore_filename;
+	u64 addr;
+	u64 offs;
+	u64 len;
+	char extract_filename[sizeof(PERF_KCORE_EXTRACT)];
+	int fd;
+};
+
+int create_kcore_extract(struct kcore_extract *kce);
+void delete_kcore_extract(struct kcore_extract *kce);
+
 #endif /* __PERF_SYMBOL */
-- 
1.7.11.7


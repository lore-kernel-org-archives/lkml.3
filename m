Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbaH1Dnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:43:40 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53947 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219AbaH1Dnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:43:39 -0400
Subject: [PATCH v4 1/3] perf/sdt : Raw SDT parsing functions
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 28 Aug 2014 03:14:20 +0530
Message-ID: <20140827214323.13454.46743.stgit@hemant-fedora>
In-Reply-To: <20140827213745.13454.46266.stgit@hemant-fedora>
References: <20140827213745.13454.46266.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082803-0005-0000-0000-000000BA6184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serves as the initial support to identify and list SDT events in binaries.
When programs containing SDT markers are compiled, gcc with the help of assembler
directives identifies them and places them in the section ".note.stapsdt". To find these
markers from the binaries, one needs to traverse through this section and parse the
relevant details like the name, type and location of the marker. Also, the original
location could be skewed due to the effect of prelinking. If that is the case, the
locations need to be adjusted.

The functions in this patch open a given ELF, find out the SDT section, parse the
relevant details, adjust the location (if necessary) and populate them in a list.

Signed-off-by : Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c |  244 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h     |   19 +++
 2 files changed, 263 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6864661..a875fdc 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1619,6 +1619,250 @@ void kcore_extract__delete(struct kcore_extract *kce)
 	unlink(kce->extract_filename);
 }
 
+/*
+ * populate_sdt_note() : Responsible for parsing the section .note.stapsdt and
+ * after adjusting the note's location, returns that to the calling functions.
+ */
+static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
+			     struct sdt_note **note)
+{
+	const char *provider, *name;
+	struct sdt_note *tmp = NULL;
+	GElf_Ehdr ehdr;
+	GElf_Addr base_off = 0;
+	GElf_Shdr shdr;
+	int ret = -1;
+	int i;
+
+	union {
+		Elf64_Addr a64[3];
+		Elf32_Addr a32[3];
+	} buf;
+
+	Elf_Data dst = {
+		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
+		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
+		.d_off = 0, .d_align = 0
+	};
+	Elf_Data src = {
+		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
+		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
+		.d_align = 0
+	};
+
+	/* Check the type of each of the notes */
+	if (type != SDT_NOTE_TYPE)
+		goto out_err;
+
+	tmp = (struct sdt_note *)calloc(1, sizeof(struct sdt_note));
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	INIT_LIST_HEAD(&tmp->note_list);
+
+	if (len < dst.d_size + 3)
+		goto out_free_note;
+
+	/* Translation from file representation to memory representation */
+	if (gelf_xlatetom(*elf, &dst, &src,
+			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
+		printf("gelf_xlatetom : %s\n", elf_errmsg(-1));
+
+	/* Populate the fields of sdt_note */
+	provider = data + dst.d_size;
+
+	name = (const char *)memchr(provider, '\0', data + len - provider);
+	if (name++ == NULL)
+		goto out_free_note;
+
+	tmp->provider = strdup(provider);
+	if (!tmp->provider) {
+		ret = -ENOMEM;
+		goto out_free_note;
+	}
+	tmp->name = strdup(name);
+	if (!tmp->name) {
+		ret = -ENOMEM;
+		goto out_free_prov;
+	}
+
+	/* Obtain the addresses */
+	if (gelf_getclass(*elf) == ELFCLASS32) {
+		for (i = 0; i < 3; i++)
+			tmp->addr.a32[i] = buf.a32[i];
+		tmp->bit32 = true;
+	} else {
+		for (i = 0; i < 3; i++)
+			tmp->addr.a64[i] = buf.a64[i];
+		tmp->bit32 = false;
+	}
+
+	/* Now Adjust the prelink effect */
+	if (!gelf_getehdr(*elf, &ehdr)) {
+		pr_debug("%s : cannot get elf header.\n", __func__);
+		ret = -EBADF;
+		goto out_free_name;
+	}
+
+	/*
+	 * Find out the .stapsdt.base section.
+	 * This scn will help us to handle prelinking (if present).
+	 * Compare the retrieved file offset of the base section with the
+	 * base address in the description of the SDT note. If its different,
+	 * then accordingly, adjust the note location.
+	 */
+	if (elf_section_by_name(*elf, &ehdr, &shdr, SDT_BASE_SCN, NULL)) {
+		base_off = shdr.sh_offset;
+		if (base_off) {
+			if (tmp->bit32)
+				tmp->addr.a32[0] = tmp->addr.a32[0] + base_off -
+					tmp->addr.a32[1];
+			else
+				tmp->addr.a64[0] = tmp->addr.a64[0] + base_off -
+					tmp->addr.a64[1];
+		}
+	}
+
+	*note = tmp;
+	return 0;
+
+out_free_name:
+	free(tmp->name);
+out_free_prov:
+	free(tmp->provider);
+out_free_note:
+	free(tmp);
+out_err:
+	return ret;
+}
+
+/*
+ * construct_sdt_notes_list() : Scans the sections in 'elf' for the section
+ * .note.stapsdt. It, then calls populate_sdt_note to find
+ * out the SDT events and populates the 'sdt_notes'.
+ */
+static int construct_sdt_notes_list(Elf *elf, struct list_head *sdt_notes)
+{
+	GElf_Ehdr ehdr;
+	Elf_Scn *scn = NULL;
+	Elf_Data *data;
+	GElf_Shdr shdr;
+	size_t shstrndx, next;
+	GElf_Nhdr nhdr;
+	size_t name_off, desc_off, offset;
+	struct sdt_note *tmp = NULL;
+	int ret = 0, val = 0;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		ret = -EBADF;
+		goto out_ret;
+	}
+	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
+		ret = -EBADF;
+		goto out_ret;
+	}
+
+	/* Look for the required section */
+	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN, NULL);
+	if (!scn) {
+		ret = -ENOENT;
+		goto out_ret;
+	}
+
+	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {
+		ret = -ENOENT;
+		goto out_ret;
+	}
+
+	data = elf_getdata(scn, NULL);
+
+	/* Get the SDT notes */
+	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
+					      &desc_off)) > 0; offset = next) {
+		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
+		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
+			    sizeof(SDT_NOTE_NAME))) {
+			val = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
+						nhdr.n_descsz, nhdr.n_type,
+						&tmp);
+			if (!val)
+				list_add_tail(&tmp->note_list, sdt_notes);
+			if (val == -ENOMEM) {
+				ret = val;
+				goto out_ret;
+			}
+		}
+	}
+	if (list_empty(sdt_notes))
+		ret = -ENOENT;
+
+out_ret:
+	return ret;
+}
+
+/*
+ * get_sdt_note_list() : Takes two arguments "head" and "target", where head
+ * is the head of the SDT events' list and "target" is the file name as to
+ * where the SDT events should be looked for. This opens the file, initializes
+ * the ELF and then calls construct_sdt_notes_list.
+ */
+int get_sdt_note_list(struct list_head *head, const char *target)
+{
+	Elf *elf;
+	int fd, ret;
+
+	fd = open(target, O_RDONLY);
+	if (fd < 0)
+		return -EBADF;
+
+	symbol__elf_init();
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+	if (!elf) {
+		ret = -EBADF;
+		goto out_close;
+	}
+	ret = construct_sdt_notes_list(elf, head);
+	elf_end(elf);
+
+out_close:
+	close(fd);
+	return ret;
+}
+
+/*
+ * is_an_elf() : Returns 'true' if the file is an elf and 'false' otherwise
+ */
+bool is_an_elf(char *file)
+{
+	int fd;
+	Elf *elf;
+	bool ret = true;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		ret = false;
+		goto out_ret;
+	}
+
+	symbol__elf_init();
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+	if (!elf) {
+		ret = false;
+		goto out_close;
+	}
+	if (elf_kind(elf) != ELF_K_ELF)
+		ret = false;
+
+	elf_end(elf);
+
+out_close:
+	close(fd);
+out_ret:
+	return ret;
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..83be31a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -294,4 +294,23 @@ int compare_proc_modules(const char *from, const char *to);
 int setup_list(struct strlist **list, const char *list_str,
 	       const char *list_name);
 
+struct sdt_note {
+	char *name;
+	char *provider;
+	bool bit32;
+	union {
+		Elf64_Addr a64[3];
+		Elf32_Addr a32[3];
+	} addr;
+	struct list_head note_list;
+};
+
+int get_sdt_note_list(struct list_head *head, const char *target);
+bool is_an_elf(char *file);
+
+#define SDT_BASE_SCN ".stapsdt.base"
+#define SDT_NOTE_SCN  ".note.stapsdt"
+#define SDT_NOTE_TYPE 3
+#define SDT_NOTE_NAME "stapsdt"
+
 #endif /* __PERF_SYMBOL */


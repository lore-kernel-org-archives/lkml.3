Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaJJK6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:58:31 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33803 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaJJK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:58:28 -0400
Subject: [PATCH v3 1/5] perf/sdt: ELF support for SDT
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Fri, 10 Oct 2014 16:27:53 +0530
Message-ID: <20141010105727.15506.99362.stgit@hemant-fedora>
In-Reply-To: <20141010104402.15506.73285.stgit@hemant-fedora>
References: <20141010104402.15506.73285.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101010-4790-0000-0000-00000434DD34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serves the initial support to identify and list SDT events in binaries.
When programs containing SDT markers are compiled, gcc with the help of assembler
directives identifies them and places them in the section ".note.stapsdt". To find
these markers from the binaries, one needs to traverse through this section and
parse the relevant details like the name, type and location of the marker. Also,
the original location could be skewed due to the effect of prelinking. If that is
the case, the locations need to be adjusted.

The functions in this patch open a given ELF, find out the SDT section, parse the
relevant details, adjust the location (if necessary) and populate them in a list.

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c |  257 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h     |   21 +++
 2 files changed, 278 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e23a5b..e403df6 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1677,6 +1677,263 @@ void kcore_extract__delete(struct kcore_extract *kce)
 	unlink(kce->extract_filename);
 }
 
+/**
+ * populate_sdt_note : Parse raw data and identify SDT note
+ * @elf: elf of the opened file
+ * @data: raw data of a section with description offset applied
+ * @len: note description size
+ * @type: type of the note
+ * @sdt_notes: List to add the SDT note
+ *
+ * Responsible for parsing the @data in section .note.stapsdt in @elf and
+ * if its an SDT note, it appends to @sdt_notes list.
+ */
+static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
+			     struct list_head *sdt_notes)
+{
+	const char *provider, *name;
+	struct sdt_note *tmp = NULL;
+	GElf_Ehdr ehdr;
+	GElf_Addr base_off = 0;
+	GElf_Shdr shdr;
+	int i, ret = -EINVAL;
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
+			  elf_getident(*elf, NULL)[EI_DATA]) == NULL) {
+		pr_err("gelf_xlatetom : %s\n", elf_errmsg(-1));
+		goto out_free_note;
+	}
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
+	list_add_tail(&tmp->note_list, sdt_notes);
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
+/**
+ * construct_sdt_notes_list : constructs a list of SDT notes
+ * @elf : elf to look into
+ * @sdt_notes : empty list_head
+ *
+ * Scans the sections in 'elf' for the section
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
+	int ret = 0;
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
+			ret = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
+						nhdr.n_descsz, nhdr.n_type,
+						sdt_notes);
+			if (ret < 0)
+				goto out_ret;
+		}
+	}
+	if (list_empty(sdt_notes))
+		ret = -ENOENT;
+
+out_ret:
+	return ret;
+}
+
+/**
+ * get_sdt_note_list : Wrapper to construct a list of sdt notes
+ * @head : empty list_head
+ * @target : file to find SDT notes from
+ *
+ * This opens the file, initializes
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
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (!elf) {
+		ret = -EBADF;
+		goto out_close;
+	}
+	ret = construct_sdt_notes_list(elf, head);
+	elf_end(elf);
+out_close:
+	close(fd);
+	return ret;
+}
+
+/**
+ * cleanup_sdt_note_list : free the sdt notes' list
+ * @sdt_notes: sdt notes' list
+ *
+ * Free up the SDT notes in @sdt_notes.
+ * Returns the number of SDT notes free'd.
+ */
+int cleanup_sdt_note_list(struct list_head *sdt_notes)
+{
+	struct sdt_note *tmp, *pos;
+	int nr_free = 0;
+
+	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
+		list_del(&pos->note_list);
+		free(pos->name);
+		free(pos->provider);
+		free(pos);
+		nr_free++;
+	}
+	return nr_free;
+}
+
+/**
+ * sdt_notes__get_count: Counts the number of sdt events
+ * @start: list_head to sdt_notes list
+ *
+ * Returns the number of SDT notes in a list
+ */
+int sdt_notes__get_count(struct list_head *start)
+{
+	struct sdt_note *sdt_ptr;
+	int count = 0;
+
+	list_for_each_entry(sdt_ptr, start, note_list)
+		count++;
+	return count;
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bec4b7b..23d3d41 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -313,4 +313,25 @@ int compare_proc_modules(const char *from, const char *to);
 int setup_list(struct strlist **list, const char *list_str,
 	       const char *list_name);
 
+/* structure containing an SDT note's info */
+struct sdt_note {
+	char *name;			/* name of the note*/
+	char *provider;			/* provider name */
+	bool bit32;			/* whether the location is 32 bits? */
+	union {				/* location, base and semaphore addrs */
+		Elf64_Addr a64[3];
+		Elf32_Addr a32[3];
+	} addr;
+	struct list_head note_list;	/* SDT notes' list */
+};
+
+int get_sdt_note_list(struct list_head *head, const char *target);
+int cleanup_sdt_note_list(struct list_head *sdt_notes);
+int sdt_notes__get_count(struct list_head *start);
+
+#define SDT_BASE_SCN ".stapsdt.base"
+#define SDT_NOTE_SCN  ".note.stapsdt"
+#define SDT_NOTE_TYPE 3
+#define SDT_NOTE_NAME "stapsdt"
+
 #endif /* __PERF_SYMBOL */


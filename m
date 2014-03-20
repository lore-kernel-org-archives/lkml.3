Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbaCTJkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:40:40 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48699 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaCTJkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:33 -0400
Subject: [PATCH 09/33] Adding notes infrastructure
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:10:20 +0530
Message-ID: <20140320094020.14878.44151.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-7014-0000-0000-0000048ABAD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating Elf_note structure and adding the required functions to add the notes.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   15 ++++++++++++
 src/coredump.h |   13 ++++++++++
 src/elf.c      |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c    |    1 +
 src/elf64.c    |    1 +
 5 files changed, 103 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index de0a7ce..0fd6343e 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -166,6 +166,18 @@ int release_threads(void)
 	return ret;
 }
 
+/* Free Notes */
+void free_notes(struct mem_note *head)
+{
+	struct mem_note *tmp;
+
+	while (head) {
+		tmp = head->next;
+		free(head);
+		head = tmp;
+	}
+}
+
 /* Performs the core dump */
 int do_coredump(int pid, char *core_file)
 {
@@ -216,6 +228,9 @@ cleanup:
 	if (cp.elf_hdr)
 		free(cp.elf_hdr);
 
+	if (cp.notes)
+		free_notes(cp.notes);
+
 	errno = status;
 
 	return ret;
diff --git a/src/coredump.h b/src/coredump.h
index 4e508c1..9b19f19 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -25,6 +25,18 @@ struct maps {
 	char fname[0];
 };
 
+/*
+ * Structure for Notes
+ * We follow this linked list data-type as we dont know the number of notes
+ * as that depends on the architecture. Also the notebuf contains the final
+ * in-file format for the note data.
+ */
+struct mem_note {
+	unsigned char *notebuf;		/* Notes - type, name_sz, datasz, name and data */
+	unsigned int size;		/* Size of Note */
+	struct mem_note *next;
+};
+
 /* Structure for the Core of the Process */
 struct core_proc {
 	int thread_count;		/* Number of threads */
@@ -33,4 +45,5 @@ struct core_proc {
 	int phdrs_count;		/* Number of Program headers */
 	int elf_class;			/* Elf class of the process */
 	void *elf_hdr;			/* Stores the ELF_header */
+	struct mem_note *notes;		/* Head of Notes */
 };
diff --git a/src/elf.c b/src/elf.c
index 9f65c77..dfcb1d7 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -30,6 +30,79 @@
 #include <linux/elf.h>
 #include "coredump.h"
 
+#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+
+/* Appending the note to the list */
+static void append_note(struct mem_note *new_note, struct core_proc *cp)
+{
+	struct mem_note *tmp;
+
+	if (cp->notes == NULL)
+		cp->notes = new_note;
+	else {
+		tmp = cp->notes;
+		while (tmp->next != NULL)
+			tmp = tmp->next;
+		tmp->next = new_note;
+	}
+}
+
+/* Adding a new note */
+static int add_note(const char *name, int type, unsigned int data_sz, void *data,
+						struct core_proc *cp)
+{
+	unsigned char *ptr, *notebuf;
+	unsigned int namelen, size, data_offset;
+	Elf_Nhdr *note;
+	struct mem_note *tmp = malloc(sizeof(struct mem_note));
+	if (!tmp) {
+		status = errno;
+		gencore_log("Failure in adding note.\n");
+		return -1;
+	}
+
+	/* Calculate the size of the Notes */
+	namelen = strlen(name) + 1;
+	size = sizeof(Elf_Nhdr);
+	size += namelen;
+
+	/* Note down the offset where data is to be stored */
+	data_offset = size = roundup(size, 4);
+	size += data_sz;
+	size = roundup(size, 4);
+
+	/* Allocate the required size, initialized to 0 */
+	notebuf = calloc(1, size);
+	if (!notebuf) {
+		status = errno;
+		gencore_log("Could not allocate memory for Notes buffer.\n");
+		return -1;
+	}
+
+	note = (Elf_Nhdr *)notebuf;
+
+	/* Where name should be stored */
+	ptr = (unsigned char *) (note + 1);
+
+	note->n_type = type;
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = data_sz;
+
+	/* Store name */
+	memcpy(ptr, name, namelen);
+
+	/* Store data */
+	memcpy(notebuf + data_offset, data, data_sz);
+
+	tmp->notebuf = notebuf;
+	tmp->size = size;
+	tmp->next = NULL;
+
+	append_note(tmp, cp);
+
+	return 0;
+}
+
 /* Fetchs ELF header of the executable */
 static int get_elf_hdr_exe_file(int pid, Elf_Ehdr *elf)
 {
diff --git a/src/elf32.c b/src/elf32.c
index 1a95ff2..01b3923 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -33,5 +33,6 @@
 #define Elf_Ehdr Elf32_Ehdr
 #define Elf_Phdr Elf32_Phdr
 #define Elf_Shdr Elf32_Shdr
+#define Elf_Nhdr Elf32_Nhdr
 
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index 953b826..a99a73b 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -33,5 +33,6 @@
 #define Elf_Ehdr Elf64_Ehdr
 #define Elf_Phdr Elf64_Phdr
 #define Elf_Shdr Elf64_Shdr
+#define Elf_Nhdr Elf64_Nhdr
 
 #include "elf.c"


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbaCTJlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:09 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34744 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaCTJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:01 -0400
Subject: [PATCH 12/33] Fetch File maps
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
Date: Thu, 20 Mar 2014 15:10:48 +0530
Message-ID: <20140320094048.14878.1986.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9264-0000-0000-000005AD5BAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file maps details are got from the maps linked list which was
populated in Patch 5 and they are filled as a note in the following
format.

long count     -- how many files are mapped
long page_size -- units for file_ofs
array of [COUNT] elements of
long start
long end
long file_ofs
followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/elf.c   |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c |    1 +
 src/elf64.c |    1 +
 3 files changed, 80 insertions(+)

diff --git a/src/elf.c b/src/elf.c
index b7fd6d0..9e3623f 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -308,6 +308,79 @@ static int get_auxv(int pid, struct core_proc *cp)
 	return ret;
 }
 
+/*
+ * Get File Maps in the following format:
+ * long count     -- how many files are mapped
+ * long page_size -- units for file_ofs
+ * array of [COUNT] elements of
+ * long start
+ * long end
+ * long file_ofs
+ * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
+ */
+static int get_file_maps(struct core_proc *cp)
+{
+	Elf_Long count = 0;
+	Elf_Long fmap_size = 0, namesz = 0;
+	Elf_Long *fmap;
+	Elf_Long *data_pos;
+	unsigned char *name_pos;
+	int ret;
+	struct maps *map = cp->vmas;
+
+	/*
+	 * Finding the actual size of the file map for which we need
+	 * to know number of VMAS(non zero inode) plus the file name size
+	 * for each of the VMAS(non zero inode.
+	 */
+	while (map) {
+		if (map->inode) {
+			count++;
+			namesz += strlen(map->fname) + 1;
+		}
+		map = map->next;
+	}
+
+	/*
+	 * We add 2 for the count and page_size, 3 * (number of vmas)
+	 * for the start, end and file_ofs and finally the entire size
+	 * of the filenames of all the VMAS.
+	 */
+	fmap_size = ((2 + (3 * count)) * sizeof(Elf_Long))
+				+ (namesz * sizeof(unsigned char));
+
+	fmap = calloc(fmap_size, 1);
+	if (!fmap) {
+		status = errno;
+		gencore_log("Could not allocate memory for file map data\n");
+		return -1;
+	}
+
+	data_pos = fmap + 2;
+	name_pos = (unsigned char *)(fmap + 2 + (count * 3));
+
+	map = cp->vmas;
+	while (map) {
+		if (map->inode) {
+			*data_pos++ = map->src;
+			*data_pos++ = map->dst;
+			*data_pos++ = map->offset;
+
+			strcpy(name_pos, map->fname);
+			name_pos += strlen(map->fname) + 1;
+		}
+		map = map->next;
+	}
+
+	fmap[0] = count;
+	fmap[1] = 1;
+
+	ret = add_note("CORE", NT_FILE, fmap_size, fmap, cp);
+	free(fmap);
+
+	return ret;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret;
@@ -327,5 +400,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Get File maps */
+	ret = get_file_maps(cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }
diff --git a/src/elf32.c b/src/elf32.c
index 8778bed..0f7c03d 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -35,5 +35,6 @@
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Nhdr Elf32_Nhdr
 #define Elf_prpsinfo compat_elf_prpsinfo
+#define Elf_Long int
 
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index d062888..77da222 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -35,5 +35,6 @@
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Nhdr Elf64_Nhdr
 #define Elf_prpsinfo elf_prpsinfo
+#define Elf_Long long
 
 #include "elf.c"


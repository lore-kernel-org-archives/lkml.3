Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaCTJjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:52 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55325 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaCTJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:49 -0400
Subject: [PATCH 05/33] Fetching Memory maps
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
Date: Thu, 20 Mar 2014 15:09:36 +0530
Message-ID: <20140320093936.14878.51299.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-3568-0000-0000-00000520E586
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetching virtual memory areas through /proc/pid/maps and storing it in a
linked list in order to populate the program headers and file maps.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |    8 +++++
 src/coredump.h |   11 ++++++
 src/proc.c     |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index dd9089f..7a559e2 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -183,6 +183,11 @@ int do_coredump(int pid, char *core_file)
 	if (ret)
 		goto cleanup;
 
+	/* Get VMAS */
+	ret = get_vmas(pid, &cp);
+	if (ret)
+		goto cleanup;
+
 cleanup:
 
 	/* Release the threads */
@@ -191,6 +196,9 @@ cleanup:
 	if (cp.t_id)
 		free(cp.t_id);
 
+	if (cp.vmas)
+		free_maps(cp.vmas);
+
 	errno = status;
 
 	return ret;
diff --git a/src/coredump.h b/src/coredump.h
index 00cb008..291e13b 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -16,8 +16,19 @@ struct pid_stat {
 	unsigned long long ps_num[NUM_STAT_FEILDS];
 };
 
+/* Structure for maps */
+struct maps {
+	unsigned long long src, dst, offset;
+	char r, w, x;
+	long inode;
+	struct maps *next;
+	char fname[0];
+};
+
 /* Structure for the Core of the Process */
 struct core_proc {
 	int thread_count;		/* Number of threads */
 	int *t_id;			/* Threads_ids of all the threads */
+	struct maps *vmas;		/* VMAs */
+	int phdrs_count;		/* Number of Program headers */
 };
diff --git a/src/proc.c b/src/proc.c
index fc16d90..a401aa5 100644
--- a/src/proc.c
+++ b/src/proc.c
@@ -25,6 +25,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <string.h>
 #include <coredump.h>
 
 /* Get Process Stats */
@@ -136,3 +137,97 @@ char get_thread_status(int tid)
 
 	return buff[pos - buff + 2];
 }
+
+/* Free Maps */
+void free_maps(struct maps *head)
+{
+	struct maps *tmp;
+
+	while (head) {
+		tmp = head->next;
+		free(head);
+		head = tmp;
+	}
+}
+
+/* Append a new VMA */
+void append_maps(struct maps *new_map, struct core_proc *cp)
+{
+	struct maps *tmp;
+
+	if (cp->vmas == NULL)
+		cp->vmas = new_map;
+	else {
+		tmp = cp->vmas;
+		while (tmp->next != NULL)
+			tmp = tmp->next;
+		tmp->next = new_map;
+	}
+}
+
+/* Collects virtual memory areas */
+int get_vmas(int pid, struct core_proc *cp)
+{
+	char filename[40];
+	char buff[4096];
+	char src[128];
+	char dst[128];
+	char fname[4096];
+	char page_offset[128];
+	char inode[128];
+	char r, w, x;
+	char junk[30];
+	FILE *fin;
+	struct maps *tmp;
+	long tmp_inode;
+
+	snprintf(filename, 40, "/proc/%d/maps", pid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failure in fetching Memory Mappings %s.\n",
+								filename);
+		return -1;
+	}
+
+	while (fgets(buff, 4096, fin)) {
+
+		sscanf(buff, "%[^-]%c%s %c%c%c%c %s %s %s %s", src, &junk[0],
+					dst, &r, &w, &x, &junk[0],
+					page_offset, junk, inode, fname);
+
+		tmp_inode = strtol(inode, NULL, 16);
+
+		if (tmp_inode)
+			tmp = malloc(sizeof(struct maps) + strlen(fname) + 1);
+		else
+			tmp = malloc(sizeof(struct maps));
+		if (!tmp) {
+			status = errno;
+			gencore_log("Failure in allocating memory for memory maps.\n");
+			fclose(fin);
+			return -1;
+		}
+
+		tmp->src = strtoull(src, NULL, 16);
+		tmp->dst = strtoull(dst, NULL, 16);
+		tmp->offset = strtoull(page_offset, NULL, 16);
+		tmp->r = r;
+		tmp->w = w;
+		tmp->x = x;
+		tmp->inode = tmp_inode;
+
+		if (tmp->inode != 0)
+			strcpy(tmp->fname, fname);
+
+		tmp->next = NULL;
+		append_maps(tmp, cp);
+		cp->phdrs_count++;
+	}
+
+	/* One extra for the PT_NOTE */
+	cp->phdrs_count++;
+
+	fclose(fin);
+	return 0;
+}


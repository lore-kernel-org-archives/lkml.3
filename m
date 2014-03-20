Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbaCTJjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:44 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39802 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaCTJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:40 -0400
Subject: [PATCH 04/33] Hold threads
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
Date: Thu, 20 Mar 2014 15:09:31 +0530
Message-ID: <20140320093931.14878.89112.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-4790-0000-0000-0000003F25C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting number of threads and their respective IDs through /proc/pid/stat and
/proc/pid/task.

The threads are then seized and interrupted. After the dump is taken they are
detached.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/coredump.h |   10 ++++
 src/proc.c     |   52 ++++++++++++++++++++
 3 files changed, 210 insertions(+), 1 deletion(-)

diff --git a/src/coredump.c b/src/coredump.c
index ad9ee7d..dd9089f 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -26,6 +26,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
+#include <dirent.h>
+#include <errno.h>
+#include <sys/ptrace.h>
 #include <coredump.h>
 
 /* For logging all the messages */
@@ -43,10 +46,154 @@ void gencore_log(char *fmt, ...)
 	va_end(argptr);
 }
 
+/* Core process object */
+struct core_proc cp;
+
+/* Initialised core process members */
+void init_core(void)
+{
+	memset(&cp, 0, sizeof(struct core_proc));
+}
+
+/* Gets the Thread IDS and siezes them */
+int seize_threads(int pid)
+{
+	char filename[40];
+	DIR *dir;
+	int ct = 0, ret = 0, tmp_tid;
+	struct dirent *entry;
+	char state;
+
+	ret = get_thread_count(pid);
+	if (ret == -1)
+		return -1;
+
+	cp.thread_count = ret;
+	cp.t_id = calloc(cp.thread_count, sizeof(int));
+	if (!cp.t_id) {
+		status = errno;
+		gencore_log("Could not allocate memory for thread_ids.\n");
+		return -1;
+	}
+
+	snprintf(filename, 40, "/proc/%d/task", pid);
+	dir = opendir(filename);
+
+	while ((entry = readdir(dir))) {
+		if (entry->d_type == DT_DIR && entry->d_name[0] != '.') {
+			tmp_tid = atoi(entry->d_name);
+			ret = ptrace(PTRACE_SEIZE, tmp_tid, 0, 0);
+			if (ret) {
+				state = get_thread_status(tmp_tid);
+				if (state == 'Z')
+					goto assign;
+				status = errno;
+				gencore_log("Could not seize thread: %d\n",
+								tmp_tid);
+				break;
+			}
+			ret = ptrace(PTRACE_INTERRUPT, tmp_tid, 0, 0);
+			if (ret) {
+				state = get_thread_status(tmp_tid);
+				if (state == 'Z')
+					goto assign;
+				status = errno;
+				gencore_log("Could not interrupt thread: %d\n",
+								tmp_tid);
+				break;
+			}
+assign:
+			/* If a new thread, is created after we fetch the thread_count,
+			 * we may encounter a buffer overflow situation in the cp_tid.
+			 * Hence we check this case and re-allocate memory if required.
+			 */
+			cp.t_id[ct++] = tmp_tid;
+		}
+	}
+
+	/* Reassigning based on successful seizes */
+	cp.thread_count = ct;
+
+	closedir(dir);
+
+	/* Successful seize and interrupt on all threads makes ret = 0 */
+	return ret;
+}
+
+/* Wait for threads to stop */
+int wait_for_threads_to_stop(void)
+{
+	int i;
+	char state;
+
+	/*
+	 * We check for the process to stop infinitely now. We need
+	 * to break out after some definite time. Need to work on
+	 * that.
+	 */
+	for (i = 0; i < cp.thread_count; i++) {
+		do {
+			state = get_thread_status(cp.t_id[i]);
+			if (state != 't')
+				sched_yield();
+		} while (state != 't' && state!='Z' && state != -1);
+		if (state == -1)
+			return -1;
+	}
+
+	return 0;
+}
+
+/* Release the threads that are held */
+int release_threads(void)
+{
+	int i, ret = 0;
+	char state;
+
+	/* Detach the process to be dumped */
+	for (i = 0; i < cp.thread_count; i++) {
+		state = get_thread_status(cp.t_id[i]);
+		if (state == 't') {
+			ret += ptrace(PTRACE_DETACH, cp.t_id[i], 0, 0);
+			if (ret)
+				gencore_log("Could not detach from thread: %d\n",
+								cp.t_id[i]);
+		}
+	}
+
+	/* Successful detach on all threads makes ret = 0 */
+	return ret;
+}
+
 /* Performs the core dump */
 int do_coredump(int pid, char *core_file)
 {
-	return 0;
+	int ret;
+
+	/* Initialise members of core process */
+	init_core();
+
+	/* Getting thread information and seizing them */
+	ret = seize_threads(pid);
+	if (ret)
+		goto cleanup;
+
+	/* Wait for threads to stop */
+	ret = wait_for_threads_to_stop();
+	if (ret)
+		goto cleanup;
+
+cleanup:
+
+	/* Release the threads */
+	release_threads();
+
+	if (cp.t_id)
+		free(cp.t_id);
+
+	errno = status;
+
+	return ret;
 }
 
 /* Daemon for self dump */
diff --git a/src/coredump.h b/src/coredump.h
index cc77197..00cb008 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -1,6 +1,10 @@
 #define COMM_LEN 17            /* Maximum length of command line */
 #define NUM_STAT_FEILDS 30     /* Number of fields read from /proc/pid/stat */
 
+#define THREAD_COUNT_IDX 16	/* Index for number of threads */
+
+#define __ps_thread_count ps_num[THREAD_COUNT_IDX]	/* Process Information */
+
 /* Status of the dump */
 extern int status;
 
@@ -11,3 +15,9 @@ struct pid_stat {
 	char ps_state;
 	unsigned long long ps_num[NUM_STAT_FEILDS];
 };
+
+/* Structure for the Core of the Process */
+struct core_proc {
+	int thread_count;		/* Number of threads */
+	int *t_id;			/* Threads_ids of all the threads */
+};
diff --git a/src/proc.c b/src/proc.c
index 6c9e804..fc16d90 100644
--- a/src/proc.c
+++ b/src/proc.c
@@ -24,6 +24,7 @@
 
 #include <stdio.h>
 #include <errno.h>
+#include <stdlib.h>
 #include <coredump.h>
 
 /* Get Process Stats */
@@ -84,3 +85,54 @@ err:
 	fclose(fin);
 	return ret;
 }
+
+/* Counts the number of threads in the process */
+int get_thread_count(int pid)
+{
+	struct pid_stat p;
+	int ret;
+
+	ret = get_pid_stat(pid, &p);
+	if (ret)
+		return -1;
+
+	return p.__ps_thread_count;
+}
+
+/* Fetched thread status */
+char get_thread_status(int tid)
+{
+	int ret;
+	char filename[40], buff[40];
+	FILE *fin;
+	char *pos;
+
+	snprintf(filename, 40, "/proc/%d/stat", tid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failure while fetching thread state from %s.\n",
+								filename);
+		return -1;
+	}
+
+	ret = fread(buff, 40, 1, fin);
+	if (ret == 0) {
+		status = errno;
+		gencore_log("Failure while fetching thread state from %s.\n",
+								filename);
+		return -1;
+	}
+
+	pos = strrchr(buff, ')');
+	if (pos == NULL) {
+		status = errno;
+		gencore_log("Failure while fetching thread state from %s.\n",
+								filename);
+		return -1;
+	}
+
+	fclose(fin);
+
+	return buff[pos - buff + 2];
+}


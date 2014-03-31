Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaCaXlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:41:12 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47790 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaCaXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:41:10 -0400
From: Ulrich Drepper <drepper@gmail.com>
To: anatol.pomozov@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org,
        xemul@parallels.com, rientjes@google.com, paul.gortmaker@windriver.com,
        n-horiguchi@ah.jp.nec.com, linux-kernel@vger.kernel.org
Subject: NUMA node information for pages
Date: Mon, 31 Mar 2014 19:41:03 -0400
Message-ID: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I might be missing something but I couldn't find a way to use the
pagemap information to then look up the NUMA node the respective page is
located on.  Especially when analyzing anomalities this is really
useful.  The /proc/kpageflags and /proc/kpagecount files don't have that
information.

If this is correct, could the attached patch be considered?  It's really
simple and follows the same line as the kpageflags file.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 Documentation/vm/pagemap.txt |    3 ++
 fs/proc/page.c               |   50
 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
index 5948e45..413b34c 100644
--- a/Documentation/vm/pagemap.txt
+++ b/Documentation/vm/pagemap.txt
@@ -34,6 +34,9 @@ There are three components to pagemap:
  * /proc/kpagecount.  This file contains a 64-bit count of the number of
    times each page is mapped, indexed by PFN.
 
+ * /proc/kpagenode.  This file contains a 32-bit number of the NUMA node
+   each page is mapped on.
+
  * /proc/kpageflags.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
diff --git a/fs/proc/page.c b/fs/proc/page.c
index e647c55..65bea9f 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -15,6 +15,9 @@
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
 
+#define KNIDSIZE sizeof(s32)
+#define KNIDMASK (KNIDSIZE - 1)
+
 /* /proc/kpagecount - an array exposing page counts
  *
  * Each entry is a u64 representing the corresponding
@@ -212,10 +215,57 @@ static const struct file_operations proc_kpageflags_operations = {
 	.read = kpageflags_read,
 };
 
+/* /proc/kpagenode - an array exposing node information for pages
+ *
+ * Each entry is a s32 representing the corresponding
+ * physical page flags.
+ */
+
+static ssize_t kpagenode_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	unsigned long src = *ppos;
+	unsigned long pfn = src / KNIDSIZE;
+	ssize_t ret = 0;
+
+	count = min_t(unsigned long, count, (max_pfn * KNIDSIZE) - src);
+	if (src & KNIDSIZE || count & KNIDMASK)
+		return -EINVAL;
+
+	while (count > 0) {
+		int nid;
+		if (pfn_valid(pfn))
+			nid = pfn_to_nid(pfn);
+		else
+			nid = -1;
+
+		if (put_user(nid, out)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		pfn++;
+		out++;
+		count -= KNIDSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static const struct file_operations proc_kpagenode_operations = {
+	.llseek = mem_lseek,
+	.read = kpagenode_read,
+};
+
 static int __init proc_page_init(void)
 {
 	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
+	proc_create("kpagenode", S_IRUSR, NULL, &proc_kpagenode_operations);
 	return 0;
 }
 fs_initcall(proc_page_init);

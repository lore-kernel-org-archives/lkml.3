Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaIXTZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:25:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47047 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbaIXTZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:25:09 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 2/4] Simplify catalog_read()
Date: Wed, 24 Sep 2014 12:24:39 -0700
Message-Id: <1411586681-21262-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411586681-21262-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586681-21262-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-5806-0000-0000-000000951B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

catalog_read() implements the read interface for the sysfs file

	/sys/bus/event_source/devices/hv_24x7/interface/catalog

It essentially takes a buffer, an offset and count as parameters
to the read() call.  It makes a hypervisor call to read a specific
page from the catalog and copy the required bytes into the given
buffer. Each call to catalog_read() returns at most one 4K page.

Given these requirements, we should be able to simplify the
catalog_read().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7.c | 92 +++++----------------------------------------
 1 file changed, 10 insertions(+), 82 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 2f2215c..9427ef7 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -75,86 +75,6 @@ static struct attribute_group format_group = {
 
 static struct kmem_cache *hv_page_cache;
 
-/*
- * read_offset_data - copy data from one buffer to another while treating the
- *                    source buffer as a small view on the total avaliable
- *                    source data.
- *
- * @dest: buffer to copy into
- * @dest_len: length of @dest in bytes
- * @requested_offset: the offset within the source data we want. Must be > 0
- * @src: buffer to copy data from
- * @src_len: length of @src in bytes
- * @source_offset: the offset in the sorce data that (src,src_len) refers to.
- *                 Must be > 0
- *
- * returns the number of bytes copied.
- *
- * The following ascii art shows the various buffer possitioning we need to
- * handle, assigns some arbitrary varibles to points on the buffer, and then
- * shows how we fiddle with those values to get things we care about (copy
- * start in src and copy len)
- *
- * s = @src buffer
- * d = @dest buffer
- * '.' areas in d are written to.
- *
- *                       u
- *   x         w	 v  z
- * d           |.........|
- * s |----------------------|
- *
- *                      u
- *   x         w	z     v
- * d           |........------|
- * s |------------------|
- *
- *   x         w        u,z,v
- * d           |........|
- * s |------------------|
- *
- *   x,w                u,v,z
- * d |..................|
- * s |------------------|
- *
- *   x        u
- *   w        v		z
- * d |........|
- * s |------------------|
- *
- *   x      z   w      v
- * d            |------|
- * s |------|
- *
- * x = source_offset
- * w = requested_offset
- * z = source_offset + src_len
- * v = requested_offset + dest_len
- *
- * w_offset_in_s = w - x = requested_offset - source_offset
- * z_offset_in_s = z - x = src_len
- * v_offset_in_s = v - x = request_offset + dest_len - src_len
- */
-static ssize_t read_offset_data(void *dest, size_t dest_len,
-				loff_t requested_offset, void *src,
-				size_t src_len, loff_t source_offset)
-{
-	size_t w_offset_in_s = requested_offset - source_offset;
-	size_t z_offset_in_s = src_len;
-	size_t v_offset_in_s = requested_offset + dest_len - src_len;
-	size_t u_offset_in_s = min(z_offset_in_s, v_offset_in_s);
-	size_t copy_len = u_offset_in_s - w_offset_in_s;
-
-	if (requested_offset < 0 || source_offset < 0)
-		return -EINVAL;
-
-	if (z_offset_in_s <= w_offset_in_s)
-		return 0;
-
-	memcpy(dest, src + w_offset_in_s, copy_len);
-	return copy_len;
-}
-
 static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
 					      unsigned long version,
 					      unsigned long index)
@@ -185,6 +105,8 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 	ssize_t ret = 0;
 	size_t catalog_len = 0, catalog_page_len = 0, page_count = 0;
 	loff_t page_offset = 0;
+	loff_t offset_in_page;
+	size_t copy_len;
 	uint64_t catalog_version_num = 0;
 	void *page = kmem_cache_alloc(hv_page_cache, GFP_USER);
 	struct hv_24x7_catalog_page_0 *page_0 = page;
@@ -203,6 +125,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 
 	page_offset = offset / 4096;
 	page_count  = count  / 4096;
+	offset_in_page = count % 4096;
 
 	if (page_offset >= catalog_page_len)
 		goto e_free;
@@ -216,8 +139,13 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 		}
 	}
 
-	ret = read_offset_data(buf, count, offset,
-				page, 4096, page_offset * 4096);
+	copy_len = 4096 - offset_in_page;
+	if (copy_len > count)
+		copy_len = count;
+
+	memcpy(buf, page+offset_in_page, copy_len);
+	ret = copy_len;
+
 e_free:
 	if (hret)
 		pr_err("h_get_24x7_catalog_page(ver=%lld, page=%lld) failed:"
-- 
1.8.3.1


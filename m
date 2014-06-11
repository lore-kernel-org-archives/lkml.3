Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaFKONY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:13:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbaFKONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:13:23 -0400
Date: Wed, 11 Jun 2014 16:13:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140611141320.GA30685@nazgul.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140605111535.GB16642@pd.tnic>
 <20140605201732.GF14083@redhat.com>
 <20140606021133.GB27257@pd.tnic>
 <20140606180214.GH1526@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140606180214.GH1526@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:02:14PM -0400, Vivek Goyal wrote:
> > If you want to make it more explicit, you could do
> > 
> > #define RES_OK		0
> > #define RES_ERR		1
> > #define RES_STOP	2
> 
> You are saying that called back function should return this to walk_*
> functions? But then we lose the actual error code which should be
> passed to parent function which actually called walk_* function.

Well, RES_STOP could implicitly mean stop and no error. Also, if
you really want to return back the retval, you could slice it into
bitfields:

retval = [ ... 8 | 7 ... 0]

where [7:0] is the return value and bits from 8 onwards contain
different flags like RES_STOP. I did it just for the fun of it and it
looks like below. I honestly can't say that I'm crazy about it though.

--
Index: b/kernel/resource.c
===================================================================
--- a/kernel/resource.c	2014-06-11 14:49:35.865426300 +0200
+++ b/kernel/resource.c	2014-06-11 15:37:50.050299684 +0200
@@ -371,7 +371,7 @@ static int find_next_iomem_res(struct re
 }
 
 int walk_ram_res(char *name, unsigned long flags, u64 start, u64 end,
-		void *arg, int (*func)(u64, u64, void *))
+		 void *arg, int (*func)(u64, u64, void *))
 {
 	struct resource res;
 	u64 orig_end;
@@ -384,12 +384,12 @@ int walk_ram_res(char *name, unsigned lo
 	while ((res.start < res.end) &&
 		(find_next_iomem_res(&res, name) >= 0)) {
 		ret = (*func)(res.start, res.end, arg);
-		if (ret)
+		if (ret & RES_STOP)
 			break;
 		res.start = res.end + 1;
 		res.end = orig_end;
 	}
-	return ret;
+	return RETVAL(ret);
 }
 
 /*
@@ -441,7 +441,7 @@ static int find_next_system_ram(struct r
  * with pfn can truncate ranges.
  */
 int walk_system_ram_res(u64 start, u64 end, void *arg,
-				int (*func)(u64, u64, void *))
+			int (*func)(u64, u64, void *))
 {
 	struct resource res;
 	u64 orig_end;
@@ -454,12 +454,13 @@ int walk_system_ram_res(u64 start, u64 e
 	while ((res.start < res.end) &&
 		(find_next_system_ram(&res, "System RAM") >= 0)) {
 		ret = (*func)(res.start, res.end, arg);
-		if (ret)
+		if (ret & RES_STOP)
 			break;
 		res.start = res.end + 1;
 		res.end = orig_end;
 	}
-	return ret;
+
+	return RETVAL(ret);
 }
 
 #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
Index: b/kernel/kexec.c
===================================================================
--- a/kernel/kexec.c	2014-06-11 14:49:35.865426300 +0200
+++ b/kernel/kexec.c	2014-06-11 16:03:26.264232477 +0200
@@ -2063,8 +2063,9 @@ static int __kexec_add_segment(struct ki
 }
 
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
-					struct kexec_buf *kbuf)
+				    struct kexec_buf *kbuf)
 {
+	int ret = 0;
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
 
@@ -2076,7 +2077,7 @@ static int locate_mem_hole_top_down(unsi
 		temp_start = temp_start & (~(kbuf->buf_align - 1));
 
 		if (temp_start < start || temp_start < kbuf->buf_min)
-			return 0;
+			return EADDRNOTAVAIL;
 
 		temp_end = temp_start + kbuf->memsz - 1;
 
@@ -2098,12 +2099,15 @@ static int locate_mem_hole_top_down(unsi
 				kbuf->memsz);
 
 	/* Stop navigating through remaining System RAM ranges */
-	return 1;
+	ret |= RES_STOP;
+
+	return ret;
 }
 
 static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
-					struct kexec_buf *kbuf)
+				     struct kexec_buf *kbuf)
 {
+	int ret = 0;
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
 
@@ -2114,7 +2118,7 @@ static int locate_mem_hole_bottom_up(uns
 		temp_end = temp_start + kbuf->memsz - 1;
 
 		if (temp_end > end || temp_end > kbuf->buf_max)
-			return 0;
+			return EADDRNOTAVAIL;
 		/*
 		 * Make sure this does not conflict with any of existing
 		 * segments
@@ -2133,7 +2137,9 @@ static int locate_mem_hole_bottom_up(uns
 				kbuf->memsz);
 
 	/* Stop navigating through remaining System RAM ranges */
-	return 1;
+	ret |= RES_STOP;
+
+	return ret;
 }
 
 static int walk_ram_range_callback(u64 start, u64 end, void *arg)
@@ -2141,12 +2147,11 @@ static int walk_ram_range_callback(u64 s
 	struct kexec_buf *kbuf = (struct kexec_buf *)arg;
 	unsigned long sz = end - start + 1;
 
-	/* Returning 0 will take to next memory range */
 	if (sz < kbuf->memsz)
-		return 0;
+		return EADDRNOTAVAIL;
 
 	if (end < kbuf->buf_min || start > kbuf->buf_max)
-		return 0;
+		return EADDRNOTAVAIL;
 
 	/*
 	 * Allocate memory top down with-in ram range. Otherwise bottom up
@@ -2168,15 +2173,15 @@ int kexec_add_buffer(struct kimage *imag
 		unsigned long buf_max, bool top_down, unsigned long *load_addr)
 {
 
-	unsigned long nr_segments = image->nr_segments, new_nr_segments;
 	struct kexec_segment *ksegment;
 	struct kexec_buf buf, *kbuf;
+	int ret;
 
 	/* Currently adding segment this way is allowed only in file mode */
 	if (!image->file_mode)
 		return -EINVAL;
 
-	if (nr_segments >= KEXEC_SEGMENT_MAX)
+	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -2208,25 +2213,18 @@ int kexec_add_buffer(struct kimage *imag
 
 	/* Walk the RAM ranges and allocate a suitable range for the buffer */
 	if (image->type == KEXEC_TYPE_CRASH)
-		walk_ram_res("Crash kernel", IORESOURCE_MEM | IORESOURCE_BUSY,
-				crashk_res.start, crashk_res.end, kbuf,
-				walk_ram_range_callback);
+		ret = walk_ram_res("Crash kernel",
+				   IORESOURCE_MEM | IORESOURCE_BUSY,
+				   crashk_res.start, crashk_res.end, kbuf,
+				   walk_ram_range_callback);
 	else
-		walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
-
-	/*
-	 * If range could be found successfully, it would have incremented
-	 * the nr_segments value.
-	 */
-	new_nr_segments = image->nr_segments;
+		ret = walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
 
-	/* A suitable memory range could not be found for buffer */
-	if (new_nr_segments == nr_segments)
+	if (ret)
 		return -EADDRNOTAVAIL;
 
 	/* Found a suitable memory range */
-
-	ksegment = &image->segment[new_nr_segments - 1];
+	ksegment = &image->segment[image->nr_segments - 1];
 	*load_addr = ksegment->mem;
 	return 0;
 }
Index: b/include/linux/ioport.h
===================================================================
--- a/include/linux/ioport.h	2014-06-11 14:49:35.865426300 +0200
+++ b/include/linux/ioport.h	2014-06-11 16:02:12.775235692 +0200
@@ -237,6 +237,16 @@ extern int iomem_is_exclusive(u64 addr);
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
+
+#define RET_BITS	8
+#define RET_MASK	((1U << RET_BITS) - 1)
+#define RETVAL(r)	(-((r) & RET_MASK))
+
+#define RET_OK		0
+#define RET_ERR		1
+
+#define RES_STOP	BIT(0 + RET_BITS)
+
 extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 				int (*func)(u64, u64, void *));


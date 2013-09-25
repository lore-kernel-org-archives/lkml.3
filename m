Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3IYVYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:24:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56659 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3IYVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:24:31 -0400
From: charlebm@gmail.com
To: balbi@ti.com
Cc: Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] Remove VLAIS usage from gadget code - alternate patch
Date: Wed, 25 Sep 2013 14:23:37 -0700
Message-Id: <1380144217-17015-1-git-send-email-charlebm@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). This alternate patch calculates offsets into the kmalloc-ed
memory buffer using macros. The previous patch required multiple kmalloc and
kfree calls. This version uses "group" vs "struct" since it really is not a
struct and is essentially a group of VLA in a common allocated block. This
version also fixes the issues pointed out by Andrzej Pietrasiewicz.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---

--- linux.orig/drivers/usb/gadget/f_fs.c
+++ linux/drivers/usb/gadget/f_fs.c
@@ -30,6 +30,21 @@
 
 #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
 
+/* Variable Length Array Macros **********************************************/
+#define vla_group(groupname) size_t groupname##__##next = 0
+#define vla_group_size(groupname) groupname##__##next
+
+#define vla_item(groupname, type, name, n) \
+	size_t groupname##_##name##__##offset = \
+		(groupname##__##next + __alignof__(type) - 1) & \
+		~(__alignof__(type) - 1); \
+	size_t groupname##_##name##__##sz = (n) * sizeof(type); \
+	type * groupname##_##name = ({ \
+	groupname##__##next = groupname##_##name##__##offset + \
+		groupname##_##name##__##sz; NULL;})
+
+#define vla_ptr(ptr,groupname,name) groupname##_##name = \
+	(__typeof__(groupname##_##name))&ptr[groupname##_##name##__##offset]
 
 /* Debugging ****************************************************************/
 
@@ -1909,30 +1924,38 @@
 
 	/* Allocate everything in one chunk so there's less maintenance. */
 	{
-		struct {
-			struct usb_gadget_strings *stringtabs[lang_count + 1];
-			struct usb_gadget_strings stringtab[lang_count];
-			struct usb_string strings[lang_count*(needed_count+1)];
-		} *d;
 		unsigned i = 0;
+		vla_group(d);
+		vla_item(d, struct usb_gadget_strings *, stringtabs,
+			lang_count + 1);
+		vla_item(d, struct usb_gadget_strings, stringtab, lang_count);
+		vla_item(d, struct usb_string, strings,
+			lang_count*(needed_count+1));
+
+		char *vlabuf = kmalloc(vla_group_size(d), GFP_KERNEL);
 
-		d = kmalloc(sizeof *d, GFP_KERNEL);
-		if (unlikely(!d)) {
+		if (unlikely(!vlabuf)) {
 			kfree(_data);
 			return -ENOMEM;
 		}
 
-		stringtabs = d->stringtabs;
-		t = d->stringtab;
+		/* Initialize the VLA pointers */
+		vla_ptr(vlabuf, d, stringtabs);
+		vla_ptr(vlabuf, d, stringtab);
+		vla_ptr(vlabuf, d, strings);
+
+		stringtabs = d_stringtabs;
+		t = d_stringtab;
 		i = lang_count;
 		do {
 			*stringtabs++ = t++;
 		} while (--i);
 		*stringtabs = NULL;
 
-		stringtabs = d->stringtabs;
-		t = d->stringtab;
-		s = d->strings;
+		/* stringtabs = vlabuf = d_stringtabs for later kfree */
+		stringtabs = d_stringtabs;
+		t = d_stringtab;
+		s = d_strings;
 		strings = s;
 	}
 
@@ -2208,16 +2231,15 @@
 	int ret;
 
 	/* Make it a single chunk, less management later on */
-	struct {
-		struct ffs_ep eps[ffs->eps_count];
-		struct usb_descriptor_header
-			*fs_descs[full ? ffs->fs_descs_count + 1 : 0];
-		struct usb_descriptor_header
-			*hs_descs[high ? ffs->hs_descs_count + 1 : 0];
-		short inums[ffs->interfaces_count];
-		char raw_descs[high ? ffs->raw_descs_length
-				    : ffs->raw_fs_descs_length];
-	} *data;
+	vla_group(d);
+	vla_item(d, struct ffs_ep, eps, ffs->eps_count);
+	vla_item(d, struct usb_descriptor_header *, fs_descs,
+		full ? ffs->fs_descs_count + 1 : 0);
+	vla_item(d, struct usb_descriptor_header *, hs_descs,
+		high ? ffs->hs_descs_count + 1 : 0);
+	vla_item(d, short, inums, ffs->interfaces_count);
+	vla_item(d, char, raw_descs,
+		high ? ffs->raw_descs_length : ffs->raw_fs_descs_length);
 
 	ENTER();
 
@@ -2225,21 +2247,30 @@
 	if (unlikely(!(full | high)))
 		return -ENOTSUPP;
 
-	/* Allocate */
-	data = kmalloc(sizeof *data, GFP_KERNEL);
-	if (unlikely(!data))
+	/* Allocate a single chunk, less management later on */
+	char *vlabuf = kmalloc(vla_group_size(d), GFP_KERNEL);
+	if (unlikely(!vlabuf))
 		return -ENOMEM;
 
+	/* Initialize each struct member pointer in the allocated memory */
+	vla_ptr(vlabuf, d, eps);
+	vla_ptr(vlabuf, d, fs_descs);
+	vla_ptr(vlabuf, d, hs_descs);
+	vla_ptr(vlabuf, d, inums);
+	vla_ptr(vlabuf, d, raw_descs);
+
 	/* Zero */
-	memset(data->eps, 0, sizeof data->eps);
-	memcpy(data->raw_descs, ffs->raw_descs + 16, sizeof data->raw_descs);
-	memset(data->inums, 0xff, sizeof data->inums);
+	memset(d_eps, 0, d_eps__sz);
+	memcpy(d_raw_descs, ffs->raw_descs + 16, d_raw_descs__sz);
+	memset(d_inums, 0xff, d_inums__sz);
 	for (ret = ffs->eps_count; ret; --ret)
-		data->eps[ret].num = -1;
+		d_eps[ret].num = -1;
 
-	/* Save pointers */
-	func->eps             = data->eps;
-	func->interfaces_nums = data->inums;
+	/* Save pointers
+	 * d_eps == vlabuf, func->eps used to kfree vlabuf later
+	*/
+	func->eps             = d_eps;
+	func->interfaces_nums = d_inums;
 
 	/*
 	 * Go through all the endpoint descriptors and allocate
@@ -2247,10 +2278,10 @@
 	 * numbers without worrying that it may be described later on.
 	 */
 	if (likely(full)) {
-		func->function.fs_descriptors = data->fs_descs;
+		func->function.fs_descriptors = d_fs_descs;
 		ret = ffs_do_descs(ffs->fs_descs_count,
-				   data->raw_descs,
-				   sizeof data->raw_descs,
+				   d_raw_descs,
+				   d_raw_descs__sz,
 				   __ffs_func_bind_do_descs, func);
 		if (unlikely(ret < 0))
 			goto error;
@@ -2259,10 +2290,10 @@
 	}
 
 	if (likely(high)) {
-		func->function.hs_descriptors = data->hs_descs;
+		func->function.hs_descriptors = d_hs_descs;
 		ret = ffs_do_descs(ffs->hs_descs_count,
-				   data->raw_descs + ret,
-				   (sizeof data->raw_descs) - ret,
+				   d_raw_descs + ret,
+				   d_raw_descs__sz - ret,
 				   __ffs_func_bind_do_descs, func);
 	}
 
@@ -2273,7 +2304,7 @@
 	 */
 	ret = ffs_do_descs(ffs->fs_descs_count +
 			   (high ? ffs->hs_descs_count : 0),
-			   data->raw_descs, sizeof data->raw_descs,
+			   d_raw_descs, d_raw_descs__sz,
 			   __ffs_func_bind_do_nums, func);
 	if (unlikely(ret < 0))
 		goto error;

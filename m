Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbbA0WnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:43:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbA0WnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:43:21 -0500
Date: Tue, 27 Jan 2015 14:43:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergei Rogachev <rogachevsergei@gmail.com>
Cc: iamjoonsoo.kim@lge.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm/page_ext: remove unnecessary stack_trace field
Message-Id: <20150127144319.f3a161e5f5d562a0a605371e@linux-foundation.org>
In-Reply-To: <1422309132-28030-2-git-send-email-rogachevsergei@gmail.com>
References: <1422309132-28030-1-git-send-email-rogachevsergei@gmail.com>
	<1422309132-28030-2-git-send-email-rogachevsergei@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 00:52:12 +0300 Sergei Rogachev <rogachevsergei@gmail.com> wrote:

> Page owner uses the page_ext structure to keep meta-information
> for every page in the system. The structure also contains a field
> of type 'struct stack_trace', page owner uses this field during
> invocation of the function save_stack_trace. It is easy to notice
> that keeping a copy of this structure for every page in the system
> is very inefficiently in terms of memory.
> 
> The patch removes this unnecessary field of page_ext and forces
> page owner to use a stack_trace structure allocated on the stack.
> 

Fair enough.

What do you think of the below tweaks?  Seems a bit neater, and it will
cause all unmentioned fields to be zeroed out.  It's not a bug to leave
.max_entries uninitialised in print_page_owner(), but it's nice not to
leave loose ends.

--- a/mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field-fix
+++ a/mm/page_owner.c
@@ -59,15 +59,14 @@ void __reset_page_owner(struct page *pag
 
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
-	struct page_ext *page_ext;
-	struct stack_trace trace;
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = 0,
+		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
+		.entries = &page_ext->trace_entries[0],
+		.skip = 3,
+	};
 
-	page_ext = lookup_page_ext(page);
-
-	trace.nr_entries = 0;
-	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace.entries = &page_ext->trace_entries[0];
-	trace.skip = 3;
 	save_stack_trace(&trace);
 
 	page_ext->order = order;
@@ -83,8 +82,11 @@ print_page_owner(char __user *buf, size_
 {
 	int ret;
 	int pageblock_mt, page_mt;
-	struct stack_trace trace;
 	char *kbuf;
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
 
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -122,9 +124,6 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	trace.nr_entries = page_ext->nr_entries;
-	trace.entries = &page_ext->trace_entries[0];
-
 	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
_


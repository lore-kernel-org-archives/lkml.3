Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3JQQrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:47:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab3JQQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:47:18 -0400
Date: Thu, 17 Oct 2013 18:47:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017164707.GV10651@twins.programming.kicks-ass.net>
References: <20131012192203.GA21738@redhat.com>
 <20131014102426.GX3081@twins.programming.kicks-ass.net>
 <20131016200924.GA23214@redhat.com>
 <20131016202822.GI2675@laptop.programming.kicks-ass.net>
 <20131016204348.GA25121@redhat.com>
 <20131016205807.GG10651@twins.programming.kicks-ass.net>
 <20131016205800.GB26066@redhat.com>
 <20131016211613.GJ10651@twins.programming.kicks-ass.net>
 <20131017152027.GA14098@redhat.com>
 <20131017152717.GA15308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017152717.GA15308@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:27:17PM +0200, Oleg Nesterov wrote:
> On 10/17, Oleg Nesterov wrote:
> >
> > 	- we do not really need "len", we can simply do
> >
> > 		size = strlen(name) + 1;
> > 		while (size % sizeof(u64))
> > 			name[size++] = '\0';
> >
> > 	  although I won't argue if you dislike "size & 7" in while().
> 
> Or, perhaps,
> 
> 	while (!IS_ALIGNED(size, sizeof(u64)))
> 		name[size++] = '\0';
> 

---
Subject: perf: Change zero-padding of strings in perf_event_mmap_event()
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu Oct 17 00:06:46 CEST 2013

Oleg complained about the excessive 0-ing in perf_event_mmap_event(),
so try and be smarter about it while keeping it fairly fool proof and
avoid leaking random bits out to userspace.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8jirlm99m6if2z13wd6rbyu6@git.kernel.org
---
 kernel/events/core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5106,15 +5106,13 @@ static void perf_event_mmap_event(struct
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
-	const char *name;
-
-	memset(tmp, 0, sizeof(tmp));
+	char *name;
 
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
 
-		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
@@ -5137,7 +5135,7 @@ static void perf_event_mmap_event(struct
 		min = MINOR(dev);
 
 	} else {
-		name = arch_vma_name(vma);
+		name = (char *)arch_vma_name(vma);
 		if (name) {
 			name = strncpy(tmp, name, sizeof(tmp) - 1);
 			tmp[sizeof(tmp) - 1] = '\0';
@@ -5160,7 +5158,14 @@ static void perf_event_mmap_event(struct
 	}
 
 got_name:
-	size = ALIGN(strlen(name)+1, sizeof(u64));
+	/*
+	 * Since our buffer works in 8 byte units we need to align our string
+	 * size to a multiple of 8. However, we must guarantee the tail end is
+	 * zero'd out to avoid leaking random bits to userspace.
+	 */
+	size = strlen(name)+1;
+	while (!IS_ALIGNED(size, sizeof(u64)))
+		name[size++] = '\0';
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;

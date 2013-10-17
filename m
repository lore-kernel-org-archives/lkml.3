Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269Ab3JQSb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:31:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758269Ab3JQSb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:31:28 -0400
Date: Thu, 17 Oct 2013 20:24:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017182417.GA17753@redhat.com>
References: <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com> <20131016202822.GI2675@laptop.programming.kicks-ass.net> <20131016204348.GA25121@redhat.com> <20131016205807.GG10651@twins.programming.kicks-ass.net> <20131016205800.GB26066@redhat.com> <20131016211613.GJ10651@twins.programming.kicks-ass.net> <20131017152027.GA14098@redhat.com> <20131017152717.GA15308@redhat.com> <20131017164707.GV10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017164707.GV10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Peter Zijlstra wrote:
>
> -		name = arch_vma_name(vma);
> +		name = (char *)arch_vma_name(vma);

Yes, this way we do not need another non-const ptr.

OK, please consider another cleanup on top of this change.

Just to "complete" the discussion, do not even bother to reply
if you think it doesn't make sense ;)

---
Subject: [PATCH] perf: Factor out strncpy() in perf_event_mmap_event()
From: Oleg Nesterov <oleg@redhat.com>
Date: Thu, 17 Oct 2013 20:04:17 +0200

While this is really minor, but strncpy() does the unnecessary
zero-padding till the end of tmp[16] and it is called every time
we are going to use the string literal.

Turn these strncpy()'s into the single strlcpy() under the new
label, saves 72 bytes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/core.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e7ace78..93ddf3d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5108,8 +5108,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
-			name = strncpy(tmp, "//enomem", sizeof(tmp));
-			goto got_name;
+			name = "//enomem";
+			goto cpy_name;
 		}
 		/*
 		 * d_path works from the end of the rb backwards, so we
@@ -5118,8 +5118,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		 */
 		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
-			name = strncpy(tmp, "//toolong", sizeof(tmp));
-			goto got_name;
+			name = "//toolong";
+			goto cpy_name;
 		}
 		inode = file_inode(vma->vm_file);
 		dev = inode->i_sb->s_dev;
@@ -5127,30 +5127,30 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		gen = inode->i_generation;
 		maj = MAJOR(dev);
 		min = MINOR(dev);
-
+		goto got_name;
 	} else {
 		name = (char *)arch_vma_name(vma);
-		if (name) {
-			name = strncpy(tmp, name, sizeof(tmp) - 1);
-			tmp[sizeof(tmp) - 1] = '\0';
-			goto got_name;
-		}
+		if (name)
+			goto cpy_name;
 
 		if (vma->vm_start <= vma->vm_mm->start_brk &&
 				vma->vm_end >= vma->vm_mm->brk) {
-			name = strncpy(tmp, "[heap]", sizeof(tmp));
-			goto got_name;
+			name = "[heap]";
+			goto cpy_name;
 		}
 		if (vma->vm_start <= vma->vm_mm->start_stack &&
 				vma->vm_end >= vma->vm_mm->start_stack) {
-			name = strncpy(tmp, "[stack]", sizeof(tmp));
-			goto got_name;
+			name = "[stack]";
+			goto cpy_name;
 		}
 
-		name = strncpy(tmp, "//anon", sizeof(tmp));
-		goto got_name;
+		name = "//anon";
+		goto cpy_name;
 	}
 
+cpy_name:
+	strlcpy(tmp, name, sizeof(tmp));
+	name = tmp;
 got_name:
 	/*
 	 * Since our buffer works in 8 byte units we need to align our string
-- 
1.5.5.1



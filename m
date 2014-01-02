Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaABWZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:25:06 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281AbaABWYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:24:45 -0500
From: Richard Weinberger <richard@nod.at>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-next@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Possible regression from "fs/exec.c: call arch_pick_mmap_layout() only once"
Date: Thu, 02 Jan 2014 23:24:39 +0100
Message-ID: <2300703.z3jyM3yTZv@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52C5DD07.40208@erley.org>
References: <52C5DD07.40208@erley.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 2. Januar 2014, 15:41:27 schrieb Pat Erley:
> On my 64bit kernel, commit 283fe963095b38a6ab75dda1436ee66b9e45c7c2
> seems to have broken 32bit compatibility.  I've run the bisection twice,
> and verified that reverting this on HEAD fixes the problem.  I've
> uploaded my .config to pastebin at http://pastebin.com/kVcr9H65
> 
> Even this simple program:
> 
> main(){puts("HELLO");}
> 
> compiled with:
> 
> gcc -m32 test.c
> 
> Will crash with a segfault.  Stracing shows that it's failing to
> allocate memory.

Good catch!

flush_old_exec() is called before setup_new_exec() and I've removed
arch_pick_mmap_layout() from the second call site.
Which turned out to be wrong.

It is wrong because between both callers current->personality is changed.
So, we have to remove the first call to arch_pick_mmap_layout() and keep the 
latter because only then the correct personality is set up.

Can you please test your config with the following patch applied and having
283fe96 reverted?

If it works out for you I'd send an updated patch to Andrew.
In the meanwhile I'll double check all call sites...

Thanks,
//richard

---
diff --git a/fs/exec.c b/fs/exec.c
index 7ea097f..a733599 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -843,7 +843,6 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);


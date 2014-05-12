Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaELO7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:59:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65051 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbaELO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140512124344.GA26865@node.dhcp.inet.fi>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
	<20140508160205.A0EC7E009B@blue.fi.intel.com>
	<CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
	<20140509140536.F06BFE009B@blue.fi.intel.com>
	<CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
	<20140512124344.GA26865@node.dhcp.inet.fi>
Date: Mon, 12 May 2014 18:59:15 +0400
Message-ID: <CALYGNiMY=f0M2gAJWgUSxa5z61PS3H8nXvJsiXp3XPbsJE+jyQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Armin Rigo <arigo@tunes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 4:43 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Fri, May 09, 2014 at 08:14:08AM -0700, Linus Torvalds wrote:
>> On Fri, May 9, 2014 at 7:05 AM, Kirill A. Shutemov
>> <kirill.shutemov@linux.intel.com> wrote:
>> >
>> > Hm. I'm confused here. Do we have any limit forced per-user?
>>
>> Sure we do. See "struct user_struct". We limit max number of
>> processes, open files, signals etc.
>>
>> > I only see things like rlimits which are copied from parrent.
>> > Is it what you want?
>>
>> No, rlimits are per process (although in some cases what they limit
>> are counted per user despite the _limits_ of those resources then
>> being settable per thread).
>>
>> So I was just thinking that if we raise the per-mm default limits,
>> maybe we should add a global per-user limit to make it harder for a
>> user to use tons and toms of vma's.
>
> Here's the first attempt.
>
> I'm not completely happy about current_user(). It means we rely on that
> user of mm owner task is always equal to user of current. Not sure if it's
> always the case.
>
> Other option is to make MM_OWNER is always on and lookup proper user
> through task_cred_xxx(rcu_dereference(mm->owner), user).
>
> From 5ee6f6dd721ada8eb66c84a91003ac1e3eb2970a Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 12 May 2014 15:13:12 +0300
> Subject: [PATCH] mm: add per-user limit on mapping count
>
> We're going to increase per-mm map_count. To avoid non-obvious memory
> abuse by creating a lot of VMA's, let's introduce per-user limit.
>
> The limit is implemented as sysctl. For now value of limit is pretty
> arbitrary -- 2^20.
>
> sizeof(vm_area_struct) with my kernel config (DEBUG_KERNEL=n) is 184
> bytes. It means with the limit user can use up to 184 MiB of RAM in
> VMAs.
>
> The limit is not applicable for root (INIT_USER).

I don't like this.

Maybe we could just account VMAs into OOM-badness points and let
OOM-killer do its job?

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -170,7 +170,9 @@ unsigned long oom_badness(struct task_struct *p,
struct mem_cgroup *memcg,
         * task's rss, pagetable and swap space use.
         */
        points = get_mm_rss(p->mm) + atomic_long_read(&p->mm->nr_ptes) +
-                get_mm_counter(p->mm, MM_SWAPENTS);
+                get_mm_counter(p->mm, MM_SWAPENTS) +
+                (long)p->mm->map_count *
+                       sizeof(struct vm_area_struct) / PAGE_SIZE;
        task_unlock(p);

        /*

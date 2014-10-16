Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaJPFOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:14:00 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46738 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaJPFN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
Date: Thu, 16 Oct 2014 13:13:57 +0800
Message-ID: <CAL1ERfPJbbMUMe=5TvN2fbnJga4oP2oNUZ7zG-NRy0NbUMh=Ag@mail.gmail.com>
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        m.szyprowski@samsung.com, akpm@linux-foundation.org, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, riel@redhat.com, mgorman@suse.de,
        minchan@kernel.org, nasa4836@gmail.com, ddstreet@ieee.org,
        hughd@google.com, mingo@kernel.org, rientjes@google.com,
        peterz@infradead.org, keescook@chromium.org, atomlin@redhat.com,
        raistlin@linux.it, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com,
        k.khlebnikov@samsung.com, msalter@redhat.com, deller@gmx.de,
        tangchen@cn.fujitsu.com, ben@decadent.org.uk, akinobu.mita@gmail.com,
        lauraa@codeaurora.org, vbabka@suse.cz, sasha.levin@oracle.com,
        vdavydov@parallels.com, suleiman@google.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:35 AM, Hui Zhu <zhuhui@xiaomi.com> wrote:
> In fallbacks of page_alloc.c, MIGRATE_CMA is the fallback of
> MIGRATE_MOVABLE.
> MIGRATE_MOVABLE will use MIGRATE_CMA when it doesn't have a page in
> order that Linux kernel want.
>
> If a system that has a lot of user space program is running, for
> instance, an Android board, most of memory is in MIGRATE_MOVABLE and
> allocated.  Before function __rmqueue_fallback get memory from
> MIGRATE_CMA, the oom_killer will kill a task to release memory when
> kernel want get MIGRATE_UNMOVABLE memory because fallbacks of
> MIGRATE_UNMOVABLE are MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE.
> This status is odd.  The MIGRATE_CMA has a lot free memory but Linux
> kernel kill some tasks to release memory.

I'm not very clear to this description, what issue do you try to solve?
Make MIGRATE_CMA be the fallback of desired MIGRATE_UNMOVABLE?

> This patch series adds a new function CMA_AGGRESSIVE to make CMA memory
> be more aggressive about allocation.
> If function CMA_AGGRESSIVE is available, when Linux kernel call function
> __rmqueue try to get pages from MIGRATE_MOVABLE and conditions allow,
> MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.  If MIGRATE_CMA
> doesn't have enough pages for allocation, go back to allocate memory from
> MIGRATE_MOVABLE.

I don't think so. That will cause MIGRATE_CMA depleted prematurely, and when a
user(such as camera) wants CMA memory, he will not get the wanted memory.

> Then the memory of MIGRATE_MOVABLE can be kept for MIGRATE_UNMOVABLE and
> MIGRATE_RECLAIMABLE which doesn't have fallback MIGRATE_CMA.

I don't think this is the root cause of oom.
But I am interested in the CMA shrinker idea, I will follow this mail.

Thanks for your work, add some test data will be better.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

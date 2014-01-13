Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaAMDvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:51:45 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36291 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMDvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140112192744.9bca5c6d.akpm@linux-foundation.org>
References: <000001cf0cfd$6d251640$476f42c0$%yang@samsung.com>
	<20140110171108.32b2be171cd5e54bf22fb2a4@linux-foundation.org>
	<CAL1ERfPnaROPiRAeWHpvwGezHsqN4R8j=QSyS48xs25ax14AhA@mail.gmail.com>
	<20140112192744.9bca5c6d.akpm@linux-foundation.org>
Date: Mon, 13 Jan 2014 11:51:42 +0800
Message-ID: <CAL1ERfOx7NF-GLuCnK4KXYpunKxQnVmSDA6FkPKXH3CxauzQcQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix race on swap_info reuse between swapoff and swapon
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Shaohua Li <shli@fusionio.com>,
        Bob Liu <bob.liu@oracle.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:27 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 13 Jan 2014 11:08:58 +0800 Weijie Yang <weijie.yang.kh@gmail.com> wrote:
>
>> >> --- a/mm/swapfile.c
>> >> +++ b/mm/swapfile.c
>> >> @@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>> >>       p->swap_map = NULL;
>> >>       cluster_info = p->cluster_info;
>> >>       p->cluster_info = NULL;
>> >> -     p->flags = 0;
>> >>       frontswap_map = frontswap_map_get(p);
>> >>       spin_unlock(&p->lock);
>> >>       spin_unlock(&swap_lock);
>> >> @@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>> >>               mutex_unlock(&inode->i_mutex);
>> >>       }
>> >>       filp_close(swap_file, NULL);
>> >> +
>> >> +     /*
>> >> +     * clear SWP_USED flag after all resources freed
>> >> +     * so that swapon can reuse this swap_info in alloc_swap_info() safely
>> >> +     * it is ok to not hold p->lock after we cleared its SWP_WRITEOK
>> >> +     */
>> >> +     spin_lock(&swap_lock);
>> >> +     p->flags = 0;
>> >> +     spin_unlock(&swap_lock);
>> >> +
>> >>       err = 0;
>> >>       atomic_inc(&proc_poll_event);
>> >>       wake_up_interruptible(&proc_poll_wait);
>> >
>> > I didn't look too closely, but this patch might also address the race
>> > which Krzysztof addressed with
>> > http://ozlabs.org/~akpm/mmots/broken-out/swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch.
>> > Can we please check that out?
>> >
>> > I do prefer fixing all these swapon-vs-swapoff races with some large,
>> > simple, wide-scope exclusion scheme.  Perhaps SWP_USED is that scheme.
>> >
>> > An alternative would be to add another mutex and just make sys_swapon()
>> > and sys_swapoff() 100% exclusive.  But that is plastering yet another
>> > lock over this mess to hide the horrors which lurk within :(
>> >
>>
>> Hi, Andrew. Thanks for your suggestion.
>>
>> I checked Krzysztof's patch, it use the global swapon_mutex to protect
>> race condition among
>> swapon, swapoff and swap_start(). It is a kind of correct method, but
>> a heavy method.
>
> But do you agree that your
> http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
> makes Krzysztof's
> http://ozlabs.org/~akpm/mmots/broken-out/swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
> obsolete?

Yes, I agree.

> I've been sitting on Krzysztof's
> swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
> for several months - Hugh had issues with it so I put it on hold and
> nothing further happened.
>
>> I will try to resend a patchset to make lock usage in swapfile.c clear
>> and fine grit
>
> OK, thanks.  In the meanwhile I'm planning on dropping Krzysztof's
> patch and merging your patch into 3.14-rc1, which is why I'd like
> confirmation that your patch addresses the issues which Krzysztof
> identified?
>

I think so, Krzysztof and I both try to fix the same issue(reuse
swap_info while its
previous resources are not cleared completely). The different is
Krzysztof's patch
uses a global swapon_mutex and its commit log only focuses on set_blocksize(),
while my patch try to maintain the fine grit lock usage.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaAMG1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:27:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaAMG1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:27:22 -0500
Date: Mon, 13 Jan 2014 07:27:03 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Shaohua Li <shli@fusionio.com>,
        Bob Liu <bob.liu@oracle.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] mm/swap: fix race on swap_info reuse between swapoff and
 swapon
Message-ID: <20140113062702.GA26880@mguzik.redhat.com>
References: <000001cf0cfd$6d251640$476f42c0$%yang@samsung.com>
 <20140110171108.32b2be171cd5e54bf22fb2a4@linux-foundation.org>
 <CAL1ERfPnaROPiRAeWHpvwGezHsqN4R8j=QSyS48xs25ax14AhA@mail.gmail.com>
 <20140112192744.9bca5c6d.akpm@linux-foundation.org>
 <CAL1ERfOx7NF-GLuCnK4KXYpunKxQnVmSDA6FkPKXH3CxauzQcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL1ERfOx7NF-GLuCnK4KXYpunKxQnVmSDA6FkPKXH3CxauzQcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:51:42AM +0800, Weijie Yang wrote:
> On Mon, Jan 13, 2014 at 11:27 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 13 Jan 2014 11:08:58 +0800 Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> >
> >> >> --- a/mm/swapfile.c
> >> >> +++ b/mm/swapfile.c
> >> >> @@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >> >>       p->swap_map = NULL;
> >> >>       cluster_info = p->cluster_info;
> >> >>       p->cluster_info = NULL;
> >> >> -     p->flags = 0;
> >> >>       frontswap_map = frontswap_map_get(p);
> >> >>       spin_unlock(&p->lock);
> >> >>       spin_unlock(&swap_lock);
> >> >> @@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >> >>               mutex_unlock(&inode->i_mutex);
> >> >>       }
> >> >>       filp_close(swap_file, NULL);
> >> >> +
> >> >> +     /*
> >> >> +     * clear SWP_USED flag after all resources freed
> >> >> +     * so that swapon can reuse this swap_info in alloc_swap_info() safely
> >> >> +     * it is ok to not hold p->lock after we cleared its SWP_WRITEOK
> >> >> +     */
> >> >> +     spin_lock(&swap_lock);
> >> >> +     p->flags = 0;
> >> >> +     spin_unlock(&swap_lock);
> >> >> +
> >> >>       err = 0;
> >> >>       atomic_inc(&proc_poll_event);
> >> >>       wake_up_interruptible(&proc_poll_wait);
> > But do you agree that your
> > http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
> > makes Krzysztof's
> > http://ozlabs.org/~akpm/mmots/broken-out/swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
> > obsolete?
> 
> Yes, I agree.
> 
> > I've been sitting on Krzysztof's
> > swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
> > for several months - Hugh had issues with it so I put it on hold and
> > nothing further happened.
> >
> >> I will try to resend a patchset to make lock usage in swapfile.c clear
> >> and fine grit
> >
> > OK, thanks.  In the meanwhile I'm planning on dropping Krzysztof's
> > patch and merging your patch into 3.14-rc1, which is why I'd like
> > confirmation that your patch addresses the issues which Krzysztof
> > identified?
> >
> 
> I think so, Krzysztof and I both try to fix the same issue(reuse
> swap_info while its
> previous resources are not cleared completely). The different is
> Krzysztof's patch
> uses a global swapon_mutex and its commit log only focuses on set_blocksize(),
> while my patch try to maintain the fine grit lock usage.
> 

Maybe I should get some sleep first, but I found some minor nits.

Newly introduced window:

p->swap_map == NULL && (p->flags & SWP_USED)

breaks swap_info_get:
        if (!(p->flags & SWP_USED))
                goto bad_device;
        offset = swp_offset(entry);
        if (offset >= p->max)
                goto bad_offset;
        if (!p->swap_map[offset])
                goto bad_free;

so that would need a trivial adjustment.

Another nit is that swap_start and swap_next do the following:
if (!(si->flags & SWP_USED) || !si->swap_map)
	continue;

Testing for swap_map does not look very nice and regardless of your
patch the latter cannot be true if the former is not, thus the check
can be simplified to mere !si->swap_map.

I'm wondering if it would make sense to dedicate a flag (SWP_ALLOCATED?)
to control whether swapon can use give swap_info. That is, it would be
tested and set in alloc_swap_info & cleared like you clear SWP_USED now.
SWP_USED would be cleared as it is and would be set in _enable_swap_info

Then swap_info_get would be left unchanged and swap_* would test for
SWP_USED only.

-- 
Mateusz Guzik

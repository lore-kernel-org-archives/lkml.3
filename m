Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3JOOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab3JOOsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:48:53 -0400
Date: Tue, 15 Oct 2013 10:48:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131015144810.GI31215@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
 <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:54:22AM -0700, Yinghai Lu wrote:
> On Mon, Oct 14, 2013 at 4:46 AM, WANG Chao <chaowang@redhat.com> wrote:
> > Now crashkernel=X will fail out if there's not enough memory at
> > low (below 896M). What makes sense for crashkernel=X would be:
> >
> >  - First try to reserve X below 896M (for being compatible with old
> >    kexec-tools).
> >  - If fails, try to reserve X below 4G (swiotlb need to stay below 4G).
> >  - If fails, try to reserve X from MAXMEM top down.
> >
> > So that user can easily reserve large memory with crashkernel=X instead
> > of crashkernel=X,high. It's more transparent and user-friendly.
> >
> > If crashkernel is large and the reserved is beyond 896M, old kexec-tools
> > won't be compatible with new kernel for most of time.
> >
> > kexec will fail out immediately in this case. But the failure could be
> > expected, because old kexec users should not try to reserve that large
> > amount of memory at the first place.
> >
> > On the other hand, old kexec also will fail on old kernel when there's
> > not enough low memory to reserve a large crash kernel area. So the
> > failure of old kexec is consistent between old kernel and new kernel.
> >
> > Signed-off-by: WANG Chao <chaowang@redhat.com>
> > ---
> >  arch/x86/kernel/setup.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index f0de629..38e6c1f 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -593,6 +593,20 @@ static void __init reserve_crashkernel(void)
> >                                         high ? CRASH_KERNEL_ADDR_HIGH_MAX :
> >                                                CRASH_KERNEL_ADDR_LOW_MAX,
> >                                         crash_size, alignment);
> > +               /*
> > +                * crashkernel=X reserve below 896M fails? Try below 4G
> > +                */
> > +               if (!high && !crash_base)
> > +                       crash_base = memblock_find_in_range(alignment,
> > +                                               (1ULL << 32),
> > +                                               crash_size, alignment);
> > +               /*
> > +                * crashkernel=X reserve below 4G fails? Try MAXMEM
> > +                */
> > +               if (!high && !crash_base)
> > +                       crash_base = memblock_find_in_range(alignment,
> > +                                               CRASH_KERNEL_ADDR_HIGH_MAX,
> > +                                               crash_size, alignment);
> >
> >                 if (!crash_base) {
> >                         pr_info("crashkernel reservation failed - No suitable area found.\n");
> > --
> 
> User should change crashkernel=X to crashkernel=X,high.

I think if we can extend old syntax of crashkernel=X, then it makes life
really easy for users.

> 
> As user could forget to update kexec-tools to utilize ",high" feature, and get
> kdump later fail later.

Previously high reservation (reservation above 896M) will anyway fail. So
instead of failing, if we try reservation in higher memory areas why that
would break old kexec-tools?

IOW, previously anyway kexec-tools will not work as no memory will be
reserved in higher memory area. Now memory will be reserved but old
kexec-tools should fail as it can't load in that area.

If that works, then one would use crashkernel=X,high only if he is
particualr that memory reservation comes from area above 4G (despite
the fact that same memory could have been reserved below 4G too).

Thanks
Vivek

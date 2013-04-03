Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912Ab3DCRrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762858Ab3DCRrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:47:52 -0400
Date: Wed, 3 Apr 2013 13:47:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130403174734.GG5939@redhat.com>
References: <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
 <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
 <20130403131842.GA5939@redhat.com>
 <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
 <CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 10:32:23AM -0700, Yinghai Lu wrote:
> On Wed, Apr 3, 2013 at 10:12 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Wed, Apr 3, 2013 at 6:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> >> - implement crashkernel_no_auto_low option to opt out of auto reserved
> >>   low memory
> >
> > No, that is ugly.
> ...
> >
> > It's *you* want me to change "Crash kernel low" to "Crash kernel".
> >
> > Do we need to drop second patch? So will still keep
> > "Crash kernel low" in /proc/iomem?
> 
> also we can drop the last patch and keep "crashkernel_high=" and
> "crashkernel_low="

as hpa mentioned, we should express memory reservation and dependency
of it in crashkernel= options. So introducing crashkernel_high or
crashkernel_low, just because you we don't want to support multiple
ranges is a kludge.

> 
> as you even like to introduce "crashkernel_no_auto_low".

This is a kludge too for ease of use. At least it does not spoil 
crashkernel= space and also works with existing crashkernel=X
parameters.

You know what, I think multiple ranges has another problem. And that is
all of the kexec/kdump code is written thinking there is one contiguous
reserved range.

        /* Verify we have a valid entry point */
        if ((entry < crashk_res.start) || (entry > crashk_res.end)) {
                result = -EADDRNOTAVAIL;
                goto out;
        }


Also look at crash_shrink_memory().

So what I am saying that all our code is written assuming there is one
single reserved range. Now if we need to reserve two ranges, then let
us make it generic to suppoprt multiple ranges instead of hardcoding
things and assume there can be 2 ranges. That will be a more generic
solution.

So how about this.

- In 3.9, just implement crashkernel=X;high. Don't auto reserve any low
  memory. Support reservation of single range only. It could be either
  high or low.

- Those who are using iommu, they can use crashkernel=X;high. Old code
  can continue to use crashkernel=X and get memory reserved in low
  memory areas.

- In 3.10 add a feature to support multiple crash reserved ranges.

Thanks
Vivek

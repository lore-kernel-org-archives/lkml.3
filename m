Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013Ab3DCVYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871Ab3DCVYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:24:21 -0400
Date: Wed, 3 Apr 2013 17:00:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130403210019.GH5939@redhat.com>
References: <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
 <20130402191130.GB31760@redhat.com>
 <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
 <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
 <20130403131842.GA5939@redhat.com>
 <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
 <CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
 <20130403174734.GG5939@redhat.com>
 <CAE9FiQU96BjThKbOGBhc6RHBey2+bvM6J6ZYaLb=xGuwahTuLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU96BjThKbOGBhc6RHBey2+bvM6J6ZYaLb=xGuwahTuLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 01:38:56PM -0700, Yinghai Lu wrote:
> On Wed, Apr 3, 2013 at 10:47 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > So what I am saying that all our code is written assuming there is one
> > single reserved range. Now if we need to reserve two ranges, then let
> > us make it generic to suppoprt multiple ranges instead of hardcoding
> > things and assume there can be 2 ranges. That will be a more generic
> > solution.
> 
> I don't think we have case that we need to support more than two ranges.
> 

never say never.

One of the biggest problems is that we are trying to reserve all the
memory at system bootup time using kernel command line.

Why not reserve memory using some kernel interface after system has booted.
That will make life much simpler.

Reason being that currently we depend on one big single chunk being
available in low memory area. And after boot there is no guarantee
we will have that memory.

But what if we just reserve enough memory for kernel and initramfs 
during boot and rest of the memory is reserved from user space. If
system has more memory, there are high chances that after boot we will
get memory immediately.

What if we don't get a single range of memory, but multiple ranges,
we should still be able to make use of all those ranges. And I think
that is one possible area where multiple ranges could be useful.

So yes, we don't have an immediate use case, but one can always pop
up in future as we try to extend the functionality.


> We only need to have one big range above 4G, and put second kernel and
> initrd in it.
> and another low one is only for switotlb or others that will be used by
> second kernel.
> 
> >
> > So how about this.
> >
> > - In 3.9, just implement crashkernel=X;high. Don't auto reserve any low
> >   memory. Support reservation of single range only. It could be either
> >   high or low.
> >
> > - Those who are using iommu, they can use crashkernel=X;high. Old code
> >   can continue to use crashkernel=X and get memory reserved in low
> >   memory areas.
> 
> That will not handle the case: big system that crashkernel=X;high
> and kdump does not work with iommu.

If we start supporting multiple ranges properly in 3.10, then it will.
And we have never supported it so it is not a regression. Delaying a
feature by a realease should be worth it in an attempt to do it
properly. 

> 
> >
> > - In 3.10 add a feature to support multiple crash reserved ranges.
> 
> Again, we only need one high and one low range.
> We don't need to support more than two ranges for crash kernel.

For your current use case, you need one high and one low currently. But 
there can always be scenarios where multiple crash ranges are required,
like reserving memory from user space.

Anyway, if you are adamant on hardcoding this stuff, please don't
use crashkernel= space. Continue to use crashkernel_high and/or
crashkernel_low options. That way it allows us to extend crashkernel=
in the form of crashkernel=X;<range-options>;<option2>;...
and support multiple range feature properly down the line and not be
bogged down with this new strange semantics.

Also docuemnt very clearly that specifying crashkernel_high ignores
any of the crashkernel= options.

Also what happens to reserve memory release interface.  IIUC, there
is no way to release crashkernel_low memory from user space and
only memory reserved by crashkernel_high will be released?

Seriously, why are you rushing with this high/low hardcoding. Why
not wait for one more release and support multiple ranges properly
both in kernel and kexec-tools.

Thanks
Vivek

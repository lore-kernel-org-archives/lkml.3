Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161698AbaKNTDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:03:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41467 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161184AbaKNTDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:03:08 -0500
Date: Fri, 14 Nov 2014 11:02:51 -0800
From: Kees Cook <kees@outflux.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RW and executable hole in page tables on x86_64
Message-ID: <20141114190251.GT5451@outflux.net>
References: <20131025133454.GC4994@outflux.net>
 <526A874B.2040108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526A874B.2040108@zytor.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing a thread from a year ago...

On Fri, Oct 25, 2013 at 03:59:23PM +0100, H. Peter Anvin wrote:
> On 10/25/2013 02:34 PM, Kees Cook wrote:
> > Hi,
> > 
> > I've noticed there's a chunk of kernel memory still marked RW and x. See
> > 0xffffffff82956000 below...
> > 
> > ---[ High Kernel Mapping ]---
> > 0xffffffff80000000-0xffffffff81000000          16M                           pmd
> > 0xffffffff81000000-0xffffffff81a00000          10M     ro         PSE GLB x  pmd
> > 0xffffffff81a00000-0xffffffff81e00000           4M     ro         PSE GLB NX pmd
> > 0xffffffff81e00000-0xffffffff82200000           4M     RW             GLB NX pte
> > 0xffffffff82200000-0xffffffff82800000           6M     RW         PSE GLB NX pmd
> > 0xffffffff82800000-0xffffffff82956000        1368K     RW             GLB NX pte
> > 0xffffffff82956000-0xffffffff82a00000         680K     RW             GLB x  pte
> > 0xffffffff82a00000-0xffffffffa0000000         470M                           pmd
> > 
> > HPA looked at it for a bit, but it wasn't obvious what was going on. It's
> > after the end of bss. I do note that the two adjacent regions add up to
> > 2MiB. Is this some kind of leftover mapping? What is this region? Is there
> > a sensible place to clean it up?
> > 
> 
> It looks to be what is left after the 2 MB page for bss is broken up.
> It doesn't mean it isn't broken, though.

It looks like the problem still exists:

---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff9ca00000     458M                   pmd
0xffffffff9ca00000-0xffffffff9d200000       8M   ro   PSE GLB x  pmd
0xffffffff9d200000-0xffffffff9d3f3000    1996K   ro       GLB x  pte
0xffffffff9d3f3000-0xffffffff9d400000      52K   ro           x  pte
0xffffffff9d400000-0xffffffff9d600000       2M   ro   PSE GLB NX pmd
0xffffffff9d600000-0xffffffff9d7e8000    1952K   ro       GLB NX pte
0xffffffff9d7e8000-0xffffffff9d800000      96K   ro           NX pte
0xffffffff9d800000-0xffffffff9d8ff000    1020K   RW       GLB NX pte
0xffffffff9d8ff000-0xffffffff9da2d000    1208K   RW           NX pte
0xffffffff9da2d000-0xffffffff9dc00000    1868K   RW       GLB NX pte
0xffffffff9dc00000-0xffffffff9e600000      10M   RW   PSE GLB NX pmd
0xffffffff9e600000-0xffffffff9e7f5000    2004K   RW       GLB NX pte
0xffffffff9e7f5000-0xffffffff9e800000      44K   RW       GLB x  pte
0xffffffff9e800000-0xffffffffc0000000     536M                   pmd

Still seems to be the bss getting broken up. What is this left-over
memory used for? Any pointers to where it happens? I'd really like to
kill this area.

-Kees

-- 
Kees Cook                                            @outflux.net

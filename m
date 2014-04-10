Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965665AbaDJWG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:06:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45690 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbaDJWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:51 -0400
Date: Thu, 10 Apr 2014 15:06:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: drepper@gmail.com, anatol.pomozov@gmail.com, jkosina@suse.cz,
        akpm@linux-foundation.org, xemul@parallels.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: NUMA node information for pages
In-Reply-To: <5345fe27.82dab40a.0831.0af9SMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <alpine.DEB.2.02.1404101500280.11995@chino.kir.corp.google.com>
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me> <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com> <CAOPLpQc8R2SfTB+=BsMa09tcQ-iBNJHg+tGnPK-9EDH1M47MJw@mail.gmail.com> <5343806c.100cc30a.0461.ffffc401SMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.02.1404091734060.1857@chino.kir.corp.google.com> <5345fe27.82dab40a.0831.0af9SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014, Naoya Horiguchi wrote:

> >  [ And that block_size_bytes file is absolutely horrid, why are we
> >    exporting all this information in hex and not telling anybody? ]
> 
> Indeed, this kind of implicit hex numbers are commonly used in many place.
> I guess that it's maybe for historical reasons.
> 

I think it was meant to be simple to that you could easily add the length 
to the start, but it should at least prefix this with `0x'.  That code has 
been around for years, though, so we probably can't fix it now.

> > I'd much prefer a single change that works for everybody and userspace can 
> > rely on exporting accurate information as long as sysfs is mounted, and 
> > not even need to rely on getpagesize() to convert from pfn to physical 
> > address: just simple {start,end}_phys_addr files added to 
> > /sys/devices/system/node/nodeN/ for node N.  Online information can 
> > already be parsed for these ranges from /sys/devices/system/node/online.
> 
> OK, so what if some node has multiple address ranges?  I don't think that
> start(end)_phys_addr simply returns minimum (maximum) possible address is optimal,
> because users can't know about void range between valid address ranges
> (non-exist pfn should not belong to any node).
> Are printing multilined (or comma-separated) ranges preferable for example
> like below?
> 
>   $ cat /sys/devices/system/node/nodeN/phys_addr
>   0x0-0x80000000
>   0x100000000-0x180000000
> 

What the...?  nodeN should represent the pgdat for that node and a pgdat 
can only have a single range.  I'm suggesting that 
/sys/devices/system/node/nodeN/start_phys_addr returns 
node_start_pfn(N) << PAGE_SHIFT and 
/sys/devices/system/node/nodeN/end_phys_addr returns
node_end_pfn(N) << PAGE_SHIFT and prefix them correctly this time with 
`0x'.

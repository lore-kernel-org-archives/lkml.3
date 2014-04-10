Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539AbaDJAl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:41:29 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40822 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaDJAl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:41:27 -0400
Date: Wed, 9 Apr 2014 17:41:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: drepper@gmail.com, anatol.pomozov@gmail.com, jkosina@suse.cz,
        akpm@linux-foundation.org, xemul@parallels.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: NUMA node information for pages
In-Reply-To: <5343806c.100cc30a.0461.ffffc401SMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <alpine.DEB.2.02.1404091734060.1857@chino.kir.corp.google.com>
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me> <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com> <CAOPLpQc8R2SfTB+=BsMa09tcQ-iBNJHg+tGnPK-9EDH1M47MJw@mail.gmail.com>
 <5343806c.100cc30a.0461.ffffc401SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014, Naoya Horiguchi wrote:

> memory hotplug is done in memory block basis, so if we get info from under
> /sys/devices/system/memory/memory<ID> it should be memory hotplug-aware
> (/sys/devices/system/memory/memory<ID>/state shows online/offline status.)
> 
> And IIUC, "pfn-node_id" mapping might be already available for userspace.
> /sys/devices/system/memory/block_size_bytes exports memory block size,
> so we can simply map pfn (physical address) into memory block ID by
> (physicall address)/(memory block size), then we can find associated node
> from /sys/devices/system/memory/memory<ID>
> 
>   $ ls -l /sys/devices/system/memory/memory0
>   ...
>   lrwxrwxrwx 1 root root    0 Apr  8 00:15 node0 -> ../../node/node0
> 

That's only possible with sparsemem and if you have memory hotplug 
enabled.  I'm thinking that Ulrich is looking for a solution that won't 
have such a dependency and work for all memory models (including one that 
disables NUMA and simply represents all memory as one big node).

 [ And that block_size_bytes file is absolutely horrid, why are we
   exporting all this information in hex and not telling anybody? ]

I'd much prefer a single change that works for everybody and userspace can 
rely on exporting accurate information as long as sysfs is mounted, and 
not even need to rely on getpagesize() to convert from pfn to physical 
address: just simple {start,end}_phys_addr files added to 
/sys/devices/system/node/nodeN/ for node N.  Online information can 
already be parsed for these ranges from /sys/devices/system/node/online.

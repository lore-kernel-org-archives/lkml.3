Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3LCUdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:33:14 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55056 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3LCUdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:33:13 -0500
Date: Tue, 3 Dec 2013 22:33:11 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: Slab BUG with DEBUG_* options
In-Reply-To: <00000142b923d9de-2c71e0b6-7443-46c0-bbde-93a81b50ed37-000000@email.amazonses.com>
Message-ID: <alpine.SOC.1.00.1312032232210.25191@math.ut.ee>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee> <00000142b923d9de-2c71e0b6-7443-46c0-bbde-93a81b50ed37-000000@email.amazonses.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am debugging a reboot problem on Sun Ultra 5 (sparc64) with 512M RAM
> > and turned on DEBUG_PAGEALLOC DEBUG_SLAB and DEBUG_SLAB_LEAK (and most
> > other debug options) and got the following BUG and hang on startup. This
> > happened originally with 3.11-rc2-00058 where my bisection of
> > another problem lead, but I retested 3.12 to have the same BUG in the
> > same place.
> 
> Hmmm. With CONFIG_DEBUG_PAGEALLOC *and* DEBUG_SLAB you would get a pretty
> strange configuration with massive sizes of slabs.
> 
> > kernel BUG at mm/slab.c:2391!
> 
> Ok so this means that we are trying to create a cache with off slab
> management during bootstrap which should not happen.
[...]
> We should not be switching on CFLGS_OFF_SLAB here because the
> kmalloc array does not contain the necessary entries yet.
> 
> Does this fix it? We may need a more sophisticated fix from someone who
> knows how handle CONFIG_DEBUG_PAGEALLOC.

No:

Kernel panic - not syncing: Creation of kmalloc slab (null) size=8388608 
failed. Reason -7

CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-rc2-00058-g20bafb3-dirty 
#134
Call Trace:
 [000000000076416c] panic+0xb4/0x22c
 [0000000000907488] create_boot_cache+0x70/0x84
 [00000000009074d0] create_kmalloc_cache+0x34/0x60
 [0000000000907540] create_kmalloc_caches+0x44/0x168
 [0000000000908dfc] kmem_cache_init+0x1d0/0x1e0
 [00000000008fc658] start_kernel+0x18c/0x370
 [0000000000761db4] tlb_fixup_done+0x88/0x94
 [0000000000000000]           (null)

Am I just running out of memory perhaps?

Will try the other patch soon.

-- 
Meelis Roos (mroos@linux.ee)

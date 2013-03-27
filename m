Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3C0VUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:20:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3C0VUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:20:46 -0400
MIME-Version: 1.0
Message-ID: <2912c0c3-e95f-4b2b-8aeb-2a2ba2df54dd@default>
Date: Wed, 27 Mar 2013 14:20:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>
Subject: RE: [RFC] mm: remove swapcache page early
References: <<1364350932-12853-1-git-send-email-minchan@kernel.org>>
In-Reply-To: <<1364350932-12853-1-git-send-email-minchan@kernel.org>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: [RFC] mm: remove swapcache page early
> 
> Swap subsystem does lazy swap slot free with expecting the page
> would be swapped out again so we can't avoid unnecessary write.
> 
> But the problem in in-memory swap is that it consumes memory space
> until vm_swap_full(ie, used half of all of swap device) condition
> meet. It could be bad if we use multiple swap device, small in-memory swap
> and big storage swap or in-memory swap alone.
> 
> This patch changes vm_swap_full logic slightly so it could free
> swap slot early if the backed device is really fast.
> For it, I used SWP_SOLIDSTATE but It might be controversial.
> So let's add Ccing Shaohua and Hugh.
> If it's a problem for SSD, I'd like to create new type SWP_INMEMORY
> or something for z* family.
> 
> Other problem is zram is block device so that it can set SWP_INMEMORY
> or SWP_SOLIDSTATE easily(ie, actually, zram is already done) but
> I have no idea to use it for frontswap.
> 
> Any idea?
> 
> Other optimize point is we remove it unconditionally when we
> found it's exclusive when swap in happen.
> It could help frontswap family, too.

By passing a struct page * to vm_swap_full() you can then call
frontswap_test()... if it returns true, then vm_swap_full
can return true.  Note that this precisely checks whether
the page is in zcache/zswap or not, so Seth's concern that
some pages may be in-memory and some may be in rotating
storage is no longer an issue.

> What do you think about it?

By removing the page from swapcache, you are now increasing
the risk that pages will "thrash" between uncompressed state
(in swapcache) and compressed state (in z*).  I think this is
a better tradeoff though than keeping a copy of both the
compressed page AND the uncompressed page in memory.

You should probably rename vm_swap_full() because you are
now overloading it with other meanings.  Maybe
vm_swap_reclaimable()?

Do you have any measurements?  I think you are correct
that it may help a LOT.

Thanks,
Dan

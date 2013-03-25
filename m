Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3CYV4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:56:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59439 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353Ab3CYV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:56:12 -0400
Date: Mon, 25 Mar 2013 16:56:08 -0500
From: Russ Anderson <rja@sgi.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130325215608.GE4796@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
 <20130322072532.GC10608@gmail.com>
 <20130323152948.GA3036@sgi.com>
 <CAE9FiQUjVRUs02-ymmtO+5+SgqTWK8Ae6jJwD08uRbgR=eLJgw@mail.gmail.com>
 <514FB24F.8080104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514FB24F.8080104@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:11:27AM +0800, Lin Feng wrote:
> On 03/24/2013 04:37 AM, Yinghai Lu wrote:
> > +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> > +int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
> > +			 unsigned long *start_pfn, unsigned long *end_pfn)
> > +{
> > +	struct memblock_type *type = &memblock.memory;
> > +	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
> 
> I'm really eager to see how much time can we save using binary search compared to
> linear search in this case :)

I have machine time tonight to measure the difference.

Based on earlier testing, a system with 9TB memory calls
__early_pfn_to_nid() 2,377,198,300 times while booting, but
only 6815 times does it not find that the memory range is
the same as previous and search the table.  Caching the
previous range avoids searching the table 2,377,191,485 times,
saving a significant amount of time.

Of the remaining 6815 times when it searches the table, a binary
search may help, but with relatively few calls it may not
make much of an overall difference.  Testing will show how much.

> (quote)
> > A 4 TB (single rack) UV1 system takes 512 seconds to get through
> > the zone code.  This performance optimization reduces the time
> > by 189 seconds, a 36% improvement.
> >
> > A 2 TB (single rack) UV2 system goes from 212.7 seconds to 99.8 seconds,
> > a 112.9 second (53%) reduction.
> (quote)
> 
> thanks,
> linfeng

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaIEJ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:28:48 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:56428 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaIEJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:28:45 -0400
Date: Fri, 5 Sep 2014 11:28:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave@sr71.net>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140905092841.GD26243@dhcp22.suse.cz>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
 <5408ED7A.5010908@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408ED7A.5010908@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-09-14 15:53:46, Dave Hansen wrote:
> On 09/04/2014 01:27 PM, Dave Hansen wrote:
> > On 09/04/2014 07:27 AM, Michal Hocko wrote:
> >> Ouch. free_pages_and_swap_cache completely kills the uncharge batching
> >> because it reduces it to PAGEVEC_SIZE batches.
> >>
> >> I think we really do not need PAGEVEC_SIZE batching anymore. We are
> >> already batching on tlb_gather layer. That one is limited so I think
> >> the below should be safe but I have to think about this some more. There
> >> is a risk of prolonged lru_lock wait times but the number of pages is
> >> limited to 10k and the heavy work is done outside of the lock. If this
> >> is really a problem then we can tear LRU part and the actual
> >> freeing/uncharging into a separate functions in this path.
> >>
> >> Could you test with this half baked patch, please? I didn't get to test
> >> it myself unfortunately.
> > 
> > 3.16 settled out at about 11.5M faults/sec before the regression.  This
> > patch gets it back up to about 10.5M, which is good.  The top spinlock
> > contention in the kernel is still from the resource counter code via
> > mem_cgroup_commit_charge(), though.
> > 
> > I'm running Johannes' patch now.
> 
> This looks pretty good.  The area where it plateaus (above 80 threads
> where hyperthreading kicks in) might be a bit slower than it was in
> 3.16, but that could easily be from other things.

Good news indeed. But I think it would be safer to apply Johannes'
revert for now. Both changes are still worth having anyway because they
have potential to improve memcg case.

> > https://www.sr71.net/~dave/intel/bb.html?1=3.16.0-rc4-g67b9d76/&2=3.17.0-rc3-g57b252f
> 
> Feel free to add my Tested-by:

Thanks a lot! I have posted another patch which reduces the batching for
LRU handling because this would be too risky. So I haven't added your
Tested-by yet.
 

-- 
Michal Hocko
SUSE Labs

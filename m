Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaIEMfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:35:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60095 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbaIEMfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:35:41 -0400
Date: Fri, 5 Sep 2014 08:35:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@sr71.net>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140905123517.GA21208@cmpxchg.org>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408CB2E.3080101@sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 01:27:26PM -0700, Dave Hansen wrote:
> On 09/04/2014 07:27 AM, Michal Hocko wrote:
> > Ouch. free_pages_and_swap_cache completely kills the uncharge batching
> > because it reduces it to PAGEVEC_SIZE batches.
> > 
> > I think we really do not need PAGEVEC_SIZE batching anymore. We are
> > already batching on tlb_gather layer. That one is limited so I think
> > the below should be safe but I have to think about this some more. There
> > is a risk of prolonged lru_lock wait times but the number of pages is
> > limited to 10k and the heavy work is done outside of the lock. If this
> > is really a problem then we can tear LRU part and the actual
> > freeing/uncharging into a separate functions in this path.
> > 
> > Could you test with this half baked patch, please? I didn't get to test
> > it myself unfortunately.
> 
> 3.16 settled out at about 11.5M faults/sec before the regression.  This
> patch gets it back up to about 10.5M, which is good.  The top spinlock
> contention in the kernel is still from the resource counter code via
> mem_cgroup_commit_charge(), though.

Thanks for testing, that looks a lot better.

But commit doesn't touch resource counters - did you mean try_charge()
or uncharge() by any chance?


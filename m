Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3EHLuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:50:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:58537 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3EHLuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,634,1363158000"; 
   d="scan'208";a="238488227"
Date: Wed, 8 May 2013 19:50:32 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] f2fs: optimize build_free_nids()
Message-ID: <20130508115032.GA23356@hli22-desktop>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
 <1367922839.16581.42.camel@kjgkr>
 <20130508062455.GB8705@hli22-desktop>
 <1368006604.16581.64.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368006604.16581.64.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:50:04PM +0900, Jaegeuk Kim wrote:
 > > Could you explain when this can happen?
> >
> > I'm thinking of this possible scenario:
> >
> > as we don't hold any spinlock to protect the context, add_free_nid() could be
> > called by other thread anytime, e.g. by the gc_thread_func() in background.
>
> The gc_thread_func() is not a proper example here though, the
> buid_free_nids() is covered by nm_i->build_lock, so build_free_nids is
> entered only one at a time.
> In addtion, build_free_nids starts with checking if (nm_i->fcnt >
> NAT_ENTRY_PER_BLOCK) in order not to be conducted repeatedely.

surely build_free_nids() itself is under well protection.
but this scenario would happen when gc_thread_func() is running in background:
        f2fs_gc()
                write_checkpoint()
                        flush_nat_entries()
                                add_free_nid()
> >
> > then nm_i->fcnt could be increased as 2 * MAX_FREE_NIDS while i < FREE_NID_PAGES.
> > Anything I misconsidered?
>
> Apart from the correctness of this behavior, I'm not sure why we should
> strictly manage this threshold value.
> Should we really need to do this?

This threshold value itself should have already be well managed in current code.

This patch is just to avoid unecessary while-loop that tries scan_nat_page() even when this threshold
has already been reached. But as I mentioned previously, it just possibly avoids "< 4" unecessary tries.

So this patch now becomes a very very trivial optimization because scan_nat_page() itself can detect out the condition.

In such case, You can *ignore* this patch:). 
Thanks for the patch review, Jaegeuk!
 
> > 
> > hmm, the pros is that this check may possibly avoid some (< 4) unnecessary while-loop,
> > the cons is that too many checks of (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> > would make the code looking messy and fragmentary...
> >  
> > > >  		if (i++ == FREE_NID_PAGES)
> > > >  			break;
> > > >  	}

-haicheng

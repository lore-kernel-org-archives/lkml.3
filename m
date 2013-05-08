Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3EHGZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:5482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3EHGZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,632,1363158000"; 
   d="scan'208";a="334259163"
Date: Wed, 8 May 2013 14:24:55 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] f2fs: optimize build_free_nids()
Message-ID: <20130508062455.GB8705@hli22-desktop>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
 <1367922839.16581.42.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367922839.16581.42.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 07:33:59PM +0900, Jaegeuk Kim wrote:
> 2013-05-06 (월), 23:15 +0800, Haicheng Li:
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 1fe3fe2..3136224 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1342,6 +1342,8 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
> >  		if (nid >= nm_i->max_nid)
> >  			nid = 0;
> >  
> > +		if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> > +			break;
> 
> Could you explain when this can happen?

I'm thinking of this possible scenario:

as we don't hold any spinlock to protect the context, add_free_nid() could be 
called by other thread anytime, e.g. by the gc_thread_func() in background.

then nm_i->fcnt could be increased as 2 * MAX_FREE_NIDS while i < FREE_NID_PAGES.

Anything I misconsidered?

> IMO, this is an unnecessary condition check, since the below condition
> that includes FREE_NID_PAGES already limits the number of free nids.
> Thanks,

hmm, the pros is that this check may possibly avoid some (< 4) unnecessary while-loop,
the cons is that too many checks of (nm_i->fcnt > 2 * MAX_FREE_NIDS)
would make the code looking messy and fragmentary...
 
> >  		if (i++ == FREE_NID_PAGES)
> >  			break;
> >  	}
> 
> -- 
> Jaegeuk Kim
> Samsung



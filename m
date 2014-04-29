Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079AbaD2TSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:18:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:28630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaD2TSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,952,1389772800"; 
   d="scan'208";a="523197207"
From: "Hammond, John" <john.hammond@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Oleg Drokin <green@linuxhacker.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: RE: [PATCH 41/47] staging/lustre/llite: remove dead code
Thread-Topic: [PATCH 41/47] staging/lustre/llite: remove dead code
Thread-Index: AQHPYjtVN2vLXpLMk02K9lmYPZNH7Zso5gMAgAASaZA=
Date: Tue, 29 Apr 2014 19:16:54 +0000
Message-ID: <C6D48C5819337145905EDC9DB164E6971EDC4A18@fmsmsx120.amr.corp.intel.com>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-42-git-send-email-green@linuxhacker.ru>
 <20140429110251.GC26890@mwanda>
In-Reply-To: <20140429110251.GC26890@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, April 29, 2014 6:03 AM
> To: Oleg Drokin
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org;
> devel@driverdev.osuosl.org; Drokin, Oleg; Hammond, John
> Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
> 
> On Sun, Apr 27, 2014 at 01:07:05PM -0400, Oleg Drokin wrote:
> > From: "John L. Hammond" <john.hammond@intel.com>
> >
> > In llite remove unused declarations, parameters, types, and unused,
> > get-only, or set-only structure members. Add static and const
> > qualifiers to declarations where possible.
> >
...
> 
> This is a random grab bag of changes to lots of files.  One thing per
> patch, etc, next time.

OK, granted. But some guidance would be welcome here. For clean-up work like this, do you want a patch that const-corrects one function, a patch that const corrects all functions in a file, or a patch that const corrects all functions in a module? Is it OK to do const and static correction in the same change? Is it OK to do const, static, and dead-code in a single file?

> > diff --git a/drivers/staging/lustre/lustre/llite/dcache.c
> b/drivers/staging/lustre/lustre/llite/dcache.c
> > index 8b55080..7d520d8 100644
> > --- a/drivers/staging/lustre/lustre/llite/dcache.c
> > +++ b/drivers/staging/lustre/lustre/llite/dcache.c
> > @@ -69,8 +69,7 @@ static void ll_release(struct dentry *de)
> >  		ll_intent_release(lld->lld_it);
> >  		OBD_FREE(lld->lld_it, sizeof(*lld->lld_it));
> >  	}
> > -	LASSERT(lld->lld_cwd_count == 0);
> > -	LASSERT(lld->lld_mnt_count == 0);
> > +
> 
> I'm totally in favour of removing LASSERT() calls...  But is this a
> "set only" struct member?  It's totally unclear from the patch
> description.

Actually it's get only. I can label what's what in the commit messages.

> > diff --git a/drivers/staging/lustre/lustre/llite/statahead.c
> b/drivers/staging/lustre/lustre/llite/statahead.c
> > index 51c5327..1b47774 100644
> > --- a/drivers/staging/lustre/lustre/llite/statahead.c
> > +++ b/drivers/staging/lustre/lustre/llite/statahead.c
> > @@ -1230,9 +1230,7 @@ do_it:
> >  			 */
> >  			ll_release_page(page, le32_to_cpu(dp->ldp_flags) &
> >  					      LDF_COLLIDE);
> > -			sai->sai_in_readpage = 1;
> >  			page = ll_get_dir_page(dir, pos, &chain);
> > -			sai->sai_in_readpage = 0;
> >  		} else {
> >  			LASSERT(le32_to_cpu(dp->ldp_flags) & LDF_COLLIDE);
> >  			ll_release_page(page, 1);
> > @@ -1563,12 +1561,6 @@ int do_statahead_enter(struct inode *dir, struct
> dentry **dentryp,
> >  			return entry ? 1 : -EAGAIN;
> >  		}
> >
> > -		/* if statahead is busy in readdir, help it do post-work */
> > -		while (!ll_sa_entry_stated(entry) &&
> > -		       sai->sai_in_readpage &&
> > -		       !sa_received_empty(sai))
> > -			ll_post_statahead(sai);
> > -
> >  		if (!ll_sa_entry_stated(entry)) {
> >  			sai->sai_index_wait = entry->se_index;
> >  			lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(30), NULL,
> 
> What is this change about really?  I've already waded through 1271 lines
> of random changes at this point and now I have to figure out what
> ll_post_statahead() does and why we don't need to call it now?
> 
> Anyways, please explain this change.

It looks like this change got squished together with something else when it was pushed to staging. I've asked to Oleg check. In the original change, sai_in_readpage was never set. Hence it was easy to see that the if statement was dead code. Sorry for the confusion.

Best,

John


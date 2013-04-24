Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3DXImx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:42:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58389 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3DXImt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:42:49 -0400
Date: Wed, 24 Apr 2013 16:42:29 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, guz.fnst@cn.fujitsu.com, tmac@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v3 2/3] resource: Add release_mem_region_adjustable()
Message-ID: <20130424084229.GB29191@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1365614221-685-1-git-send-email-toshi.kani@hp.com>
 <1365614221-685-3-git-send-email-toshi.kani@hp.com>
 <20130410144412.395bf9f2fb8192920175e30a@linux-foundation.org>
 <1365630585.32127.110.camel@misato.fc.hp.com>
 <alpine.DEB.2.02.1304101505250.1526@chino.kir.corp.google.com>
 <20130410152404.e0836af597ba3545b9846672@linux-foundation.org>
 <1365697802.32127.117.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365697802.32127.117.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042408-7606-0000-0000-00000ACD9D43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:30:02AM -0600, Toshi Kani wrote:
> On Wed, 2013-04-10 at 15:24 -0700, Andrew Morton wrote:
> > On Wed, 10 Apr 2013 15:08:29 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> > 
> > > On Wed, 10 Apr 2013, Toshi Kani wrote:
> > > 
> > > > > I'll switch it to GFP_ATOMIC.  Which is horridly lame but the
> > > > > allocation is small and alternatives are unobvious.
> > > > 
> > > > Great!  Again, thanks for the update!
> > > 
> > > release_mem_region_adjustable() allocates at most one struct resource, so 
> > > why not do kmalloc(sizeof(struct resource), GFP_KERNEL) before taking 
> > > resource_lock and then testing whether it's NULL or not when splitting?  
> > > It unnecessarily allocates memory when there's no split, but 
> > > __remove_pages() shouldn't be a hotpath.
> > 
> > yup.
> > 
> > --- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix
> > +++ a/kernel/resource.c
> > @@ -1046,7 +1046,8 @@ int release_mem_region_adjustable(struct
> >  			resource_size_t start, resource_size_t size)
> >  {
> >  	struct resource **p;
> > -	struct resource *res, *new;
> > +	struct resource *res;
> > +	struct resource *new_res;
> >  	resource_size_t end;
> >  	int ret = -EINVAL;
> >  
> > @@ -1054,6 +1055,9 @@ int release_mem_region_adjustable(struct
> >  	if ((start < parent->start) || (end > parent->end))
> >  		return ret;
> >  
> > +	/* The kzalloc() result gets checked later */
> > +	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > +
> >  	p = &parent->child;
> >  	write_lock(&resource_lock);
> >  
> > @@ -1091,32 +1095,33 @@ int release_mem_region_adjustable(struct
> >  						start - res->start);
> >  		} else {
> >  			/* split into two entries */
> > -			new = kzalloc(sizeof(struct resource), GFP_ATOMIC);
> > -			if (!new) {
> > +			if (!new_res) {
> >  				ret = -ENOMEM;
> >  				break;
> >  			}
> > -			new->name = res->name;
> > -			new->start = end + 1;
> > -			new->end = res->end;
> > -			new->flags = res->flags;
> > -			new->parent = res->parent;
> > -			new->sibling = res->sibling;
> > -			new->child = NULL;
> > +			new_res->name = res->name;
> > +			new_res->start = end + 1;
> > +			new_res->end = res->end;
> > +			new_res->flags = res->flags;
> > +			new_res->parent = res->parent;
> > +			new_res->sibling = res->sibling;
> > +			new_res->child = NULL;
> >  
> >  			ret = __adjust_resource(res, res->start,
> >  						start - res->start);
> >  			if (ret) {
> > -				kfree(new);
> > +				kfree(new_res);
> >  				break;
> >  			}
> 
> The kfree() in the if-statement above is not necessary since kfree() is
> called before the return at the end.  That is, the if-statement needs to
> be:
> 	if (ret)
> 		break;
> 
> With this change, I confirmed that all my test cases passed (with all
> the config debug options this time :).  With the change:
> 
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>

I am not confortable witht the assumption, that when a split takes
place, the children are assumed to be in the lower entry. Probably a
warning to that effect,  would help quickly
nail down the problem, if such a case does encounter ?

Otherwise this looks fine. Sorry for the delayed reply. Was out.

Reviewed-by: Ram Pai <linuxram@us.ibm.com>


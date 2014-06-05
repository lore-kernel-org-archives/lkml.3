Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaFEN7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:59:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaFEN7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:59:42 -0400
Date: Thu, 5 Jun 2014 09:58:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 04/13] resource: Provide new functions to walk through
 resources
Message-ID: <20140605135857.GA17389@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-5-git-send-email-vgoyal@redhat.com>
 <20140604102420.GC4105@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604102420.GC4105@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 12:24:20PM +0200, Borislav Petkov wrote:
> On Tue, Jun 03, 2014 at 09:06:53AM -0400, Vivek Goyal wrote:
> > @@ -322,7 +327,71 @@ int release_resource(struct resource *old)
> >  
> >  EXPORT_SYMBOL(release_resource);
> >  
> > -#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> > +/*
> > + * Finds the lowest iomem reosurce exists with-in [res->start.res->end)
> > + * the caller must specify res->start, res->end, res->flags and "name".
> > + * If found, returns 0, res is overwritten, if not found, returns -1.
> > + * This walks through whole tree and not just first level children.
> > + */
> > +static int find_next_iomem_res(struct resource *res, char *name)
> > +{
> > +	resource_size_t start, end;
> > +	struct resource *p;
> > +
> > +	BUG_ON(!res);
> > +
> > +	start = res->start;
> > +	end = res->end;
> > +	BUG_ON(start >= end);
> > +
> > +	read_lock(&resource_lock);
> > +	p = &iomem_resource;
> > +	while ((p = next_resource(p))) {
> 
> Just a thought - this function differs from find_next_system_ram() only
> in the traversal mode through resources. I wonder if next_resource()
> could be given a flag, say TRAVERSE_SIBLINGS_ONLY or so and be called
> from both, once with the flag set and once without and thus save us the
> code duplication.

Yep, that makes sense. I will change it and start passing a flag.

Thanks
Vivek

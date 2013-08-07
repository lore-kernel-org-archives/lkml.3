Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3HGHRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:17:24 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55221 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3HGHRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:17:23 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-ff-5201f482b6ce
Date: Wed, 7 Aug 2013 16:17:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/4] mm, rmap: allocate anon_vma_chain before starting to
 link anon_vma_chain
Message-ID: <20130807071726.GB32449@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778620-31593-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20130807060803.GJ1845@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807060803.GJ1845@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:08:03AM -0400, Johannes Weiner wrote:
> >  
> >  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> >  		struct anon_vma *anon_vma;
> >  
> > -		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
> > -		if (unlikely(!avc)) {
> > -			unlock_anon_vma_root(root);
> > -			root = NULL;
> > -			avc = anon_vma_chain_alloc(GFP_KERNEL);
> > -			if (!avc)
> > -				goto enomem_failure;
> > -		}
> > +		avc = list_entry((&avc_list)->next, typeof(*avc), same_vma);
> 
> list_first_entry() please

Okay. I will send next version soon.

> 
> > +		list_del(&avc->same_vma);
> >  		anon_vma = pavc->anon_vma;
> >  		root = lock_anon_vma_root(root, anon_vma);
> >  		anon_vma_chain_link(dst, avc, anon_vma);
> > @@ -259,8 +262,11 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  	unlock_anon_vma_root(root);
> >  	return 0;
> >  
> > - enomem_failure:
> > -	unlink_anon_vmas(dst);
> > +enomem_failure:
> > +	list_for_each_entry_safe(avc, pavc, &avc_list, same_vma) {
> > +		list_del(&avc->same_vma);
> > +		anon_vma_chain_free(avc);
> > +	}
> >  	return -ENOMEM;
> >  }
> 
> Otherwise, looks good.

Thank you!


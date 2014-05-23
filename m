Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEWRv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:51:57 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:50422 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbaEWRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:51:56 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 13:51:56 EDT
Date: Fri, 23 May 2014 12:45:48 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140523152642.GD3147@esperanza>
Message-ID: <alpine.DEB.2.10.1405231241250.22913@gentwo.org>
References: <20140516132234.GF32113@esperanza> <alpine.DEB.2.10.1405160957100.32249@gentwo.org> <20140519152437.GB25889@esperanza> <alpine.DEB.2.10.1405191056580.22956@gentwo.org> <537A4D27.1050909@parallels.com> <alpine.DEB.2.10.1405210937440.8038@gentwo.org>
 <20140521150408.GB23193@esperanza> <alpine.DEB.2.10.1405211912400.4433@gentwo.org> <20140522134726.GA3147@esperanza> <alpine.DEB.2.10.1405221422390.15766@gentwo.org> <20140523152642.GD3147@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Vladimir Davydov wrote:

> On Thu, May 22, 2014 at 02:25:30PM -0500, Christoph Lameter wrote:
> > slab_free calls __slab_free which can release slabs via
> > put_cpu_partial()/unfreeze_partials()/discard_slab() to the page
> > allocator. I'd rather have preemption enabled there.
>
> Hmm, why? IMO, calling __free_pages with preempt disabled won't hurt
> latency, because it proceeds really fast. BTW, we already call it for a
> bunch of pages from __slab_free() -> put_cpu_partial() ->
> unfreeze_partials() with irqs disabled, which is harder. FWIW, SLAB has
> the whole obj free path executed under local_irq_save/restore, and it
> doesn't bother enabling irqs for freeing pages.
>
> IMO, the latency improvement we can achieve by enabling preemption while
> calling __free_pages is rather minor, and it isn't worth complicating
> the code.

If you look at the end of unfreeze_partials() you see that we release
locks and therefore enable preempt before calling into the page allocator.

You never know what other new features they are going to be adding to the
page allocator. I'd rather be safe than sorry on this one. We have had
some trouble in the past with some debugging logic triggering.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3JRRGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:06:18 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:36716 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756583Ab3JRRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:06:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3870:3871:3872:3874:4250:4321:4605:5007:6119:6120:7652:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNS
X-HE-Tag: nut12_8dd281cee1404
X-Filterd-Recvd-Size: 3047
Message-ID: <1382115973.2041.3.camel@joe-AO722>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Joe Perches <joe@perches.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Fri, 18 Oct 2013 10:06:13 -0700
In-Reply-To: <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
References: <1381296747.2040.17.camel@joe-AO722>
	 <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
	 <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 09:57 -0700, Kevin Hilman wrote:
[]
> A handful of boot panics on ARM platforms were bisected to point at
> the version of this commit that's in linux-next (commit
> 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
> makes things happy again.
> 
> Upon further digging, it seems that users of devres_alloc() are
> relying on the previous behavior of having the memory zero'd which is
> no longer the case after $SUBJECT patch.  The change below on top of
> -next makes these ARM boards happy again.
[]
> commit 64c862a8 (devres: add kernel standard devm_k.alloc functions) changed
> the default behavior of alloc_dr() to no longer zero the allocated
> memory.  However,
> only the devm.k.alloc() function were modified to pass in __GFP_ZERO
> which leaves
> any users of devres_alloc() or __devres_alloc() with potentially wrong
> assumptions
> about memory being zero'd upon allocation.
> 
> To fix, add __GFP_ZERO to devres_alloc() calls to preserve previous
> behavior of zero'ing memory upon allocation.
[]
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
[]
> @@ -136,7 +136,7 @@ void * devres_alloc(dr_release_t release, size_t
> size, gfp_t gfp)
>  {
>   struct devres *dr;
> 
> - dr = alloc_dr(release, size, gfp);
> + dr = alloc_dr(release, size, gfp | __GFP_ZERO);
>   if (unlikely(!dr))
>   return NULL;
>   return dr->data;

Wouldn't the __devres_alloc need that too?


#ifdef CONFIG_DEBUG_DEVRES
void * __devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
		      const char *name)
{
	struct devres *dr;

	dr = alloc_dr(release, size, gfp);
	if (unlikely(!dr))
		return NULL;
	set_node_dbginfo(&dr->node, name, size);
	return dr->data;
}
EXPORT_SYMBOL_GPL(__devres_alloc);



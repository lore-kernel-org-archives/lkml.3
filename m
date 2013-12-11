Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3LKN2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:28:53 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58238 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3LKN2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:28:50 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()
To: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <528E577C.2050506@wwwdotorg.org>
References: <1385041249-7705-1-git-send-email-hdoyu@nvidia.com>< 1385041249-7705-2-git-send-email-hdoyu@nvidia.com> <20131121.191720. 1487772262083864095.hdoyu@nvidia.com> <528E577C.2050506@wwwdotorg.org>
Date: Wed, 11 Dec 2013 13:28:45 +0000
Message-Id: <20131211132845.5461FC4061A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 11:57:00 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/21/2013 10:17 AM, Hiroshi Doyu wrote:
> > Iterating over a property containing a list of phandles with arguments
> > is a common operation for device drivers. This patch adds a new
> > of_property_for_each_phandle_with_args() macro to make the iteration
> > simpler.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> > v6+:
> > Use the description, which Grant Likely proposed, to be full enough
> > that a future reader can figure out why a patch was written.
> >   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007062.html
> 
> This new version only addresses one of the concerns that Grant had,
> namely the commit message.
> 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> 
> > +#define of_property_for_each_phandle_with_args(np, list, cells, i, args) \
> > +	for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> > +
> 
> Grant also wanted the actual implementation fixed so that it wasn't so
> inefficient.
> 
> What this current patch does is basically:
> 
> for every entry in the property:
>     for every entry in the property before the current index:
>         parse the phandle+specifier
> 
> That's roughly O(n^2). (n is # entries in the property)
> 
> Instead, what should happen is:
> 
> for every entry in the property:
>     parse the phandle+specifier
>     yield the result
> 
> That's roughly O(n).
> 
> In other words, an implementation more along the lines of
> include/linux/of.h's:
> 
> #define of_property_for_each_u32(np, propname, prop, p, u)      \
>         for (prop = of_find_property(np, propname, NULL),       \
>                 p = of_prop_next_u32(prop, NULL, &u);           \
>                 p;                                              \
>                 p = of_prop_next_u32(prop, p, &u))
> 
> ... so you'd need functions like of_prop_first_specifier() and
> of_prop_next_specifier(), and perhaps some associated set of state
> variables, perhaps with all the state wrapped into a single struct for
> simplicity.

That's right, I forgot I said that. Yes please fix the implementation.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3JWQQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:16:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47977 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3JWQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:16:54 -0400
Date: Wed, 23 Oct 2013 09:16:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Usage of for_each_child_of_node()
Message-ID: <20131023161644.GB20675@roeck-us.net>
References: <5259B6F8.3070701@roeck-us.net>
 <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
 <20131023071006.GA7708@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023071006.GA7708@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:10:07AM +0200, Thierry Reding wrote:
> On Sat, Oct 12, 2013 at 10:15:03PM -0500, Rob Herring wrote:
> > On Sat, Oct 12, 2013 at 3:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > Hi all,
> > >
> > > for_each_child_of_node() and similar functions increase the refcount
> > > on each returned node and expect the caller to release the node by
> > > calling of_node_put() when done.
> > >
> > > Looking through the kernel code, it appears this is hardly ever done,
> > > if at all. Some code even calls of_node_get() on returned nodes again.
> > >
> > > I guess this doesn't matter in cases where devicetree is a static entity.
> > > However, this is not (or no longer) the case with devicetree overlays,
> > > or more generically in cases where devicetree nodes are added and
> > > removed dynamically.
> > >
> > > Fundamental question: Would patches to fix this problem be accepted upstream
> > > ?
> > 
> > Certainly.
> > 
> > > Or, of course, stepping a bit back: Am I missing something essential ?
> > 
> > No. I think this is frequently wrong since it typically doesn't matter
> > for static entries as you mention.
> 
> Actually, I think it actually happens to be correct most of the time.
> The reason is that for_each_child_of_node() internally calls the
> of_get_next_child() to iterate over all children. And that function
> already calls of_node_put() on the "previous" node. So if all the code
> does is to iterate over all nodes to query them, then all should be
> fine.
> 
Good, that reduces the scope of the problem significantly.

> The only case where you actually need to drop the reference on a node is
> if you break out of the loop (so that of_get_next_child() will not be
> called). But that's usually the case when you need to perform some
> operation on the node, in which case it is the right thing to hold on to
> a reference until you're done with the node.
> 
Unfortunately, there are many cases with code such as

	if (error)
		return;	/* or break; */

or even
	if (found node)
		return of_node_get(node);

in the loop.

Guenter

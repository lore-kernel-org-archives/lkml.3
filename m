Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3CSSPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:15:31 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57055 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552Ab3CSSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:15:28 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/6] OF: Introduce Device Tree resolve support.
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
In-Reply-To: <6BBAEB5D-D4E0-4276-B3B8-468C30547E75@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-6-git-send-email-panto@antoniou-consulting.com> <20130121044836.GB24829@truffula.fritz.box> <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com> <20130122040524.GG23500@truffula.fritz.box> <AB11FABF-6A45-493D-869D-7549FD758DD2@antoniou-consulting.com> <20130123044041.GS23500@truffula.fritz.box> <060132B1-BB52-4C7F-B8D3-82B49BE49BB7@antoniou-consulting.com> <20130316092435.9FA4B3E095B@localhost> <6BBAEB5D-D4E0-4276-B3B8-468C30547E75@antoniou-consulting.com>
Date: Tue, 19 Mar 2013 17:18:48 +0000
Message-Id: <20130319171848.733493E33F5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 13:51:01 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Hi Grant,
> 
> On Mar 16, 2013, at 11:24 AM, Grant Likely wrote:
> 
> > On Wed, 23 Jan 2013 12:58:02 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> >> Hi David,
> >> 
> >> On Jan 23, 2013, at 6:40 AM, David Gibson wrote:
> >>> Ok.  Nonetheless it's not hard to avoid a recursive approach here.
> >> 
> >> How can I find the maximum phandle value of a subtree without using recursion.
> >> Note that the whole function is just 6 lines long.
> > 
> > It's a failure in the existing kernel DT data structures. We need a hash
> > lookup for the phandles to eliminate the search entirely. Then you'd be
> > able to allocated new phandles on the fly easily and resolve phandles
> > without searching the whole tree (which has always been horrible).
> > 
> 
> Yes, it is pretty obvious that the in-kernel data structures are sub-optimal.
> But I was not after modifying them, since that's a different kind of problem.

Think about it this way; fixing up that aspect of the data structure
makes the job you're trying to do a lot easier. I don't feel bad about
asking you to add a radix tree for phandle lookups when it makes your
patches a whole lot better.  :-)

> Since we're having a 'sub-optimal' data structures, I'd like to point out that
> the usage of of_find_by_name(), mostly by drivers trying to find a child
> of their own node, works by a lucky accident of how the device nodes are instantiated
> by the flat tree loader. Most of the use cases should be replaced by a call
> to of_get_child_by_name() which does the right thing.

It is true. In fact, calling of_find_node_by_name() when using .dtb is
most likely a bug since using node name to determine behaviour is
strongly discouraged.

> Fair enough, but be warned that phandle resolution the overlay feature is mostly useless.
> 
> In actual practice the amount of driver nodes that can be overlaid without a single case
> of referencing phandles outside (or within) their own blob is close to zero.

That's not what I'm saying. I'm saying that (at least for now) we should
require the overlay to already know the phandles from the parent and to
refuse to load an overlay that defines phandles already in use in the
base. Overlays do become usable at that point. A mechanism for phandle
resolution so that conflicts can be found and resolved can be added
as a feature enhancement. By splitting it out you'll be able to get the
overlay feature merged even if we don't have agreement on the resolution
mechanism yet.

g.


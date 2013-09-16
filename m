Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3IPWq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:46:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:45885 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3IPWqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:46:23 -0400
Message-ID: <1379371567.3721.46.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Sep 2013 08:46:07 +1000
In-Reply-To: <52372F2A.2050003@wwwdotorg.org>
References: <1379300274.4098.77.camel@pasglop>
	 <52372F2A.2050003@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 10:17 -0600, Stephen Warren wrote:
> On 09/15/2013 08:57 PM, Benjamin Herrenschmidt wrote:
> > [resent to the right list this time around]
> > 
> > Hi folks !
> > 
> > So I don't have the bandwidth to follow closely what's going on, but I
> > just today noticed the crackpot that went into 3.11 as part of commit:
> > 
> > 9d8eab7af79cb4ce2de5de39f82c455b1f796963
> > drivers: of: add initialization code for dma reserved memory
> > 
> > Fist of all, do NOT add (or change) a binding as part of a patch
> > implementing code, it's gross.
> 
> Personally, I would argue the opposite; it's much easier to see what's
> going on when it's all together in one patch. 

One patch series eventually, but not the same patch.

> Ensuring ABI stability can
> only be achieved through code review, i.e. splitting into separate
> DT/code patches won't achieve that, so that argument doesn't affect this.
> 
> ...
> > Additionally, it has the following issues:
> > 
> >  - It describes the "memory" node as /memory, which is WRONG
> > 
> > It should be "/memory@unit-address, this is important because the Linux
> > kernel of_find_device_by_path() isn't smart enough to do partial
> > searches (unlike the real OFW one) and thus to ignore the unit address
> > for search purposes, and you *need* the unit address if you have
> > multiple memory nodes (which you typically do on NUMA machines).
> 
> Perhaps /memory should have had a unit-address, but it never has had on
> ARM; see arch/arm/boot/dts/skeleton.dtsi which says:

Well, this is a mistake ARM folks might have done from day one but it
should still be fixed :-)

A node that has a "reg" property should have the corresponding unit
address.

>         memory { device_type = "memory"; reg = <0 0>; };
> 
> ... and the fact that reg in /memory can have multiple entries seems to
> support the expectation we only have a single node here. I'm not sure
> how we could possibly change this now it's become so entrenched?

Because everybody else does differently ? If you have things like NUMA
configurations where some memory ranges pertain to different nodes, you
need a memory node per NUMA node so you can add the other node-local
properties there.

The above should have been memory@0

The best way to fix this in a backward compatible manner is to once and
for all for our implementation of path-lookup to be able to work with
partial path components like a real OFW does, ie, name only, unit
address only, or both.

In anycase, just "/memory" will break on at least powerpc.

Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



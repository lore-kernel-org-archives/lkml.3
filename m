Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3I0Pmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:42:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48827 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3I0Pmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:42:49 -0400
Subject: Re: "memory" binding issues
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1379492496.6148.35.camel@pasglop>
Date: Fri, 27 Sep 2013 10:42:50 -0500
Cc: Grant Likely <grant.likely@secretlab.ca>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com
Content-Transfer-Encoding: 8BIT
Message-Id: <CD611795-B45E-4E37-B387-76B5C855DEEA@codeaurora.org>
References: <1379300274.4098.77.camel@pasglop> <20130918025714.A69D8C42C8F@trevor.secretlab.ca> <1379492496.6148.35.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 18, 2013, at 3:21 AM, Benjamin Herrenschmidt wrote:

> On Tue, 2013-09-17 at 21:57 -0500, Grant Likely wrote:
> 
>>> - It provides no indication of what a given region is used for (or used
>>> by). In the example, "display_region" is a label (thus information that
>>> is lost) and unless it's referenced by another node there is no good way
>>> to know what this region is about which is quite annoying.
>> 
>> Does this actually matter? In most cases the regions are completely
>> anonymous until referenced by a specific device and by default the
>> kernel should not use until it knows what the region is for.
> 
> First it's handy for the developer to know for
> debug/diagnostic/you-name-it purposes. You don't always know what the
> heck the firmware is doing and there are some cases where such regions
> exist independently of any specific device.
> 
> The ability of the node of the driver to have a phandle pointing to a is
> indeed a nice feature and that's a good point in favor of making them
> nodes. But I would be against *requiring* it.
> 
> I might have some architecture code that knows that this region is for
> use by some internal DMA translation cache or god knows what without
> having a clear device node as the "owner" of the region, there are going
> to be a few special cases like that and we still want to be able to
> identify it.
> 
> So I would definitely want them named. Guess what ? They are all
> children of /reserved-memory right ? So their individual name doesn't
> matter one bit, thus the node name can perfectly well serve that
> purpose.
> 
>> We can however add properties to give the kernel hints on the usage. For
>> instance, if a regions isn't in use at boot time, then it would be fine
>> for the kernel to use it for movable pages up until the time a device
>> asks for the region (ie. CMA regions can be used this way).
> 
> Let's not get into something overly Linux-centric though...
> 
>>> - The "memory-region" property is a phandle to a "reserved-memory"
>>> region, this is not intuitive. If anything, the property should have
>>> been called "reserved-memory-region".
>> 
>> Sure. I don't see the problem, but I have no problem changing it if you
>> feel strongly about it.
> 
> Well it all boils down to whether we turn that whole thing into a way to
> describe arbitrary memory regions (and not just reserved ones), for
> example, CMA stuff as mentioned above doesn't strictly need to be
> reserved, in which case, we would call the whole thing /memory-regions
> and the property could be named the same. In that case we do want a
> specific property however in each region node to indicate whether it
> should be strictly reserved or not.
> 
> But I would argue against that unless we have a very clear use case,
> because it's starting to smell a lot like trying to solve world hunger
> with over engineering :-)
> 
>>> - The way the "compatible" property is documented breaks a basic
>>> premise that the device-tree is a hardware description and not some
>>> convenient way to pass linux specific kernel parameters accross. It is
>>> *ok* to pass some linux specific stuff and to make compromise based on
>>> what a driver generally might expect but the whole business of using
>>> that to describe what to put in CMA is pushing it pretty far ...
>> 
>> I disagree. Originally I had the same reaction, but I've been swayed to
>> the point of view that setting aside regions is actually a pretty
>> hardware-centric thing because it describes how the hardware needs to be
>> used.
> 
> I would still not use the "compatible" property for that. Maybe
> recommended-usage ? Or simply "usage" property with well defined
> semantics ? "reserved" would be one, "consistent-memory" would be
> another (not strictly reserved but thrown into the CMA pool at first
> notice) etc... ?
> 
>> I've already used the example of a framebuffer. It may not stricly
>> be hardware, but it is a description of how the hardware is setup that
>> the kernel should respect. Similarly, the size and placement of CMA
>> regions are more than merely a software parameter because they are
>> defined specifically to support the hardware devices.
> 
> Right and the advantage of using a node with a "reg" property here is
> that a region can actually be made of separate ranges.
> 
>>> - The implementation of early_init_dt_scan_reserved_mem() will not work
>>> on a setup whose /memory node has a unit address (typically /memory@0)
>> 
>> Agreed, that should be fixed. It should work regardless of whether or
>> not the memory node(s) have a unit address.
>> 
>>> Now, I'd like to understand why not use the simpler binding originally
>>> proposed by Jeremy, which had the advantage of proposing a unique name
>>> per region in the traditional form "vendor,name", which then allows
>>> drivers to pick up the region directly if they wish to query, remove or
>>> update it in the tree for example (because they changed the framebuffer
>>> address for example and want kexec to continue working).
>> 
>> Hmmm... I don't follow. How is query/remove/update any more or less
>> difficult between the two approaches? Updating the reg property should
>> be doable in-place with both methods, but finding a specific region
>> associated with a device is explicit in the nodes-and-phandles approach.
>> (unless the 'name' part of vendor,name is an instance name and the
>> device node has a property containing the name; ie "acme,framebuffer1",
>> "acme,framebuffer2", and then in the device node something like:
>> framebuffer-region = "acme,framebuffer2";)
>> 
>>> I don't object to having a node per region, though it seemed unnecessary
>>> at the time, but in any case, the current binding is crap and need to be
>>> fixed urgently before its use spreads.
>> 
>> It seems to me that the 'top-level' objection is the creation of a new
>> binding using a node per region. I think it is warrented. If you
>> disagree strongly then we'll revert the whole series and try again for
>> v3.13. Otherwise I think the other objections are fixable in this cycle.
> 
> No. I don't fundamentally object to using a node per region, it does
> have some advantages indeed as I have mentioned in a few places.
> 
> My main issues are:
> 
> - Documentation of the "memory" binding. This is a separate thing that
> shouldn't have been there and should not document the node without the
> unit address (it's ok to specify I suppose that it can be ommitted
> though I don't like it).
> 
> - Location. I don't want that under /memory. I have to deal with
> machines with multiple /memory nodes and regions potentially straddling
> them.
> 
> - The choice of properties for describing, naming and defining their
> usage. I think we can come to an agreement here.
> 
> In fact the use of a node per region is the *least* of my worries :-)


So where have we gotten on this?

It seems we are in agreement that:
1. reserve memory should be probably be described in nodes
2. it should be pulled out of the memory node and put at root level
3. Use reg to describe the memory regions for a given node

Now to figure out about how to convey usage information for the region and possibly driver association.  I agree with Ben that there are probably cases that an associated device node may not exist so that shouldn't be a hard requirement.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


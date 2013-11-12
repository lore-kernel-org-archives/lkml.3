Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3KLJa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:30:56 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:34662 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab3KLJas convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:30:48 -0500
Subject: Re: [PATCH v3 2/3] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131111184245.D569DC4234A@trevor.secretlab.ca>
Date: Tue, 12 Nov 2013 10:30:37 +0100
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ED51965C-6EC8-48AE-A59C-CD09FFD57731@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com> <20131111184245.D569DC4234A@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 11, 2013, at 7:42 PM, Grant Likely wrote:

> On Fri,  8 Nov 2013 17:06:09 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Introduce DT overlay support.
>> Using this functionality it is possible to dynamically overlay a part of
>> the kernel's tree with another tree that's been dynamically loaded.
>> It is also possible to remove node and properties.
>> 
>> Note that the I2C client devices are 'special', as in they're not platform
>> devices. They need to be registered with an I2C specific method.
>> 
>> In general I2C is just no good platform device citizen and needs
>> special casing.
>> 
>> PCI is another special case where PCI device insertion and removal
>> is implemented in the PCI subsystem.
> 
> Actually. I2C isn't special in this regard; SPI, MDIO, PCI, USB are all
> in the same boat. platform_device just happens to be able to make a few
> assumptions. If anything, platform_device is the 'special' one. :-)
> 

I'm of the opinion that 'platform_device' shouldn't exist at all btw :)
Most of it's functionality can pretty easily be subsumed by device proper
and the world would be a better place :)
 
> In all cases it must be the underlying subsystem that should be
> responsible for creation/removal of devices described in the overlay.
> Sometimes that will extend right down into the individual bus device
> drivers, but it is better if that can be avoided.
> 

Yes, that's the right way to handle this, but we're talking about 
serious modification in almost every kind of device core.

Just getting the basic concept of overlays in is hard without having
to tackle something like this.

In the future, I'd be ecstatic if we could get a per device class
filter, but it's nothing we can fix right now.

IMHO of course.

>> 
>> Bug fixes & PCI support by Guenter Roeck <groeck@juniper.net>
>> 

[snip]

>> +so a bar platform device will be registered and if a matching device driver
>> +is loaded the device will be created as expected.
>> +
>> +Overlay in-kernel API
>> +---------------------
>> +
>> +The steps typically required to get an overlay to work are as follows:
>> +
>> +1. Use of_build_overlay_info() to create an array of initialized and
>> +ready to use of_overlay_info structures.
>> +2. Call of_overlay() to apply the overlays declared in the array.
>> +3. If the overlay needs to be removed, call of_overlay_revert().
>> +4. Finally release the memory taken by the overlay info array by
>> +of_free_overlay_info().
> 
> Make of_overlay_info a kobject and use a release method to free it when
> all users go away. Freeing directly is a dangerous thing to do.
> 

It's more dangerous than even that. We also have the mess with the way
unflattening works (properties point directly to binary blob area
with no way to free per property data). In general freeing/releasing
device tree nodes is tricky on a good day.

I agree we have to move to a kobject model eventually. 

>> +
>> +/**
>> + * of_build_overlay_info	- Build an overlay info array
>> + * @tree:	Device node containing all the overlays
>> + * @cntp:	Pointer to where the overlay info count will be help
>> + * @ovinfop:	Pointer to the pointer of an overlay info structure.
>> + *
>> + * Helper function that given a tree containing overlay information,
>> + * allocates and builds an overlay info array containing it, ready
>> + * for use using of_overlay.
>> + *
>> + * Returns 0 on success with the @cntp @ovinfop pointers valid,
>> + * while on error a negative error value is returned.
>> + */
>> +int of_build_overlay_info(struct device_node *tree,
>> +		int *cntp, struct of_overlay_info **ovinfop);
>> +
>> +/**
>> + * of_free_overlay_info	- Free an overlay info array
>> + * @count:	Number of of_overlay_info's
>> + * @ovinfo_tab:	Array of overlay_info's to free
>> + *
>> + * Releases the memory of a previously allocate ovinfo array
>> + * by of_build_overlay_info.
>> + * Returns 0, or an error if the arguments are bogus.
>> + */
>> +int of_free_overlay_info(int count, struct of_overlay_info *ovinfo_tab);
>> +
>> +/**
>> + * of_overlay	- Apply @count overlays pointed at by @ovinfo_tab
>> + * @count:	Number of of_overlay_info's
>> + * @ovinfo_tab:	Array of overlay_info's to apply
>> + *
>> + * Applies the overlays given, while handling all error conditions
>> + * appropriately. Either the operation succeeds, or if it fails the
>> + * live tree is reverted to the state before the attempt.
>> + * Returns 0, or an error if the overlay attempt failed.
>> + */
>> +int of_overlay(int count, struct of_overlay_info *ovinfo_tab);
>> +
>> +/**
>> + * of_overlay_revert	- Revert a previously applied overlay
>> + * @count:	Number of of_overlay_info's
>> + * @ovinfo_tab:	Array of overlay_info's to apply
>> + *
>> + * Revert a previous overlay. The state of the live tree
>> + * is reverted to the one before the overlay.
>> + * Returns 0, or an error if the overlay table is not given.
>> + */
>> +int of_overlay_revert(int count, struct of_overlay_info *ovinfo_tab);
>> +
>> +Overlay DTS Format
>> +------------------
>> +
>> +The DTS of an overlay should have the following format:
>> +
>> +{
>> +	/* ignored properties by the overlay */
>> +
>> +	fragment@0 {	/* first child node */
>> +		target=<phandle>;	/* target of the overlay */
>> +		__overlay__ {
>> +			property-a;	/* add property-a to the target */
>> +			-property-b;	/* remove property-b from target */
>> +			node-a {	/* add to an existing, or create a node-a */
>> +				...
>> +			};
>> +			-node-b {	/* remove an existing node-b */
>> +				...
>> +			};
> 
> Are the node & property removals reversable? What about property
> modifications? If they are not, then it would be better to not support
> removals at all for now. Otherwise we'll end up with overlays that
> cannot be removed and I don't want to inadvertently put users into that
> situation.

Yes, everything is reversible. Doesn't mean that the drivers/driver core
can handle it. Using overlays is an excellent way to trigger bugs in
device removal as I've found out :)

> 
>> +		};
>> +	}
>> +	fragment@1 {	/* second child node */
>> +		...
>> +	};
>> +	/* more fragments follow */
>> +}

[snip]

>> +
>> +static int of_overlay_device_entry_change(struct of_overlay_info *ovinfo,
>> +		struct of_overlay_device_entry *de, int revert)
>> +{
> 
> I've got big problems here. This is entirely the wrong place to create
> and delete devices. Each subsystem needs to create and remove its own
> device types. To begin with, only the subsystem knows which busses are
> appropriate for creating child devices.
> 

It was the best I could under the circumstances, without having to touch
every subsystem.


> Second, it is incorrect to create a platform_device for every single
> node by default. Some nodes aren't devices at all. Just looking for a
> compatible property isn't sufficient either.
> 

Yep. 

> The solution here is for each subsystem to have it's own notifier, and
> only create a child device if the changed node has a parent the
> subsystem already knows about (because it's already populated device
> tree devices from that parent). This is also true for platform_devices.
> 
> Finally, sometimes the tips of the tree will get populated, but not
> until after some parent nodes have been delt with. In that case the
> creation of devices needs to be deferred back to the driver for the
> parent bus.
> 

Well, any solution that requires each and every subsystem to do dynamic
child insertions/removal is going to be hard sell.

What about something more gentle?

For example, I know that most of the cases fall into a couple of set
patterns for my case

a) Target is the ocp node (on chip peripheral node) and results in
the creation of platform devices under that node.

b) Target is one of the disabled devices under the ocp node
and the status property is modified, plus optional nodes are
added that result in the creation of more devices under the bus this
node controls. This is the case of enabled an I2C/SPI bus and inserting
children devices.

Perhaps the trick is having hooks about what to do in case certain
nodes are modified in a certain way, i.e. a notifier on the ocp node
would 'catch' those. The problem is a having a way to present this
information to the notifier in a way that's easy to be handled.

What do you think?

>> +
>> +/**
>> + * Revert one overlay
>> + * Either due to an error, or due to normal overlay removal.
>> + * Using the log entries, we revert any change to the live tree.
>> + * In the same manner, using the device entries we enable/disable
>> + * the platform devices appropriately.
>> + */
>> +static void of_overlay_revert_one(struct of_overlay_info *ovinfo)
>> +{
>> +	struct of_overlay_device_entry *de, *den;
>> +	struct of_overlay_log_entry *le, *len;
>> +	struct property *prop, **propp;
>> +	int ret;
>> +	unsigned long flags;
>> +
>> +	if (!ovinfo || !ovinfo->target || !ovinfo->overlay)
>> +		return;
>> +
>> +	pr_debug("%s: Reverting overlay on '%s'\n", __func__,
>> +			ovinfo->target->full_name);
>> +
>> +	/* overlay applied correctly, now create/destroy pdevs */
>> +	list_for_each_entry_safe_reverse(de, den, &ovinfo->de_list, node) {
>> +		of_overlay_device_entry_change(ovinfo, de, 1);
>> +		of_node_put(de->np);
>> +		list_del(&de->node);
>> +		kfree(de);
>> +	}
> 
> Can overlays interact in bad ways? If overlay 1 is installed before
> overlay 2, what happens if overlay 1 is removed?
> 

Yes, they can. It is not something easily fixed; the proper way would
be to calculate overlay intersection points and refuse to unload.

> Okay, my brain is tired. It's a complicated series and I don't see any
> obvious bits that can be split off and be independently useful. I would
> *really* like to see some test cases for this functionality. It's
> complicated enough to make me quite nervous.... in fact I would really
> like to see drivers/of/selftest.c become an early user of overlays. That
> would make the DT selftests executable on any platform.
> 

OK, I see your point. My brain is tired too, and I'm on travel too for
this week and the next. I'll see what I can come up with.

> g.
> 

Regards

-- Pantelis


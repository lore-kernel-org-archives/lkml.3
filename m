Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3CUMts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:49:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:49333 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab3CUMtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:49:47 -0400
Message-ID: <1363870176.17680.33.camel@pasglop>
Subject: Re: [PATCH V2 1/2] of: Make device nodes kobjects so they show up
 in sysfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, davem@davemloft.net
Date: Thu, 21 Mar 2013 13:49:36 +0100
In-Reply-To: <1363865097-32764-2-git-send-email-grant.likely@secretlab.ca>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
	 <1363865097-32764-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
> Device tree nodes are already treated as objects, and we already want to
> expose them to userspace which is done using the /proc filesystem today.
> Right now the kernel has to do a lot of work to keep the /proc view in
> sync with the in-kernel representation. If device_nodes are switched to
> be kobjects then the device tree code can be a whole lot simpler. It
> also turns out that switching to using /sysfs from /proc results in
> smaller code and data size, and the userspace ABI won't change if
> /proc/device-tree symlinks to /sys/device-tree

Here you say /sys/device-tree

> +What:		/sys/firmware/ofw/../device-tree/

Here you say /sys/firmware/../device-tree/ ... (wtf are those .. ?)

And further down:

	proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");

Some confusion here ... at least _I_ am confused :-)

Then, you do this:

> +static bool of_init_complete = false;

The above requires some explanations

> +static int __of_node_add(struct device_node *np)
> +{
> +
> +	const char *name;
> +	struct property *pp;
> +	static int extra = 0;
> +	int rc;
> +
> +	np->kobj.kset = of_kset;
> +	if (!np->parent) {
> +		/* Nodes without parents are new top level trees */
> +		rc = kobject_add(&np->kobj, NULL, "device-tree-%i", extra++);
> +#if !defined(CONFIG_PROC_DEVICETREE)
> +		/* Symlink to the new tree when PROC_DEVICETREE is disabled */
> +		if (!rc && extra == 1)
> +			proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");
> +#endif /* CONFIG_PROC_DEVICETREE */

WTF is this business of having multiple top level trees ? Also that
local static extra is gross. What is this all about ?
 
> +	} else {
> +		name = kbasename(np->full_name);
> +		if (!name || !name[0])
> +			return -EINVAL;
> +		rc = kobject_add(&np->kobj, &np->parent->kobj, "%s", name);
> +	}
> +	if (rc)
> +		return rc;
> +
> +	for_each_property_of_node(np, pp) {
> +		/* Important: Don't leak passwords */
> +		bool secure = strncmp(pp->name, "security-", 9) == 0;
> +
> +		pp->attr.attr.name = pp->name;
> +		pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
> +		pp->attr.size = secure ? 0 : pp->length;
> +		pp->attr.read = of_node_property_read;
> +		rc = sysfs_create_bin_file(&np->kobj, &pp->attr);
> +		WARN(rc, "error creating device node attribute\n");

Might want some better message (attribute name, node path, ...)

We have mechanisms to deal with collisions in proc devicetree that you
don't seem to have here (or am I missing something ?). The main source
of pain is a property and a child node having the same name (happens
regulary with l2-cache on macs for example).

Cheers,
Ben.



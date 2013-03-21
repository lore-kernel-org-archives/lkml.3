Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CUUcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:32:06 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52413 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3CUUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363870176.17680.33.camel@pasglop>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
 <1363865097-32764-2-git-send-email-grant.likely@secretlab.ca> <1363870176.17680.33.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Mar 2013 20:31:43 +0000
X-Google-Sender-Auth: sMzykEjLZkmPciLV0IKpbuBVUMo
Message-ID: <CACxGe6vv1Own_HFRL3LEv7XW0ycNb2xm53kM9t8TgHj=XFEKeQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] of: Make device nodes kobjects so they show up in sysfs
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:49 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
>> Device tree nodes are already treated as objects, and we already want to
>> expose them to userspace which is done using the /proc filesystem today.
>> Right now the kernel has to do a lot of work to keep the /proc view in
>> sync with the in-kernel representation. If device_nodes are switched to
>> be kobjects then the device tree code can be a whole lot simpler. It
>> also turns out that switching to using /sysfs from /proc results in
>> smaller code and data size, and the userspace ABI won't change if
>> /proc/device-tree symlinks to /sys/device-tree
>
> Here you say /sys/device-tree

That's a typo

>
>> +What:                /sys/firmware/ofw/../device-tree/
>
> Here you say /sys/firmware/../device-tree/ ... (wtf are those .. ?)

See below... although I forgot to come back here and fix up the ABI
document after I fixed up the multiple trees stuff, so the above line
is a defect in the patch.

>
> And further down:
>
>         proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");
>
> Some confusion here ... at least _I_ am confused :-)
>
> Then, you do this:
>
>> +static bool of_init_complete = false;
>
> The above requires some explanations

I'll add a description to the patch here. What is happening is that
the device tree is unflattened well before the firmware kobject is
created. The of_init() function was created to loop over all the known
device_nodes and register them at core_initcall() time. The
of_init_complete flag is the holdoff mechanism, but looking at it
again the code can simply check to see if of_kset is NULL to decide
whether or not to call kobject_add()

>
>> +static int __of_node_add(struct device_node *np)
>> +{
>> +
>> +     const char *name;
>> +     struct property *pp;
>> +     static int extra = 0;
>> +     int rc;
>> +
>> +     np->kobj.kset = of_kset;
>> +     if (!np->parent) {
>> +             /* Nodes without parents are new top level trees */
>> +             rc = kobject_add(&np->kobj, NULL, "device-tree-%i", extra++);
>> +#if !defined(CONFIG_PROC_DEVICETREE)
>> +             /* Symlink to the new tree when PROC_DEVICETREE is disabled */
>> +             if (!rc && extra == 1)
>> +                     proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");
>> +#endif /* CONFIG_PROC_DEVICETREE */
>
> WTF is this business of having multiple top level trees ? Also that
> local static extra is gross. What is this all about ?

Separate trees has been supported for a while now. The Xilinx folks
have used it for describing FPGA configurations on add-in boards that
are populated at runtime. 'extra' was trivial way to make sure each
top level tree gets a unique directory name. Yeah, it's not the most
elegant thing in the world. I wrote that as a placeholder until I've
got a better idea of how multiple top level trees should be arranged.
I want to take another look at how the devicetree overlay patches
before settling on this.

BTW, that is part of the reason why the ABI document states userspace
should be using /proc/device-tree to access the tree. The location of
the 'system' device tree may need to be moved.

>
>> +     } else {
>> +             name = kbasename(np->full_name);
>> +             if (!name || !name[0])
>> +                     return -EINVAL;
>> +             rc = kobject_add(&np->kobj, &np->parent->kobj, "%s", name);
>> +     }
>> +     if (rc)
>> +             return rc;
>> +
>> +     for_each_property_of_node(np, pp) {
>> +             /* Important: Don't leak passwords */
>> +             bool secure = strncmp(pp->name, "security-", 9) == 0;
>> +
>> +             pp->attr.attr.name = pp->name;
>> +             pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
>> +             pp->attr.size = secure ? 0 : pp->length;
>> +             pp->attr.read = of_node_property_read;
>> +             rc = sysfs_create_bin_file(&np->kobj, &pp->attr);
>> +             WARN(rc, "error creating device node attribute\n");
>
> Might want some better message (attribute name, node path, ...)

Hahaha. I think I cut and paste that from somewhere. Yeah I can fix that up.

> We have mechanisms to deal with collisions in proc devicetree that you
> don't seem to have here (or am I missing something ?). The main source
> of pain is a property and a child node having the same name (happens
> regulary with l2-cache on macs for example).

I missed those. Will be fixed for v3

g.

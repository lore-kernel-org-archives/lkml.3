Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaHUMMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:12:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65439 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbaHUMME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:12:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: German Rivera <German.Rivera@freescale.com>
Subject: Re: [RFC PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc) bus driver
Date: Thu, 21 Aug 2014 13:30:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stuart.yoder@freescale.com, linuxppc-release@linux.freescale.net
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com> <3344352.Av1d0tahxM@wuerfel> <53F3B8EA.6070609@freescale.com>
In-Reply-To: <53F3B8EA.6070609@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201408211330.20869.arnd@arndb.de>
X-Provags-ID: V02:K0:cWliYQuSI3EMM5hZjXf2HBUTbBHi/TRYI0wDKF+yX7c
 FMhD1K3lQ6Gewlb/Z83oz0z+l7czcaJCnhROcMS6KUtET5WJ8f
 eAP1GCA+58sOQdP4acNGVlswdHa4OCAzs/AReqUw84P3XVkG6C
 3guIpU+HjN1p+7F3hqLo79H9nfzg+rQEQS+bBhOvz2EkDo8jYE
 IPgDh8M9IxXLZ0xH/rTgNfsIGeHW7d5mksGBaV+BTOleYH4P5W
 TAosCRDWsglj+5AP2DjgzJxuIAPAJ4y4Q05XWyD+ZezdqyuCxA
 ldHePpYHQnp0KyQoyHM0ESnl3q+kHyEaoT54ijbxqDYrBx2QgN
 wAyicZHofJCki2agRNjprvYyxwpCmmoCCkaRkkWJo
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2014, German Rivera wrote:
> >> + * @dev_node: Node in the container's child list
> >
> > Same here: just use the device model's list management instead if you can,
> > or explain why this is needed.
> >
> We still need to keep a per-bus list of child devices (devices contained 
> in a given DPRC object). Unless I'm missing something,
> I think the device model's list management links together all the 
> devices of the same bus type. We are trying to follow a similar approach 
> to the pci_dev/pci_bus structs.

There are multiple lists in the device handling. device_for_each_child()
should iterate over the children of a particular device using the
klist_children member.

> >> +/**
> >> + * struct fsl_mc_dprc - Data Path Resource Container (DPRC) object
> >> + * @magic: marker to verify identity of this structure
> >> + * @mc_dev: pointer to MC object device object for this DPRC
> >> + * @mutex: mutex to serialize access to the container.
> >> + * @child_device_count: have the count of devices in this DPRC
> >> + * @child_list:     anchor node of list of child devices on this DPRC
> >> + */
> >> +struct fsl_mc_dprc {
> >> +#   define FSL_MC_DPRC_MAGIC   FSL_MC_MAGIC('D', 'P', 'R', 'C')
> >> +    uint32_t magic;
> >> +    struct fsl_mc_device *mc_dev;
> >> +    struct mutex mutex;     /* serializes access to fields below */
> >> +    uint16_t child_device_count;    /* Count of devices in this DPRC */
> >> +    struct list_head child_list;
> >> +};
> >
> > It's not clear what this represents to me. mc_dev presumably already
> > has a list of children, so why not just use a pointer to mc_dev
> > and remove this structure entirely?
> >
> This structure represents the per-bus (per DPRC object) information.
> It is kind of the equivalent to 'struct pci_bus' in the PCI world.
> I have renamed this struct to 'struct fsl_mc_bus'.

Ok, I'll look at the new version when I get back to Germany. I still think
that can remove all members of the current structure and just use the
same structure for fsl_mc_bus and fsl_mc_device. If you really need
a small number of extra members beyond what is in the device, you have
two other choices:

a) put the members into the device structure as well but not use them
   for a device that is not a bus

b) embed the device structure within the bus structure like

	struct fsl_mc_bus {
		int something;
		struct fsl_mc_device;
	};

and then use container_of() to go from the device to the bus where needed
rather than having two objects that are allocated separately. This is
what a lot of other subsystems (not PCI) do. See for instance
platform_device, which often has child devices as well.

	Arnd

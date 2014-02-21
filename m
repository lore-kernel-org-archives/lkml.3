Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaBULs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:48:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36696 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbaBULsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:48:25 -0500
Date: Fri, 21 Feb 2014 11:48:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alistair Popple <alistair@popple.id.au>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the
 ehci-platform driver
Message-ID: <20140221114803.GB8783@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392964293-13687-5-git-send-email-alistair@popple.id.au>
Thread-Topic: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the
 ehci-platform driver
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Tony Prisk to Cc]

On Fri, Feb 21, 2014 at 06:31:30AM +0000, Alistair Popple wrote:
> Currently the ppc-of driver uses the compatibility string
> "usb-ehci". This means platforms that use device-tree and implement an
> EHCI compatible interface have to either use the ppc-of driver or add
> a compatible line to the ehci-platform driver. It would be more
> appropriate for the platform driver to be compatible with "usb-ehci"
> as non-powerpc platforms are also beginning to utilise device-tree.
>
> This patch merges the device tree property parsing from ehci-ppc-of
> into the platform driver and adds a "usb-ehci" compatibility
> string. The existing ehci-ppc-of driver is removed and the 440EPX
> specific quirks are added to the ehci-platform driver.
>
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> ---
>  drivers/usb/host/Kconfig         |    7 +-
>  drivers/usb/host/ehci-hcd.c      |    5 -
>  drivers/usb/host/ehci-platform.c |   87 +++++++++++++-
>  drivers/usb/host/ehci-ppc-of.c   |  238 --------------------------------------
>  4 files changed, 89 insertions(+), 248 deletions(-)
>  delete mode 100644 drivers/usb/host/ehci-ppc-of.c

[...]

> +       /* Device tree properties if available will override platform data. */
> +       dn = hcd_to_bus(hcd)->controller->of_node;
> +       if (dn) {
> +               if (of_get_property(dn, "big-endian", NULL)) {
> +                       ehci->big_endian_mmio = 1;
> +                       ehci->big_endian_desc = 1;
> +               }
> +               if (of_get_property(dn, "big-endian-regs", NULL))
> +                       ehci->big_endian_mmio = 1;
> +               if (of_get_property(dn, "big-endian-desc", NULL))
> +                       ehci->big_endian_desc = 1;
> +       }

Please use of_property_read_bool for these.

This driver already handles "via,vt8500-ehci" and "wm,prizm-ehci" which
aren't documented to handle these properties, but now gain support for
them. It might be worth unifying the binding documents if there's
nothing special about those two host controllers.

We seem to have two binding documents for "via,vt8500-ehci", so some
cleanup is definitely in order.

Tony, you seem to have written both documents judging by 95e9fd10f06c
and 8ad551d150e3. Do you have any issue with merging both of these into
a common usb-ehci document?

> +
> +       np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
> +       if (np != NULL) {
> +               /* claim we really affected by usb23 erratum */
> +               if (!of_address_to_resource(np, 0, &res))
> +                       ehci->ohci_hcctrl_reg =
> +                               devm_ioremap(&pdev->dev,
> +                                            res.start + OHCI_HCCTRL_OFFSET,
> +                                            OHCI_HCCTRL_LEN);
> +               else
> +                       ehci_dbg(ehci, "%s: no ohci offset in fdt\n", __FILE__);
> +               if (!ehci->ohci_hcctrl_reg) {
> +                       ehci_dbg(ehci, "%s: ioremap for ohci hcctrl failed\n",
> +                               __FILE__);
> +               } else {
> +                       ehci->has_amcc_usb23 = 1;
> +               }
> +       }

As this is being dropped into a generic driver, it would be nice to have
a comment explaining why we need to do this -- not everyone using this
will know the powerpc history. It certainly seems odd to look for
another node in the tree that this driver isn't necessarily handling,
and that should probably be explained.

As this bit of fixup is only needed for powerpc, it would be nice to not
have to do it elsewhere. Perhaps these could be factored out into a
ppc_platform_reset function that could be empty stub for other
architectures.

> +
> +       if (of_device_is_compatible(dn, "ibm,usb-ehci-440epx")) {
> +               retval = ppc44x_enable_bmt(dn);
> +               ehci_dbg(ehci, "Break Memory Transfer (BMT) is %senabled!\n",
> +                       retval ? "NOT " : "");
> +       }
> +

Likewise.

[...]

> +       /* use request_mem_region to test if the ohci driver is loaded.  if so
> +        * ensure the ohci core is operational.
> +        */

Nit: comment code style (should have a newline after the /* according to
Documentation/CodingStyle).

> +       if (ehci->has_amcc_usb23) {
> +               np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
> +               if (np != NULL) {
> +                       if (!of_address_to_resource(np, 0, &res))
> +                               if (!request_mem_region(res.start,
> +                                                           0x4, hcd_name))
> +                                       set_ohci_hcfs(ehci, 1);
> +                               else
> +                                       release_mem_region(res.start, 0x4);
> +                       else
> +                               ehci_dbg(ehci, "%s: no ohci offset in fdt\n",
> +                                       __FILE__);
> +                       of_node_put(np);
> +               }
> +       }

As with the earlier comment, this looks a bit odd. A comment explaining
why we're looking for another node would help. Also, we should only need
this for powerpc.

Cheers,
Mark.

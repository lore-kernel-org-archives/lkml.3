Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaBUOVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:21:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaBUOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:21:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alistair Popple <alistair@popple.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the ehci-platform driver
Date: Fri, 21 Feb 2014 15:21:32 +0100
Message-ID: <9352625.f2QvCl1mNy@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140221114803.GB8783@e106331-lin.cambridge.arm.com>
References: <20140221114803.GB8783@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nOMo/WhATBFPxvkZ51KIL89xsBW+0GYbpBW1VPwvNSe
 BMi3jHgCaBVGzRc4Rn4n3Qh2IxdxH2HvP5cpZXQCABdFJcgo5e
 QglJiEUaBrbTkTPZeSQYs8LZFO8eEcXuatuS9RbLed49M3lg+E
 aASLh74X1+ayXTsL+Byb516DMKSMT6XcseBEhVx/ZzMR+Z6Vfp
 MqbimgOWLOpVfhJVQDYSSCLttd+rpyFep3x0y2+4LgFELVtWRH
 jMiDnfe2NmNo1oWTf1TOF6SBSmq3OgNB1Qd2zco5mCwYwzyWaJ
 OKeqVaU72p7qFLzAuV46cyVlxEx/i0WudMlPgjM1+TnFIr5IeK
 l5/ir1lTyIZGYIDYBUn8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 11:48:03 Mark Rutland wrote:
> > +
> > +       np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
> > +       if (np != NULL) {
> > +               /* claim we really affected by usb23 erratum */
> > +               if (!of_address_to_resource(np, 0, &res))
> > +                       ehci->ohci_hcctrl_reg =
> > +                               devm_ioremap(&pdev->dev,
> > +                                            res.start + OHCI_HCCTRL_OFFSET,
> > +                                            OHCI_HCCTRL_LEN);
> > +               else
> > +                       ehci_dbg(ehci, "%s: no ohci offset in fdt\n", __FILE__);
> > +               if (!ehci->ohci_hcctrl_reg) {
> > +                       ehci_dbg(ehci, "%s: ioremap for ohci hcctrl failed\n",
> > +                               __FILE__);
> > +               } else {
> > +                       ehci->has_amcc_usb23 = 1;
> > +               }
> > +       }
> 
> As this is being dropped into a generic driver, it would be nice to have
> a comment explaining why we need to do this -- not everyone using this
> will know the powerpc history. It certainly seems odd to look for
> another node in the tree that this driver isn't necessarily handling,
> and that should probably be explained.
> 
> As this bit of fixup is only needed for powerpc, it would be nice to not
> have to do it elsewhere. Perhaps these could be factored out into a
> ppc_platform_reset function that could be empty stub for other
> architectures.

How about using the .data field of the of_device_id array to point to
a structure of functions? That way you don't even have to call
of_device_is_compatible() here. Note that using of_find_compatible_node()
is the wrong approach anyway, you want to check the current device
for compatibility, not just any device I assume.

	Arnd

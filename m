Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3JCSdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:33:37 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:7955
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab3JCSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:33:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1454I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380825207.12932.151.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Thu, 3 Oct 2013 13:33:27 -0500
In-Reply-To: <20131002234009.GA27714@kroah.com>
References: <20131002015355.GD63102@lvm>
	 <1380681356.14271.57.camel@ul30vt.home> <20131002151413.GG63102@lvm>
	 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
	 <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 16:40 -0700, gregkh@linuxfoundation.org wrote:
> On Wed, Oct 02, 2013 at 04:35:15PM -0500, Scott Wood wrote:
> > On Wed, 2013-10-02 at 14:16 -0700, gregkh@linuxfoundation.org wrote:
> > > On Wed, Oct 02, 2013 at 04:08:41PM -0500, Scott Wood wrote:
> > > > I don't see any equivalent functionality to PCI_ANY_ID for platform
> > > > devices.
> > > 
> > > Nor should it.  If you are wanting to bind platform devices to different
> > > things based on "ids" or "strings" or something else, then you had
> > > better not be using a platform device because that is not what you have
> > > anymore.
> > 
> > I don't see how anything could be considered a platform device under
> > your definition.
> 
> Devices that you just "know" are at a specific memory location ahead of
> time.
>
> > Even before all the device tree stuff came along,
> > platform devices were still bound based on strings.
> 
> Not all of them, there are lots that are not, look at ISA devices on a
> PC platform for one example (your pc speaker, keyboard controller,
> etc.)

Using platform devices to let board files provide this information to
driver files was a big improvement over hacking up the drivers directly
to know about all sorts of different boards/SoCs.  Once you split that
knowledge into a different place you need a way of matching the two.

BTW, this is done with the pc speaker as far as I can tell --
arch/x86/kernel/pcspeaker.c registers a device using the string
"pcspkr" (as do some non-PC platforms).

> > And even if we did still have a separate OF platform bus, my point about
> > there not being a wildcard match applies to of_device_id as well.  It
> > certainly is not the case that "this is already there, and has been for
> > years with no problems".
> 
> That's an OF problem then, feel free to fix it there, but not in the
> driver core with a crazy "ignore this bus type string" hack :)

Even if we did this for OF and ACPI, you'd still have a problem if you
want to use VFIO with a platform device that only has plain old
platform data; thus, the platform bus (not driver core) seems to be the
appropriate place for a wildcard match if we end up needing it.  It may
be moot though, since for platform devices we may want explicit kernel
support for a device even with vfio, in order to reset/quiesce it
between users.

What it looks like we do still want from the driver core is the ability
for a driver to say that it should not be bound to a device except via
explicit sysfs bind, and the ability for a user to say that a device
should not be bound to a driver except via explicit sysfs bind.  This is
a separate issue from making driver_match_device() happy (in some
earlier e-mails in the thread these two issues were not properly
separated).

-Scott




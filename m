Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaLHJzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:55:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbaLHJzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:55:08 -0500
Message-ID: <1418032501.27021.42.camel@nilsson.home.kraxel.org>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
From: Gerd Hoffmann <kraxel@redhat.com>
To: Jike Song <jike.song@intel.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Date: Mon, 08 Dec 2014 10:55:01 +0100
In-Reply-To: <5482835F.5090707@intel.com>
References: <547FC5DE.4010701@intel.com>
	 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
	 <5482835F.5090707@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2014-12-06 at 12:17 +0800, Jike Song wrote:
> On 12/05/2014 04:50 PM, Gerd Hoffmann wrote:
> > A few comments on the kernel stuff (brief look so far, also
> > compile-tested only, intel gfx on my test machine is too old).
> >
> >   * Noticed the kernel bits don't even compile when configured as
> >     module.  Everything (vgt, i915, kvm) must be compiled into the
> >     kernel.
> 
> Yes, that's planned to be done along with separating hypervisor-related
> code from vgt.

Good.

> > What are the exact requirements for the device?  Must it match the host
> > exactly, to not confuse the guest intel graphics driver?  Or would
> > something more recent -- such as the q35 emulation qemu has -- be good
> > enough to make things work (assuming we add support for the
> > graphic-related pci config space registers there)?
> >
> 
> I don't know that is exactly needed, we also need to have Windows
> driver considered.  However, I'm quite confident that, if things gonna
> work for IGD passthrough, it gonna work for GVT-g.

I'd suggest to focus on q35 emulation.  q35 is new enough that a version
with integrated graphics exists, so the gap we have to close is *much*
smaller.

In case guests expect a northbridge matching the chipset generation of
the graphics device (which I'd expect is the case, after digging a bit
in the igd and agpgart linux driver code) I think we should add proper
device emulation for them, i.e. comply q35-pcihost with
sandybridge-pcihost + ivybridge-pcihost + haswell-pcihost instead of
just copying over the pci ids from the host.  Most likely all those
variants can share most of the emulation code.

SeaBIOS then can just get support for these three northbridge variants,
so we don't need magic pci id switching hacks at all.

> > The patch also adds a dummy isa bridge at 0x1f.  Simliar question here:
> > What exactly is needed here?  Would things work if we simply use the q35
> > lpc device here?

> Ditto.

Ok.  Lets try to just use the q35 emulation + q35 lpc device then
instead of adding a second dummy lpc device.

cheers,
  Gerd



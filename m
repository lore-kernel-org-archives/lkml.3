Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaGJMiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:38:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55528 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbaGJMiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:38:21 -0400
Date: Thu, 10 Jul 2014 13:38:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140710123824.GN2449@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140709134050.GN9485@arm.com>
 <20140709142125.GB3262@ulmo>
 <20140709181048.GX9485@arm.com>
 <20140710094909.GA21583@ulmo>
 <20140710102334.GG2449@arm.com>
 <20140710105737.GD21583@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710105737.GD21583@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:57:38AM +0100, Thierry Reding wrote:
> On Thu, Jul 10, 2014 at 11:23:34AM +0100, Will Deacon wrote:
> > On Thu, Jul 10, 2014 at 10:49:10AM +0100, Thierry Reding wrote:
> > > On Wed, Jul 09, 2014 at 07:10:48PM +0100, Will Deacon wrote:
> > > > On Wed, Jul 09, 2014 at 03:21:27PM +0100, Thierry Reding wrote:
> > > > > Anything beyond that (e.g. logical grouping of masters) isn't directly
> > > > > within the scope of the binding (it doesn't describe hardware but some
> > > > > policy pertaining to some specific use-case).
> > > > 
> > > > This *is* for hardware. I can use PCI as an example, but this could equally
> > > > apply to other types of bus. If you have a bunch of PCI master devices
> > > > sitting being a non-transparent bridge, they can end up sharing the same
> > > > master device ID (requester ID). This means that there is no way in the
> > > > IOMMU to initialise a translation for one of these devices without also
> > > > affecting the others. We currently have iommu_groups to deal with this, but
> > > > it *is* a property of the hardware and we absolutely need a way to describe
> > > > it. I'm happy to add it later, but we need to think about it now to avoid
> > > > merging something that can't easily be extended.
> > > > 
> > > > For PCI, the topology is probable but even then, we need this information to
> > > > describe the resulting master device ID emitted by the bridge for the
> > > > upstream group. One way to do this with your binding would be to treat all
> > > > of the upstream masters as having the same device ID.
> > > 
> > > Yes, I think that makes most sense. After all from the IOMMU's point of
> > > view requests from all devices behind the bridge will originate from the
> > > same ID.
> > > 
> > > So technically it's not really correct to encode the master ID within
> > > each of the devices, but rather they should be inheriting the ID from
> > > the non-transparent bridge.
> > 
> > Indeed. Is that possible with your binding, or would we just duplicate the
> > IDs between the masters?
> 
> No, the binding only describes direct relationships between the IOMMU
> and masters. There's no way to translate them inbetween or inherit them.

[...]

> ? That way some code could walk up the IOMMU tree to resolve this. Or
> perhaps even easier:
> 
> 	iommu {
> 		#iommu-cells = <1>;
> 	};
> 
> 	bridge {
> 		iommus = <&/iommu 42>;
> 
> 		device@0 {
> 			...
> 		};
> 
> 		device@1 {
> 			...
> 		};
> 
> 		...
> 	};

Yes, I like that. Good thinking!

> And we could enhance the binding by defining that the iommus node is
> inherited by devices on a bus, which by what you're saying would be the
> sensible thing to do anyway.
> 
> In the second example above, the presence of an iommus property in the
> bridge would indicate that it's non-transparent regarding IOMMU
> translation and therefore the master ID should be inherited. Devices
> could still override by providing their own iommus property, though I'd
> be a little surprised if there ever was hardware like that.
> 
> > > > With virtualisation, we may want to assign a group of devices to a guest but
> > > > without emulating the bridge. This would need something the device-tree to
> > > > describe that they are grouped together.
> > > 
> > > But that's also a software decision, isn't it? Virtualization doesn't
> > > have anything to do with the hardware description. Or am I missing
> > > something? Of course I guess you could generate a DTB for the guest and
> > > group device together, in which case you're pretty much free to do what
> > > you want since you're essentially defining your own hardware.
> > 
> > If you're doing device passthrough and you want to allow the guest to
> > program the IOMMU, I think that virtualisation is directly related to the
> > hardware description, since the guest will be bound by physical properties
> > of the system.
> 
> Evidently you know much better what the requirements are here and what
> will actually be required. I guess we'll need to have more discussions
> along with examples of use-cases.

It's still early days for getting this stuff up and running on ARM, so I
agree that we'll have to come back to it a few times once we've got concrete
examples and code.

Will

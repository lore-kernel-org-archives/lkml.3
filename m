Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3HSUxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:53:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39471 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3HSUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:53:41 -0400
Message-ID: <521285D1.2050500@wwwdotorg.org>
Date: Mon, 19 Aug 2013 14:53:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
References: <1376685563-1053-1-git-send-email-treding@nvidia.com> <1376685563-1053-3-git-send-email-treding@nvidia.com> <20130816210637.GC2198@kroah.com> <20130816215530.GA14464@mithrandir> <20130816220807.GA6848@kroah.com> <20130817111747.GB1536@mithrandir> <5212757F.2080107@wwwdotorg.org> <20130819201042.GB5191@mithrandir>
In-Reply-To: <20130819201042.GB5191@mithrandir>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:10 PM, Thierry Reding wrote:
> On Mon, Aug 19, 2013 at 01:43:59PM -0600, Stephen Warren wrote:
>> On 08/17/2013 05:17 AM, Thierry Reding wrote: ...
>>> Well, the most obvious cases where early initialization is
>>> needed are interrupt controllers and clocks.
>> 
>> ... and IOMMUs, which apparently need to initialize before any
>> devices whose transactions are routed through the IOMMU, in order
>> to set themselves up as the IOMMU for the relevant devices.
>> 
>> It's possible that the CPU-visible bus structure isn't a strict 
>> inverse/reverse of the device-visible bus-structure. A device may
>> have CPU-visible registers on one bus segment, but inject master 
>> transactions onto an unrelated bus segment. So it may not be as
>> simple as making a bus driver for the bus segment affected by the
>> IOMMU, and having that driver trigger instantiation of all its
>> children.
> 
> Well, perhaps that can be handled via deferred probing? The only
> thing preventing that right now is that drivers aren't actively
> aware of the IOMMUs existence. If we can make it a requirement that
> each driver needing the services of an IOMMU actively requests that
> service, then deferred probing should be able to deal with it.

I believe the hope was to specifically avoid drivers knowing about the
presence of an IOMMU. Drivers would simply use standard dma
alloc/map/unmap APIs, and those APIs would internally set up any IOMMU
HW is present and necessary.

Having e.g. a DT property that says "this is your IOMMU" which drivers
had to explicitly handle parsing, and/or requiring drivers to make
some call during probe to say "bind to an IOMMU" (unless that API can
simply be called in all cases including when there actually is no
IOMMU) would be a bit annoying.

> That doesn't necessarily mean that drivers need to be doing it
> manually. It strikes me as the kind of thing that could easily be
> done by the core. In fact I've been thinking of doing something
> similar to resolve devicetree IRQ references at probe time, rather
> than at device creation time to remove the need for interrupt chips
> to register early.

If we can make this automatic and hidden yet still use deferred
probing, then that'd likely be just fine.

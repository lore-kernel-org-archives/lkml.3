Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaETIo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:44:56 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53267 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:44:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Scott Lurndal <kdb@lurndal.org>,
        "yu.zhao@intel.com" <yu.zhao@intel.com>
Subject: Re: [PATCH v7 0/3] Add support for PCI in AArch64
Date: Tue, 20 May 2014 10:44:30 +0200
Message-ID: <5759329.P75jKFdv3B@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+sq2Ce+8YB+02B7zhxTXwropZXv9spy-w=AJ8YXCP69kr-_1A@mail.gmail.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com> <4292818.mI6kZGgTzd@wuerfel> <CA+sq2Ce+8YB+02B7zhxTXwropZXv9spy-w=AJ8YXCP69kr-_1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YQCjMl25gBmiVpOt0qDEzmbrSblAoub1Nl97K5/aeWj
 d6YaAXFZ8VNM0OEn7JnqzlI6Jm7RUgxTmjs/TByGjpXQKpMKI7
 IXgcvHfp/TUETG3IMhl11BZIbC1SclQPhac4Ju/PP1oDojdsf8
 3C62yuFLBiW5IWeA7UyvVfjeoQ3Ha7KmSjgZO/gD7ZZ/2Xml4P
 ym3varoggOqkg3Z5olkqIXzA5K4UzBGk9bAHTtF/cSY0CltGYD
 bFUXkyvT4EOVJmRjz4+P7hLodKC5tH7Nsl1ISF3Y4qr3fd9rFN
 pEpXj1v5xLQBZ+6Bjp1Bs/4hc/eVtZhAo3ivZi5+D6p1j0+Afa
 LDfYBWzli0E+Bkyq1rqM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 09:52:33 Sunil Kovvuri wrote:
> >> In sriov_enable() (drivers/pci/iov.c)
> >>
> >>  296        for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
> >>  297                 bars |= (1 << (i + PCI_IOV_RESOURCES));
> >>  298                 res = dev->resource + PCI_IOV_RESOURCES + i;
> >>  299                 if (res->parent)
> >>  300                         nres++;
> >>  301         }
> >>  302         if (nres != iov->nres) {
> >>  303                 dev_err(&dev->dev, "not enough MMIO resources for
> >>  SR-IOV\n");
> >>  304                 return -ENOMEM;
> >>  305         }
> >>
> >> Here its checking if physical function's IOV resource has a parent or not.
> >> Which is pci-pci bridge in this case. Otherwise it doesn't consider
> >> that resource.
> >>
> >> Added below api to your patch.
> >> This will try to claim a resource while creating a PCI device which
> >> inturn sets 'res->parent'.
> >
> > This looks like the wrong approach. The PCI host controller should
> > really have been registered with the root 'iomem_resource' during
> > the probe of the host controller.
> >
> I didn't get this, if a SR-IOV device is connected to a PCI-PCI bridge
> and inturn bridge connected to root port. Then the parent bus is not root,
> but the bridge.  The issue is either hierarchy should not be checked for
> SR-IOV resources or someone should set the hierarchy (i.e parent resources).

Ah, I misunderstood the problem, I thought the PCI core was complaining
about lack of space in the resources, not about a lack of BARs.

It seems there is code like yours in a couple of architectures, but they
only claim the resources of bridges, not the actual devices as you
seem to be doing. Can you check if the x86 version of
pcibios_allocate_bus_resources() does the trick for you? Maybe we can
turn that into a generic helper.

	Arnd

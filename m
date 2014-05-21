Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaEUSM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:12:27 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49895 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaEUSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:12:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 21 May 2014 20:11:19 +0200
Message-ID: <4393962.rf2bYfTJVU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521170954.GC3830@e103592.cambridge.arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <20140521090037.GA19268@ulmo> <20140521170954.GC3830@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pUbJr1xbOr3S16SPavQ0O+lGvxnAX/iklbJmj/f2eYM
 jdeRiDqGG7sxqqcIxsOzORGFJxZQ7GZdWHOwOzBDV89HA80CMS
 ZtGmf7oBSSzWhTh47Y2ZyP+qVNJjGyrP2ipyB8w6rpL/bZ14mB
 nzAJoo7WHELlihmF89ajcTR+hQA2k9396/+t5bApiYw9jesHp1
 KbHaZRldttdftJ9Tk/6tLjNpW9axQ178amWNUpcwGlPCUrdHlu
 uk9RhDqSZ/eUQg+ONf7I3l7IFrAmba8JNq8jhVdvWQ2eB5/Z9e
 iHfCMk+IViCgE8fRCvqkNcLp/kXlV7BSFROpmtwd8FOBQ7vkQj
 osMGSLkUNMAyKxNkKxeM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 18:09:54 Dave Martin wrote:
> On Wed, May 21, 2014 at 11:00:38AM +0200, Thierry Reding wrote:
> > On Wed, May 21, 2014 at 10:50:38AM +0200, Arnd Bergmann wrote:
> > > On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:
> > > > 
> > > > Similarily, should the IOMMU not be treated like any other device here?
> > > > Its DMA mask should determine what address range it can access.
> > > 
> > > Right. But for that we need a dma-ranges property in the parent of the
> > > iommu, just so the mask can be set correctly and we don't have to
> > > rely on the 32-bit fallback case.
> > 
> > Shouldn't the IOMMU driver be the one to set the DMA mask for the device
> > in exactly the same way that other drivers override the 32-bit default?
> > 
> 
> Are we confusing the "next-hop DMA mask" with the "end-to-end DMA mask"
> here?  The device has a next-hop mask which may be non-trivial.  The
> IOMMU also has a next-hop mask and/or remapping, but I think we agree
> that in sensible systems that will be trivial.  There might be other
> non-trivial remappings between the IOMMU and memory (but again, not
> in the common case).
> 
> If we just use the same name for all these, we are liable to get
> confused.
> 
> To answer the question "what memory can the kernel allocate for DMA
> with this device", it is the end-to-end transformation that is
> important.

Yes, but that is not the same as the dma mask of the device. The DMA
mask gets set by the device according to its capabilities, and may
get limited by what the bus to either memory or to the iommu can do,
if one is in use.

Without an IOMMU, the mask is used for allocations, with an IOMMU,
The iommu code makes the decision what to allocate without taking
dev->dma_mask into account.

As mentioned, this is currently not handled well for SCSI and network,
where we use a smaller mask than necessary and can end up copying
data.

	Arnd

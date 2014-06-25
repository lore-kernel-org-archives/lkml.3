Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaFYJtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:49:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57386 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:49:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Olav Haugan <ohaugan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 25 Jun 2014 11:48:31 +0200
Message-ID: <130361958.xFghHXmZkz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140625093825.GH6153@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <4839521.56FtveYIl6@wuerfel> <20140625093825.GH6153@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Nom83bjP+vtqUqx8D0UBuVxeG0vSk0vtj7R4ZwCUsQr
 5UVI/FuSbAH442MhwgY+HAga+BIE3KP+T7+yCJPUWryyJax+3Q
 aYHP41mqGPmCsDVQhb6vnBfH4O67TMD4ixVfFhDr6KbB5MZYBn
 6pGcdMOemtEPLrrUg+yJ5ONsVuo25yrIkEkofEqcpHYhutupQ9
 myuAcSNNgLb+lyrA5qzQUj35S3w/Uxyea+7If9gwLa36GDtTQ8
 fe2b0W+V43bgw+UWbvOi96BkR+cqkXr6oBPDDRO0rHQcurpAbM
 sY6kcjP9cNM4g+Nj74yVb6Cft4aBiFjapgTAojmRcE62Sq8rNE
 ogPGctkXMnpKsu7bj2/Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 10:38:25 Will Deacon wrote:
> On Wed, Jun 25, 2014 at 10:27:50AM +0100, Arnd Bergmann wrote:
> > On Wednesday 25 June 2014 10:17:02 Will Deacon wrote:
> > > On Tue, Jun 24, 2014 at 07:20:56PM +0100, Arnd Bergmann wrote:
> > > > On Tuesday 24 June 2014 19:11:50 Will Deacon wrote:
> > > > > On Tue, Jun 24, 2014 at 06:57:44PM +0100, Olav Haugan wrote:
> > > > > > We do describe the masked StreamID (SID) but we need to specify the mask
> > > > > > that the SMMU should apply to the incoming SIDs, right?
> > > > > > 
> > > > > > We have a bus master that emits 43 unique SIDs. However, we have only 40
> > > > > > SMMU_SMRn registers in the SMMU. So we need to mask out some of the
> > > > > > incoming SID bits so that the 43 SIDs can match one of 40 entries in the
> > > > > > SMR.
> > > > > 
> > > > > Hmm, so you're talking about stream matching, right? That doesn't belong in
> > > > > the device-tree. I appreciate that the current driver does a terrible job at
> > > > > allocating the SMRs (it's bloody difficult!), but we should try to improve
> > > > > the dynamic behaviour instead of moving configuration of the SMMU out into
> > > > > device-tree, where it's inflexible at best.
> > > > > 
> > > > > There have been patches previously posted by Andreas Herrmann helping here.
> > > > > I'd be glad to see them revived.
> > > > 
> > > > Note that there are areas where we have in the past decided that dynamic
> > > > configuration is just too hard for the kernel to do and that we're better
> > > > off putting the configuration into DT. Pinctrl and clocks are at least
> > > > partially in that category.
> > > > 
> > > > It's always best if you can get the kernel to do things in the ideal
> > > > way where that is possible, but getting there may be just not worth it.
> > > > 
> > > > I have no idea where it should be for SMMU, but it's something to consider:
> > > > if you can take reasonable shortcuts by reading parts of the configuration
> > > > from DT, you may just as well do that.
> > > 
> > > I treat this in the same manner as the topology bindings we discussed
> > > previously; we should do a best-effort to configure things dynamically and
> > > solve corner-cases and quirks as special cases.
> > 
> > I think the situation is a bit different here: It's less about the corner
> > cases for the SMMU, but about the question whether it makes more sense to
> > have the kernel figure out the settings, or have them come from DT
> > all the time.
> 
> But, as far as I can tell, this setting is basically `which bits are
> constant among this set of IDs'.
> 
> > As I said, I can't tell which approach is best here, but it sounds to
> > me we should either do dynamic configuration and get it right, or
> > hardcode the configuration it all the time if we can't.
> 
> I disagree. If you have `sensible' StreamID allocations, doing this
> dynamically should be straight-forward and gives the driver more flexibility
> (e.g. we then have the option of combining SMR entries for different masters
> if they are in the same domain). The dynamic approach also lends itself to
> sanity-checking (it is IMPLEMENTATION DEFINED whether the SMMU detects SMR
> aliases) and helps with virtualisation (forcing QEMU to generate these masks
> in a device-tree for a guest using a virtual SMMU interface is very painful).

In which case do you think hardcoding is needed then? I'm still confused
why you think we need both, as your arguments seem to all be in favor of
dynamic configuration.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaF0Kyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:54:44 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61384 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaF0Kyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:54:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hiroshi DOyu <hdoyu@nvidia.com>, Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <Dave.Martin@arm.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>,
        Allen Martin <AMartin@nvidia.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kumar Gala <galak@codeaurora.org>, Rhyland Klein <rklein@nvidia.com>
Subject: Re: [RFC 09/10] drm/tegra: Add IOMMU support
Date: Fri, 27 Jun 2014 12:54:20 +0200
Message-ID: <4455459.GtiCHWk2CB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140627124614.050be2e406a4b9a02d9fe97c@nvidia.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-10-git-send-email-thierry.reding@gmail.com> <20140627124614.050be2e406a4b9a02d9fe97c@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QKSmYn+uRy5Gotz2EuigdcZ5QuF/zBQMuUIUphzV5k7
 s8UmvyKHTMIQOfdOkyMFdtRPMlqcjtUuIRce1T2CFhfPQlyi3g
 SeOM90HMo+Z3vRwZf0o2oduKzCGWEDDg5LArIgk3BLn8FnlcDx
 Stg1x06znAd9oBq7v46BIXKxpSujNBWFJyOBFC0ahMEz9BIVxZ
 0BpcTTx4x5s3LkBG5B/K22X4qA9Ms5pvyUhdmg3HlMRMdqEuhY
 PdpfgwYI+9gMgaBXhqC6Pqnc2TntbJ6yr6P2VmIM3awXqTo8oh
 2raw0j2Vy5LLHXh18U4Jkbr7c7RXri/NxQipV3lz+WJwS2VGy9
 qvzqr+jRy8dw+s/6PHGs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014 12:46:14 Hiroshi DOyu wrote:
> 
> Thierry Reding <thierry.reding@gmail.com> writes:
> 
> > From: Thierry Reding <treding@nvidia.com>
> >
> > When an IOMMU device is available on the platform bus, allocate an IOMMU
> > domain and attach the display controllers to it. The display controllers
> > can then scan out non-contiguous buffers by mapping them through the
> > IOMMU.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > @@ -1283,8 +1284,18 @@ static int tegra_dc_init(struct host1x_client *client)
> >  {
> >         struct drm_device *drm = dev_get_drvdata(client->parent);
> >         struct tegra_dc *dc = host1x_client_to_dc(client);
> > +       struct tegra_drm *tegra = drm->dev_private;
> >         int err;
> >
> > +       if (tegra->domain) {
> > +               err = iommu_attach_device(tegra->domain, dc->dev);
> 
> I wanted to keep device drivers iommu-free with the following:
> 
> http://patchwork.ozlabs.org/patch/354074/
> 

We definitely need something like your series to make iommus work transparently
on ARM for normal devices, using the of_dma_configure() to look up the correct
iommu per device and initialize it.

However, any devices that work with multiple iommu domains cannot do that
and still need to use the iommu API directy. I believe the tegra drm code
falls into this category.

	Arnd

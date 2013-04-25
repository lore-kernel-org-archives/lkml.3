Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab3DYOL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:11:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3DYOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:11:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
Date: Thu, 25 Apr 2013 16:11:39 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com> <20130425134402.GN4623@gmail.com>
In-Reply-To: <20130425134402.GN4623@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304251611.39667.arnd@arndb.de>
X-Provags-ID: V02:K0:+IJWFAV0UUaG460ItQzr7x/sy4G4SSwQOssHMagBkJl
 bunW5gwBKuQ8XGLPOYeECVrXXvBKzh0u/Z3JU6HcWAeVuel/Na
 72xuSSfDNzoHTWx4ELdTyacJTG6jvP6Uw4Mu5GHAhO2E6PK/p8
 gkZnKjhpcyFv33upyYzPBMYWL7AOAJcyw3qzcT/QuqMpBmvV2U
 dVEFycB8ixeJpfWjSmXuVN6cyKP2R32NebR+voK+Dpts9L5Mjr
 COUEn5xFR5VMLMsEyGulVzO+s/RBfVdKPjfsszjCi1wAQI1DKN
 sFWviLY4ePIiuy1edLe+mpb9fyKRKaiz8aevCLE0P47rvQjQMR
 fEfp1UVB7zTC0+tDFwcc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 April 2013, Lee Jones wrote:

> > > @@ -232,6 +236,7 @@ struct cryp_dma {
> > >   */
> > >  struct cryp_device_data {
> > >         struct cryp_register __iomem *base;
> > > +       phys_addr_t phybase;
> > 
> > Use dma_addr_t. Maybe "phybase" is misleading,
> > "dmabase" is probably better. (Also applies to the
> > cryp patch).
> 
> Accept it's not the dmabase.
> 
> It's the phybase (U8500_CRYP1_BASE) i.e. the physical base address of
> the device's regs.

Right, this recently came up in a different context and I agree:

The dma engine driver must know the address in its dma space, while the
slave driver has it available in physical space. These two are often the
same, but there is no generic way to convert between the two, especially
if the dma engine resides behind an IOMMU.

The best assumption we can make is that the dma engine driver knows
how to convert between the two. Interestingly the documentation for
dma_slave_config talks about "physical address", while the structure
itself uses a dma_addr_t. Linus Walleij introduced the structure in
c156d0a5b0 "DMAENGINE: generic slave channel control v3", so I assume
he can shed some light on what he was thinking. I assume the documentation
is right but the structure is not and should be converted to use
phys_add_t or resource_size_t.

	Arnd

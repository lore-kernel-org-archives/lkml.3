Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaGDL2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:28:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49863 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGDL2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:28:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Prabhakar Kushwaha <prabhakar@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: PCI(e) arch support
Date: Fri, 04 Jul 2014 13:28:09 +0200
Message-ID: <8557411.iWl9PJdYsS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140704110251.GF6501@e106497-lin.cambridge.arm.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com> <4342569.JSAyWBcJn2@wuerfel> <20140704110251.GF6501@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SyYOqh72dOMVMPjCn7Xpom6Z+PDQtsYCl823KrKbvWG
 h+byLvBxHIW+bEZnfW8FMwTd69xLZs9MJ1E7eG2OkJyXMIJrOi
 MytOCZ3vHo9GbT9b5a0CHuc2dDlruQuVjWXlE84LF5dgxHDZqa
 Zj2bfp2HxYfHPAIpRnZN4i7NdQZn5NduGdlrAvGFz4PMlfsNfG
 enZ8k1p6gVQC6YOuTg2LawPNiCFxc079ihRRVsmk5Hja4l5mB7
 Dzzah6l87IzaRN2lhOGiLtEj/w7kEtJ5hOKXJ9r8k33JWn/4r2
 pbTLa6XqNX+mpLO1na0Trve+UB6C0Fo4HsYVy9YCliPMOwYqLA
 yz0IRIt+Ox8gsYvK9T7g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 12:02:51 Liviu Dudau wrote:
> > Supporting just one boot loader is of course a bit silly, especially when
> > you know that people will be using all sorts of boot loaders.
> 
> You could also argue that supporting just one kernel is silly as well, but
> so far I haven't seen too many Linux people complaining that *BSD is not
> officially supported.

I have heard complaints from UEFI people though that want to support
more than just Linux ;-)

> It's also a small game of demand and offer: ARM partners that were interested
> in ARMv8 have been asked which bootloader solution they are interested in,
> and I guess not enough u-boot supporters made their voices heard. Limited
> resources leads to limited choices.

I think it's rather a question of whether they'd benefit from ARM doing it.
It's fairly easy to port most of the smaller boot-loaders, and there
is not much architecture specific code in them.

> > A more interesting aspect of this question is what the kernel can expect
> > the boot loader to have done with the PCI host bridge when the kernel
> > is entered.
> 
> Indeed. I'm interested in opinions here.
> 
> > 
> > Traditionally, embedded ARM boot loaders have left the PCI host bridge
> > alone unless they were booting from it, and Linux did all the setup.
> > With the SBSA class of ARM servers, this is not really practical, and
> > whatever runs before Linux (typically UEFI) should already set up the
> > PCI bus and do resource allocation like every other server architecture
> > does. I would assume that UEFI does this right, and if not we can consider
> > that a bug.
> 
> And at the moment we have UEFI on Juno that can be made SBSA compliant
> but by default it's not (yes, it *is* a bug).

Is this because of the PCI config space access or something else?

The publically announced version of Juno doesn't have any PCI slots,
so I guess this is about a future variant, right?

> > However, what do we do about PCI hosts that can be used with different
> > kinds of systems? Do we assume that they all do PCI resource allocation?
> > Can we decide this on a per host driver basis, or do we need to introduce
> > an extension to the PCI DT binding to make that decision?
> 
> The PCI code currently should skip the configured devices and only touch
> the not configured ones. The question is how to detect if the host bridge
> has been initialised by the firmware or not.

On PowerPC we used to have a per platform flag that defined whether PCI was
supposed to be initialized by firmware or by the OS, but it makes less
sense on ARM64 since we try to avoid introducing the concept of platforms
in too many places.

If we can't rely on the firmware to get it right, I think we don't have
a choice but to rely on DT information (In the ACPI case, I would definitely
mandate that the firmware has to get it right). We may also need to deal
with the case of firmware initializing the PCI host bridge incorrectly,
though we can try not to do that until we have to.

It should be easy enough to detect the case of a host bridge that has
not been touched, but that would fail in case of kexec() when it has
been set up by a previously running kernel.

	Arnd

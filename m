Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaBDJBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:01:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDJBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:01:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 04 Feb 2014 10:01:23 +0100
Message-ID: <3586724.k5LBp6hZRL@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <3808209.DeG1VobanZ@wuerfel> <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xQGVwVJvT06Muz0xD8Rf2GNE6wAzKfYrEVJWR932VMi
 UnT+OIilaA0JzzZ5EVjC/WLwmy56dh6vqvhfzWeeObK6XByONE
 b6VliUPey1CIdnmzDjQYqeIIx00EsTmQ9L8Ttx6Uj7lwxnsMJ2
 ZNWdQjrjt0KEHMdfNHZLhsO1dGkfwCtBLsS24b1OC0M0n0O7TX
 rAjANylhRUArfDD+zwwEBos2KkII/xhdvdY4Ee1OTbL+BVuaMf
 JAQUx42KwcxXHFCCccgg86zldM6vzyOlNckr2/KQCNnl4gYKeQ
 0p5ZBwrr+AmeVd3bptDJWUd4fCvueIOh+sJlgFEPGs8OKuZVPl
 R2USG70SXNMDwZo9A1+s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 17:07:48 Rob Herring wrote:
> On Mon, Feb 3, 2014 at 2:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> You might want to re-read the SBSA. Unless ARM provides an IP block or
> there is some other standard such as EHCI or AHCI, there is no generic
> implementation. You only have to go look at the Linux EHCI or AHCI
> drivers and see how meaningless and inadequate "use EHCI" is. For PCI,
> the text is so brief in the SBSA there will be no way PCI is going to
> just work given all the variations of root complexes, bridges, address
> windows, etc. we typically see on ARM platforms. I could be wrong and
> some AML magic will solve all the problems. 

I don't think you need any AML, and SBSA seems to cover the PCI case
just fine, though I have to agree that the EHCI/AHCI/xHCI part is
rather ambiguous. What the existing PCI host controller drivers do is
essentially:

1. provide a config space access method
2. set up the I/O and memory address windows
3. set up clocks, PHYs etc
4. work around any deviations from the PCI standard
5. provide an MSI/MSI-X controller

For all I can tell, any SBSA compliant system should handle
those four like this:

1. config space is ECAM compliant, we only need to pass the
   location in DT. (SBSA 8.1)
2. all address windows are set up by the boot loader, we only
   need to know the location (IMHO this should be the
   preferred way to do things regardless of SBSA).
3. any external hardware dependencies are set up statically
   by the boot loader and are operational as we enter the
   kernel.
4. deviations from PCI are not allowed (SBSA 8.8)
5. MSI has to be handled by GICv3 (SBSA 8.3.2)

So I definitely expect SBSA compliant systems to work fine with a
very simple generic PCI host bridge driver (which is likely what
Liviu has implemented and waiting for approval to submit).
The more important question is what systems will actually be
compliant with the above. X-Gene manages to get all five wrong,
for instance, and so would any system that reuses the existing
PCI hardware (alphabetically: exynos, imx6, mvebu, rcar-gen2,
tegra, designware), although points 2 and 3 are a question of
the boot loader, and it's possible that the designware based ones
get point 4 right.

	Arnd

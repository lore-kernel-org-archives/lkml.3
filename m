Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDWLEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:04:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:63241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDWLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:03:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Wed, 23 Apr 2014 13:03:47 +0200
Message-ID: <4565008.ZECF3eWqge@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com> <201404221611.40087.arnd@arndb.de> <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2t0kA97nGLbtWCkIiXD8SDJH774TmLlYgyh3NL5efLd
 ZuaVbEXXjbqbMsIUATaG74UigTP9naxWu2ym9VPGwGpeeF9fvo
 XeNXfz28emr8Y3M7T7jjDvSYRFmCDfn2zU0agdxMpBUaZfoGKL
 72uc3dvgtLArgDWFoiTZBcGqYNhoTv2+jYt2mTPBWs78L46NWc
 Lt3Lpx/7zQXTAomn5Ed5fjZUylnZ5EcuAtNOxRvodC1y1duRDn
 P5gAQ0i6+qCwl8v2HLHrEFz1GyGEGcEc7i6K3b9ufjtSdVOKgi
 HwdjgLA3ndO3dMQPuJt7jBgIFonnE9QZwqsHGGlGR1aJ9uDhTj
 3DZQV4LF6TrRSuWlopyY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 18:19:30 Kukjin Kim wrote:
> 

> Basically, ARMv8 based GH7 has same PCIe hardware IP with previous ARMv7
> based exynos5440, several features in PCIe are different though. In other
> words, basic functionalities for PCIe are same. So I think, would be nice if
> we could use one PCIe device driver for both SoCs.

Ok, I see. I was just trying to get a feeling for how much is shared
or SoC specific between your variants. If they are different enough,
it may be easier to have two drivers.

> However, if we need to support the PCIe with each own device driver because
> of difference of 32bit and 64bit, please kindly let us know. Honestly, I'm
> not sure about that right now.

We are working already on ideas to minimize the differences between
arm32 and arm64 PCI support, it will just take more work.

> > Also, if gh7 is expected to run a full firmware, I think you should
> > do all the setup in the firmware before booting Linux, and just
> > do the required run-time operations in the driver itself.
> > 
> Well, we're expecting that all the setup should be done by the device driver
> in kernel not firmware.

Ok, just make sure this hardware never shows up in servers then.

Unfortunately we are in a tricky situation on arm64 because we have
to support both server-type SoCs and embedded-type SoCs. In an
embedded system, you can't trust the boot loader to do a proper
setup of all the hardware, so the kernel needs full control over
all the initialization. In a server, the initialization is the
responsibility of the firmware, and we don't want the kernel to
even know about those registers.

My hope is that all server chips use an SBSA compliant PCIe
implementation, but we already have X-Gene, which is doing server
workloads with a nonstandard PCIe, and it's possible that there
will also be server-like systems with a DesignWare PCIe block
instead of an SBSA compliant one. We can still support those, but
I don't want to see more than one implementation of dw-pcie
on servers. Just like we have the generic PCIe support that Will
is doing for virtual machines and SBSA compliant systems, we
would do one dw-pcie variant for all systems that come with a
host firmware and rely on it being set up already.

	Arnd

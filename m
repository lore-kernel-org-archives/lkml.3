Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaDXJu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:50:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:50093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaDXJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:50:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Liviu Dudau'" <Liviu.Dudau@arm.com>, linaro-kernel@lists.linaro.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Thu, 24 Apr 2014 11:49:39 +0200
Message-ID: <4760019.Svnt8uv0v8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <01ff01cf5f79$30f926b0$92eb7410$@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com> <14215032.8jhN17iHj5@wuerfel> <01ff01cf5f79$30f926b0$92eb7410$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:l4BR+S5lW14HJgq9Q7JrSFA303PX2Q77lruEfyg2cQa
 6ET83PQROxkx49/PnhKm8rVYt7QoiqMRpPCjggM3uonl1SElPA
 AMvoiD/JA2bxgUnkoPJt4OQkVzTlKH+1vYQ+AZOLhrpD/AtHmL
 H9FG+YekWm8uZE6YYwf8rRBlQG3cYcNWiqr50kZjSiR+rnIegy
 UxNfe7G8L3vqG9dGS8CE8WkrFLTCJxlyyOlKq4oKZWFMSK+2sh
 z0l2ib876jayly1jRD3NL8UF82TCpDy1FlRKAWbF4caryrt1nD
 qf0dZkAedwKw5k8qgM2w/phII5NOuQNOLNrCgGI9UzRtBScwQy
 FV99ugWU9yYFXpp3v6HM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2014 13:53:47 Kukjin Kim wrote:
> Arnd Bergmann wrote:
> > 
> > On Wednesday 23 April 2014 15:23:16 Liviu Dudau wrote:
> > > > Unfortunately we are in a tricky situation on arm64 because we have
> > > > to support both server-type SoCs and embedded-type SoCs. In an
> > > > embedded system, you can't trust the boot loader to do a proper
> > > > setup of all the hardware, so the kernel needs full control over
> > > > all the initialization. In a server, the initialization is the
> > > > responsibility of the firmware, and we don't want the kernel to
> > > > even know about those registers.
> 
> BTW, actually we can trust boot-loader to do required things in mobile also ;-)

Not really. Those boot loaders do the bare minimum to get one kernel
running. There is no testing done with distro kernels (usually because
they won't work anyway), and they wouldn't touch (or describe in DT) any
hardware that isn't actually used by the kernel that initially ships
with the device.

If we could trust the boot loader to do all the necessary setup,
we would get rid of a lot of kernel code.

> > > > My hope is that all server chips use an SBSA compliant PCIe
> > > > implementation, but we already have X-Gene, which is doing server
> > > > workloads with a nonstandard PCIe, and it's possible that there
> > > > will also be server-like systems with a DesignWare PCIe block
> > > > instead of an SBSA compliant one. We can still support those, but
> > > > I don't want to see more than one implementation of dw-pcie
> > > > on servers. Just like we have the generic PCIe support that Will
> > > > is doing for virtual machines and SBSA compliant systems, we
> > > > would do one dw-pcie variant for all systems that come with a
> > > > host firmware and rely on it being set up already.
> 
> OK and I think, just one device driver would be nice for whatever
> embedded or server.

The runtime parts (e.g. config space access) should definitely
be shared, and we should also share any peripheral drivers.

However, basic infrastructure like PCI on servers should just work
and you really shouldn't require any driver code for it. SBSA gets
this part right by defining the config space layout, so we can have
a very trivial PCI host driver for all SBSA systems, even if the
same hardware needs a SoC specific driver for embedded systems that
don't initialize the PCI host at boot time.

There is also nothing wrong with embedded systems doing it the same
way as servers and initializing everything before Linux starts. We
just need to be prepared to add fixups when someone gets it wrong.

> > I think we should treat DW-PCIe in the same way if anyone attempts
> > to use that in a server, e.g. in SBSA level 0. As you can see here,
> 
> Agreed. BTW, how about GICv2m for level 1? It can be supported with the same
> way in one DW-PCIe driver?

I don't think anybody has done a DT binding for GICv2m or submitted a
patch yet, but I'm pretty sure it can be done. We just need to come
up with a proper DT representation to pick which MSI controller is
used by default.

Hardware-wise you should be able to mix any combination of MSI controllers,
but I would suspect that if there is a GICv2m or higher, we would always
want to use that for performance reasons. The MSI controller in the
dw-pcie block just sends a normal interrupt to the GIC, which means you
lose all the benefits of using MSI.

> > even when reusing hardware between Exynos and GH7, you can't just
> > use the same init code, so it has to be in firmware to be any good.
> > On a real server platform, you can't require a kernel upgrade every
> > time a new SoC comes out, any basic functionality like PCI just has to
> > work with existing OS images.
> > 
> OK, when Will's driver is ready, we will test it on GH7 with the setup for PCIe
> included in firmware. Anyway I hope we can use the driver in 3.16 :-)

Ok, sounds good.

	Arnd

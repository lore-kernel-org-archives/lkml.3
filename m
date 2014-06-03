Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaFCJV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:21:56 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63466 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaFCJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:21:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
Date: Tue, 03 Jun 2014 11:21:10 +0200
Message-ID: <5535126.fgWbMeOQVO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140603084459.EC01BC4096E@trevor.secretlab.ca>
References: <20140530233034.GH1677@bart.dudau.co.uk> <2F6515B1-48FE-4ED6-908E-CC1CAD7AF403@codeaurora.org> <20140603084459.EC01BC4096E@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NBnux3Ja02WGeAfELLveHyO4oQvW6vPCn/z/8deCuNK
 sgkd3YvXJhuW2C3EbksXTGxA54gniL52AyAEEQLd/BTvtWdDRs
 dWG+3QRZU9gsiKTb+jbHaEXPhqEndx6VI16xBz43nf+mdPYYlb
 4QsOVD/EVoh0L3EMtvBIgAzIJZB6oiUcp60sHblDTHlUe+vOY+
 qzjnY2IvrJT06L/XshjP5/de44HAtcoR382Eei26DNiJaiSDxJ
 +cnYJzDnU4HONdzRzYsUBs7PNg/z9zzs7yDJN5UhEf2yzIG7VU
 f9ulQ2sqxV6cPzYxEGgetE2qfvJ6gtXkc7bewI4/ASx10XYoHH
 R0FPt/IEGK/oBs92obVM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2014 09:44:59 Grant Likely wrote:
> > The reason I think allow an ECAM makes sense in ranges is because it allows for a direct IO read/write to CFG space (w/o any mapping) similar to what one would do for MEM space or IO.
> 
> I don't think that's right. PCI addresses are defined as follows:
> phys.hi cell: npt000ss bbbbbbbb dddddfff rrrrrrrr
> phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
> phys.low cell: llllllll llllllll llllllll llllllll
> 
> where 'ddddd' is the device number (0-31) and 'fff' is the function number (0-7)
> 
> Going up by one device number or even function number does not result in
> contiguious address values:
> 
> device 0: 0x00000000 00000000 00000000
> device 1: 0x00000800 00000000 00000000
> device 2: 0x00001000 00000000 00000000
> device 3: 0x00001800 00000000 00000000
> ...
> device 30:0x0000f000 00000000 00000000
> device 31:0x0000f800 00000000 00000000
> 
> a simple ranges doesn't work transparently because each of those config
> ranges needs to be mapped to a 4k block. I think ranges would need to
> look like this:
> 
> ranges = <0x00000000 0 0  0x0ff00000  0x1000>,
>          <0x00000800 0 0  0x0ff01000  0x1000>,
>          <0x00001800 0 0  0x0ff02000  0x1000>,
>          ...
>          <0x0000f000 0 0  0x0ff1e000  0x1000>,
>          <0x0000f800 0 0  0x0ff1f000  0x1000>;
> 
> (I just hacked the above up; I make no claims to it's accuracy for
> actual address values)
> 
> But I don't even thing the semantics work there because the address is
> encoded in the phys.hi cell, not the phys.low cell. Incrementing by one
> does not behaves as most bus addresses work. To actually work properly
> we would have needed a way to define a stride of 64bits when
> incrementing config space addresses in a ranges mapping.

Thanks for clearing that up. I always suspected it was roughly this
way, but never managed to think it through completely before getting
distracted by something else.

I wonder if the OF definition matches CAM though, if not ECAM, as
CAM is also limited to 256 byte config space per function.

	Arnd

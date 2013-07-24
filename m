Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3GXVD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:03:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3GXVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:03:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part and Exynos part
Date: Wed, 24 Jul 2013 23:02:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com> <51EE22DF.6090902@ti.com> <001301ce8772$522dfc50$f689f4f0$@samsung.com>
In-Reply-To: <001301ce8772$522dfc50$f689f4f0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307242302.40934.arnd@arndb.de>
X-Provags-ID: V02:K0:vGLy51xQ/+NGpp3Mi7iAFGIa6aLip4sr0Qyi/e1XGRA
 gLY+Px+PhUZ3M1DNSfil541/b5vC+UGUrbHLTUIE9EIjkFU9Kf
 sEAa1Yv64Bfyu/sb6vuTzmyClanpAzy1xjdoM010LWODTTzdxh
 48dRv3/0rEbBwlgXUN/kmqsqHB7uNx6v/6mIET8Wyet6BwOdSJ
 f4+MiYD44W2Se5EBpXfeLRVmBln4ZIeE+oFlFuJg1BXoGyypu7
 yfYvqjBJRPvcdlP0MMoQs/4EoilBvu+vQgsVaOd+oM4jyfuW/A
 AWx0lk+4CM5rtytSFSP4P2Ze/gew8w4DgrVeA9JOdwDYgq0UX5
 MRze3C5uxEM2R6B3uVdE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 July 2013, Jingoo Han wrote:
> > 
> > Also I have one more query.
> > In your dt binding, your pci address and cpu address is the same. But the pci
> > address should start at 0x00000000 and end at 0xffffffff (for 32bit). Shouldn't
> > the cpu address map to something within this range of pci address?

The size is limited by the window available (e.g. 0x80000000-0x8FFFFFFF), it can
never be the full 4GB on a 32 bit non-LPAE system. If you only care about memory
space here (in practice you want at least also config space) that means you could
either have an identity map

	<0x82000000 0 0x80000000 0x80000000 0 0x1fffffff>;

or use bus address 0

	<0x82000000 0 0 0x80000000 0 0x1fffffff>;

but the length is always limited by the upstream bus.

> Sorry, I cannot answer it exactly.
> DT binding was confirmed by Arnd Bergmann.
> He will answer it exactly.

Normally you want the pci and cpu addresses to be the same, i.e. identity mapped.
This simplifies PCI bus master DMA as it ensures that there is no aliasing between
PCI memory space and RAM addresses visible to the host.

If you know that there is never any RAM at CPU address 0, you can also make the
PCI memory space be mapped from bus address 0, which has the advantage of allowing
access to low PCI addresses, e.g. for legacy VGA output using the 0xa0000-0xbffff
range, but it's less common. In particular on x86 there is always an identity
mapping.

The driver should be able to handle any mapping that can be described by the binding
and is physically possible to be programmed into the translation windows.

	Arnd

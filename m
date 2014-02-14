Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaBNJKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:10:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaBNJKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:10:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jisheng Zhang <jszhang@marvell.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: use {readl|writel}_relaxed instead of readl/writel in i2c-designware-core ?
Date: Fri, 14 Feb 2014 10:09:44 +0100
Message-ID: <8705989.qzo882Ldx0@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140214155438.4f749a79@xhacker>
References: <20140214155438.4f749a79@xhacker>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I2bb06ubJDvu2T/bldGeOkYWFu428VleKhpCEZ65tTq
 0yxyYqGB3UG/lHqh5WVsSEuzOCNBukml/cKpylfpwDTJNDQfon
 zY4IEsgsquLDWvBcpem2kL/A38B30ko+KWx+7JKJOPNSpbTkzk
 m1Lop/F7l0byX9kJekE2EzKjzd7ebXSXoU6oHZLSyGYzExGOAt
 qRAYLXR/b2/DPC8ikfPYuC+VTlrtSzcpsDJBkVGszDqvhslxw6
 2kloFBseoN24QJCe2ngAqW6e+PTw8R3etN5hhtK9l7s/7lLuHC
 Ho0syeD56cDm7b9SptvHYhlD8phMMUCV7KtTFYAIWoxvif+jj/
 mMVMuqVOxs7wbz1UXFFA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014 15:54:38 Jisheng Zhang wrote:
> Hi all,
> 
> The writel/readl is too expensive especially on Cortex A9 w/ outer L2 cache. This
> introduce i2c read/write error on Marvell Berlin SoCs when there are L2 cache
> maintenance operations at the same time.
> 
> In our internal berlin bsp, we just replaced readl/writel with the relaxed
> version. But AFAIK, the "relaxed" version doesn't exist on all architectures. How
> to handle this issue? 

In case of i2c-designware, this is safe because that driver does not perform
DMA. In other drivers, you may have to be more careful, to ensure that all MMIO
is serialized with DMA operations performed by the driver.

> Any suggestions are appreciated.

I would definitely welcome a patch that adds a default  _relaxed implementation
to include/linux/io.h, like this:

#ifndef readb_relaxed
#define readb_relaxed(p) readb(p)
#endif

and then adds "#define readb_relaxed(p) readb_relaxed(p)" etc. to all
architectures that have a non-macro definition for readb.

Alternatively, we could have a CONFIG_ARCH_MMIO_RELAXED configuration
symbol that gets selected by any architecture that provides the _relaxed
accessors, and get linux/io.h to define all of them for the other
architectures.

	Arnd

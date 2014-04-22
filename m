Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaDVPCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:02:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:50459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbaDVPCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:02:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and dma-coherent
Date: Tue, 22 Apr 2014 17:02:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Gregory =?iso-8859-1?q?Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <20140419182528.414b9b2e@skate>
In-Reply-To: <20140419182528.414b9b2e@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221702.19842.arnd@arndb.de>
X-Provags-ID: V02:K0:2bL5F/G5/fFElYOTzzudZrry/8mrLD7AEu9tgAWhxP5
 a75P9zUurHnO8H8J9yu5bhzwScgOP3Q4FDKtrCh3OqKRNJnuIQ
 jqeYBN0vhOgDwgTi5ApH0SY7WXGHHaVqJkjCo/p/VfU7fSM/qH
 e50kJmFjEQFdUsX65oMrmag2kwJUHqEmjtJmhl4pd+Ba6cE0fR
 yCH7Pnad30CZco+6p4Q79m9/MVf9mJFJcvGXfI1EF+3YaCQnH7
 XFEjd3HWyWkEz9AyOvK5RHYxKKzpMcTU64NOR+Rcd+ifJI2kRc
 azWHXJlmwdlgqH5PFtx5xCQpdKHJT4/WBcwYZHx+Q0WA6JawdZ
 PGDt4w/xZ/gCpxbgjGig=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2014, Thomas Petazzoni wrote:
> 
> I am not sure whether there is an intersection or not, but I wanted to
> mention that the mvebu platform (in mach-mvebu) supports hardware I/O
> coherency, which makes it a coherent DMA platform. However, we are not
> able to use arm_coherent_dma_ops for this platform, because when a
> transfer is being made DMA_FROM_DEVICE, at the end of the transfer, we
> need to perform an I/O barrier to wait for the snooping unit to
> complete its coherency work. So we're coherent, but not with
> arm_coherent_dma_ops: we have our own dma operation implementation (see
> arch/arm/mach-mvebu/coherency.c).

I had completely missed the fact that this support was merged already.

It's an interesting question if this should actually be called
'coherent' or not. It's certainly more coherent than without that
support, but then again, you still can't rely on incoming data to
be visible after a readl() from the device has returned or an MSI
interrupt has been delivered, which is what we normally expect.

In particular, it means you can't really use arm_coherent_dma_alloc(),
which is a shame, since that is a significante performance overhead.

I would hope we can find a way to avoid the platform notifiers for
mvebu as well and come up with a generic way to express this
'semi-coherent' mode. I believe x-gene has a similar issue, and
I wouldn't be surprised if there are others like this.

	Arnd

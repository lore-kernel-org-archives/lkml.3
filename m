Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaIKMg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755701AbaIKMgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:36:55 -0400
Date: Thu, 11 Sep 2014 14:36:16 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140911143616.3ebb025a@bbrezillon>
In-Reply-To: <20140911120928.GA1585@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911120928.GA1585@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Thu, 11 Sep 2014 20:09:30 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> > Several MTD users (either in user or kernel space) expect a valid raw
> > access support to NAND chip devices.
> > This is particularly true for testing tools which are often touching the
> > data stored in a NAND chip in raw mode to artificially generate errors.
> > 
> > The GPMI drivers do not implemenent raw access functions, and thus rely on
> > default HW_ECC scheme implementation.
> > The default implementation consider the data and OOB area as properly
> > separated in their respective NAND section, which is not true for the GPMI
> > controller.
> > In this driver/controller some OOB data are stored at the beginning of the
> > NAND data area (these data are called metadata in the driver), then ECC
> > bytes are interleaved with data chunk (which is similar to the
> > HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> > OOB data.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> > Hello,
> > 
> > This patch is providing raw access support to the GPMI driver which is
> > particularly useful to run some tests on the NAND (the one coming in
> > mind is the mtd_nandbiterrs testsuite).
> > 
> > I know this rework might break several user space tools which are relying
> > on the default raw access implementation (I already experienced an issue
> > with the kobs-ng tool provided by freescale), but many other tools will
> > now work as expected.
> If the kobs-ng can not works, there is no meaning that other tools
> works.  So I do not think we need to implement these hooks.

Well, I don't know about freescale specific tools, but at least I have
an example with mtd_nandbiterrs module.
This module is assuming it can write only the data part of a NAND page
without modifying the OOB area (see [1]), which in GPMI controller case
is impossible because raw write function store the data as if there
were no specific scheme, while there is one:
(metadata + n x (data_chunk + ECC bytes) + remaining_bytes).

Moreover, IMHO, nanddump and nandwrite tools (which can use raw
access mode when passing the appropriate option) should always return
the same kind of data no matter what NAND controller is in use on the
system => (DATA + OOB_DATA), and this is definitely not the case with
the GPMI driver.

See how raw access on HW_ECC_SYNDROME scheme is implemented in
nand_base.c [2]. It hides to the mtd user the fact that DATA and ECC
bytes are interleaved, and give him the expected (DATA + OOB_DATA)
representation.

Best Regards,

Boris

[1]http://lxr.free-electrons.com/source/drivers/mtd/tests/nandbiterrs.c#L112
[2]http://lxr.free-electrons.com/source/drivers/mtd/nand/nand_base.c#L1364


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

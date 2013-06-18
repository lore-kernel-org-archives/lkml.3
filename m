Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab3FRQce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:32:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65500 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab3FRQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:32:31 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 18 Jun 2013 09:32:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Frank Li <Frank.Li@freescale.com>,
        Jim Baxter <jim_baxter@mentor.com>
Subject: Re: [PATCH v2] net: fec: Fix build for MCF5272
Message-ID: <20130618163232.GA10097@roeck-us.net>
References: <1371569885-9054-1-git-send-email-linux@roeck-us.net>
 <CAOMZO5DW_e33MbfJhNG0ouf5g5o04AF7UchD3xwJV30GLovoNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5DW_e33MbfJhNG0ouf5g5o04AF7UchD3xwJV30GLovoNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 01:23:13PM -0300, Fabio Estevam wrote:
> On Tue, Jun 18, 2013 at 12:38 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Commits 4c09eed9 (net: fec: Enable imx6 enet checksum acceleration) and
> > baa70a5c (net: fec: enable pause frame to improve rx prefomance for 1G
> > network) introduced functionality into the FEC driver which is not
> > supported on MCF5272. The registers used to implement this functionality
> > do not exist on MCF5272. Since register defines for MCF5272 are separate
> > from register defines for other chips, building images for MCF5272 fails,
> > complaining about several undefined symbols.
> >
> > Adding the missing register defines is not an option, since the registers
> > do not exist on MCF5272. Disable the added functionality for MCF5272 builds.
> 
> Can you please show the build error message you got?
> 
> Also, it would be nice if FEC could be enabled by default on some m68k
> defconfig, so that we could spot issues like this earlier.
> 
Try building m5272c3_defconfig; this is actually how I found the problem when
test-building v3.9.6-rc1.

make ARCH=m68k CROSS_COMPILE=m68k-linux-gnu- mrproper
make ARCH=m68k CROSS_COMPILE=m68k-linux-gnu- m5272c3_defconfig
make ARCH=m68k CROSS_COMPILE=m68k-linux-gnu-

results in:

drivers/net/ethernet/freescale/fec_main.c: In function ‘fec_restart’:
drivers/net/ethernet/freescale/fec_main.c:520:8: error: ‘FEC_RACC’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec_main.c:520:8: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/freescale/fec_main.c:585:3: error: ‘FEC_R_FIFO_RSEM’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec_main.c:586:3: error: ‘FEC_R_FIFO_RSFL’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec_main.c:587:3: error: ‘FEC_R_FIFO_RAEM’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec_main.c:588:3: error: ‘FEC_R_FIFO_RAFL’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec_main.c:591:3: error: ‘FEC_OPD’ undeclared (first use in this function)

with v3.10-rc6,

and

drivers/net/ethernet/freescale/fec.c: In function ‘fec_restart’:
drivers/net/ethernet/freescale/fec.c:530:3: error: ‘FEC_R_FIFO_RSEM’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec.c:530:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/freescale/fec.c:531:3: error: ‘FEC_R_FIFO_RSFL’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec.c:532:3: error: ‘FEC_R_FIFO_RAEM’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec.c:533:3: error: ‘FEC_R_FIFO_RAFL’ undeclared (first use in this function)
drivers/net/ethernet/freescale/fec.c:536:3: error: ‘FEC_OPD’ undeclared (first use in this function)

with 3.9.6.
 
Want me to add it to the commit log ?

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbaCRXOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:14:48 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38436 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbaCRXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:14:46 -0400
Date: Wed, 19 Mar 2014 10:14:22 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
In-Reply-To: <1395148051.2812.51.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>  <1395112756.20860.1.camel@joe-AO722>  <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>  <1395146702.2812.47.camel@joe-AO722>  <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
 <1395148051.2812.51.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Mar 2014, Joe Perches wrote:

> On Tue, 2014-03-18 at 13:55 +0100, Geert Uytterhoeven wrote:

> > 
> > #define dprintk(flg, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
> 
> Fine, but with a correction.
> 
> no_printk keeps all side effects like performing any function calls made 
> by the statement or accessing any volatiles.
> 
> Using
> 
> do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
> 
> does not have any side-effects.

I take your point about having the compiler check arguments when
NDEBUG & flg == 0.

As for side-effects, chip register accesses would be affected if dprintk() 
expanded to no_printk() when NDEBUG & flg == 0.

E.g. NCR5380.c line 1213:
dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n",
                     basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));

I don't want to re-introduce side-effects into a dozen different NCR5380 
drivers on three different architectures when I can test only one of those 
drivers. It's difficult to get good code coverage even for one driver.

-- 

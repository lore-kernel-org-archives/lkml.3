Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3J0R4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 13:56:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:62746 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3J0R4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 13:56:14 -0400
Date: Sun, 27 Oct 2013 18:56:08 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131027175608.GA1340@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027173131.GC21868@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:H7lGfwMzbEAchaBpgNguuXt7OZYSldtlhCwOkbT5y6Pr9nceALH
 IVQNphdaZgLzq3jy1nfBUYHZxwlE9vJwgQfo84cJLPYE5U6aNZwzspmrYfjrZbVKI2Qfw5A
 yzEUHjBruxKw3HZks+NpqB/jgDGAhutORiFqgrGZYYUN7zkwSL309HbhoKpX+giQVYarUjM
 1DpaE1OPLN8R04gP262+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 06:31:31PM +0100, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 05:51:59PM +0100, Andreas Werner wrote:
> > Im currently working on an ethernet driver for our own ETH core. The
> > problem is that one requirement is to not use DMA to transmit or
> > receive the data. This means the that the ethernet buffers are not
> > located in the main memory. They are located in the FPGA internal RAM.
> >
> > To transmit or receive a frame, i have to read or write to mmio to get
> > the data.
> >
> > Intel has introduced the instruction "clflush" which can flush a cache
> > line. I want to use the caches for those mmio (eth buffer) to speed
> > up the transmit/receive and to transmit/receive using PCIe bursts
> > (read/write).
> >
> > The problem was if i set the buffer to Write-Back and call clflush on
> > those mmio-addresses, the system crashed without any output.
> 
> But allocating a WB region and calling CLFLUSH right after writing
> into it sounds like you want to allocate an UC region, no? Writing
> into it will make sure the data has reached memory and is not in the
> cache, basically what CLFLUSH does but by having it UC, this happens
> automatically.
> 
> So basically what ioremap_nocache does.
> 
> > I found this articel 
> > http://software.intel.com/en-us/forums/topic/393070
> >
> > After that i configured the transmit buffers to be Write-Combining
> > (only write to that adresses) using ioremap_wc, and the receive
> > buffers to be Write-Through (ioremap_cache + mtrr Write-Through + this
> > kernel patch) everything worked as expected.
> 
> Right, but this all sounds like you want to use ioremap_nocache which
> makes your buffers UC.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

Maybe you missunderstood me.

My configuration is:

Transmit Buffers WC (only write to that buffer)
i have PICe bursts on my tracer.

Receive Buffers WT (only read to that buffer).
I use clflush_cache_range before reading from that
adresses and i have PCIe bursts on my tracer.

With UC memory there are no PCIe bursts and my bandwidth
is very slow.

Best regards
	Andy

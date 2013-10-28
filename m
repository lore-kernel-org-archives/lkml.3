Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3J1G3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:29:52 -0400
Received: from mout.gmx.net ([212.227.15.18]:56787 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3J1G3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:29:51 -0400
Date: Mon, 28 Oct 2013 07:29:46 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028062946.GA1391@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027190148.GD21868@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:RrjIUl78C2jMUQ0bPvKFzdBkaPLM2TMcIR3h2frHiJq+fIV7kpS
 ApIwg9MjecsH39WbxMnWGtj7PNNni/Mzzkksxa8wJeR4pBuUhQyXEL27Qa+PEHi8208s1E6
 nCq/aZz/JzWb9JKuiECmRgVcENAtDuwM53am3ktee8HTkOyhORXYflgj+32nAYMgTWW8Bck
 c624b14TI9S0vqSB15b+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:01:48PM +0100, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 06:56:08PM +0100, Andreas Werner wrote:
> > Transmit Buffers WC (only write to that buffer)
> > i have PICe bursts on my tracer.
> 
> For that you can do ioremap_wc().

Yes i am currently using ioremap_wc() and it is working
as expected.
> 
> > Receive Buffers WT (only read to that buffer). I use
> > clflush_cache_range before reading from that adresses and i have PCIe
> > bursts on my tracer.
> 
> That one I don't understand - why would you need a WT buffer? It only
> caches reads but you will read from it only once after it has been
> received. Why pollute the cache?
> 
> IOW, you probably could use a WC buffer here too, as it would combine
> the writes coming from the FPGA.
> 
> Btw, there's also mtrr_add(..., MTRR_TYPE_WRTHROUGH, ) if you must use a
> WT thing. Have you tried that?
> 
For reading i need to map the mmio with attributes that allow cache-line read.
Therefore i use WT. For the Virtual address i use ioremap_cache in combination
with this patch to get an effective memory type of "Write-Through". This allows
me to read from the mmio with "PCIe burst". The write behaviour to this
region do not matter.

The clflush is used to remove stale cache lines from the cache so that
the read operation to a line goes to the MMIO device.
WT was the only one where i had bursts in reading.
A WC buffer had the same behaviour like UC on the PCIe Tracer (for reading).

I use mtrr_add to make an entry in the MTRR with a typ of WRTHROUGH
for the "receive" memory region.


> > With UC memory there are no PCIe bursts and my bandwidth is very slow.
> 
> Right.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

Regards
Andy

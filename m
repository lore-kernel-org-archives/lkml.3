Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3J0Rbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 13:31:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41400 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab3J0Rbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 13:31:34 -0400
Date: Sun, 27 Oct 2013 18:31:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131027173131.GC21868@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131027165159.GD1617@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 05:51:59PM +0100, Andreas Werner wrote:
> Im currently working on an ethernet driver for our own ETH core. The
> problem is that one requirement is to not use DMA to transmit or
> receive the data. This means the that the ethernet buffers are not
> located in the main memory. They are located in the FPGA internal RAM.
>
> To transmit or receive a frame, i have to read or write to mmio to get
> the data.
>
> Intel has introduced the instruction "clflush" which can flush a cache
> line. I want to use the caches for those mmio (eth buffer) to speed
> up the transmit/receive and to transmit/receive using PCIe bursts
> (read/write).
>
> The problem was if i set the buffer to Write-Back and call clflush on
> those mmio-addresses, the system crashed without any output.

But allocating a WB region and calling CLFLUSH right after writing
into it sounds like you want to allocate an UC region, no? Writing
into it will make sure the data has reached memory and is not in the
cache, basically what CLFLUSH does but by having it UC, this happens
automatically.

So basically what ioremap_nocache does.

> I found this articel 
> http://software.intel.com/en-us/forums/topic/393070
>
> After that i configured the transmit buffers to be Write-Combining
> (only write to that adresses) using ioremap_wc, and the receive
> buffers to be Write-Through (ioremap_cache + mtrr Write-Through + this
> kernel patch) everything worked as expected.

Right, but this all sounds like you want to use ioremap_nocache which
makes your buffers UC.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

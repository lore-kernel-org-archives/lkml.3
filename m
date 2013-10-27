Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3J0QwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:52:08 -0400
Received: from mout.gmx.net ([212.227.17.22]:56077 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3J0QwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:52:06 -0400
Date: Sun, 27 Oct 2013 17:51:59 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131027165159.GD1617@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027133401.GB24817@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:XR5sVHvoG/ZIktvcYyh+8g8y16ie+p0YF8WahZcZHW72qtwAcvW
 WQyclra0DEZHlJibwPk85swy0GnPerXxjUs+K3bacPutodCw1YiOwTFaT2JTIMj+HOqakQ+
 kD2g3yK8kJqhmCZ9OEiQFVVqnR3jkHcvs2LM7oRn6zzvDf5avdexXeIKZT2uhTPfioCIuAJ
 cCGvHL3YWDNI2swbM19Yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 02:34:01PM +0100, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 01:55:25PM +0100, Andreas Werner wrote:
> > This patch adds the Write-through memory type in combination with mtrr.
> > If you call ioremap_cache to request cachable memory (write-back) the
> > function tries to set the PAT to write-back only if the mtrr setting of
> > the requested region is also marked as Write-Back.
> > If the mttr regions are marked e.g. as Write-through or with other
> > types, the function will always return UC- memory.
> > 
> > If you check the Intel document " IA-32 SDM vol 3a table Effective
> > Memory Type", there
> > are many other combinations possible.
> > 
> > This patch will only add the following combination:
> >   PAT=Write-Back + MTRR=Write-Through = Effective Memory of
> > Write-Through
> 
> And yet the code below returns WB for WT MTRR type which can't be
> right since having a write-through mapping cannot be compatible with
> write-back as the last caches writes into the cache instead of writing
> them through to memory.
> 
> Why do you even care about WT? Are you trying to fix a bug or what?
>

Im currently working on an ethernet driver for our own ETH core.
The problem is that one requirement is to not use DMA to transmit 
or receive the data. This means the that the ethernet buffers are not 
located in the main memory. They are located in the FPGA internal RAM.
 
To transmit or receive a frame, i have to read or write to mmio to get the data.
 
Intel has introduced the instruction "clflush" which can flush a cache line.
I want to use the caches for those mmio (eth buffer) to speed up the transmit/receive
and to transmit/receive using PCIe bursts (read/write).
 
The problem was if i set the buffer to Write-Back and call clflush on 
those mmio-addresses, the system crashed without any output.
I found this articel 
http://software.intel.com/en-us/forums/topic/393070
 
After that i configured the transmit buffers to be Write-Combining (only write to that adresses) 
using ioremap_wc, and the receive buffers to be Write-Through (ioremap_cache + mtrr Write-Through + this kernel patch) 
everything worked as expected.
 
On PCIe Tracer i can see the bursts on read/write on my device with this configuration.

I know that this is a special use case but there is also one person more out there,
who use that configuration. But why not allow this setting in the kernel? It is
also mentioned in the Intel IA32 document.

I know that there is also an instruction called "movntdqa" but this is not support on my platform
(Intel E680) this instruction was introduced in SSE3. So i can not use it.

If you need more detailed informations please ask me.

Best Regards
Andy

> > Tested on - Intel (R) Atom E680 (Tunnel Creek)
> >           - Intel (R) Core(TM)2 Duo
> > 
> > Signed-off-by: Andreas Werner <wernerandy@gmx.de>
> > ---
> >  arch/x86/mm/pat.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> > index 6574388..9cfe107 100644
> > --- a/arch/x86/mm/pat.c
> > +++ b/arch/x86/mm/pat.c
> > @@ -149,10 +149,15 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
> >  		u8 mtrr_type;
> >  
> >  		mtrr_type = mtrr_type_lookup(start, end);
> > -		if (mtrr_type != MTRR_TYPE_WRBACK)
> > -			return _PAGE_CACHE_UC_MINUS;
> >  
> > -		return _PAGE_CACHE_WB;
> > +		switch (mtrr_type) {
> > +		case MTRR_TYPE_WRBACK:
> > +		case MTRR_TYPE_WRTHROUGH:
> > +		  return _PAGE_CACHE_WB;
> > +
> > +		default:
> > +		  return _PAGE_CACHE_UC_MINUS;
> > +		}
> >  	}
> >  
> >  	return req_type;
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

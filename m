Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaKGWyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:54:39 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36135 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbaKGWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:54:38 -0500
X-Sasl-enc: vQZ94KZu7iSdu3b0ia3qA9snmHv2SVnfaTOCR/M7coDr 1415400877
Date: Fri, 7 Nov 2014 20:54:25 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141107225425.GC18128@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107195905.GE5180@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Borislav Petkov wrote:
> > --- a/Documentation/x86/early-microcode.txt
> > +++ b/Documentation/x86/early-microcode.txt
> > @@ -14,6 +14,16 @@ during boot time. The microcode file in cpio name space is:
> >  on Intel: kernel/x86/microcode/GenuineIntel.bin
> >  on AMD  : kernel/x86/microcode/AuthenticAMD.bin
> >  
> > +For Intel processors, the microcode load process will be faster when special
> 
> faster??

Well, it might well be lost in the noise given how slow a microcode update
is.

What I mean is that the early microcode driver "won't waste cpu time moving
data that is already aligned".

However, if the data is _not_ aligned (and it will *not* be aligned if you
use standard cpio without any tricks), the early driver will have to move it
around so that it respects the architectural requirement of 16-byte
alignment for the microcode update WRMSR.

> > index 2182cec..40caef1 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel.c
> > @@ -157,6 +157,11 @@ static int apply_microcode_intel(int cpu)
> >  	if (mc_intel == NULL)
> >  		return 0;
> >  
> > +	/* Intel SDM vol 3A section 9.11.6, page 9-34 */
> > +	if (WARN_ONCE((unsigned long)(mc_intel->bits) % 16,
> > +		"microcode data incorrectly aligned"))
> 
> I wonder how many people would start complaining when this goes out the
> door? Have you checked actually how the majority of the tools do layout
> the microcode in the initrd?

That WARN_ONCE() should only trigger if a bug shows its ugly face.  If it is
triggering in any other case, this patch is broken.

mc_intel->bits in the late driver really shouldn't depend at all on any
alignment from initramfs or whatever: that path is supposed to run on
microcode that came from the firmware loader, or the deprecated microcode
device, or which was memcpy'd from the initramfs to a kmalloc()'d area by
save_microcode() in the early driver.  All of these will always be 16-byte
aligned AFAIK.

So, the early driver gets alignment code as it will usually have to deal
with unaligned microcode data, and the late driver (which should never see
unaligned microcode data) gets a WARN_ONCE to alert us if something broke in
the kernel code.

Should I change the WARN_ONCE message to:

WARN_ONCE(... "kernel bug: microcode data incorrectly aligned") ?

> > +		return -1;
> > +
> >  	/*
> >  	 * Microcode on this CPU might be already up-to-date.  Only apply
> >  	 * the microcode patch in mc_intel when it is newer than the one
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> > index 92629a8..994c59b 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> > @@ -662,14 +662,40 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
> >  	struct microcode_intel *mc_intel;
> >  	unsigned int val[2];
> >  
> > +	char savedbuf[16];
> > +	void *mcu_data;
> > +	void *aligned_mcu_data;
> > +	unsigned int mcu_size = 0;
> > +
> >  	mc_intel = uci->mc;
> >  	if (mc_intel == NULL)
> >  		return 0;
> >  
> > +	mcu_data = mc_intel->bits;
> > +	aligned_mcu_data = mc_intel->bits;
> > +
> > +	/* Intel SDM vol 3A section 9.11.6, page 9-34: */
> > +	/* WRMSR MSR_IA32_UCODE_WRITE requires 16-byte alignment */
> 
> Kernel comment style:
> 
> 	/*
> 	 * Blabla.
> 	 * More bla.
> 	 */

Will fix.

> > +	if ((unsigned long)(mcu_data) % 16) {
> > +		/* We have more than 16 bytes worth of microcode header
> > +		 * just before mc_intel->bits on a version 1 header */
> > +		BUILD_BUG_ON(offsetof(struct microcode_intel, bits) < 16);
> 
> That's not really needed - I don't see struct microcode_header_intel
> changing anytime soon.

Neither do I.  But this has zero footprint on the resulting kernel, and
might save someone 10 years from now from trying to debug initramfs data
corruption.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

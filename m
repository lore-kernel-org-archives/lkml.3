Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaJTSYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:24:42 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48681 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaJTSYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:24:39 -0400
X-Sasl-enc: 1i4JjfJraiCGq+N1tKl3hjKdOpj4nNb0B1sW+PFt/fB1 1413829478
Date: Mon, 20 Oct 2014 16:24:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2/8] x86, microcode, intel: don't update each HT core
 twice
Message-ID: <20141020182427.GB19306@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
 <20141020133252.GC3524@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020133252.GC3524@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:48PM -0300, Henrique de Moraes Holschuh wrote:
> > -static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
> > +static void __collect_cpu_info(int cpu_num, struct cpu_signature *csig)
> >  {
> >  	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
> >  	unsigned int val[2];
> > @@ -102,7 +102,19 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
> >  		csig->pf = 1 << ((val[1] >> 18) & 7);
> >  	}
> >  
> > -	csig->rev = c->microcode;
> > +	/* get the current microcode revision from MSR 0x8B */
> > +	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> > +	sync_core();
> > +	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
> > +
> > +	csig->rev = val[1];
> > +	c->microcode = val[1];  /* re-sync */
> > +}
> > +
> > +static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
> > +{
> > +	__collect_cpu_info(cpu_num, csig);
> > +
> >  	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
> >  		cpu_num, csig->sig, csig->pf, csig->rev);
> 
> We probably should downgrade this to pr_debug and use collect_cpu_info()
> everywhere instead of having a __ version.

Over time, grepping for that information on reports and logs all over the
net has helped me a great deal.  In fact, it is in my backlog to add it to
the early microcode driver as well.

I really miss the full microcode ID information in /proc/cpuinfo, in fact.

If you want, I can modify the logging it in a future patch so that we print
it only once when all cores have the same sig, pf and revision (which should
cover 95% of the systems out there).

> > -	/* write microcode via MSR 0x79 */
> > +	/* write microcode via MSR 0x79. THIS IS VERY EXPENSIVE */
> 
> No need for screaming here - we know MSR accesses are expensive. This
> comment is totally useless here so drop it altogether.

MSR 79H writes are on a class of their own as far as "expensive" goes... On
a modern i3/i5/i7, it will take approximately one million cycles to complete
(the larger the microcode update, the longer it takes).

I don't think people usually associate MSR write with "takes one million
cycles to complete"...

That said, I will remove the comment.

> >  	wrmsr(MSR_IA32_UCODE_WRITE,
> > -	      (unsigned long) mc_intel->bits,
> > -	      (unsigned long) mc_intel->bits >> 16 >> 16);
> > -	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> > -
> > -	/* As documented in the SDM: Do a CPUID 1 here */
> > -	sync_core();
> > +		lower_32_bits((unsigned long) mc_intel->bits),
> > +		upper_32_bits((unsigned long) mc_intel->bits));
> 
> wrmsrl() takes u64 directly - no need for the splitting.

This is old code, I guess it predates wrmsrl()...

Should I replace the old split version with wrmsrl() in this patch, or as a
separate patch?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

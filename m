Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161917AbaKNVHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:07:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:4760 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaKNVHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:07:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="608081646"
Message-ID: <1415999255.29427.5.camel@theros.lm.intel.com>
Subject: Re: [PATCH 1/6] x86: Add support for the pcommit instruction
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Date: Fri, 14 Nov 2014 14:07:35 -0700
In-Reply-To: <546424B1.6070205@amacapital.net>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1415731396-19364-2-git-send-email-ross.zwisler@linux.intel.com>
	 <546424B1.6070205@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 19:25 -0800, Andy Lutomirski wrote:
> On 11/11/2014 10:43 AM, Ross Zwisler wrote:
> > Add support for the new pcommit instruction.  This instruction was
> > announced in the document "Intel Architecture Instruction Set Extensions
> > Programming Reference" with reference number 319433-022.
> > 
> > https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: H Peter Anvin <h.peter.anvin@intel.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: x86@kernel.org
> > ---
> >  arch/x86/include/asm/cpufeature.h    | 1 +
> >  arch/x86/include/asm/special_insns.h | 6 ++++++
> >  2 files changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index 0bb1335..b3e6b89 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -225,6 +225,7 @@
> >  #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
> >  #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
> >  #define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
> > +#define X86_FEATURE_PCOMMIT	( 9*32+22) /* PCOMMIT instruction */
> >  #define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
> >  #define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
> >  #define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
> > diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> > index e820c08..1709a2e 100644
> > --- a/arch/x86/include/asm/special_insns.h
> > +++ b/arch/x86/include/asm/special_insns.h
> > @@ -199,6 +199,12 @@ static inline void clflushopt(volatile void *__p)
> >  		       "+m" (*(volatile char __force *)__p));
> >  }
> >  
> > +static inline void pcommit(void)
> > +{
> > +	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
> > +		    X86_FEATURE_PCOMMIT);
> > +}
> > +
> 
> Should this patch add the feature bit and cpuinfo entry to go with it?
> 
> --Andy

I think this patch does everything we need?  The text for cpuinfo is
auto-generated in arch/x86/kernel/cpu/capflags.c from the flags defined
in arch/x86/include/asm/cpufeature.h, I think.  Here's what I get in
cpuinfo on my system with a faked-out CPUID saying that clwb and pcommit
are present:

$ grep 'flags' /proc/cpuinfo 
flags		: fpu <snip> erms pcommit clflushopt clwb xsaveopt

The X86_FEATURE_CLWB and X86_FEATURE_PCOMMIT flags are being set up
according to what's in CPUID, and the proper alternatives are being
triggered.  I stuck some debug code in the alternatives code to see what
was being patched in the presence and absence of each of the flags.

Is there something else I'm missing?

Thanks,
- Ross


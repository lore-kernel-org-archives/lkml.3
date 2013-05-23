Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab3EWPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:18:07 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:36615
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759348Ab3EWPSE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:18:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Ic89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h93fhd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN9BTS-02-2II-02
X-M-MSG: 
Date: Thu, 23 May 2013 10:17:54 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/microcode: vendor abstract out
 save_microcode_in_initrd()
Message-ID: <20130523151754.GA1476@jshin-Toonie>
References: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
 <1369271734-3231-2-git-send-email-jacob.shin@amd.com>
 <20130523075423.GA3977@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130523075423.GA3977@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:54:23AM +0200, Borislav Petkov wrote:
> On Wed, May 22, 2013 at 08:15:33PM -0500, Jacob Shin wrote:
> > Currently save_microcode_in_initrd() is declared in vendor neutural
> > microcode.h file, but defined in vendor specific
> > microcode_intel_early.c file. Vendor abstract it out to
> > microcode_core_early.c with a wrapper function.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/include/asm/microcode_intel.h  |    2 ++
> >  arch/x86/kernel/microcode_core_early.c  |   10 ++++++++++
> >  arch/x86/kernel/microcode_intel_early.c |    2 +-
> >  3 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> > index 5356f92..cf729eb 100644
> > --- a/arch/x86/include/asm/microcode_intel.h
> > +++ b/arch/x86/include/asm/microcode_intel.h
> > @@ -67,10 +67,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
> >  extern void __init load_ucode_intel_bsp(void);
> >  extern void __cpuinit load_ucode_intel_ap(void);
> >  extern void show_ucode_info_early(void);
> > +extern int __init save_microcode_in_initrd_intel(void);
> >  #else
> >  static inline __init void load_ucode_intel_bsp(void) {}
> >  static inline __cpuinit void load_ucode_intel_ap(void) {}
> >  static inline void show_ucode_info_early(void) {}
> > +static inline int __init save_microcode_in_initrd_intel(void) {}
> 
> In file included from arch/x86/kernel/cpu/common.c:41:0:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
> In file included from arch/x86/kernel/microcode_intel_lib.c:30:0:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
> In file included from arch/x86/kernel/microcode_intel.c:82:0:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
> /w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
> Setup is 15436 bytes (padded to 15872 bytes).
> System is 4268 kB
> CRC a330a73f
> 
> You need:
> 
> diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> index cf729eb3beee..87a085333cbf 100644
> --- a/arch/x86/include/asm/microcode_intel.h
> +++ b/arch/x86/include/asm/microcode_intel.h
> @@ -72,7 +72,7 @@ extern int __init save_microcode_in_initrd_intel(void);
>  static inline __init void load_ucode_intel_bsp(void) {}
>  static inline __cpuinit void load_ucode_intel_ap(void) {}
>  static inline void show_ucode_info_early(void) {}
> -static inline int __init save_microcode_in_initrd_intel(void) {}
> +static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }

Oops, sorry about that. Will fix,

>  #endif
>  
>  #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
> 
> Btw,
> 
> could you pick up this trivial fix and add it to your set - I can't help
> myself when I see typos, especially in user-visible printks :)

Will do and send out a V2 today.

Thanks!


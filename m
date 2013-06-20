Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994Ab3FTAha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:37:30 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60969 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382Ab3FTAh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:37:29 -0400
Date: Wed, 19 Jun 2013 20:36:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Fix section mismatch on load_ucode_ap
Message-ID: <20130620003654.GB15693@windriver.com>
References: <1371654926-11729-1-git-send-email-paul.gortmaker@windriver.com>
 <tip-949785996ec2250fa958fc3a924e5186e9a8fa2c@git.kernel.org>
 <CAE9FiQWdTVFo5PW7dycXj-Exv5jVyzQcHfrH_q2tJbDRYnPZeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQWdTVFo5PW7dycXj-Exv5jVyzQcHfrH_q2tJbDRYnPZeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [tip:x86/urgent] x86: Fix section mismatch on load_ucode_ap] On 19/06/2013 (Wed 17:02) Yinghai Lu wrote:

> On Wed, Jun 19, 2013 at 3:03 PM, tip-bot for Paul Gortmaker
> <tipbot@zytor.com> wrote:
> > Commit-ID:  949785996ec2250fa958fc3a924e5186e9a8fa2c
> > Gitweb:     http://git.kernel.org/tip/949785996ec2250fa958fc3a924e5186e9a8fa2c
> > Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
> > AuthorDate: Wed, 19 Jun 2013 11:15:26 -0400
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 19 Jun 2013 14:43:59 -0700
> >
> > x86: Fix section mismatch on load_ucode_ap
> >
> > We are in the process of removing all the __cpuinit annotations.
> > While working on making that change, an existing problem was
> > made evident:
> >
> >   WARNING: arch/x86/kernel/built-in.o(.text+0x198f2): Section mismatch
> >   in reference from the function cpu_init() to the function
> >   .init.text:load_ucode_ap()   The function cpu_init() references
> >   the function __init load_ucode_ap().  This is often because cpu_init
> >   lacks a __init annotation or the annotation of load_ucode_ap is wrong.
> >
> > This now appears because in my working tree, cpu_init() is no longer
> > tagged as __cpuinit, and so the audit picks up the mismatch.  The 2nd
> > hypothesis from the audit is the correct one, as there was an incorrect
> > __init tag on the prototype in the header (but __cpuinit was used on
> > the function itself.)
> >
> > The audit is telling us that the prototype's __init annotation took
> > effect and the function did land in the .init.text section.  Checking
> > with objdump on a mainline tree that still has __cpuinit shows that
> > the __cpuinit on the function takes precedence over the __init on the
> > prototype, but that won't be true once we make __cpuinit a no-op.
> >
> > Even though we are removing __cpuinit, we temporarily align both
> > the function and the prototype on __cpuinit so that the changeset
> > can be applied to stable trees  if desired.
> >
> > [ hpa: build fix only, no object code change ]
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: stable <stable@vger.kernel.org> # 3.9+
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Link: http://lkml.kernel.org/r/1371654926-11729-1-git-send-email-paul.gortmaker@windriver.com
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/include/asm/microcode.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
> > index 6825e2e..6bc3985 100644
> > --- a/arch/x86/include/asm/microcode.h
> > +++ b/arch/x86/include/asm/microcode.h
> > @@ -60,11 +60,11 @@ static inline void __exit exit_amd_microcode(void) {}
> >  #ifdef CONFIG_MICROCODE_EARLY
> >  #define MAX_UCODE_COUNT 128
> >  extern void __init load_ucode_bsp(void);
> > -extern __init void load_ucode_ap(void);
> > +extern void __cpuinit load_ucode_ap(void);
> 
> why not just dropping __init in header file?

Why?  Because then the mis-match remains, and the next person along who
cares about understanding what it really means, has to repeat the same
research that I did in order to understand what was really happening
(or in this case, not happening).  Why do that?  That doesn't make sense.

Paul.
--

> 
> 
> >  extern int __init save_microcode_in_initrd(void);
> >  #else
> >  static inline void __init load_ucode_bsp(void) {}
> > -static inline __init void load_ucode_ap(void) {}
> > +static inline void __cpuinit load_ucode_ap(void) {}
> >  static inline int __init save_microcode_in_initrd(void)
> >  {
> >         return 0;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

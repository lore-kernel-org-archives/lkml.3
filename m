Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaJHTuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:50:46 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:59015 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121AbaJHTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:50:45 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Wed, 8 Oct 2014 20:49:55 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141008194955.GF12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
 <20141008051059.65566251@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141008051059.65566251@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 05:10:59AM -0500, Chuck Ebbert wrote:
> On Wed, 8 Oct 2014 10:03:36 +0100
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > 
> > I ran into a problem on a Sandybridge i5-2500s whilst measuring the
> > performance of GTT write-combining access. I found subsequent runs were
> > about 10-40x slower than the first. For example,
> > 
> > igt/gem_gtt_speed:
> > 
> > Time to read 16k through a GTT map:             325.285탎
> > Time to write 16k through a GTT map:              4.729탎
> > Time to clear 16k through a GTT map:              4.584탎
> > Time to clear 16k through a cached GTT map:       1.342탎
> > 
> > on the second run became:
> > 
> > Time to read 16k through a GTT map:             332.148탎
> > Time to write 16k through a GTT map:            209.411탎
> > Time to clear 16k through a GTT map:             56.460탎
> > Time to clear 16k through a cached GTT map:      50.897탎
> > 
> > Naively I would say that we lost the wc on our ioremap.
> > /sys/kernel/debug/x86/pat_memtype_list remained the same across repeated
> > runs.
> > 
> > A bisection pointed to 
> > 
> > commit ea8596bb2d8d37957f3e92db9511c50801689180
> > Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Date:   Thu Jul 18 20:47:53 2013 +0900
> > 
> >     kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions
> > 
> > of which the active ingredient was just
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index b32ebf9..f4001e0 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2334,7 +2334,6 @@ config HAVE_ATOMIC_IOMAP
> >  
> >  config HAVE_TEXT_POKE_SMP
> >         bool
> > -       select STOP_MACHINE if SMP
> >  
> >  config X86_DEV_DMA_OPS
> >         bool
> > 
> > and adding that back into the current build, e.g.
> 
> Hmm, set_mtrr() uses stop_machine(). I wonder if your MTRRs are out of
> sync and your results depend on which CPU the test runs on?

Indeed, this appears to be the explanation. (And here I thought PAT
superseded mtrrs - i915.ko stopped trying to use assign an mtrr for its
GTT quite a while ago.)

Replacing the stop_machine there with on_each_cpu does the trick:

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index f961de9..c0e37d5 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -151,7 +151,7 @@ struct set_mtrr_data {
  *
  * Returns nothing.
  */
-static int mtrr_rendezvous_handler(void *info)
+static void mtrr_rendezvous_handler(void *info)
 {
        struct set_mtrr_data *data = info;
 
@@ -174,7 +174,6 @@ static int mtrr_rendezvous_handler(void *info)
        } else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
                mtrr_if->set_all();
        }
-       return 0;
 }
 
 static inline int types_compatible(mtrr_type type1, mtrr_type type2)
@@ -228,7 +227,7 @@ set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type typ
                                      .smp_type = type
                                    };
 
-       stop_machine(mtrr_rendezvous_handler, &data, cpu_online_mask);
+       on_each_cpu_mask(cpu_online_mask, mtrr_rendezvous_handler, &data, true);
 }
 
 static void set_mtrr_from_inactive_cpu(unsigned int reg, unsigned long base,
@@ -240,8 +239,7 @@ static void set_mtrr_from_inactive_cpu(unsigned int reg, unsigned long base,
                                      .smp_type = type
                                    };
 
-       stop_machine_from_inactive_cpu(mtrr_rendezvous_handler, &data,
-                                      cpu_callout_mask);
+       on_each_cpu_mask(cpu_callout_mask, mtrr_rendezvous_handler, &data, true);
 }
 
 /**

-- 
Chris Wilson, Intel Open Source Technology Centre

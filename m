Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3IKN6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:58:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34442 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:58:16 -0400
Date: Wed, 11 Sep 2013 09:57:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911135745.GB11043@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
 <20130911134717.GA10925@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911134717.GA10925@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 09:47:17AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 10, 2013 at 07:48:44PM -0700, H. Peter Anvin wrote:
> > Hi Linus,
> > 
> > One more x86 tree for this merge window.  This tree improves the
> > handling of jump labels, so that most of the time we don't have to do
> > a massive initial patching run.  Furthermore, we will error out of the
> > jump label is not what is expected, e.g. if it has been corrupted or
> > tampered with.
> > 
> > This tree does conflict with your top of tree; the resolution should be
> > reasonably straightforward but let me know if you want a merged tree.
> > 
> > The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> > 
> >   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-jumplabel-for-linus
> > 
> > for you to fetch changes up to fb40d7a8994a3cc7a1e1c1f3258ea8662a366916:
> > 
> >   x86/jump-label: Show where and what was wrong on errors (2013-08-06 21:54:33 -0400)
> 
> This triggers BUG when booting a Xen guest with PV ticketlocks enabled (which
> are by default enabled). If I revert this merge it boots, or if I provide 'xen_nopvspin'..
> 
> With some modifications (pasted-in-at-the-end) I see:
> 
> about to get started...
> Unexpected op at trace_clock_global+0x6b/0x120 [ffffffff8113a21b] (0f 1f 44 00 00) /home/build/linux-konrad/arch/x86/kernel/jumpn VCPU 0 [ec=0000]
> (XEN) domain_crash_sync called from entry.S
> (XEN) Domain 0 (vcpu#0) crashed on cpu#0:
> (XEN) ----[ Xen-4.2.2-pre  x86_64  debug=n  Not tainted ]----
> (XEN) CPU:    0
> (XEN) RIP:    e033:[<ffffffff81051e3d>]
> (XEN) RFLAGS: 0000000000000292   EM: 1   CONTEXT: pv guest
> (XEN) rax: 0000000000000000   rbx: ffffffff81eaaec0   rcx: 0000000000000001
> (XEN) rdx: ffffffff81fac0a0   rsi: 000000000000008c   rdi: 0000000000000000
> (XEN) rbp: ffffffff81c01e88   rsp: ffffffff81c01e08   r8:  000000000000fffa
> (XEN) r9:  0000000000000002   r10: 0000000000000000   r11: 000000000000fffd
> (XEN) r12: ffffffff81ca8598   r13: ffffffff81eaaea0   r14: 0000000000000000
> (XEN) r15: 0000000000000000   cr0: 0000000080050033   cr4: 00000000000426f0
> (XEN) cr3: 0000000231c0c000   cr2: 0000000000000000
> (XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
> (XEN) Guest stack trace from rsp=ffffffff81c01e08:
> (XEN)    0000000000000001 000000000000fffd ffffffff81051e3d 000000010000e030
> (XEN)    0000000000010092 ffffffff81c01e48 000000000000e02b ffffffff81051e3d
> (XEN)    ffffffff00000000 0000000000000000 ffffffff81952c18 0000000000000035
> (XEN)    0000000000441f0f 0000000000000018 ffffff9066666666 ffffffffffffffff
> (XEN)    ffffffff81c01ea8 ffffffff81051eb5 0000000000441f0f 0000000000000000
> (XEN)    ffffffff81c01ed8 ffffffff81cfbbfb ffffffff81d6b900 ffffffffffffffff
> (XEN)    ffffffff81d6b900 ffffffff81d742e0 ffffffff81c01f28 ffffffff81cd3e3c
> (XEN)    ffffffff81cd3af2 ffffffff82051000 ffffffff82052000 ffffffff81d742e0
> (XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
> (XEN)    ffffffff81c01f38 ffffffff81cd35f3 ffffffff81c01ff8 ffffffff81cd833a
> (XEN)    0300000100000032 0000000000000005 0000000000000000 0000000000000000
> (XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
> (XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
> (XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
> (XEN)    0000000000000000 0000000000000000 9d9822831fc9cbf5 000206a700100800
> (XEN)    0000000000000001 0000000000000000 0000000000000000 0f00000060c0c748
> (XEN)    ccccccccccccc305 cccccccccccccccc cccccccccccccccc cccccccccccccccc
> (XEN)    cccccccccccccccc cccccccccccccccc cccccccccccccccc cccccccccccccccc
> (XEN)    cccccccccccccccc cccccccccccccccc cccccccccccccccc cccccccccccccccc
> (XEN)    cccccccccccccccc cccccccccccccccc cccccccccccccccc cccccccccccccccc
> (XEN) Domain 0 crashed: rebooting machine in 5 seconds.
> (XEN) Resetting with ACPI MEMORY or I/O RESET_REG.
> 
> I can boot it with 'xen_nopvspin' which leads me to believe that it is due
> to:
> 
> 262 void __init xen_init_spinlocks(void)                                            
> 263 {                                                                               
> 264                                                                                 
> 265         if (!xen_pvspin) {                                                      
> 266                 printk(KERN_DEBUG "xen: PV spinlocks disabled\n");              
> 267                 return;                                                         
> 268         }                                                                       
> 269                                                                                 
> 270         static_key_slow_inc(&paravirt_ticketlocks_enabled); <====
> 
> Which means that all of the arch_spin_unlock (which are inlined) and such
> will now be patched over.
> 
> But perhaps they are not suppose to be enabled in the .smp_prepare_boot_cpu
> function chain? But that seems the best place - as you need to enable
> this before the spinlocks are used on SMP.
> 
> And the IPs are all NOPs.
> 
> Steven, ideas?
> 
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index ee11b7d..e37a2bb 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -23,7 +23,7 @@ union jump_code_union {
>                 int offset;
>         } __attribute__((packed));
>  };
> -
> +#include <xen/hvc-console.h>
>  static void bug_at(unsigned char *ip, int line)
>  {
>         /*
> @@ -31,7 +31,7 @@ static void bug_at(unsigned char *ip, int line)
>          * Something went wrong. Crash the box, as something could be
>          * corrupting the kernel.
>          */
> -       pr_warning("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
> +       xen_raw_printk("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
>                ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
>         BUG();
>  }
> 
> Let me modify the bug_at so that the 'line' can been seen as it seems to have been
> truncated.

It seems to imply line 53 is the originating bug, so that would be:

 47         if (type == JUMP_LABEL_ENABLE) {
 48                 /*
 49                  * We are enabling this jump label. If it is not a nop
 50                  * then something must have gone wrong.
 51                  */
 52                 if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
 53                         bug_at((void *)entry->code, __LINE__);

But it is a NOP isn't it? The code is

Unexpected op at trace_clock_global+0x6b/0x120 [ffffffff8113a21b] (0f 1f 44 00 00) 53

Perhaps the ideal_nop has not been set yet?


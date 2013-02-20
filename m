Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3BTJNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:13:48 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:48166 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3BTJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:13:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355097600"; 
   d="scan'208";a="1641849"
Message-ID: <1361351620.1051.139.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH LINUX v4] xen: event channel arrays are xen_ulong_t and
 not unsigned long
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 20 Feb 2013 09:13:40 +0000
In-Reply-To: <20130220030943.GA28092@phenom.dumpdata.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361294951-28633-1-git-send-email-ian.campbell@citrix.com>
	 <20130220020727.GA25329@phenom.dumpdata.com>
	 <20130220030943.GA28092@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 03:09 +0000, Konrad Rzeszutek Wilk wrote:
> On Tue, Feb 19, 2013 at 09:07:27PM -0500, Konrad Rzeszutek Wilk wrote:
> > On Tue, Feb 19, 2013 at 05:29:11PM +0000, Ian Campbell wrote:
> > > On ARM we want these to be the same size on 32- and 64-bit.
> > >
> > > This is an ABI change on ARM. X86 does not change.
> >
> > Hehe. You didn't test this, did you :-)
> >
> > It hangs bootup on X86.
> 
> Ah wait. The version that hangs was the first posted - I hadn't
> tested this one yet. I will wait until later on Wednesday to do that.

I don't know what I tested yesterday but it surely wasn't this patch
because it hangs for me too this morning :-/

Sorry about this, will investigate...

Ian.

> 
> 
> > >
> > > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > > Cc: Jan Beulich <JBeulich@suse.com>
> > > Cc: Keir (Xen.org) <keir@xen.org>
> > > Cc: Tim Deegan <tim@xen.org>
> > > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: xen-devel@lists.xen.org
> > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > > Changes since V3
> > >   s/read_evtchn_pending_sel/xchg_xen_ulong/ in a comment.
> > > Changes since V2
> > >   Add comments about the correct bitops to use, and on the ordering/barrier
> > >   requirements on xchg_xen_ulong.
> > > Changes since V1
> > >   use find_first_set not __ffs
> > >   fix some more unsigned long -> xen_ulong_t
> > >   use more generic xchg_xen_ulong instead of ...read_evtchn...
> > > ---
> > >  arch/arm/include/asm/xen/events.h |   22 +++++++
> > >  arch/x86/include/asm/xen/events.h |    3 +
> > >  drivers/xen/events.c              |  113 +++++++++++++++++++++----------------
> > >  include/xen/interface/xen.h       |    8 +-
> > >  4 files changed, 94 insertions(+), 52 deletions(-)
> > >
> > > diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> > > index 94b4e90..5c27696 100644
> > > --- a/arch/arm/include/asm/xen/events.h
> > > +++ b/arch/arm/include/asm/xen/events.h
> > > @@ -15,4 +15,26 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
> > >     return raw_irqs_disabled_flags(regs->ARM_cpsr);
> > >  }
> > >
> > > +/*
> > > + * We cannot use xchg because it does not support 8-byte
> > > + * values. However it is safe to use {ldr,dtd}exd directly because all
> > > + * platforms which Xen can run on support those instructions.
> > > + */
> > > +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> > > +{
> > > +   xen_ulong_t oldval;
> > > +   unsigned int tmp;
> > > +
> > > +   wmb();
> > > +   asm volatile("@ xchg_xen_ulong\n"
> > > +           "1:     ldrexd  %0, %H0, [%3]\n"
> > > +           "       strexd  %1, %2, %H2, [%3]\n"
> > > +           "       teq     %1, #0\n"
> > > +           "       bne     1b"
> > > +           : "=&r" (oldval), "=&r" (tmp)
> > > +           : "r" (val), "r" (ptr)
> > > +           : "memory", "cc");
> > > +   return oldval;
> > > +}
> > > +
> > >  #endif /* _ASM_ARM_XEN_EVENTS_H */
> > > diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
> > > index cc146d5..ca842f2 100644
> > > --- a/arch/x86/include/asm/xen/events.h
> > > +++ b/arch/x86/include/asm/xen/events.h
> > > @@ -16,4 +16,7 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
> > >     return raw_irqs_disabled_flags(regs->flags);
> > >  }
> > >
> > > +/* No need for a barrier -- XCHG is a barrier on x86. */
> > > +#define xchg_xen_ulong(ptr, val) xchg((ptr), (val))
> > > +
> > >  #endif /* _ASM_X86_XEN_EVENTS_H */
> > > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > > index 0be4df3..b8d84f5 100644
> > > --- a/drivers/xen/events.c
> > > +++ b/drivers/xen/events.c
> > > @@ -80,6 +80,12 @@ enum xen_irq_type {
> > >  };
> > >
> > >  /*
> > > + * Make a bitmask (i.e. unsigned long *) of a xen_ulong_t
> > > + * array. Primarily to avoid long lines (hence the terse name).
> > > + */
> > > +#define BM(x) (unsigned long *)(x)
> > > +
> > > +/*
> > >   * Packed IRQ information:
> > >   * type - enum xen_irq_type
> > >   * event channel - irq->event channel mapping
> > > @@ -120,7 +126,14 @@ static unsigned long *pirq_eoi_map;
> > >  #endif
> > >  static bool (*pirq_needs_eoi)(unsigned irq);
> > >
> > > -static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
> > > +/*
> > > + * Note sizeof(xen_ulong_t) can be more than sizeof(unsigned long). Be
> > > + * careful to only use bitops which allow for this (e.g test_bit and
> > > + * friends but not __ffs).
> > > + */
> > > +#define BITS_PER_EVTCHN_WORD (sizeof(xen_ulong_t)*8)
> > > +
> > > +static DEFINE_PER_CPU(xen_ulong_t [NR_EVENT_CHANNELS/BITS_PER_EVTCHN_WORD],
> > >                   cpu_evtchn_mask);
> > >
> > >  /* Xen will never allocate port zero for any purpose. */
> > > @@ -294,9 +307,9 @@ static bool pirq_needs_eoi_flag(unsigned irq)
> > >     return info->u.pirq.flags & PIRQ_NEEDS_EOI;
> > >  }
> > >
> > > -static inline unsigned long active_evtchns(unsigned int cpu,
> > > -                                      struct shared_info *sh,
> > > -                                      unsigned int idx)
> > > +static inline xen_ulong_t active_evtchns(unsigned int cpu,
> > > +                                    struct shared_info *sh,
> > > +                                    unsigned int idx)
> > >  {
> > >     return sh->evtchn_pending[idx] &
> > >             per_cpu(cpu_evtchn_mask, cpu)[idx] &
> > > @@ -312,8 +325,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
> > >     cpumask_copy(irq_to_desc(irq)->irq_data.affinity, cpumask_of(cpu));
> > >  #endif
> > >
> > > -   clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
> > > -   set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
> > > +   clear_bit(chn, BM(per_cpu(cpu_evtchn_mask, cpu_from_irq(irq))));
> > > +   set_bit(chn, BM(per_cpu(cpu_evtchn_mask, cpu)));
> > >
> > >     info_for_irq(irq)->cpu = cpu;
> > >  }
> > > @@ -339,19 +352,19 @@ static void init_evtchn_cpu_bindings(void)
> > >  static inline void clear_evtchn(int port)
> > >  {
> > >     struct shared_info *s = HYPERVISOR_shared_info;
> > > -   sync_clear_bit(port, &s->evtchn_pending[0]);
> > > +   sync_clear_bit(port, BM(&s->evtchn_pending[0]));
> > >  }
> > >
> > >  static inline void set_evtchn(int port)
> > >  {
> > >     struct shared_info *s = HYPERVISOR_shared_info;
> > > -   sync_set_bit(port, &s->evtchn_pending[0]);
> > > +   sync_set_bit(port, BM(&s->evtchn_pending[0]));
> > >  }
> > >
> > >  static inline int test_evtchn(int port)
> > >  {
> > >     struct shared_info *s = HYPERVISOR_shared_info;
> > > -   return sync_test_bit(port, &s->evtchn_pending[0]);
> > > +   return sync_test_bit(port, BM(&s->evtchn_pending[0]));
> > >  }
> > >
> > >
> > > @@ -375,7 +388,7 @@ EXPORT_SYMBOL_GPL(notify_remote_via_irq);
> > >  static void mask_evtchn(int port)
> > >  {
> > >     struct shared_info *s = HYPERVISOR_shared_info;
> > > -   sync_set_bit(port, &s->evtchn_mask[0]);
> > > +   sync_set_bit(port, BM(&s->evtchn_mask[0]));
> > >  }
> > >
> > >  static void unmask_evtchn(int port)
> > > @@ -389,7 +402,7 @@ static void unmask_evtchn(int port)
> > >     if (unlikely((cpu != cpu_from_evtchn(port))))
> > >             do_hypercall = 1;
> > >     else
> > > -           evtchn_pending = sync_test_bit(port, &s->evtchn_pending[0]);
> > > +           evtchn_pending = sync_test_bit(port, BM(&s->evtchn_pending[0]));
> > >
> > >     if (unlikely(evtchn_pending && xen_hvm_domain()))
> > >             do_hypercall = 1;
> > > @@ -403,7 +416,7 @@ static void unmask_evtchn(int port)
> > >     } else {
> > >             struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
> > >
> > > -           sync_clear_bit(port, &s->evtchn_mask[0]);
> > > +           sync_clear_bit(port, BM(&s->evtchn_mask[0]));
> > >
> > >             /*
> > >              * The following is basically the equivalent of
> > > @@ -411,8 +424,8 @@ static void unmask_evtchn(int port)
> > >              * the interrupt edge' if the channel is masked.
> > >              */
> > >             if (evtchn_pending &&
> > > -               !sync_test_and_set_bit(port / BITS_PER_LONG,
> > > -                                      &vcpu_info->evtchn_pending_sel))
> > > +               !sync_test_and_set_bit(port / BITS_PER_EVTCHN_WORD,
> > > +                                      BM(&vcpu_info->evtchn_pending_sel)))
> > >                     vcpu_info->evtchn_upcall_pending = 1;
> > >     }
> > >
> > > @@ -1189,7 +1202,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
> > >  {
> > >     struct shared_info *sh = HYPERVISOR_shared_info;
> > >     int cpu = smp_processor_id();
> > > -   unsigned long *cpu_evtchn = per_cpu(cpu_evtchn_mask, cpu);
> > > +   xen_ulong_t *cpu_evtchn = per_cpu(cpu_evtchn_mask, cpu);
> > >     int i;
> > >     unsigned long flags;
> > >     static DEFINE_SPINLOCK(debug_lock);
> > > @@ -1205,7 +1218,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
> > >             pending = (get_irq_regs() && i == cpu)
> > >                     ? xen_irqs_disabled(get_irq_regs())
> > >                     : v->evtchn_upcall_mask;
> > > -           printk("%d: masked=%d pending=%d event_sel %0*lx\n  ", i,
> > > +           printk("%d: masked=%d pending=%d event_sel %0*"PRI_xen_ulong"\n  ", i,
> > >                    pending, v->evtchn_upcall_pending,
> > >                    (int)(sizeof(v->evtchn_pending_sel)*2),
> > >                    v->evtchn_pending_sel);
> > > @@ -1214,49 +1227,52 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
> > >
> > >     printk("\npending:\n   ");
> > >     for (i = ARRAY_SIZE(sh->evtchn_pending)-1; i >= 0; i--)
> > > -           printk("%0*lx%s", (int)sizeof(sh->evtchn_pending[0])*2,
> > > +           printk("%0*"PRI_xen_ulong"%s",
> > > +                  (int)sizeof(sh->evtchn_pending[0])*2,
> > >                    sh->evtchn_pending[i],
> > >                    i % 8 == 0 ? "\n   " : " ");
> > >     printk("\nglobal mask:\n   ");
> > >     for (i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
> > > -           printk("%0*lx%s",
> > > +           printk("%0*"PRI_xen_ulong"%s",
> > >                    (int)(sizeof(sh->evtchn_mask[0])*2),
> > >                    sh->evtchn_mask[i],
> > >                    i % 8 == 0 ? "\n   " : " ");
> > >
> > >     printk("\nglobally unmasked:\n   ");
> > >     for (i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
> > > -           printk("%0*lx%s", (int)(sizeof(sh->evtchn_mask[0])*2),
> > > +           printk("%0*"PRI_xen_ulong"%s",
> > > +                  (int)(sizeof(sh->evtchn_mask[0])*2),
> > >                    sh->evtchn_pending[i] & ~sh->evtchn_mask[i],
> > >                    i % 8 == 0 ? "\n   " : " ");
> > >
> > >     printk("\nlocal cpu%d mask:\n   ", cpu);
> > > -   for (i = (NR_EVENT_CHANNELS/BITS_PER_LONG)-1; i >= 0; i--)
> > > -           printk("%0*lx%s", (int)(sizeof(cpu_evtchn[0])*2),
> > > +   for (i = (NR_EVENT_CHANNELS/BITS_PER_EVTCHN_WORD)-1; i >= 0; i--)
> > > +           printk("%0*"PRI_xen_ulong"%s", (int)(sizeof(cpu_evtchn[0])*2),
> > >                    cpu_evtchn[i],
> > >                    i % 8 == 0 ? "\n   " : " ");
> > >
> > >     printk("\nlocally unmasked:\n   ");
> > >     for (i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--) {
> > > -           unsigned long pending = sh->evtchn_pending[i]
> > > +           xen_ulong_t pending = sh->evtchn_pending[i]
> > >                     & ~sh->evtchn_mask[i]
> > >                     & cpu_evtchn[i];
> > > -           printk("%0*lx%s", (int)(sizeof(sh->evtchn_mask[0])*2),
> > > +           printk("%0*"PRI_xen_ulong"%s",
> > > +                  (int)(sizeof(sh->evtchn_mask[0])*2),
> > >                    pending, i % 8 == 0 ? "\n   " : " ");
> > >     }
> > >
> > >     printk("\npending list:\n");
> > >     for (i = 0; i < NR_EVENT_CHANNELS; i++) {
> > > -           if (sync_test_bit(i, sh->evtchn_pending)) {
> > > -                   int word_idx = i / BITS_PER_LONG;
> > > +           if (sync_test_bit(i, BM(sh->evtchn_pending))) {
> > > +                   int word_idx = i / BITS_PER_EVTCHN_WORD;
> > >                     printk("  %d: event %d -> irq %d%s%s%s\n",
> > >                            cpu_from_evtchn(i), i,
> > >                            evtchn_to_irq[i],
> > > -                          sync_test_bit(word_idx, &v->evtchn_pending_sel)
> > > +                          sync_test_bit(word_idx, BM(&v->evtchn_pending_sel))
> > >                                          ? "" : " l2-clear",
> > > -                          !sync_test_bit(i, sh->evtchn_mask)
> > > +                          !sync_test_bit(i, BM(sh->evtchn_mask))
> > >                                          ? "" : " globally-masked",
> > > -                          sync_test_bit(i, cpu_evtchn)
> > > +                          sync_test_bit(i, BM(cpu_evtchn))
> > >                                          ? "" : " locally-masked");
> > >             }
> > >     }
> > > @@ -1273,7 +1289,7 @@ static DEFINE_PER_CPU(unsigned int, current_bit_idx);
> > >  /*
> > >   * Mask out the i least significant bits of w
> > >   */
> > > -#define MASK_LSBS(w, i) (w & ((~0UL) << i))
> > > +#define MASK_LSBS(w, i) (w & ((~((xen_ulong_t)0UL)) << i))
> > >
> > >  /*
> > >   * Search the CPUs pending events bitmasks.  For each one found, map
> > > @@ -1295,18 +1311,19 @@ static void __xen_evtchn_do_upcall(void)
> > >     unsigned count;
> > >
> > >     do {
> > > -           unsigned long pending_words;
> > > +           xen_ulong_t pending_words;
> > >
> > >             vcpu_info->evtchn_upcall_pending = 0;
> > >
> > >             if (__this_cpu_inc_return(xed_nesting_count) - 1)
> > >                     goto out;
> > >
> > > -#ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
> > > -           /* Clear master flag /before/ clearing selector flag. */
> > > -           wmb();
> > > -#endif
> > > -           pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
> > > +           /*
> > > +            * Master flag must be /before/ clearing selector
> > > +            * flag. xchg_xen_ulong must contain an appropriate
> > > +            * barrier.
> > > +            */
> > > +           pending_words = xchg_xen_ulong(&vcpu_info->evtchn_pending_sel, 0);
> > >
> > >             start_word_idx = __this_cpu_read(current_word_idx);
> > >             start_bit_idx = __this_cpu_read(current_bit_idx);
> > > @@ -1314,8 +1331,8 @@ static void __xen_evtchn_do_upcall(void)
> > >             word_idx = start_word_idx;
> > >
> > >             for (i = 0; pending_words != 0; i++) {
> > > -                   unsigned long pending_bits;
> > > -                   unsigned long words;
> > > +                   xen_ulong_t pending_bits;
> > > +                   xen_ulong_t words;
> > >
> > >                     words = MASK_LSBS(pending_words, word_idx);
> > >
> > > @@ -1327,7 +1344,7 @@ static void __xen_evtchn_do_upcall(void)
> > >                             bit_idx = 0;
> > >                             continue;
> > >                     }
> > > -                   word_idx = __ffs(words);
> > > +                   word_idx = find_first_bit(BM(&words), sizeof(words));
> > >
> > >                     pending_bits = active_evtchns(cpu, s, word_idx);
> > >                     bit_idx = 0; /* usually scan entire word from start */
> > > @@ -1342,7 +1359,7 @@ static void __xen_evtchn_do_upcall(void)
> > >                     }
> > >
> > >                     do {
> > > -                           unsigned long bits;
> > > +                           xen_ulong_t bits;
> > >                             int port, irq;
> > >                             struct irq_desc *desc;
> > >
> > > @@ -1352,10 +1369,10 @@ static void __xen_evtchn_do_upcall(void)
> > >                             if (bits == 0)
> > >                                     break;
> > >
> > > -                           bit_idx = __ffs(bits);
> > > +                           bit_idx = find_first_bit(BM(&bits), sizeof(bits));
> > >
> > >                             /* Process port. */
> > > -                           port = (word_idx * BITS_PER_LONG) + bit_idx;
> > > +                           port = (word_idx * BITS_PER_EVTCHN_WORD) + bit_idx;
> > >                             irq = evtchn_to_irq[port];
> > >
> > >                             if (irq != -1) {
> > > @@ -1364,12 +1381,12 @@ static void __xen_evtchn_do_upcall(void)
> > >                                             generic_handle_irq_desc(irq, desc);
> > >                             }
> > >
> > > -                           bit_idx = (bit_idx + 1) % BITS_PER_LONG;
> > > +                           bit_idx = (bit_idx + 1) % BITS_PER_EVTCHN_WORD;
> > >
> > >                             /* Next caller starts at last processed + 1 */
> > >                             __this_cpu_write(current_word_idx,
> > >                                              bit_idx ? word_idx :
> > > -                                            (word_idx+1) % BITS_PER_LONG);
> > > +                                            (word_idx+1) % BITS_PER_EVTCHN_WORD);
> > >                             __this_cpu_write(current_bit_idx, bit_idx);
> > >                     } while (bit_idx != 0);
> > >
> > > @@ -1377,7 +1394,7 @@ static void __xen_evtchn_do_upcall(void)
> > >                     if ((word_idx != start_word_idx) || (i != 0))
> > >                             pending_words &= ~(1UL << word_idx);
> > >
> > > -                   word_idx = (word_idx + 1) % BITS_PER_LONG;
> > > +                   word_idx = (word_idx + 1) % BITS_PER_EVTCHN_WORD;
> > >             }
> > >
> > >             BUG_ON(!irqs_disabled());
> > > @@ -1487,8 +1504,8 @@ int resend_irq_on_evtchn(unsigned int irq)
> > >     if (!VALID_EVTCHN(evtchn))
> > >             return 1;
> > >
> > > -   masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
> > > -   sync_set_bit(evtchn, s->evtchn_pending);
> > > +   masked = sync_test_and_set_bit(evtchn, BM(s->evtchn_mask));
> > > +   sync_set_bit(evtchn, BM(s->evtchn_pending));
> > >     if (!masked)
> > >             unmask_evtchn(evtchn);
> > >
> > > @@ -1536,8 +1553,8 @@ static int retrigger_dynirq(struct irq_data *data)
> > >     if (VALID_EVTCHN(evtchn)) {
> > >             int masked;
> > >
> > > -           masked = sync_test_and_set_bit(evtchn, sh->evtchn_mask);
> > > -           sync_set_bit(evtchn, sh->evtchn_pending);
> > > +           masked = sync_test_and_set_bit(evtchn, BM(sh->evtchn_mask));
> > > +           sync_set_bit(evtchn, BM(sh->evtchn_pending));
> > >             if (!masked)
> > >                     unmask_evtchn(evtchn);
> > >             ret = 1;
> > > diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> > > index 5d6c272..a9075df 100644
> > > --- a/include/xen/interface/xen.h
> > > +++ b/include/xen/interface/xen.h
> > > @@ -285,7 +285,7 @@ DEFINE_GUEST_HANDLE_STRUCT(multicall_entry);
> > >   * Event channel endpoints per domain:
> > >   *  1024 if a long is 32 bits; 4096 if a long is 64 bits.
> > >   */
> > > -#define NR_EVENT_CHANNELS (sizeof(unsigned long) * sizeof(unsigned long) * 64)
> > > +#define NR_EVENT_CHANNELS (sizeof(xen_ulong_t) * sizeof(xen_ulong_t) * 64)
> > >
> > >  struct vcpu_time_info {
> > >     /*
> > > @@ -341,7 +341,7 @@ struct vcpu_info {
> > >      */
> > >     uint8_t evtchn_upcall_pending;
> > >     uint8_t evtchn_upcall_mask;
> > > -   unsigned long evtchn_pending_sel;
> > > +   xen_ulong_t evtchn_pending_sel;
> > >     struct arch_vcpu_info arch;
> > >     struct pvclock_vcpu_time_info time;
> > >  }; /* 64 bytes (x86) */
> > > @@ -384,8 +384,8 @@ struct shared_info {
> > >      * per-vcpu selector word to be set. Each bit in the selector covers a
> > >      * 'C long' in the PENDING bitfield array.
> > >      */
> > > -   unsigned long evtchn_pending[sizeof(unsigned long) * 8];
> > > -   unsigned long evtchn_mask[sizeof(unsigned long) * 8];
> > > +   xen_ulong_t evtchn_pending[sizeof(xen_ulong_t) * 8];
> > > +   xen_ulong_t evtchn_mask[sizeof(xen_ulong_t) * 8];
> > >
> > >     /*
> > >      * Wallclock time: updated only by control software. Guests should base
> > > --
> > > 1.7.2.5
> > >



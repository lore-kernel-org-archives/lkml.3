Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbbAJTMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:12:17 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:46760 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbAJTMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:12:15 -0500
Date: Sat, 10 Jan 2015 20:12:02 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1767175032.20150110201202@eikelenboom.it>
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>, Oren Twaig <oren@scalemp.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit b81975eade8c
In-Reply-To: <1420611244-25624-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420611244-25624-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, January 7, 2015, 7:13:49 AM, you wrote:

> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
> setup_IO_APIC(), so no irqdomains created for IOAPICs and
> mp_map_pin_to_irq() fails at the very beginning.

> Enhance xen_smp_prepare_cpus() to call setup_IO_APIC() to initialize
> irqdomain for IOAPICs.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Reported-and-tested-by: Sander Eikelenboom <linux@eikelenboom.it>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Hi all,
>         This patch should be backported to v3.17, but there are
> conflicts. So I will send backported patch to 3.17/3.18 stable tree
> once this patch has been merged into mainstream kernel.
> Thanks!
> Gerry

Hi Gerry / Konrad / Thomas,

This patch doesn't apply cleanly to current linux-tip.

Unfortunately the "Tested-by" seems only valid for the intel hardware i have (intel NUC).
Testing on AMD delivered some interesting results:

- Under Xen: Host freeze early in dom0 kernel boot, unfortunately no more info.

- On baremetal with iommu enabled and ivrs_ioapic[6]=00:14.0 ivrs_hpet[0]=00:14.0
  as commandline override for a borked bios:
  It doesn't boot and spits out:
  
  [    0.339811] AMD-Vi: Command-line override present for HPET id 0 - ignoring
  [    0.460563] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
  [    0.511535] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
  [    0.537042] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc3-20150110-pciback-doflr-apic-fixed+ #1
  [    0.564887] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
  [    0.588558]  ffff88054b00c000 ffff880547d8fda8 ffffffff81bb3fc9 ffff880547db0000
  [    0.610722]  ffffffff81f20070 ffff880547d8fe28 ffffffff81baeeb9 ffff880547d8fde8
  [    0.632886]  ffffffff00000008 ffff880547d8fe38 ffff880547d8fdd8 00000000fffea093
  [    0.655052] Call Trace:
  [    0.662349]  [<ffffffff81bb3fc9>] dump_stack+0x45/0x57
  [    0.677712]  [<ffffffff81baeeb9>] panic+0xcd/0x212
  [    0.692026]  [<ffffffff81583187>] panic_if_irq_remap+0x17/0x20
  [    0.709460]  [<ffffffff8233c634>] setup_IO_APIC+0x2bb/0x74c
  [    0.726112]  [<ffffffff8233a04a>] native_smp_prepare_cpus+0x2c9/0x35a
  [    0.745365]  [<ffffffff82328200>] kernel_init_freeable+0x153/0x298
  [    0.763839]  [<ffffffff81baa589>] ? kernel_init+0x9/0xf0
  [    0.779712]  [<ffffffff810e82bb>] ? finish_task_switch+0x8b/0x100
  [    0.797937]  [<ffffffff81baa580>] ? rest_init+0xc0/0xc0
  [    0.813549]  [<ffffffff81baa589>] kernel_init+0x9/0xf0
  [    0.828904]  [<ffffffff81bbf8bc>] ret_from_fork+0x7c/0xb0
  [    0.845036]  [<ffffffff81baa580>] ? rest_init+0xc0/0xc0
  [    0.860660] ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC


- On baremetal with iommu enabled and without the commandline overrides:
  It boots, but iommu is disabled (as expected) but i also get this lockdep trace:

  [    0.339808] [Firmware Bug]: AMD-Vi: IOAPIC[6] not in IVRS table
  [    0.357519] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found
  [    0.375220] AMD-Vi: Disabling interrupt remapping
  [    0.389723] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
  [    0.440685] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
  [    0.458128] ...trying to set up timer (IRQ0) through the 8259A ...
  [    0.476602] ..... (found apic 0 pin 2) ...
  [    0.488834] ------------[ cut here ]------------
  [    0.502631] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0x12c/0x140()
  [    0.530215] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
  [    0.546347] Modules linked in:
  [    0.556006] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc3-20150110-pciback-doflr-apic-fixed+ #1
  [    0.583839] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
  [    0.607512]  ffffffff81f2408e ffff880547d8fcd8 ffffffff81bb3fc9 ffff880547db0000
  [    0.629675]  ffff880547d8fd28 ffff880547d8fd18 ffffffff810c738d ffff880547d8fd08
  [    0.651840]  ffff880547db0000 0000000000000086 0000000000000080 0000000000000000
  [    0.674004] Call Trace:
  [    0.681302]  [<ffffffff81bb3fc9>] dump_stack+0x45/0x57
  [    0.696653]  [<ffffffff810c738d>] warn_slowpath_common+0x8d/0xd0
  [    0.714605]  [<ffffffff810c7471>] warn_slowpath_fmt+0x41/0x50
  [    0.731780]  [<ffffffff8110e2c2>] ? vprintk_emit+0x312/0x5f0
  [    0.748692]  [<ffffffff8110229c>] lockdep_trace_alloc+0x12c/0x140
  [    0.766906]  [<ffffffff811b5a9f>] kmem_cache_alloc_node+0x3f/0x160
  [    0.785379]  [<ffffffff8104573c>] ? __add_pin_to_irq_node+0x6c/0xc0
  [    0.804112]  [<ffffffff8104573c>] __add_pin_to_irq_node+0x6c/0xc0
  [    0.822326]  [<ffffffff8233c6c8>] setup_IO_APIC+0x34f/0x74c
  [    0.838990]  [<ffffffff8233a04a>] native_smp_prepare_cpus+0x2c9/0x35a
  [    0.858243]  [<ffffffff82328200>] kernel_init_freeable+0x153/0x298
  [    0.876719]  [<ffffffff81baa589>] ? kernel_init+0x9/0xf0
  [    0.892602]  [<ffffffff810e82bb>] ? finish_task_switch+0x8b/0x100
  [    0.910815]  [<ffffffff81baa580>] ? rest_init+0xc0/0xc0
  [    0.926428]  [<ffffffff81baa589>] kernel_init+0x9/0xf0
  [    0.941782]  [<ffffffff81bbf8bc>] ret_from_fork+0x7c/0xb0
  [    0.957913]  [<ffffffff81baa580>] ? rest_init+0xc0/0xc0
  [    0.973531] ---[ end trace 5f14749f8239057a ]---
  [    1.020338] ....... works.

Without this patch applied i don't see these issues (with or without the 
override).

.config and dmesg of a baremetal boot without the commandline override is attached.

--
Sander







> ---
>  arch/x86/include/asm/io_apic.h       |    2 +-
>  arch/x86/include/asm/smpboot_hooks.h |    5 ++---
>  arch/x86/kernel/apic/apic.c          |    5 ++---
>  arch/x86/kernel/apic/io_apic.c       |   32 +++++++++++++++-----------------
>  arch/x86/xen/smp.c                   |    3 +++
>  5 files changed, 23 insertions(+), 24 deletions(-)

> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index bf006cce9418..72a1298658bb 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -237,7 +237,7 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
>  
>  extern void io_apic_eoi(unsigned int apic, unsigned int vector);
>  
> -extern void setup_IO_APIC(void);
> +extern void setup_IO_APIC(bool xen_smp);
>  extern void enable_IO_APIC(void);
>  extern void disable_IO_APIC(void);
>  extern void setup_ioapic_dest(void);
> diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
> index 0da7409f0bec..e47df710a588 100644
> --- a/arch/x86/include/asm/smpboot_hooks.h
> +++ b/arch/x86/include/asm/smpboot_hooks.h
> @@ -53,10 +53,9 @@ static inline void __init smpboot_setup_io_apic(void)
>          * go and set it up:
>          */
>         if (!skip_ioapic_setup && nr_ioapics)
> -               setup_IO_APIC();
> -       else {
> +               setup_IO_APIC(false);
> +       else
>                 nr_ioapics = 0;
> -       }
>  #endif
>  }
>  
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 29b5b18afa27..71b8a6cb7f0e 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1913,10 +1913,9 @@ int __init APIC_init_uniprocessor(void)
>  
>  #ifdef CONFIG_X86_IO_APIC
>         if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
> -               setup_IO_APIC();
> -       else {
> +               setup_IO_APIC(false);
> +       else
>                 nr_ioapics = 0;
> -       }
>  #endif
>  
>         x86_init.timers.setup_percpu_clockev();
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 3f5f60406ab1..13cddc75e4c0 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2369,31 +2369,29 @@ static void ioapic_destroy_irqdomain(int idx)
>         ioapics[idx].pin_info = NULL;
>  }
>  
> -void __init setup_IO_APIC(void)
> +void __init setup_IO_APIC(bool xen_smp)
>  {
>         int ioapic;
>  
> -       /*
> -        * calling enable_IO_APIC() is moved to setup_local_APIC for BP
> -        */
> -       io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
> +       if (!xen_smp) {
> +               apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
> +               io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
> +
> +               /* Set up IO-APIC IRQ routing. */
> +               x86_init.mpparse.setup_ioapic_ids();
> +               sync_Arb_IDs();
> +       }
>  
> -       apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
>         for_each_ioapic(ioapic)
>                 BUG_ON(mp_irqdomain_create(ioapic));
> -
> -       /*
> -         * Set up IO-APIC IRQ routing.
> -         */
> -       x86_init.mpparse.setup_ioapic_ids();
> -
> -       sync_Arb_IDs();
>         setup_IO_APIC_irqs();
> -       init_IO_APIC_traps();
> -       if (nr_legacy_irqs())
> -               check_timer();
> -
>         ioapic_initialized = 1;
> +
> +       if (!xen_smp) {
> +               init_IO_APIC_traps();
> +               if (nr_legacy_irqs())
> +                       check_timer();
> +       }
>  }
>  
>  /*
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 4c071aeb8417..7eb0283901fa 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -326,7 +326,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>  
>                 xen_raw_printk(m);
>                 panic(m);
> +       } else {
> +               setup_IO_APIC(true);
>         }
> +
>         xen_init_lock_cpu(0);
>  
>         smp_store_boot_cpu_info();


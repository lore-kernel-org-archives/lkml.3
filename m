Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3BVXiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:38:24 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46692 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3BVXiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130222214811.GA25445@phenom.dumpdata.com>
References: <20130222214811.GA25445@phenom.dumpdata.com>
Date: Fri, 22 Feb 2013 15:38:18 -0800
X-Google-Sender-Auth: yuXU6wXPkdAQLax99S9LDl0qdGM
Message-ID: <CAE9FiQUjj_bqF0aLVHDg01rc+A-1xKMuFc0yHN6Tqnxc5A-h3g@mail.gmail.com>
Subject: Re: Regression introduced by 805d410fb0dbd65e1a57a810858fa2491e75822d
 (ACPI: Separate adding ACPI device objects from probing ACPI drivers) in v3.9-rc0
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: rafael.j.wysocki@intel.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 1:48 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Hey Rafael,
>
> Per git bisect it looks like that patch:
> ACPI: Separate adding ACPI device objects from probing ACPI drivers
> blows up when running under Xen PV guests:
>
> (please notice that ACPI is turned off with normal Xen PV guests):
> 547 #ifdef CONFIG_ACPI
> 548         if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
> 549                 printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
> 550                 disable_acpi();
> 551         }
> 552 #endif
>
> (in arch/x86/xen/setup.c). Here is what the console tells me
> (I can't get the early console somehow to work):
>
> [    0.000000] console [hvc0] enabled, bootconsole disabled
> [    0.000000] Xen: using vcpuop timer interface
> [    0.000000] installing Xen timer for CPU 0
> [    0.000000] tsc: Detected 3901.188 MHz processor
> [    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
> [    0.001000] pid_max: default: 32768 minimum: 301
> [    0.001000] Security Framework initialized
> [    0.001000] SELinux:  Initializing.
> [    0.001000] SELinux:  Starting in permissive mode
> [    0.001000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.001224] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.001488] Mount-cache hash table entries: 256
> [    0.001774] Initializing cgroup subsys cpuacct
> [    0.001782] Initializing cgroup subsys freezer
> [    0.001860] tseg: 00adf00000
> [    0.001868] CPU: Physical Processor ID: 0
> [    0.001874] CPU: Processor Core ID: 1
> [    0.001883] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
> [    0.001883] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
> [    0.001883] tlb_flushall_shift: 5
> [    0.028911] cpu 0 spinlock event irq 17
> [    0.028956] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
> [    0.028966] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
> [    0.028976] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
> [    0.028986] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
> [    0.028997] calling  init_hw_perf_events+0x0/0x414 @ 1
> [    0.029000] Performance Events:
> [    0.029000] perf: AMD core performance counters detected
> [    0.029000] no APIC, boot with the "lapic" boot parameter to force-enable it.
> [    0.029000] no hardware sampling interrupt available.
> [    0.029000] Broken PMU hardware detected, using software events only.
> [    0.029005] Failed to access perfctr msr (MSR c0010201 is 0)
> [    0.029014] initcall init_hw_perf_events+0x0/0x414 returned 0 after 976 usecs
> [    0.029024] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
> [    0.029034] initcall register_trigger_all_cpu_backtrace+0x0/0x16 returned 0 after 0 usecs
> [    0.029044] calling  spawn_ksoftirqd+0x0/0x28 @ 1
> [    0.029093] initcall spawn_ksoftirqd+0x0/0x28 returned 0 after 0 usecs
> [    0.029103] calling  init_workqueues+0x0/0x33a @ 1
> [    0.029316] initcall init_workqueues+0x0/0x33a returned 0 after 0 usecs
> [    0.029327] calling  migration_init+0x0/0x71 @ 1
> [    0.029337] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
> [    0.029346] calling  cpu_stop_init+0x0/0xb4 @ 1
> [    0.029392] initcall cpu_stop_init+0x0/0xb4 returned 0 after 0 usecs
> [    0.029402] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
> [    0.029413] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
> [    0.029423] calling  rcu_spawn_gp_kthread+0x0/0x89 @ 1
> [    0.029493] initcall rcu_spawn_gp_kthread+0x0/0x89 returned 0 after 0 usecs
> [    0.029502] calling  relay_init+0x0/0x14 @ 1
> [    0.029510] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
> [    0.029519] calling  tracer_alloc_buffers+0x0/0x1fc @ 1
> [    0.029565] initcall tracer_alloc_buffers+0x0/0x1fc returned 0 after 0 usecs
> [    0.029575] calling  init_events+0x0/0x61 @ 1
> [    0.029584] initcall init_events+0x0/0x61 returned 0 after 0 usecs
> [    0.029592] calling  init_trace_printk+0x0/0x12 @ 1
> [    0.029601] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
> [    0.029610] calling  jump_label_init_module+0x0/0x12 @ 1
> [    0.029618] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
> [    0.029630] calling  mce_amd_init+0x0/0x110 @ 1
> [    0.029638] MCE: In-kernel MCE decoding enabled.
> [    0.029647] initcall mce_amd_init+0x0/0x110 returned 0 after 0 usecs
> [    0.029760] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.030028] installing Xen timer for CPU 1
> [    0.030051] cpu 1 spinlock event irq 24
> [    0.030092] SMP alternatives: switching to SMP code
> [    0.056501] installing Xen timer for CPU 2
> [    0.056544] cpu 2 spinlock event irq 31
> [    0.057032] Brought up 3 CPUs
> [    0.058000] calling  ipc_ns_init+0x0/0x14 @ 1
> [    0.058000] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
> [    0.058000] calling  init_mmap_min_addr+0x0/0x26 @ 1
> [    0.058000] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
> [    0.058000] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
> [    0.058000] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
> [    0.058000] calling  net_ns_init+0x0/0xfd @ 1
> [    0.061054] initcall net_ns_init+0x0/0xfd returned 0 after 976 usecs
> [    0.061056] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
> [    0.061069] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
> [    0.061081] calling  cpufreq_tsc+0x0/0x37 @ 1
> [    0.061092] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
> [    0.061104] calling  reboot_init+0x0/0x1d @ 1
> [    0.061116] initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
> [    0.061128] calling  init_lapic_sysfs+0x0/0x20 @ 1
> [    0.061138] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
> [    0.109030] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
> [    0.109044] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
> [    0.109056] calling  alloc_frozen_cpus+0x0/0x8 @ 1
> [    0.110000] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
> [    0.111008] calling  ksysfs_init+0x0/0x94 @ 1
> [    0.111035] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
> [    0.111045] calling  pm_init+0x0/0x4e @ 1
> [    0.111063] initcall pm_init+0x0/0x4e returned 0 after 0 usecs
> [    0.111072] calling  pm_disk_init+0x0/0x19 @ 1
> [    0.111092] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
> [    0.111102] calling  swsusp_header_init+0x0/0x30 @ 1
> [    0.111113] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
> [    0.111122] calling  init_jiffies_clocksource+0x0/0x12 @ 1
> [    0.111137] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
> [    0.111148] calling  event_trace_enable+0x0/0xa9 @ 1
> [    0.111191] initcall event_trace_enable+0x0/0xa9 returned 0 after 0 usecs
> [    0.111202] calling  init_zero_pfn+0x0/0x35 @ 1
> [    0.111211] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
> [    0.111222] calling  fsnotify_init+0x0/0x26 @ 1
> [    0.111235] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
> [    0.111246] calling  filelock_init+0x0/0x2a @ 1
> [    0.111317] initcall filelock_init+0x0/0x2a returned 0 after 976 usecs
> [    0.111329] calling  init_misc_binfmt+0x0/0x31 @ 1
> [    0.111341] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
> [    0.111351] calling  init_script_binfmt+0x0/0x16 @ 1
> [    0.111361] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
> [    0.111371] calling  init_elf_binfmt+0x0/0x16 @ 1
> [    0.111381] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
> [    0.111391] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
> [    0.111401] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
> [    0.111412] calling  debugfs_init+0x0/0x5c @ 1
> [    0.111425] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
> [    0.111435] calling  securityfs_init+0x0/0x53 @ 1
> [    0.111448] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
> [    0.111458] calling  prandom_init+0x0/0xd9 @ 1
> [    0.111469] initcall prandom_init+0x0/0xd9 returned 0 after 0 usecs
> [    0.111480] calling  virtio_init+0x0/0x30 @ 1
> [    0.112062] kworker/u:0 (26) used greatest stack depth: 5592 bytes left
> [    0.112092] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
> [    0.112092] calling  __gnttab_init+0x0/0x30 @ 1
> [    0.112092] Grant tables using version 2 layout.
> [    0.112109] Grant table initialized
> [    0.112118] initcall __gnttab_init+0x0/0x30 returned 0 after 0 usecs
> [    0.112130] calling  early_resume_init+0x0/0x1d0 @ 1
> [    0.126868] RTC time: 165:165:165, date: 165/165/65
> [    0.126887] initcall early_resume_init+0x0/0x1d0 returned 0 after 14648 usecs
> [    0.126901] calling  cpufreq_core_init+0x0/0xc7 @ 1
> [    0.126911] initcall cpufreq_core_init+0x0/0xc7 returned -19 after 0 usecs
> [    0.126921] calling  cpuidle_init+0x0/0x40 @ 1
> [    0.126930] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
> [    0.126941] calling  bsp_pm_check_init+0x0/0x14 @ 1
> [    0.126951] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
> [    0.126960] calling  sock_init+0x0/0x89 @ 1
> [    0.128845] initcall sock_init+0x0/0x89 returned 0 after 1953 usecs
> [    0.128856] calling  net_inuse_init+0x0/0x26 @ 1
> [    0.128867] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
> [    0.128877] calling  netpoll_init+0x0/0x31 @ 1
> [    0.128886] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
> [    0.128896] calling  netlink_proto_init+0x0/0x1b3 @ 1
> [    0.128919] NET: Registered protocol family 16
> [    0.128953] initcall netlink_proto_init+0x0/0x1b3 returned 0 after 0 usecs
> [    0.128985] calling  bdi_class_init+0x0/0x4d @ 1
> [    0.129075] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
> [    0.129075] calling  kobject_uevent_init+0x0/0x12 @ 1
> [    0.129077] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
> [    0.129087] calling  pcibus_class_init+0x0/0x19 @ 1
> [    0.129114] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
> [    0.129114] calling  pci_driver_init+0x0/0x19 @ 1
> [    0.129114] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
> [    0.129114] calling  backlight_class_init+0x0/0x5d @ 1
> [    0.129114] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
> [    0.129114] calling  video_output_class_init+0x0/0x19 @ 1
> [    0.129114] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
> [    0.217038] calling  xenbus_init+0x0/0x21a @ 1
> [    0.217110] initcall xenbus_init+0x0/0x21a returned 0 after 0 usecs
> [    0.217110] calling  tty_class_init+0x0/0x38 @ 1
> [    0.217110] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
> [    0.217110] calling  vtconsole_class_init+0x0/0xc2 @ 1
> [    0.217110] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
> [    0.217110] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
> [    0.217110] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
> [    0.217110] calling  register_node_type+0x0/0x34 @ 1
> [    0.218034] initcall register_node_type+0x0/0x34 returned 0 after 976 usecs
> [    0.218045] calling  i2c_init+0x0/0x77 @ 1
> [    0.218063] initcall i2c_init+0x0/0x77 returned 0 after 0 usecs
> [    0.218063] calling  amd_postcore_init+0x0/0x143 @ 1
> [    0.218673] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
> [    0.218710] calling  set_real_mode_permissions+0x0/0xa9 @ 1
> [    0.221082] initcall set_real_mode_permissions+0x0/0xa9 returned 0 after 2929 usecs
> [    0.221097] calling  arch_kdebugfs_init+0x0/0x233 @ 1
> [    0.221181] initcall arch_kdebugfs_init+0x0/0x233 returned 0 after 0 usecs
> [    0.221193] calling  mtrr_if_init+0x0/0x78 @ 1
> [    0.221202] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
> [    0.221212] calling  ffh_cstate_init+0x0/0x2a @ 1
> [    0.221222] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
> [    0.221233] initcall ffh_cstate_init+0x0/0x2a returned with error code -1
> [    0.221243] calling  activate_jump_labels+0x0/0x32 @ 1
> [    0.221253] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
> [    0.221263] calling  acpi_pci_init+0x0/0x5c @ 1
> [    0.221273] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
> [    0.221283] calling  dma_bus_init+0x0/0x19 @ 1
> [    0.221306] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
> [    0.221306] calling  dma_channel_table_init+0x0/0x119 @ 1
> [    0.221306] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
> [    0.221306] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
> [    0.226301] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 4882 usecs
> [    0.226320] calling  register_xen_pci_notifier+0x0/0x38 @ 1
> [    0.226331] initcall register_xen_pci_notifier+0x0/0x38 returned 0 after 0 usecs
> [    0.226342] calling  xen_pcpu_init+0x0/0xcc @ 1
> [    0.226353] initcall xen_pcpu_init+0x0/0xcc returned -19 after 0 usecs
> [    0.226364] calling  dmi_id_init+0x0/0x31d @ 1
> [    0.226374] initcall dmi_id_init+0x0/0x31d returned -19 after 0 usecs
> [    0.226385] calling  dca_init+0x0/0x20 @ 1
> [    0.226394] dca service started, version 1.12.1
> [    0.226499] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
> [    0.226511] calling  pci_arch_init+0x0/0x69 @ 1
> [    0.227009] PCI: setting up Xen PCI frontend stub
> [    0.227020] PCI: pci_cache_line_size set to 64 bytes
> [    0.227032] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
> [    0.227066] calling  topology_init+0x0/0x98 @ 1
> [    0.227348] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
> [    0.227360] calling  mtrr_init_finialize+0x0/0x36 @ 1
> [    0.227370] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
> [    0.227380] calling  init_vdso+0x0/0x135 @ 1
> [    0.227393] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
> [    0.227403] calling  sysenter_setup+0x0/0x2dd @ 1
> [    0.227417] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
> [    0.227427] calling  param_sysfs_init+0x0/0x192 @ 1
> [    0.243968] initcall param_sysfs_init+0x0/0x192 returned 0 after 15625 usecs
> [    0.243988] calling  pm_sysrq_init+0x0/0x19 @ 1
> [    0.243999] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
> [    0.244000] calling  default_bdi_init+0x0/0x37 @ 1
> [    0.244189] initcall default_bdi_init+0x0/0x37 returned 0 after 976 usecs
> [    0.244202] calling  init_bio+0x0/0xe8 @ 1
> [    0.244226] bio: create slab <bio-0> at 0
> [    0.244247] initcall init_bio+0x0/0xe8 returned 0 after 0 usecs
> [    0.244258] calling  fsnotify_notification_init+0x0/0x8b @ 1
> [    0.244281] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
> [    0.244294] calling  cryptomgr_init+0x0/0x12 @ 1
> [    0.244304] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
> [    0.244314] calling  blk_settings_init+0x0/0x2c @ 1
> [    0.244323] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
> [    0.244333] calling  blk_ioc_init+0x0/0x2a @ 1
> [    0.244350] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
> [    0.244360] calling  blk_softirq_init+0x0/0x6e @ 1
> [    0.244371] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
> [    0.244382] calling  blk_iopoll_setup+0x0/0x6e @ 1
> [    0.244391] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
> [    0.244401] calling  genhd_device_init+0x0/0x85 @ 1
> [    0.244544] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
> [    0.244557] calling  pci_slot_init+0x0/0x50 @ 1
> [    0.244571] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
> [    0.244581] calling  fbmem_init+0x0/0x98 @ 1
> [    0.244684] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
> [    0.244697] calling  acpi_init+0x0/0xbc @ 1
> [    0.244705] ACPI: Interpreter disabled.
> [    0.244714] initcall acpi_init+0x0/0xbc returned -19 after 0 usecs
> [    0.244724] calling  dock_init+0x0/0x7b @ 1
> [    0.244733] initcall dock_init+0x0/0x7b returned 0 after 0 usecs
> [    0.244744] calling  acpi_pci_link_init+0x0/0x43 @ 1
> [    0.244754] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
> [    0.244764] calling  pnp_init+0x0/0x19 @ 1
> [    0.244875] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
> [    0.244887] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
> [    0.246077] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 1953 usecs
> [    0.246091] calling  balloon_init+0x0/0x133 @ 1
> [    0.246099] xen/balloon: Initialising balloon driver.
> [    0.247065] initcall balloon_init+0x0/0x133 returned 0 after 976 usecs
> [    0.247078] calling  xenbus_probe_backend_init+0x0/0x34 @ 1
> [    0.255037] initcall xenbus_probe_backend_init+0x0/0x34 returned 0 after 7812 usecs
> [    0.255055] calling  xenbus_probe_frontend_init+0x0/0x34 @ 1
> [    0.259050] initcall xenbus_probe_frontend_init+0x0/0x34 returned 0 after 3906 usecs
> [    0.259065] calling  xen_acpi_pad_init+0x0/0x47 @ 1
> [    0.259075] initcall xen_acpi_pad_init+0x0/0x47 returned -19 after 0 usecs
> [    0.259084] calling  balloon_init+0x0/0xfa @ 1
> [    0.259093] xen-balloon: Initialising balloon driver.
> [    0.259328] initcall balloon_init+0x0/0xfa returned 0 after 0 usecs
> [    0.259328] calling  xen_selfballoon_init+0x0/0xb9 @ 1
> [    0.259328] initcall xen_selfballoon_init+0x0/0xb9 returned -19 after 0 usecs
> [    0.259328] calling  misc_init+0x0/0xba @ 1
> [    0.259328] initcall misc_init+0x0/0xba returned 0 after 0 usecs
> [    0.259328] calling  vga_arb_device_init+0x0/0xde @ 1
> [    0.259419] vgaarb: loaded
> [    0.259430] initcall vga_arb_device_init+0x0/0xde returned 0 after 0 usecs
> [    0.259442] calling  cn_init+0x0/0xc0 @ 1
> [    0.259466] initcall cn_init+0x0/0xc0 returned 0 after 0 usecs
> [    0.259477] calling  phy_init+0x0/0x2e @ 1
> [    0.260111] initcall phy_init+0x0/0x2e returned 0 after 976 usecs
> [    0.260123] calling  init_pcmcia_cs+0x0/0x3d @ 1
> [    0.260208] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
> [    0.260219] calling  usb_init+0x0/0x170 @ 1
> [    0.260418] usbcore: registered new interface driver usbfs
> [    0.260511] usbcore: registered new interface driver hub
> [    0.260635] usbcore: registered new device driver usb
> [    0.260646] initcall usb_init+0x0/0x170 returned 0 after 0 usecs
> [    0.260656] calling  serio_init+0x0/0x38 @ 1
> [    0.260750] initcall serio_init+0x0/0x38 returned 0 after 0 usecs
> [    0.260760] calling  input_init+0x0/0x103 @ 1
> [    0.260852] initcall input_init+0x0/0x103 returned 0 after 0 usecs
> [    0.260863] calling  rtc_init+0x0/0x71 @ 1
> [    0.260943] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
> [    0.260954] calling  pps_init+0x0/0xb7 @ 1
> [    0.261000] pps_core: LinuxPPS API ver. 1 registered
> [    0.261000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.261000] initcall pps_init+0x0/0xb7 returned 0 after 0 usecs
> [    0.261014] calling  ptp_init+0x0/0xa4 @ 1
> [    0.261102] PTP clock support registered
> [    0.261112] initcall ptp_init+0x0/0xa4 returned 0 after 0 usecs
> [    0.261122] calling  power_supply_class_init+0x0/0x44 @ 1
> [    0.261204] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
> [    0.261215] calling  hwmon_init+0x0/0xf6 @ 1
> [    0.261296] initcall hwmon_init+0x0/0xf6 returned 0 after 0 usecs
> [    0.261307] calling  leds_init+0x0/0x48 @ 1
> [    0.261388] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
> [    0.261399] calling  iommu_init+0x0/0x58 @ 1
> [    0.261411] initcall iommu_init+0x0/0x58 returned 0 after 0 usecs
> [    0.261423] calling  pci_subsys_init+0x0/0x4f @ 1
> [    0.261432] PCI: System does not support PCI
> [    0.261440] PCI: System does not support PCI
> [    0.261450] initcall pci_subsys_init+0x0/0x4f returned 0 after 0 usecs
> [    0.261459] calling  proto_init+0x0/0x12 @ 1
> [    0.261474] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
> [    0.261485] calling  net_dev_init+0x0/0x1c7 @ 1
> [    0.261931] initcall net_dev_init+0x0/0x1c7 returned 0 after 0 usecs
> [    0.261942] calling  neigh_init+0x0/0x80 @ 1
> [    0.261952] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
> [    0.261961] calling  fib_rules_init+0x0/0xaf @ 1
> [    0.261972] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
> [    0.261982] calling  pktsched_init+0x0/0xfe @ 1
> [    0.261997] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
> [    0.262000] calling  tc_filter_init+0x0/0x55 @ 1
> [    0.262000] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
> [    0.262000] calling  tc_action_init+0x0/0x55 @ 1
> [    0.262000] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
> [    0.262000] calling  genl_init+0x0/0x75 @ 1
> [    0.262033] initcall genl_init+0x0/0x75 returned 0 after 976 usecs
> [    0.263021] calling  cipso_v4_init+0x0/0x61 @ 1
> [    0.263039] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
> [    0.263052] calling  netlbl_init+0x0/0x81 @ 1
> [    0.263062] NetLabel: Initializing
> [    0.263072] NetLabel:  domain hash size = 128
> [    0.263081] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.263126] NetLabel:  unlabeled traffic allowed by default
> [    0.263137] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
> [    0.263147] calling  rfkill_init+0x0/0x79 @ 1
> [    0.263402] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
> [    0.263436] calling  xen_p2m_debugfs+0x0/0x4a @ 1
> [    0.263478] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 0 usecs
> [    0.263489] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
> [    0.263645] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 0 usecs
> [    0.263659] calling  hpet_late_init+0x0/0x101 @ 1
> [    0.263671] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
> [    0.263682] calling  init_amd_nbs+0x0/0xb8 @ 1
> [    0.263693] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
> [    0.263704] calling  clocksource_done_booting+0x0/0x5a @ 1
> [    0.263714] Switching to clocksource xen
> [    0.263742] initcall clocksource_done_booting+0x0/0x5a returned 0 after 8 usecs
> [    0.263756] calling  tracer_init_debugfs+0x0/0x3a4 @ 1
> [    0.263756] initcall tracer_init_debugfs+0x0/0x3a4 returned 0 after 511 usecs
> [    0.263756] calling  init_trace_printk_function_export+0x0/0x2f @ 1
> [    0.263756] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 7 usecs
> [    0.263756] calling  event_trace_init+0x0/0x271 @ 1
> [    0.275332] initcall event_trace_init+0x0/0x271 returned 0 after 11443 usecs
> [    0.275351] calling  init_kprobe_trace+0x0/0x93 @ 1
> [    0.275377] initcall init_kprobe_trace+0x0/0x93 returned 0 after 15 usecs
> [    0.275389] calling  init_pipe_fs+0x0/0x4c @ 1
> [    0.275432] initcall init_pipe_fs+0x0/0x4c returned 0 after 31 usecs
> [    0.275443] calling  eventpoll_init+0x0/0xda @ 1
> [    0.275466] initcall eventpoll_init+0x0/0xda returned 0 after 12 usecs
> [    0.275477] calling  anon_inode_init+0x0/0x5b @ 1
> [    0.275513] initcall anon_inode_init+0x0/0x5b returned 0 after 26 usecs
> [    0.275524] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
> [    0.275533] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
> [    0.275543] calling  acpi_event_init+0x0/0x81 @ 1
> [    0.275553] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
> [    0.275563] calling  pnp_system_init+0x0/0x12 @ 1
> [    0.275708] initcall pnp_system_init+0x0/0x12 returned 0 after 131 usecs
> [    0.275719] calling  pnpacpi_init+0x0/0x8c @ 1
> [    0.275726] pnp: PnP ACPI: disabled
> [    0.275734] initcall pnpacpi_init+0x0/0x8c returned 0 after 6 usecs
> [    0.275742] calling  pcistub_init+0x0/0x29f @ 1
> [    0.275843] initcall pcistub_init+0x0/0x29f returned 0 after 90 usecs
> [    0.275852] calling  chr_dev_init+0x0/0xc6 @ 1
> [    0.283039] initcall chr_dev_init+0x0/0xc6 returned 0 after 7006 usecs
> [    0.283108] calling  firmware_class_init+0x0/0xda @ 1
> [    0.283203] initcall firmware_class_init+0x0/0xda returned 0 after 82 usecs
> [    0.283213] calling  init_pcmcia_bus+0x0/0x6c @ 1
> [    0.283298] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 73 usecs
> [    0.283309] calling  thermal_init+0x0/0x75 @ 1
> [    0.283400] initcall thermal_init+0x0/0x75 returned 0 after 80 usecs
> [    0.283411] calling  thermal_gov_step_wise_init+0x0/0x12 @ 1
> [    0.283422] initcall thermal_gov_step_wise_init+0x0/0x12 returned 0 after 0 usecs
> [    0.283432] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
> [    0.283442] initcall cpufreq_gov_performance_init+0x0/0x12 returned -19 after 0 usecs
> [    0.283454] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
> [    0.283465] initcall init_acpi_pm_clocksource+0x0/0xec returned -19 after 0 usecs
> [    0.283476] calling  pcibios_assign_resources+0x0/0xf8 @ 1
> [    0.283489] initcall pcibios_assign_resources+0x0/0xf8 returned 0 after 2 usecs
> [    0.283500] calling  sysctl_core_init+0x0/0x2c @ 1
> [    0.283523] initcall sysctl_core_init+0x0/0x2c returned 0 after 13 usecs
> [    0.283534] calling  inet_init+0x0/0x2a1 @ 1
> [    0.283572] NET: Registered protocol family 2
> [    0.283850] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
> [    0.283962] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
> [    0.284018] TCP: Hash tables configured (established 16384 bind 16384)
> [    0.284118] TCP: reno registered
> [    0.284136] UDP hash table entries: 1024 (order: 3, 32768 bytes)
> [    0.284162] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
> [    0.284282] initcall inet_init+0x0/0x2a1 returned 0 after 720 usecs
> [    0.284292] calling  ipv4_offload_init+0x0/0x68 @ 1
> [    0.284304] initcall ipv4_offload_init+0x0/0x68 returned 0 after 1 usecs
> [    0.284314] calling  af_unix_init+0x0/0x55 @ 1
> [    0.284326] NET: Registered protocol family 1
> [    0.284346] initcall af_unix_init+0x0/0x55 returned 0 after 21 usecs
> [    0.284356] calling  ipv6_offload_init+0x0/0x6e @ 1
> [    0.467091] initcall ipv6_offload_init+0x0/0x6e returned 0 after 1 usecs
> [    0.467106] calling  init_sunrpc+0x0/0x69 @ 1
> [    0.467311] RPC: Registered named UNIX socket transport module.
> [    0.467321] RPC: Registered udp transport module.
> [    0.467330] RPC: Registered tcp transport module.
> [    0.467338] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.467348] initcall init_sunrpc+0x0/0x69 returned 0 after 225 usecs
> [    0.467358] calling  pci_apply_final_quirks+0x0/0x117 @ 1
> [    0.467370] PCI: CLS 0 bytes, default 64
> [    0.467379] initcall pci_apply_final_quirks+0x0/0x117 returned 0 after 10 usecs
> [    0.467390] calling  populate_rootfs+0x0/0x10d @ 1
> [    0.467693] Unpacking initramfs...
> [    1.224465] Freeing initrd memory: 339320k freed
> [    1.330309] initcall populate_rootfs+0x0/0x10d returned 0 after 842675 usecs
> [    1.330328] calling  pci_iommu_init+0x0/0x41 @ 1
> [    1.330339] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
> [    1.330349] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
> [    1.330358] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
> [    1.330395] calling  irqfd_module_init+0x0/0x33 @ 1
> [    1.330489] initcall irqfd_module_init+0x0/0x33 returned 0 after 81 usecs
> [    1.330500] calling  i8259A_init_ops+0x0/0x21 @ 1
> [    1.330510] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
> [    1.330520] calling  vsyscall_init+0x0/0x27 @ 1
> [    1.330534] initcall vsyscall_init+0x0/0x27 returned 0 after 4 usecs
> [    1.330544] calling  sbf_init+0x0/0xf6 @ 1
> [    1.330553] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
> [    1.330563] calling  init_tsc_clocksource+0x0/0x89 @ 1
> [    1.330576] initcall init_tsc_clocksource+0x0/0x89 returned 0 after 3 usecs
> [    1.330585] calling  add_rtc_cmos+0x0/0x96 @ 1
> [    1.330729] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    1.330741] initcall add_rtc_cmos+0x0/0x96 returned 0 after 143 usecs
> [    1.330751] calling  i8237A_init_ops+0x0/0x14 @ 1
> [    1.330761] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
> [    1.330771] calling  cache_sysfs_init+0x0/0x6c @ 1
> [    1.330843] initcall cache_sysfs_init+0x0/0x6c returned 0 after 60 usecs
> [    1.330855] calling  intel_uncore_init+0x0/0x3fa @ 1
> [    1.330866] initcall intel_uncore_init+0x0/0x3fa returned -19 after 0 usecs
> [    1.330878] calling  inject_init+0x0/0x30 @ 1
> [    1.330886] Machine check injector initialized
> [    1.330897] initcall inject_init+0x0/0x30 returned 0 after 9 usecs
> [    1.330906] calling  thermal_throttle_init_device+0x0/0x9d @ 1
> [    1.330917] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 0 usecs
> [    1.330929] calling  amd_ibs_init+0x0/0x48d @ 1
> [    1.330939] initcall amd_ibs_init+0x0/0x48d returned -19 after 0 usecs
> [    1.330949] calling  msr_init+0x0/0x162 @ 1
> [    1.331168] initcall msr_init+0x0/0x162 returned 0 after 204 usecs
> [    1.331179] calling  cpuid_init+0x0/0x162 @ 1
> [    1.331356] initcall cpuid_init+0x0/0x162 returned 0 after 161 usecs
> [    1.331368] calling  ioapic_init_ops+0x0/0x14 @ 1
> [    1.331379] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
> [    1.331389] calling  add_pcspkr+0x0/0x40 @ 1
> [    1.331493] initcall add_pcspkr+0x0/0x40 returned 0 after 91 usecs
> [    1.331504] calling  microcode_init+0x0/0x1b1 @ 1
> [    1.331600] microcode: CPU0: patch_level=0x06000626
> [    1.331698] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.331710] initcall microcode_init+0x0/0x1b1 returned 0 after 193 usecs
> [    1.331721] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
> [    1.331731] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
> [    1.331741] calling  audit_classes_init+0x0/0xaf @ 1
> [    1.331756] initcall audit_classes_init+0x0/0xaf returned 0 after 5 usecs
> [    1.331767] calling  pt_dump_init+0x0/0x30 @ 1
> [    1.331801] initcall pt_dump_init+0x0/0x30 returned 0 after 24 usecs
> [    1.331815] calling  ia32_binfmt_init+0x0/0x14 @ 1
> [    1.331833] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 6 usecs
> [    1.331844] calling  proc_execdomains_init+0x0/0x22 @ 1
> [    1.331861] initcall proc_execdomains_init+0x0/0x22 returned 0 after 6 usecs
> [    1.331871] calling  ioresources_init+0x0/0x3c @ 1
> [    1.331887] initcall ioresources_init+0x0/0x3c returned 0 after 6 usecs
> [    1.331896] calling  uid_cache_init+0x0/0xa5 @ 1
> [    1.331911] initcall uid_cache_init+0x0/0xa5 returned 0 after 5 usecs
> [    1.331923] calling  init_posix_timers+0x0/0x1f4 @ 1
> [    1.331940] initcall init_posix_timers+0x0/0x1f4 returned 0 after 5 usecs
> [    1.331950] calling  init_posix_cpu_timers+0x0/0xbf @ 1
> [    1.331959] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
> [    1.331969] calling  proc_schedstat_init+0x0/0x22 @ 1
> [    1.331982] initcall proc_schedstat_init+0x0/0x22 returned 0 after 3 usecs
> [    1.331992] calling  snapshot_device_init+0x0/0x12 @ 1
> [    1.332147] initcall snapshot_device_init+0x0/0x12 returned 0 after 141 usecs
> [    1.332162] calling  create_proc_profile+0x0/0x2c0 @ 1
> [    1.332173] initcall create_proc_profile+0x0/0x2c0 returned 0 after 0 usecs
> [    1.332185] calling  timekeeping_init_ops+0x0/0x14 @ 1
> [    1.332198] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
> [    1.332209] calling  init_clocksource_sysfs+0x0/0x52 @ 1
> [    1.332448] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 219 usecs
> [    1.332464] calling  init_timer_list_procfs+0x0/0x2c @ 1
> [    1.332489] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 7 usecs
> [    1.332504] calling  alarmtimer_init+0x0/0x15d @ 1
> [    1.332743] initcall alarmtimer_init+0x0/0x15d returned 0 after 221 usecs
> [    1.332754] calling  init_tstats_procfs+0x0/0x2c @ 1
> [    1.332771] initcall init_tstats_procfs+0x0/0x2c returned 0 after 5 usecs
> [    1.332781] calling  futex_init+0x0/0x65 @ 1
> [    1.332804] initcall futex_init+0x0/0x65 returned 0 after 9 usecs
> [    1.427360] calling  proc_dma_init+0x0/0x22 @ 1
> [    1.427383] initcall proc_dma_init+0x0/0x22 returned 0 after 9 usecs
> [    1.427394] calling  proc_modules_init+0x0/0x22 @ 1
> [    1.427408] initcall proc_modules_init+0x0/0x22 returned 0 after 4 usecs
> [    1.427417] calling  kallsyms_init+0x0/0x25 @ 1
> [    1.427430] initcall kallsyms_init+0x0/0x25 returned 0 after 3 usecs
> [    1.427440] calling  crash_save_vmcoreinfo_init+0x0/0x4a9 @ 1
> [    1.427469] initcall crash_save_vmcoreinfo_init+0x0/0x4a9 returned 0 after 18 usecs
> [    1.427480] calling  crash_notes_memory_init+0x0/0x36 @ 1
> [    1.427493] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 4 usecs
> [    1.427503] calling  pid_namespaces_init+0x0/0x2d @ 1
> [    1.427519] initcall pid_namespaces_init+0x0/0x2d returned 0 after 6 usecs
> [    1.427529] calling  ikconfig_init+0x0/0x3a @ 1
> [    1.427542] initcall ikconfig_init+0x0/0x3a returned 0 after 3 usecs
> [    1.427552] calling  audit_init+0x0/0x141 @ 1
> [    1.427563] audit: initializing netlink socket (disabled)
> [    1.427590] type=2000 audit(1361569070.777:1): initialized
> [    1.427603] initcall audit_init+0x0/0x141 returned 0 after 38 usecs
> [    1.427613] calling  audit_watch_init+0x0/0x3a @ 1
> [    1.427624] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
> [    1.427636] calling  audit_tree_init+0x0/0x49 @ 1
> [    1.427647] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
> [    1.427656] calling  init_kprobes+0x0/0x16c @ 1
> [    1.439621] initcall init_kprobes+0x0/0x16c returned 0 after 11669 usecs
> [    1.439637] calling  hung_task_init+0x0/0x56 @ 1
> [    1.439718] initcall hung_task_init+0x0/0x56 returned 0 after 68 usecs
> [    1.439729] calling  irq_pm_init_ops+0x0/0x14 @ 1
> [    1.439738] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
> [    1.439748] calling  utsname_sysctl_init+0x0/0x14 @ 1
> [    1.439767] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 9 usecs
> [    1.439778] calling  init_tracepoints+0x0/0x20 @ 1
> [    1.439788] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
> [    1.439798] calling  init_blk_tracer+0x0/0x5a @ 1
> [    1.439808] initcall init_blk_tracer+0x0/0x5a returned 0 after 1 usecs
> [    1.439818] calling  perf_event_sysfs_init+0x0/0x9a @ 1
> [    1.440270] initcall perf_event_sysfs_init+0x0/0x9a returned 0 after 431 usecs
> [    1.440283] calling  init_per_zone_wmark_min+0x0/0x8c @ 1
> [    1.440420] initcall init_per_zone_wmark_min+0x0/0x8c returned 0 after 122 usecs
> [    1.440433] calling  kswapd_init+0x0/0x76 @ 1
> [    1.440489] initcall kswapd_init+0x0/0x76 returned 0 after 45 usecs
> [    1.440499] calling  extfrag_debug_init+0x0/0x7e @ 1
> [    1.440539] initcall extfrag_debug_init+0x0/0x7e returned 0 after 29 usecs
> [    1.440549] calling  setup_vmstat+0x0/0xc8 @ 1
> [    1.440578] initcall setup_vmstat+0x0/0xc8 returned 0 after 18 usecs
> [    1.440589] calling  mm_sysfs_init+0x0/0x29 @ 1
> [    1.440602] initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
> [    1.440613] calling  slab_proc_init+0x0/0x25 @ 1
> [    1.440626] initcall slab_proc_init+0x0/0x25 returned 0 after 4 usecs
> [    1.440636] calling  proc_vmalloc_init+0x0/0x25 @ 1
> [    1.440650] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
> [    1.440660] calling  procswaps_init+0x0/0x22 @ 1
> [    1.440673] initcall procswaps_init+0x0/0x22 returned 0 after 3 usecs
> [    1.440684] calling  init_frontswap+0x0/0x96 @ 1
> [    1.440737] initcall init_frontswap+0x0/0x96 returned 0 after 43 usecs
> [    1.440749] calling  hugetlb_init+0x0/0x415 @ 1
> [    1.440759] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.440788] initcall hugetlb_init+0x0/0x415 returned 0 after 28 usecs
> [    1.440797] calling  mmu_notifier_init+0x0/0x12 @ 1
> [    1.440810] initcall mmu_notifier_init+0x0/0x12 returned 0 after 2 usecs
> [    1.440821] calling  slab_proc_init+0x0/0x8 @ 1
> [    1.440831] initcall slab_proc_init+0x0/0x8 returned 0 after 0 usecs
> [    1.440840] calling  cpucache_init+0x0/0x52 @ 1
> [    1.440851] initcall cpucache_init+0x0/0x52 returned 0 after 1 usecs
> [    1.440861] calling  hugepage_init+0x0/0x191 @ 1
> [    1.440870] initcall hugepage_init+0x0/0x191 returned -22 after 0 usecs
> [    1.440880] initcall hugepage_init+0x0/0x191 returned with error code -22
> [    1.440890] calling  init_cleancache+0x0/0x96 @ 1
> [    1.440939] initcall init_cleancache+0x0/0x96 returned 0 after 38 usecs
> [    1.440949] calling  fcntl_init+0x0/0x2a @ 1
> [    1.440964] initcall fcntl_init+0x0/0x2a returned 0 after 5 usecs
> [    1.440974] calling  proc_filesystems_init+0x0/0x22 @ 1
> [    1.440991] initcall proc_filesystems_init+0x0/0x22 returned 0 after 7 usecs
> [    1.441002] calling  dio_init+0x0/0x2d @ 1
> [    1.441016] initcall dio_init+0x0/0x2d returned 0 after 5 usecs
> [    1.441025] calling  fsnotify_mark_init+0x0/0x40 @ 1
> [    1.441109] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 71 usecs
> [    1.441119] calling  dnotify_init+0x0/0x7b @ 1
> [    1.441137] initcall dnotify_init+0x0/0x7b returned 0 after 8 usecs
> [    1.441146] calling  inotify_user_setup+0x0/0x70 @ 1
> [    1.441163] initcall inotify_user_setup+0x0/0x70 returned 0 after 7 usecs
> [    1.441173] calling  aio_setup+0x0/0x7c @ 1
> [    1.441192] initcall aio_setup+0x0/0x7c returned 0 after 9 usecs
> [    1.627775] calling  proc_locks_init+0x0/0x22 @ 1
> [    1.627796] initcall proc_locks_init+0x0/0x22 returned 0 after 9 usecs
> [    1.627806] calling  init_sys32_ioctl+0x0/0x28 @ 1
> [    1.627885] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 67 usecs
> [    1.627895] calling  dquot_init+0x0/0x121 @ 1
> [    1.627904] VFS: Disk quotas dquot_6.5.2
> [    1.627962] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.627974] initcall dquot_init+0x0/0x121 returned 0 after 66 usecs
> [    1.627985] calling  init_v2_quota_format+0x0/0x22 @ 1
> [    1.627996] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
> [    1.628006] calling  quota_init+0x0/0x26 @ 1
> [    1.628027] initcall quota_init+0x0/0x26 returned 0 after 10 usecs
> [    1.628037] calling  proc_cmdline_init+0x0/0x22 @ 1
> [    1.628072] initcall proc_cmdline_init+0x0/0x22 returned 0 after 22 usecs
> [    1.628088] calling  proc_consoles_init+0x0/0x22 @ 1
> [    1.628105] initcall proc_consoles_init+0x0/0x22 returned 0 after 4 usecs
> [    1.628115] calling  proc_cpuinfo_init+0x0/0x22 @ 1
> [    1.628129] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 4 usecs
> [    1.628140] calling  proc_devices_init+0x0/0x22 @ 1
> [    1.628154] initcall proc_devices_init+0x0/0x22 returned 0 after 3 usecs
> [    1.628165] calling  proc_interrupts_init+0x0/0x22 @ 1
> [    1.628179] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
> [    1.628189] calling  proc_loadavg_init+0x0/0x22 @ 1
> [    1.628204] initcall proc_loadavg_init+0x0/0x22 returned 0 after 3 usecs
> [    1.628214] calling  proc_meminfo_init+0x0/0x22 @ 1
> [    1.628228] initcall proc_meminfo_init+0x0/0x22 returned 0 after 3 usecs
> [    1.628237] calling  proc_stat_init+0x0/0x22 @ 1
> [    1.628251] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
> [    1.628261] calling  proc_uptime_init+0x0/0x22 @ 1
> [    1.628275] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
> [    1.628287] calling  proc_version_init+0x0/0x22 @ 1
> [    1.628300] initcall proc_version_init+0x0/0x22 returned 0 after 3 usecs
> [    1.645978] calling  proc_softirqs_init+0x0/0x22 @ 1
> [    1.646001] initcall proc_softirqs_init+0x0/0x22 returned 0 after 10 usecs
> [    1.646012] calling  proc_kcore_init+0x0/0xb5 @ 1
> [    1.646032] initcall proc_kcore_init+0x0/0xb5 returned 0 after 8 usecs
> [    1.646042] calling  vmcore_init+0x0/0x370 @ 1
> [    1.646052] initcall vmcore_init+0x0/0x370 returned 0 after 0 usecs
> [    1.646063] calling  proc_kmsg_init+0x0/0x25 @ 1
> [    1.646076] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
> [    1.646086] calling  proc_page_init+0x0/0x42 @ 1
> [    1.646104] initcall proc_page_init+0x0/0x42 returned 0 after 7 usecs
> [    1.646125] calling  init_devpts_fs+0x0/0x62 @ 1
> [    1.646192] initcall init_devpts_fs+0x0/0x62 returned 0 after 54 usecs
> [    1.646203] calling  init_ramfs_fs+0x0/0x12 @ 1
> [    1.646213] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
> [    1.646224] calling  init_hugetlbfs_fs+0x0/0x15d @ 1
> [    1.646302] initcall init_hugetlbfs_fs+0x0/0x15d returned 0 after 66 usecs
> [    1.646313] calling  init_fat_fs+0x0/0x4f @ 1
> [    1.646329] initcall init_fat_fs+0x0/0x4f returned 0 after 6 usecs
> [    1.646340] calling  init_vfat_fs+0x0/0x12 @ 1
> [    1.646350] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
> [    1.646360] calling  init_msdos_fs+0x0/0x12 @ 1
> [    1.646370] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
> [    1.646380] calling  init_iso9660_fs+0x0/0x70 @ 1
> [    1.646412] initcall init_iso9660_fs+0x0/0x70 returned 0 after 22 usecs
> [    1.646422] calling  init_nfs_fs+0x0/0x16c @ 1
> [    1.646598] initcall init_nfs_fs+0x0/0x16c returned 0 after 162 usecs
> [    1.646609] calling  init_nfs_v2+0x0/0x14 @ 1
> [    1.646619] initcall init_nfs_v2+0x0/0x14 returned 0 after 0 usecs
> [    1.646629] calling  init_nfs_v3+0x0/0x14 @ 1
> [    1.646639] initcall init_nfs_v3+0x0/0x14 returned 0 after 0 usecs
> [    1.646649] calling  init_nfs_v4+0x0/0x3b @ 1
> [    1.646658] NFS: Registering the id_resolver key type
> [    1.646685] Key type id_resolver registered
> [    1.646694] Key type id_legacy registered
> [    1.646708] initcall init_nfs_v4+0x0/0x3b returned 0 after 47 usecs
> [    1.646717] calling  init_nlm+0x0/0x4c @ 1
> [    1.646732] initcall init_nlm+0x0/0x4c returned 0 after 6 usecs
> [    1.646742] calling  init_nls_cp437+0x0/0x12 @ 1
> [    1.646752] initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
> [    1.646760] calling  init_nls_ascii+0x0/0x12 @ 1
> [    1.646770] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
> [    1.646780] calling  init_nls_iso8859_1+0x0/0x12 @ 1
> [    1.646790] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
> [    1.646799] calling  init_nls_utf8+0x0/0x2b @ 1
> [    1.646810] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
> [    1.646819] calling  init_ntfs_fs+0x0/0x1d1 @ 1
> [    1.646827] NTFS driver 2.1.30 [Flags: R/W].
> [    1.646853] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 23 usecs
> [    1.646863] calling  init_autofs4_fs+0x0/0x2a @ 1
> [    1.647010] initcall init_autofs4_fs+0x0/0x2a returned 0 after 133 usecs
> [    1.647019] calling  init_pstore_fs+0x0/0x12 @ 1
> [    1.647030] initcall init_pstore_fs+0x0/0x12 returned 0 after 0 usecs
> [    1.647040] calling  ipc_init+0x0/0x2f @ 1
> [    1.647079] msgmni has been set to 2923
> [    1.647097] initcall ipc_init+0x0/0x2f returned 0 after 46 usecs
> [    1.647106] calling  ipc_sysctl_init+0x0/0x14 @ 1
> [    1.647123] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 6 usecs
> [    1.647132] calling  init_mqueue_fs+0x0/0xa2 @ 1
> [    1.647183] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 40 usecs
> [    1.647193] calling  key_proc_init+0x0/0x5e @ 1
> [    1.647210] initcall key_proc_init+0x0/0x5e returned 0 after 7 usecs
> [    1.647220] calling  selinux_nf_ip_init+0x0/0x69 @ 1
> [    1.647228] SELinux:  Registering netfilter hooks
> [    1.647457] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 222 usecs
> [    1.647467] calling  init_sel_fs+0x0/0xa5 @ 1
> [    1.647812] initcall init_sel_fs+0x0/0xa5 returned 0 after 327 usecs
> [    1.647822] calling  selnl_init+0x0/0x56 @ 1
> [    1.647839] initcall selnl_init+0x0/0x56 returned 0 after 7 usecs
> [    1.647848] calling  sel_netif_init+0x0/0x5c @ 1
> [    1.647860] initcall sel_netif_init+0x0/0x5c returned 0 after 2 usecs
> [    1.647870] calling  sel_netnode_init+0x0/0x6a @ 1
> [    1.647880] initcall sel_netnode_init+0x0/0x6a returned 0 after 1 usecs
> [    1.647889] calling  sel_netport_init+0x0/0x6a @ 1
> [    1.647900] initcall sel_netport_init+0x0/0x6a returned 0 after 1 usecs
> [    1.647909] calling  aurule_init+0x0/0x2d @ 1
> [    1.647921] initcall aurule_init+0x0/0x2d returned 0 after 0 usecs
> [    1.647932] calling  crypto_wq_init+0x0/0x33 @ 1
> [    1.647976] initcall crypto_wq_init+0x0/0x33 returned 0 after 33 usecs
> [    1.647986] calling  crypto_algapi_init+0x0/0xd @ 1
> [    1.647999] initcall crypto_algapi_init+0x0/0xd returned 0 after 4 usecs
> [    1.829390] calling  skcipher_module_init+0x0/0x35 @ 1
> [    1.829403] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
> [    1.829414] calling  chainiv_module_init+0x0/0x12 @ 1
> [    1.829425] initcall chainiv_module_init+0x0/0x12 returned 0 after 1 usecs
> [    1.829435] calling  eseqiv_module_init+0x0/0x12 @ 1
> [    1.829445] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
> [    1.829455] calling  hmac_module_init+0x0/0x12 @ 1
> [    1.829464] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
> [    1.829474] calling  md5_mod_init+0x0/0x12 @ 1
> [    1.829598] initcall md5_mod_init+0x0/0x12 returned 0 after 111 usecs
> [    1.829609] calling  sha1_generic_mod_init+0x0/0x12 @ 1
> [    1.829676] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 55 usecs
> [    1.829687] calling  crypto_cbc_module_init+0x0/0x12 @ 1
> [    1.829696] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
> [    1.829706] calling  des_generic_mod_init+0x0/0x17 @ 1
> [    1.829828] initcall des_generic_mod_init+0x0/0x17 returned 0 after 109 usecs
> [    1.829839] calling  aes_init+0x0/0x12 @ 1
> [    1.829904] initcall aes_init+0x0/0x12 returned 0 after 54 usecs
> [    1.829917] calling  zlib_mod_init+0x0/0x12 @ 1
> [    1.829983] initcall zlib_mod_init+0x0/0x12 returned 0 after 55 usecs
> [    1.829995] calling  crypto_authenc_module_init+0x0/0x12 @ 1
> [    1.830005] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
> [    1.830016] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
> [    1.830026] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
> [    1.830037] calling  lzo_mod_init+0x0/0x12 @ 1
> [    1.830133] initcall lzo_mod_init+0x0/0x12 returned 0 after 84 usecs
> [    1.830143] calling  krng_mod_init+0x0/0x12 @ 1
> [    1.830208] initcall krng_mod_init+0x0/0x12 returned 0 after 53 usecs
> [    1.830219] calling  proc_genhd_init+0x0/0x3c @ 1
> [    1.830241] initcall proc_genhd_init+0x0/0x3c returned 0 after 11 usecs
> [    1.830251] calling  bsg_init+0x0/0x12e @ 1
> [    1.830364] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    1.830375] initcall bsg_init+0x0/0x12e returned 0 after 112 usecs
> [    1.830385] calling  noop_init+0x0/0x12 @ 1
> [    1.830394] io scheduler noop registered
> [    1.830403] initcall noop_init+0x0/0x12 returned 0 after 9 usecs
> [    1.830412] calling  deadline_init+0x0/0x12 @ 1
> [    1.830421] io scheduler deadline registered
> [    1.830430] initcall deadline_init+0x0/0x12 returned 0 after 8 usecs
> [    1.830439] calling  cfq_init+0x0/0x8b @ 1
> [    1.830456] io scheduler cfq registered (default)
> [    1.830466] initcall cfq_init+0x0/0x8b returned 0 after 16 usecs
> [    1.830475] calling  percpu_counter_startup+0x0/0x38 @ 1
> [    1.830488] initcall percpu_counter_startup+0x0/0x38 returned 0 after 2 usecs
> [    1.830498] calling  pci_proc_init+0x0/0x6a @ 1
> [    1.830517] initcall pci_proc_init+0x0/0x6a returned 0 after 9 usecs
> [    1.830527] calling  pcie_portdrv_init+0x0/0x7a @ 1
> [    1.830717] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 175 usecs
> [    1.830729] calling  aer_service_init+0x0/0x2b @ 1
> [    1.830742] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
> [    1.830762] IP: [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> [    1.830780] PGD 0
> [    1.830791] Oops: 0000 [#1] SMP
> [    1.830806] Modules linked in:
> [    1.830819] CPU 0
> [    1.830827] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc2upstream-00002-g92ef2a2 #1
> [    1.830838] RIP: e030:[<ffffffff813862fa>]  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> [    1.830853] RSP: e02b:ffff88005bb69e98  EFLAGS: 00010246
> [    1.830862] RAX: 00000000ffffffea RBX: 0000000000000030 RCX: 0000000000000017
> [    1.830871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81328b30
> [    1.830880] RBP: ffff88005bb69eb8 R08: 00000000833df7a7 R09: 0720072007200720
> [    1.830890] R10: 0720072007200720 R11: 0720072007200720 R12: 0000000000000000
> [    1.830899] R13: ffffffff81328b30 R14: 0000000000000000 R15: 0000000000000000
> [    1.830913] FS:  0000000000000000(0000) GS:ffff88005d600000(0000) knlGS:0000000000000000
> [    1.830926] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    1.830935] CR2: 0000000000000024 CR3: 0000000001a0c000 CR4: 0000000000040660
> [    1.830945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    1.830955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    1.830965] Process swapper/0 (pid: 1, threadinfo ffff88005bb68000, task ffff88005bb627f0)
> [    1.830975] Stack:
> [    1.830981]  0000000000000030 0000000000000000 ffffffff81ae8f60 000000006d1ed4e7
> [    1.831007]  ffff88005bb69ec8 ffffffff81328b8b ffff88005bb69ed8 ffffffff81ae8f72
> [    1.831033]  ffff88005bb69f08 ffffffff81002124 0000000000000030 0000000000000007
> [    1.831057] Call Trace:
> [    1.831057]  [<ffffffff81ae8f60>] ? pcie_portdrv_init+0x7a/0x7a
> [    1.831057]  [<ffffffff81328b8b>] aer_acpi_firmware_first+0x1b/0x30
> [    1.831057]  [<ffffffff81ae8f72>] aer_service_init+0x12/0x2b
> [    1.831057]  [<ffffffff81002124>] do_one_initcall+0x124/0x170
> [    1.831057]  [<ffffffff81645404>] kernel_init+0x174/0x2f0
> [    1.831057]  [<ffffffff81abd5ca>] ? parse_early_options+0x2b/0x2b
> [    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
> [    1.831057]  [<ffffffff81663ffc>] ret_from_fork+0x7c/0xb0
> [    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
> [    1.831057] Code: 90 55 80 3d 50 5f 8d 00 00 b8 ea ff ff ff 48 89 e5 41 56 49 89 f6 41 55 49 89 fd 41 54 53 0f 85 bd 00 00 00 48 8b 15 fe 7c 71 00 <44> 8b 4a 24 45 85 c9 0f 84 e1 00 00 00 0f b7 42 28 31 db 48 8d
> [    1.831057] RIP  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> [    1.831057]  RSP <ffff88005bb69e98>
> [    1.831057] CR2: 0000000000000024
> [    2.028436] ---[ end trace dad4411f23c0dcf5 ]---
> [    2.028459] swapper/0 (1) used greatest stack depth: 5176 bytes left
> [    2.028476] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [    2.028476]
> Parsing config from test.xm
> Daemon running with PID 5069
>


https://patchwork.kernel.org/patch/2175871/

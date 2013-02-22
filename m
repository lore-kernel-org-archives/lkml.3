Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3BVVs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:48:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26473 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3BVVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:48:22 -0500
Date: Fri, 22 Feb 2013 16:48:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rafael.j.wysocki@intel.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Regression introduced by 805d410fb0dbd65e1a57a810858fa2491e75822d
 (ACPI: Separate adding ACPI device objects from probing ACPI drivers) in
 v3.9-rc0
Message-ID: <20130222214811.GA25445@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rafael,

Per git bisect it looks like that patch: 
ACPI: Separate adding ACPI device objects from probing ACPI drivers
blows up when running under Xen PV guests:

(please notice that ACPI is turned off with normal Xen PV guests):
547 #ifdef CONFIG_ACPI
548         if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
549                 printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
550                 disable_acpi();
551         }
552 #endif

(in arch/x86/xen/setup.c). Here is what the console tells me
(I can't get the early console somehow to work):

[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 3901.188 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001224] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001488] Mount-cache hash table entries: 256
[    0.001774] Initializing cgroup subsys cpuacct
[    0.001782] Initializing cgroup subsys freezer
[    0.001860] tseg: 00adf00000
[    0.001868] CPU: Physical Processor ID: 0
[    0.001874] CPU: Processor Core ID: 1
[    0.001883] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.001883] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.001883] tlb_flushall_shift: 5
[    0.028911] cpu 0 spinlock event irq 17
[    0.028956] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.028966] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.028976] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.028986] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.028997] calling  init_hw_perf_events+0x0/0x414 @ 1
[    0.029000] Performance Events: 
[    0.029000] perf: AMD core performance counters detected
[    0.029000] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.029000] no hardware sampling interrupt available.
[    0.029000] Broken PMU hardware detected, using software events only.
[    0.029005] Failed to access perfctr msr (MSR c0010201 is 0)
[    0.029014] initcall init_hw_perf_events+0x0/0x414 returned 0 after 976 usecs
[    0.029024] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
[    0.029034] initcall register_trigger_all_cpu_backtrace+0x0/0x16 returned 0 after 0 usecs
[    0.029044] calling  spawn_ksoftirqd+0x0/0x28 @ 1
[    0.029093] initcall spawn_ksoftirqd+0x0/0x28 returned 0 after 0 usecs
[    0.029103] calling  init_workqueues+0x0/0x33a @ 1
[    0.029316] initcall init_workqueues+0x0/0x33a returned 0 after 0 usecs
[    0.029327] calling  migration_init+0x0/0x71 @ 1
[    0.029337] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.029346] calling  cpu_stop_init+0x0/0xb4 @ 1
[    0.029392] initcall cpu_stop_init+0x0/0xb4 returned 0 after 0 usecs
[    0.029402] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.029413] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.029423] calling  rcu_spawn_gp_kthread+0x0/0x89 @ 1
[    0.029493] initcall rcu_spawn_gp_kthread+0x0/0x89 returned 0 after 0 usecs
[    0.029502] calling  relay_init+0x0/0x14 @ 1
[    0.029510] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.029519] calling  tracer_alloc_buffers+0x0/0x1fc @ 1
[    0.029565] initcall tracer_alloc_buffers+0x0/0x1fc returned 0 after 0 usecs
[    0.029575] calling  init_events+0x0/0x61 @ 1
[    0.029584] initcall init_events+0x0/0x61 returned 0 after 0 usecs
[    0.029592] calling  init_trace_printk+0x0/0x12 @ 1
[    0.029601] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.029610] calling  jump_label_init_module+0x0/0x12 @ 1
[    0.029618] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
[    0.029630] calling  mce_amd_init+0x0/0x110 @ 1
[    0.029638] MCE: In-kernel MCE decoding enabled.
[    0.029647] initcall mce_amd_init+0x0/0x110 returned 0 after 0 usecs
[    0.029760] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.030028] installing Xen timer for CPU 1
[    0.030051] cpu 1 spinlock event irq 24
[    0.030092] SMP alternatives: switching to SMP code
[    0.056501] installing Xen timer for CPU 2
[    0.056544] cpu 2 spinlock event irq 31
[    0.057032] Brought up 3 CPUs
[    0.058000] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.058000] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.058000] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.058000] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.058000] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.058000] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.058000] calling  net_ns_init+0x0/0xfd @ 1
[    0.061054] initcall net_ns_init+0x0/0xfd returned 0 after 976 usecs
[    0.061056] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.061069] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
[    0.061081] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.061092] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.061104] calling  reboot_init+0x0/0x1d @ 1
[    0.061116] initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
[    0.061128] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.061138] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.109030] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
[    0.109044] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
[    0.109056] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.110000] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.111008] calling  ksysfs_init+0x0/0x94 @ 1
[    0.111035] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.111045] calling  pm_init+0x0/0x4e @ 1
[    0.111063] initcall pm_init+0x0/0x4e returned 0 after 0 usecs
[    0.111072] calling  pm_disk_init+0x0/0x19 @ 1
[    0.111092] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.111102] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.111113] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.111122] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.111137] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.111148] calling  event_trace_enable+0x0/0xa9 @ 1
[    0.111191] initcall event_trace_enable+0x0/0xa9 returned 0 after 0 usecs
[    0.111202] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.111211] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.111222] calling  fsnotify_init+0x0/0x26 @ 1
[    0.111235] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.111246] calling  filelock_init+0x0/0x2a @ 1
[    0.111317] initcall filelock_init+0x0/0x2a returned 0 after 976 usecs
[    0.111329] calling  init_misc_binfmt+0x0/0x31 @ 1
[    0.111341] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.111351] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.111361] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.111371] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.111381] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.111391] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
[    0.111401] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.111412] calling  debugfs_init+0x0/0x5c @ 1
[    0.111425] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.111435] calling  securityfs_init+0x0/0x53 @ 1
[    0.111448] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.111458] calling  prandom_init+0x0/0xd9 @ 1
[    0.111469] initcall prandom_init+0x0/0xd9 returned 0 after 0 usecs
[    0.111480] calling  virtio_init+0x0/0x30 @ 1
[    0.112062] kworker/u:0 (26) used greatest stack depth: 5592 bytes left
[    0.112092] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    0.112092] calling  __gnttab_init+0x0/0x30 @ 1
[    0.112092] Grant tables using version 2 layout.
[    0.112109] Grant table initialized
[    0.112118] initcall __gnttab_init+0x0/0x30 returned 0 after 0 usecs
[    0.112130] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.126868] RTC time: 165:165:165, date: 165/165/65
[    0.126887] initcall early_resume_init+0x0/0x1d0 returned 0 after 14648 usecs
[    0.126901] calling  cpufreq_core_init+0x0/0xc7 @ 1
[    0.126911] initcall cpufreq_core_init+0x0/0xc7 returned -19 after 0 usecs
[    0.126921] calling  cpuidle_init+0x0/0x40 @ 1
[    0.126930] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
[    0.126941] calling  bsp_pm_check_init+0x0/0x14 @ 1
[    0.126951] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
[    0.126960] calling  sock_init+0x0/0x89 @ 1
[    0.128845] initcall sock_init+0x0/0x89 returned 0 after 1953 usecs
[    0.128856] calling  net_inuse_init+0x0/0x26 @ 1
[    0.128867] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.128877] calling  netpoll_init+0x0/0x31 @ 1
[    0.128886] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.128896] calling  netlink_proto_init+0x0/0x1b3 @ 1
[    0.128919] NET: Registered protocol family 16
[    0.128953] initcall netlink_proto_init+0x0/0x1b3 returned 0 after 0 usecs
[    0.128985] calling  bdi_class_init+0x0/0x4d @ 1
[    0.129075] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.129075] calling  kobject_uevent_init+0x0/0x12 @ 1
[    0.129077] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.129087] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.129114] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.129114] calling  pci_driver_init+0x0/0x19 @ 1
[    0.129114] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    0.129114] calling  backlight_class_init+0x0/0x5d @ 1
[    0.129114] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.129114] calling  video_output_class_init+0x0/0x19 @ 1
[    0.129114] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.217038] calling  xenbus_init+0x0/0x21a @ 1
[    0.217110] initcall xenbus_init+0x0/0x21a returned 0 after 0 usecs
[    0.217110] calling  tty_class_init+0x0/0x38 @ 1
[    0.217110] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.217110] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.217110] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.217110] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.217110] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.217110] calling  register_node_type+0x0/0x34 @ 1
[    0.218034] initcall register_node_type+0x0/0x34 returned 0 after 976 usecs
[    0.218045] calling  i2c_init+0x0/0x77 @ 1
[    0.218063] initcall i2c_init+0x0/0x77 returned 0 after 0 usecs
[    0.218063] calling  amd_postcore_init+0x0/0x143 @ 1
[    0.218673] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
[    0.218710] calling  set_real_mode_permissions+0x0/0xa9 @ 1
[    0.221082] initcall set_real_mode_permissions+0x0/0xa9 returned 0 after 2929 usecs
[    0.221097] calling  arch_kdebugfs_init+0x0/0x233 @ 1
[    0.221181] initcall arch_kdebugfs_init+0x0/0x233 returned 0 after 0 usecs
[    0.221193] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.221202] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.221212] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.221222] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.221233] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.221243] calling  activate_jump_labels+0x0/0x32 @ 1
[    0.221253] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
[    0.221263] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.221273] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.221283] calling  dma_bus_init+0x0/0x19 @ 1
[    0.221306] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.221306] calling  dma_channel_table_init+0x0/0x119 @ 1
[    0.221306] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
[    0.221306] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.226301] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 4882 usecs
[    0.226320] calling  register_xen_pci_notifier+0x0/0x38 @ 1
[    0.226331] initcall register_xen_pci_notifier+0x0/0x38 returned 0 after 0 usecs
[    0.226342] calling  xen_pcpu_init+0x0/0xcc @ 1
[    0.226353] initcall xen_pcpu_init+0x0/0xcc returned -19 after 0 usecs
[    0.226364] calling  dmi_id_init+0x0/0x31d @ 1
[    0.226374] initcall dmi_id_init+0x0/0x31d returned -19 after 0 usecs
[    0.226385] calling  dca_init+0x0/0x20 @ 1
[    0.226394] dca service started, version 1.12.1
[    0.226499] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
[    0.226511] calling  pci_arch_init+0x0/0x69 @ 1
[    0.227009] PCI: setting up Xen PCI frontend stub
[    0.227020] PCI: pci_cache_line_size set to 64 bytes
[    0.227032] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
[    0.227066] calling  topology_init+0x0/0x98 @ 1
[    0.227348] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    0.227360] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.227370] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.227380] calling  init_vdso+0x0/0x135 @ 1
[    0.227393] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    0.227403] calling  sysenter_setup+0x0/0x2dd @ 1
[    0.227417] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    0.227427] calling  param_sysfs_init+0x0/0x192 @ 1
[    0.243968] initcall param_sysfs_init+0x0/0x192 returned 0 after 15625 usecs
[    0.243988] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.243999] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.244000] calling  default_bdi_init+0x0/0x37 @ 1
[    0.244189] initcall default_bdi_init+0x0/0x37 returned 0 after 976 usecs
[    0.244202] calling  init_bio+0x0/0xe8 @ 1
[    0.244226] bio: create slab <bio-0> at 0
[    0.244247] initcall init_bio+0x0/0xe8 returned 0 after 0 usecs
[    0.244258] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.244281] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.244294] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.244304] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.244314] calling  blk_settings_init+0x0/0x2c @ 1
[    0.244323] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.244333] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.244350] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.244360] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.244371] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.244382] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.244391] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.244401] calling  genhd_device_init+0x0/0x85 @ 1
[    0.244544] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    0.244557] calling  pci_slot_init+0x0/0x50 @ 1
[    0.244571] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.244581] calling  fbmem_init+0x0/0x98 @ 1
[    0.244684] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.244697] calling  acpi_init+0x0/0xbc @ 1
[    0.244705] ACPI: Interpreter disabled.
[    0.244714] initcall acpi_init+0x0/0xbc returned -19 after 0 usecs
[    0.244724] calling  dock_init+0x0/0x7b @ 1
[    0.244733] initcall dock_init+0x0/0x7b returned 0 after 0 usecs
[    0.244744] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.244754] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
[    0.244764] calling  pnp_init+0x0/0x19 @ 1
[    0.244875] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
[    0.244887] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.246077] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 1953 usecs
[    0.246091] calling  balloon_init+0x0/0x133 @ 1
[    0.246099] xen/balloon: Initialising balloon driver.
[    0.247065] initcall balloon_init+0x0/0x133 returned 0 after 976 usecs
[    0.247078] calling  xenbus_probe_backend_init+0x0/0x34 @ 1
[    0.255037] initcall xenbus_probe_backend_init+0x0/0x34 returned 0 after 7812 usecs
[    0.255055] calling  xenbus_probe_frontend_init+0x0/0x34 @ 1
[    0.259050] initcall xenbus_probe_frontend_init+0x0/0x34 returned 0 after 3906 usecs
[    0.259065] calling  xen_acpi_pad_init+0x0/0x47 @ 1
[    0.259075] initcall xen_acpi_pad_init+0x0/0x47 returned -19 after 0 usecs
[    0.259084] calling  balloon_init+0x0/0xfa @ 1
[    0.259093] xen-balloon: Initialising balloon driver.
[    0.259328] initcall balloon_init+0x0/0xfa returned 0 after 0 usecs
[    0.259328] calling  xen_selfballoon_init+0x0/0xb9 @ 1
[    0.259328] initcall xen_selfballoon_init+0x0/0xb9 returned -19 after 0 usecs
[    0.259328] calling  misc_init+0x0/0xba @ 1
[    0.259328] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    0.259328] calling  vga_arb_device_init+0x0/0xde @ 1
[    0.259419] vgaarb: loaded
[    0.259430] initcall vga_arb_device_init+0x0/0xde returned 0 after 0 usecs
[    0.259442] calling  cn_init+0x0/0xc0 @ 1
[    0.259466] initcall cn_init+0x0/0xc0 returned 0 after 0 usecs
[    0.259477] calling  phy_init+0x0/0x2e @ 1
[    0.260111] initcall phy_init+0x0/0x2e returned 0 after 976 usecs
[    0.260123] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    0.260208] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    0.260219] calling  usb_init+0x0/0x170 @ 1
[    0.260418] usbcore: registered new interface driver usbfs
[    0.260511] usbcore: registered new interface driver hub
[    0.260635] usbcore: registered new device driver usb
[    0.260646] initcall usb_init+0x0/0x170 returned 0 after 0 usecs
[    0.260656] calling  serio_init+0x0/0x38 @ 1
[    0.260750] initcall serio_init+0x0/0x38 returned 0 after 0 usecs
[    0.260760] calling  input_init+0x0/0x103 @ 1
[    0.260852] initcall input_init+0x0/0x103 returned 0 after 0 usecs
[    0.260863] calling  rtc_init+0x0/0x71 @ 1
[    0.260943] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.260954] calling  pps_init+0x0/0xb7 @ 1
[    0.261000] pps_core: LinuxPPS API ver. 1 registered
[    0.261000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.261000] initcall pps_init+0x0/0xb7 returned 0 after 0 usecs
[    0.261014] calling  ptp_init+0x0/0xa4 @ 1
[    0.261102] PTP clock support registered
[    0.261112] initcall ptp_init+0x0/0xa4 returned 0 after 0 usecs
[    0.261122] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.261204] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.261215] calling  hwmon_init+0x0/0xf6 @ 1
[    0.261296] initcall hwmon_init+0x0/0xf6 returned 0 after 0 usecs
[    0.261307] calling  leds_init+0x0/0x48 @ 1
[    0.261388] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.261399] calling  iommu_init+0x0/0x58 @ 1
[    0.261411] initcall iommu_init+0x0/0x58 returned 0 after 0 usecs
[    0.261423] calling  pci_subsys_init+0x0/0x4f @ 1
[    0.261432] PCI: System does not support PCI
[    0.261440] PCI: System does not support PCI
[    0.261450] initcall pci_subsys_init+0x0/0x4f returned 0 after 0 usecs
[    0.261459] calling  proto_init+0x0/0x12 @ 1
[    0.261474] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.261485] calling  net_dev_init+0x0/0x1c7 @ 1
[    0.261931] initcall net_dev_init+0x0/0x1c7 returned 0 after 0 usecs
[    0.261942] calling  neigh_init+0x0/0x80 @ 1
[    0.261952] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.261961] calling  fib_rules_init+0x0/0xaf @ 1
[    0.261972] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    0.261982] calling  pktsched_init+0x0/0xfe @ 1
[    0.261997] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
[    0.262000] calling  tc_filter_init+0x0/0x55 @ 1
[    0.262000] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    0.262000] calling  tc_action_init+0x0/0x55 @ 1
[    0.262000] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    0.262000] calling  genl_init+0x0/0x75 @ 1
[    0.262033] initcall genl_init+0x0/0x75 returned 0 after 976 usecs
[    0.263021] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.263039] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.263052] calling  netlbl_init+0x0/0x81 @ 1
[    0.263062] NetLabel: Initializing
[    0.263072] NetLabel:  domain hash size = 128
[    0.263081] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.263126] NetLabel:  unlabeled traffic allowed by default
[    0.263137] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.263147] calling  rfkill_init+0x0/0x79 @ 1
[    0.263402] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.263436] calling  xen_p2m_debugfs+0x0/0x4a @ 1
[    0.263478] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 0 usecs
[    0.263489] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
[    0.263645] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 0 usecs
[    0.263659] calling  hpet_late_init+0x0/0x101 @ 1
[    0.263671] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
[    0.263682] calling  init_amd_nbs+0x0/0xb8 @ 1
[    0.263693] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
[    0.263704] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.263714] Switching to clocksource xen
[    0.263742] initcall clocksource_done_booting+0x0/0x5a returned 0 after 8 usecs
[    0.263756] calling  tracer_init_debugfs+0x0/0x3a4 @ 1
[    0.263756] initcall tracer_init_debugfs+0x0/0x3a4 returned 0 after 511 usecs
[    0.263756] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.263756] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 7 usecs
[    0.263756] calling  event_trace_init+0x0/0x271 @ 1
[    0.275332] initcall event_trace_init+0x0/0x271 returned 0 after 11443 usecs
[    0.275351] calling  init_kprobe_trace+0x0/0x93 @ 1
[    0.275377] initcall init_kprobe_trace+0x0/0x93 returned 0 after 15 usecs
[    0.275389] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.275432] initcall init_pipe_fs+0x0/0x4c returned 0 after 31 usecs
[    0.275443] calling  eventpoll_init+0x0/0xda @ 1
[    0.275466] initcall eventpoll_init+0x0/0xda returned 0 after 12 usecs
[    0.275477] calling  anon_inode_init+0x0/0x5b @ 1
[    0.275513] initcall anon_inode_init+0x0/0x5b returned 0 after 26 usecs
[    0.275524] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.275533] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.275543] calling  acpi_event_init+0x0/0x81 @ 1
[    0.275553] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
[    0.275563] calling  pnp_system_init+0x0/0x12 @ 1
[    0.275708] initcall pnp_system_init+0x0/0x12 returned 0 after 131 usecs
[    0.275719] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.275726] pnp: PnP ACPI: disabled
[    0.275734] initcall pnpacpi_init+0x0/0x8c returned 0 after 6 usecs
[    0.275742] calling  pcistub_init+0x0/0x29f @ 1
[    0.275843] initcall pcistub_init+0x0/0x29f returned 0 after 90 usecs
[    0.275852] calling  chr_dev_init+0x0/0xc6 @ 1
[    0.283039] initcall chr_dev_init+0x0/0xc6 returned 0 after 7006 usecs
[    0.283108] calling  firmware_class_init+0x0/0xda @ 1
[    0.283203] initcall firmware_class_init+0x0/0xda returned 0 after 82 usecs
[    0.283213] calling  init_pcmcia_bus+0x0/0x6c @ 1
[    0.283298] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 73 usecs
[    0.283309] calling  thermal_init+0x0/0x75 @ 1
[    0.283400] initcall thermal_init+0x0/0x75 returned 0 after 80 usecs
[    0.283411] calling  thermal_gov_step_wise_init+0x0/0x12 @ 1
[    0.283422] initcall thermal_gov_step_wise_init+0x0/0x12 returned 0 after 0 usecs
[    0.283432] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.283442] initcall cpufreq_gov_performance_init+0x0/0x12 returned -19 after 0 usecs
[    0.283454] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    0.283465] initcall init_acpi_pm_clocksource+0x0/0xec returned -19 after 0 usecs
[    0.283476] calling  pcibios_assign_resources+0x0/0xf8 @ 1
[    0.283489] initcall pcibios_assign_resources+0x0/0xf8 returned 0 after 2 usecs
[    0.283500] calling  sysctl_core_init+0x0/0x2c @ 1
[    0.283523] initcall sysctl_core_init+0x0/0x2c returned 0 after 13 usecs
[    0.283534] calling  inet_init+0x0/0x2a1 @ 1
[    0.283572] NET: Registered protocol family 2
[    0.283850] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.283962] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.284018] TCP: Hash tables configured (established 16384 bind 16384)
[    0.284118] TCP: reno registered
[    0.284136] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.284162] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.284282] initcall inet_init+0x0/0x2a1 returned 0 after 720 usecs
[    0.284292] calling  ipv4_offload_init+0x0/0x68 @ 1
[    0.284304] initcall ipv4_offload_init+0x0/0x68 returned 0 after 1 usecs
[    0.284314] calling  af_unix_init+0x0/0x55 @ 1
[    0.284326] NET: Registered protocol family 1
[    0.284346] initcall af_unix_init+0x0/0x55 returned 0 after 21 usecs
[    0.284356] calling  ipv6_offload_init+0x0/0x6e @ 1
[    0.467091] initcall ipv6_offload_init+0x0/0x6e returned 0 after 1 usecs
[    0.467106] calling  init_sunrpc+0x0/0x69 @ 1
[    0.467311] RPC: Registered named UNIX socket transport module.
[    0.467321] RPC: Registered udp transport module.
[    0.467330] RPC: Registered tcp transport module.
[    0.467338] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.467348] initcall init_sunrpc+0x0/0x69 returned 0 after 225 usecs
[    0.467358] calling  pci_apply_final_quirks+0x0/0x117 @ 1
[    0.467370] PCI: CLS 0 bytes, default 64
[    0.467379] initcall pci_apply_final_quirks+0x0/0x117 returned 0 after 10 usecs
[    0.467390] calling  populate_rootfs+0x0/0x10d @ 1
[    0.467693] Unpacking initramfs...
[    1.224465] Freeing initrd memory: 339320k freed
[    1.330309] initcall populate_rootfs+0x0/0x10d returned 0 after 842675 usecs
[    1.330328] calling  pci_iommu_init+0x0/0x41 @ 1
[    1.330339] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    1.330349] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    1.330358] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    1.330395] calling  irqfd_module_init+0x0/0x33 @ 1
[    1.330489] initcall irqfd_module_init+0x0/0x33 returned 0 after 81 usecs
[    1.330500] calling  i8259A_init_ops+0x0/0x21 @ 1
[    1.330510] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    1.330520] calling  vsyscall_init+0x0/0x27 @ 1
[    1.330534] initcall vsyscall_init+0x0/0x27 returned 0 after 4 usecs
[    1.330544] calling  sbf_init+0x0/0xf6 @ 1
[    1.330553] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    1.330563] calling  init_tsc_clocksource+0x0/0x89 @ 1
[    1.330576] initcall init_tsc_clocksource+0x0/0x89 returned 0 after 3 usecs
[    1.330585] calling  add_rtc_cmos+0x0/0x96 @ 1
[    1.330729] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.330741] initcall add_rtc_cmos+0x0/0x96 returned 0 after 143 usecs
[    1.330751] calling  i8237A_init_ops+0x0/0x14 @ 1
[    1.330761] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.330771] calling  cache_sysfs_init+0x0/0x6c @ 1
[    1.330843] initcall cache_sysfs_init+0x0/0x6c returned 0 after 60 usecs
[    1.330855] calling  intel_uncore_init+0x0/0x3fa @ 1
[    1.330866] initcall intel_uncore_init+0x0/0x3fa returned -19 after 0 usecs
[    1.330878] calling  inject_init+0x0/0x30 @ 1
[    1.330886] Machine check injector initialized
[    1.330897] initcall inject_init+0x0/0x30 returned 0 after 9 usecs
[    1.330906] calling  thermal_throttle_init_device+0x0/0x9d @ 1
[    1.330917] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 0 usecs
[    1.330929] calling  amd_ibs_init+0x0/0x48d @ 1
[    1.330939] initcall amd_ibs_init+0x0/0x48d returned -19 after 0 usecs
[    1.330949] calling  msr_init+0x0/0x162 @ 1
[    1.331168] initcall msr_init+0x0/0x162 returned 0 after 204 usecs
[    1.331179] calling  cpuid_init+0x0/0x162 @ 1
[    1.331356] initcall cpuid_init+0x0/0x162 returned 0 after 161 usecs
[    1.331368] calling  ioapic_init_ops+0x0/0x14 @ 1
[    1.331379] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.331389] calling  add_pcspkr+0x0/0x40 @ 1
[    1.331493] initcall add_pcspkr+0x0/0x40 returned 0 after 91 usecs
[    1.331504] calling  microcode_init+0x0/0x1b1 @ 1
[    1.331600] microcode: CPU0: patch_level=0x06000626
[    1.331698] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.331710] initcall microcode_init+0x0/0x1b1 returned 0 after 193 usecs
[    1.331721] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    1.331731] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    1.331741] calling  audit_classes_init+0x0/0xaf @ 1
[    1.331756] initcall audit_classes_init+0x0/0xaf returned 0 after 5 usecs
[    1.331767] calling  pt_dump_init+0x0/0x30 @ 1
[    1.331801] initcall pt_dump_init+0x0/0x30 returned 0 after 24 usecs
[    1.331815] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    1.331833] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 6 usecs
[    1.331844] calling  proc_execdomains_init+0x0/0x22 @ 1
[    1.331861] initcall proc_execdomains_init+0x0/0x22 returned 0 after 6 usecs
[    1.331871] calling  ioresources_init+0x0/0x3c @ 1
[    1.331887] initcall ioresources_init+0x0/0x3c returned 0 after 6 usecs
[    1.331896] calling  uid_cache_init+0x0/0xa5 @ 1
[    1.331911] initcall uid_cache_init+0x0/0xa5 returned 0 after 5 usecs
[    1.331923] calling  init_posix_timers+0x0/0x1f4 @ 1
[    1.331940] initcall init_posix_timers+0x0/0x1f4 returned 0 after 5 usecs
[    1.331950] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    1.331959] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    1.331969] calling  proc_schedstat_init+0x0/0x22 @ 1
[    1.331982] initcall proc_schedstat_init+0x0/0x22 returned 0 after 3 usecs
[    1.331992] calling  snapshot_device_init+0x0/0x12 @ 1
[    1.332147] initcall snapshot_device_init+0x0/0x12 returned 0 after 141 usecs
[    1.332162] calling  create_proc_profile+0x0/0x2c0 @ 1
[    1.332173] initcall create_proc_profile+0x0/0x2c0 returned 0 after 0 usecs
[    1.332185] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    1.332198] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.332209] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    1.332448] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 219 usecs
[    1.332464] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    1.332489] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 7 usecs
[    1.332504] calling  alarmtimer_init+0x0/0x15d @ 1
[    1.332743] initcall alarmtimer_init+0x0/0x15d returned 0 after 221 usecs
[    1.332754] calling  init_tstats_procfs+0x0/0x2c @ 1
[    1.332771] initcall init_tstats_procfs+0x0/0x2c returned 0 after 5 usecs
[    1.332781] calling  futex_init+0x0/0x65 @ 1
[    1.332804] initcall futex_init+0x0/0x65 returned 0 after 9 usecs
[    1.427360] calling  proc_dma_init+0x0/0x22 @ 1
[    1.427383] initcall proc_dma_init+0x0/0x22 returned 0 after 9 usecs
[    1.427394] calling  proc_modules_init+0x0/0x22 @ 1
[    1.427408] initcall proc_modules_init+0x0/0x22 returned 0 after 4 usecs
[    1.427417] calling  kallsyms_init+0x0/0x25 @ 1
[    1.427430] initcall kallsyms_init+0x0/0x25 returned 0 after 3 usecs
[    1.427440] calling  crash_save_vmcoreinfo_init+0x0/0x4a9 @ 1
[    1.427469] initcall crash_save_vmcoreinfo_init+0x0/0x4a9 returned 0 after 18 usecs
[    1.427480] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    1.427493] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 4 usecs
[    1.427503] calling  pid_namespaces_init+0x0/0x2d @ 1
[    1.427519] initcall pid_namespaces_init+0x0/0x2d returned 0 after 6 usecs
[    1.427529] calling  ikconfig_init+0x0/0x3a @ 1
[    1.427542] initcall ikconfig_init+0x0/0x3a returned 0 after 3 usecs
[    1.427552] calling  audit_init+0x0/0x141 @ 1
[    1.427563] audit: initializing netlink socket (disabled)
[    1.427590] type=2000 audit(1361569070.777:1): initialized
[    1.427603] initcall audit_init+0x0/0x141 returned 0 after 38 usecs
[    1.427613] calling  audit_watch_init+0x0/0x3a @ 1
[    1.427624] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    1.427636] calling  audit_tree_init+0x0/0x49 @ 1
[    1.427647] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    1.427656] calling  init_kprobes+0x0/0x16c @ 1
[    1.439621] initcall init_kprobes+0x0/0x16c returned 0 after 11669 usecs
[    1.439637] calling  hung_task_init+0x0/0x56 @ 1
[    1.439718] initcall hung_task_init+0x0/0x56 returned 0 after 68 usecs
[    1.439729] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    1.439738] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.439748] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.439767] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 9 usecs
[    1.439778] calling  init_tracepoints+0x0/0x20 @ 1
[    1.439788] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    1.439798] calling  init_blk_tracer+0x0/0x5a @ 1
[    1.439808] initcall init_blk_tracer+0x0/0x5a returned 0 after 1 usecs
[    1.439818] calling  perf_event_sysfs_init+0x0/0x9a @ 1
[    1.440270] initcall perf_event_sysfs_init+0x0/0x9a returned 0 after 431 usecs
[    1.440283] calling  init_per_zone_wmark_min+0x0/0x8c @ 1
[    1.440420] initcall init_per_zone_wmark_min+0x0/0x8c returned 0 after 122 usecs
[    1.440433] calling  kswapd_init+0x0/0x76 @ 1
[    1.440489] initcall kswapd_init+0x0/0x76 returned 0 after 45 usecs
[    1.440499] calling  extfrag_debug_init+0x0/0x7e @ 1
[    1.440539] initcall extfrag_debug_init+0x0/0x7e returned 0 after 29 usecs
[    1.440549] calling  setup_vmstat+0x0/0xc8 @ 1
[    1.440578] initcall setup_vmstat+0x0/0xc8 returned 0 after 18 usecs
[    1.440589] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.440602] initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
[    1.440613] calling  slab_proc_init+0x0/0x25 @ 1
[    1.440626] initcall slab_proc_init+0x0/0x25 returned 0 after 4 usecs
[    1.440636] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.440650] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    1.440660] calling  procswaps_init+0x0/0x22 @ 1
[    1.440673] initcall procswaps_init+0x0/0x22 returned 0 after 3 usecs
[    1.440684] calling  init_frontswap+0x0/0x96 @ 1
[    1.440737] initcall init_frontswap+0x0/0x96 returned 0 after 43 usecs
[    1.440749] calling  hugetlb_init+0x0/0x415 @ 1
[    1.440759] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.440788] initcall hugetlb_init+0x0/0x415 returned 0 after 28 usecs
[    1.440797] calling  mmu_notifier_init+0x0/0x12 @ 1
[    1.440810] initcall mmu_notifier_init+0x0/0x12 returned 0 after 2 usecs
[    1.440821] calling  slab_proc_init+0x0/0x8 @ 1
[    1.440831] initcall slab_proc_init+0x0/0x8 returned 0 after 0 usecs
[    1.440840] calling  cpucache_init+0x0/0x52 @ 1
[    1.440851] initcall cpucache_init+0x0/0x52 returned 0 after 1 usecs
[    1.440861] calling  hugepage_init+0x0/0x191 @ 1
[    1.440870] initcall hugepage_init+0x0/0x191 returned -22 after 0 usecs
[    1.440880] initcall hugepage_init+0x0/0x191 returned with error code -22 
[    1.440890] calling  init_cleancache+0x0/0x96 @ 1
[    1.440939] initcall init_cleancache+0x0/0x96 returned 0 after 38 usecs
[    1.440949] calling  fcntl_init+0x0/0x2a @ 1
[    1.440964] initcall fcntl_init+0x0/0x2a returned 0 after 5 usecs
[    1.440974] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.440991] initcall proc_filesystems_init+0x0/0x22 returned 0 after 7 usecs
[    1.441002] calling  dio_init+0x0/0x2d @ 1
[    1.441016] initcall dio_init+0x0/0x2d returned 0 after 5 usecs
[    1.441025] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    1.441109] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 71 usecs
[    1.441119] calling  dnotify_init+0x0/0x7b @ 1
[    1.441137] initcall dnotify_init+0x0/0x7b returned 0 after 8 usecs
[    1.441146] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.441163] initcall inotify_user_setup+0x0/0x70 returned 0 after 7 usecs
[    1.441173] calling  aio_setup+0x0/0x7c @ 1
[    1.441192] initcall aio_setup+0x0/0x7c returned 0 after 9 usecs
[    1.627775] calling  proc_locks_init+0x0/0x22 @ 1
[    1.627796] initcall proc_locks_init+0x0/0x22 returned 0 after 9 usecs
[    1.627806] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    1.627885] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 67 usecs
[    1.627895] calling  dquot_init+0x0/0x121 @ 1
[    1.627904] VFS: Disk quotas dquot_6.5.2
[    1.627962] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.627974] initcall dquot_init+0x0/0x121 returned 0 after 66 usecs
[    1.627985] calling  init_v2_quota_format+0x0/0x22 @ 1
[    1.627996] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    1.628006] calling  quota_init+0x0/0x26 @ 1
[    1.628027] initcall quota_init+0x0/0x26 returned 0 after 10 usecs
[    1.628037] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.628072] initcall proc_cmdline_init+0x0/0x22 returned 0 after 22 usecs
[    1.628088] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.628105] initcall proc_consoles_init+0x0/0x22 returned 0 after 4 usecs
[    1.628115] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.628129] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 4 usecs
[    1.628140] calling  proc_devices_init+0x0/0x22 @ 1
[    1.628154] initcall proc_devices_init+0x0/0x22 returned 0 after 3 usecs
[    1.628165] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.628179] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    1.628189] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.628204] initcall proc_loadavg_init+0x0/0x22 returned 0 after 3 usecs
[    1.628214] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.628228] initcall proc_meminfo_init+0x0/0x22 returned 0 after 3 usecs
[    1.628237] calling  proc_stat_init+0x0/0x22 @ 1
[    1.628251] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    1.628261] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.628275] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    1.628287] calling  proc_version_init+0x0/0x22 @ 1
[    1.628300] initcall proc_version_init+0x0/0x22 returned 0 after 3 usecs
[    1.645978] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.646001] initcall proc_softirqs_init+0x0/0x22 returned 0 after 10 usecs
[    1.646012] calling  proc_kcore_init+0x0/0xb5 @ 1
[    1.646032] initcall proc_kcore_init+0x0/0xb5 returned 0 after 8 usecs
[    1.646042] calling  vmcore_init+0x0/0x370 @ 1
[    1.646052] initcall vmcore_init+0x0/0x370 returned 0 after 0 usecs
[    1.646063] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.646076] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
[    1.646086] calling  proc_page_init+0x0/0x42 @ 1
[    1.646104] initcall proc_page_init+0x0/0x42 returned 0 after 7 usecs
[    1.646125] calling  init_devpts_fs+0x0/0x62 @ 1
[    1.646192] initcall init_devpts_fs+0x0/0x62 returned 0 after 54 usecs
[    1.646203] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.646213] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    1.646224] calling  init_hugetlbfs_fs+0x0/0x15d @ 1
[    1.646302] initcall init_hugetlbfs_fs+0x0/0x15d returned 0 after 66 usecs
[    1.646313] calling  init_fat_fs+0x0/0x4f @ 1
[    1.646329] initcall init_fat_fs+0x0/0x4f returned 0 after 6 usecs
[    1.646340] calling  init_vfat_fs+0x0/0x12 @ 1
[    1.646350] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    1.646360] calling  init_msdos_fs+0x0/0x12 @ 1
[    1.646370] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    1.646380] calling  init_iso9660_fs+0x0/0x70 @ 1
[    1.646412] initcall init_iso9660_fs+0x0/0x70 returned 0 after 22 usecs
[    1.646422] calling  init_nfs_fs+0x0/0x16c @ 1
[    1.646598] initcall init_nfs_fs+0x0/0x16c returned 0 after 162 usecs
[    1.646609] calling  init_nfs_v2+0x0/0x14 @ 1
[    1.646619] initcall init_nfs_v2+0x0/0x14 returned 0 after 0 usecs
[    1.646629] calling  init_nfs_v3+0x0/0x14 @ 1
[    1.646639] initcall init_nfs_v3+0x0/0x14 returned 0 after 0 usecs
[    1.646649] calling  init_nfs_v4+0x0/0x3b @ 1
[    1.646658] NFS: Registering the id_resolver key type
[    1.646685] Key type id_resolver registered
[    1.646694] Key type id_legacy registered
[    1.646708] initcall init_nfs_v4+0x0/0x3b returned 0 after 47 usecs
[    1.646717] calling  init_nlm+0x0/0x4c @ 1
[    1.646732] initcall init_nlm+0x0/0x4c returned 0 after 6 usecs
[    1.646742] calling  init_nls_cp437+0x0/0x12 @ 1
[    1.646752] initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
[    1.646760] calling  init_nls_ascii+0x0/0x12 @ 1
[    1.646770] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    1.646780] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    1.646790] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    1.646799] calling  init_nls_utf8+0x0/0x2b @ 1
[    1.646810] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
[    1.646819] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    1.646827] NTFS driver 2.1.30 [Flags: R/W].
[    1.646853] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 23 usecs
[    1.646863] calling  init_autofs4_fs+0x0/0x2a @ 1
[    1.647010] initcall init_autofs4_fs+0x0/0x2a returned 0 after 133 usecs
[    1.647019] calling  init_pstore_fs+0x0/0x12 @ 1
[    1.647030] initcall init_pstore_fs+0x0/0x12 returned 0 after 0 usecs
[    1.647040] calling  ipc_init+0x0/0x2f @ 1
[    1.647079] msgmni has been set to 2923
[    1.647097] initcall ipc_init+0x0/0x2f returned 0 after 46 usecs
[    1.647106] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.647123] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 6 usecs
[    1.647132] calling  init_mqueue_fs+0x0/0xa2 @ 1
[    1.647183] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 40 usecs
[    1.647193] calling  key_proc_init+0x0/0x5e @ 1
[    1.647210] initcall key_proc_init+0x0/0x5e returned 0 after 7 usecs
[    1.647220] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    1.647228] SELinux:  Registering netfilter hooks
[    1.647457] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 222 usecs
[    1.647467] calling  init_sel_fs+0x0/0xa5 @ 1
[    1.647812] initcall init_sel_fs+0x0/0xa5 returned 0 after 327 usecs
[    1.647822] calling  selnl_init+0x0/0x56 @ 1
[    1.647839] initcall selnl_init+0x0/0x56 returned 0 after 7 usecs
[    1.647848] calling  sel_netif_init+0x0/0x5c @ 1
[    1.647860] initcall sel_netif_init+0x0/0x5c returned 0 after 2 usecs
[    1.647870] calling  sel_netnode_init+0x0/0x6a @ 1
[    1.647880] initcall sel_netnode_init+0x0/0x6a returned 0 after 1 usecs
[    1.647889] calling  sel_netport_init+0x0/0x6a @ 1
[    1.647900] initcall sel_netport_init+0x0/0x6a returned 0 after 1 usecs
[    1.647909] calling  aurule_init+0x0/0x2d @ 1
[    1.647921] initcall aurule_init+0x0/0x2d returned 0 after 0 usecs
[    1.647932] calling  crypto_wq_init+0x0/0x33 @ 1
[    1.647976] initcall crypto_wq_init+0x0/0x33 returned 0 after 33 usecs
[    1.647986] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.647999] initcall crypto_algapi_init+0x0/0xd returned 0 after 4 usecs
[    1.829390] calling  skcipher_module_init+0x0/0x35 @ 1
[    1.829403] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
[    1.829414] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.829425] initcall chainiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    1.829435] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.829445] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.829455] calling  hmac_module_init+0x0/0x12 @ 1
[    1.829464] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.829474] calling  md5_mod_init+0x0/0x12 @ 1
[    1.829598] initcall md5_mod_init+0x0/0x12 returned 0 after 111 usecs
[    1.829609] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    1.829676] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 55 usecs
[    1.829687] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.829696] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.829706] calling  des_generic_mod_init+0x0/0x17 @ 1
[    1.829828] initcall des_generic_mod_init+0x0/0x17 returned 0 after 109 usecs
[    1.829839] calling  aes_init+0x0/0x12 @ 1
[    1.829904] initcall aes_init+0x0/0x12 returned 0 after 54 usecs
[    1.829917] calling  zlib_mod_init+0x0/0x12 @ 1
[    1.829983] initcall zlib_mod_init+0x0/0x12 returned 0 after 55 usecs
[    1.829995] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    1.830005] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.830016] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    1.830026] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.830037] calling  lzo_mod_init+0x0/0x12 @ 1
[    1.830133] initcall lzo_mod_init+0x0/0x12 returned 0 after 84 usecs
[    1.830143] calling  krng_mod_init+0x0/0x12 @ 1
[    1.830208] initcall krng_mod_init+0x0/0x12 returned 0 after 53 usecs
[    1.830219] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.830241] initcall proc_genhd_init+0x0/0x3c returned 0 after 11 usecs
[    1.830251] calling  bsg_init+0x0/0x12e @ 1
[    1.830364] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.830375] initcall bsg_init+0x0/0x12e returned 0 after 112 usecs
[    1.830385] calling  noop_init+0x0/0x12 @ 1
[    1.830394] io scheduler noop registered
[    1.830403] initcall noop_init+0x0/0x12 returned 0 after 9 usecs
[    1.830412] calling  deadline_init+0x0/0x12 @ 1
[    1.830421] io scheduler deadline registered
[    1.830430] initcall deadline_init+0x0/0x12 returned 0 after 8 usecs
[    1.830439] calling  cfq_init+0x0/0x8b @ 1
[    1.830456] io scheduler cfq registered (default)
[    1.830466] initcall cfq_init+0x0/0x8b returned 0 after 16 usecs
[    1.830475] calling  percpu_counter_startup+0x0/0x38 @ 1
[    1.830488] initcall percpu_counter_startup+0x0/0x38 returned 0 after 2 usecs
[    1.830498] calling  pci_proc_init+0x0/0x6a @ 1
[    1.830517] initcall pci_proc_init+0x0/0x6a returned 0 after 9 usecs
[    1.830527] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    1.830717] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 175 usecs
[    1.830729] calling  aer_service_init+0x0/0x2b @ 1
[    1.830742] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
[    1.830762] IP: [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
[    1.830780] PGD 0 
[    1.830791] Oops: 0000 [#1] SMP 
[    1.830806] Modules linked in:
[    1.830819] CPU 0 
[    1.830827] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc2upstream-00002-g92ef2a2 #1  
[    1.830838] RIP: e030:[<ffffffff813862fa>]  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
[    1.830853] RSP: e02b:ffff88005bb69e98  EFLAGS: 00010246
[    1.830862] RAX: 00000000ffffffea RBX: 0000000000000030 RCX: 0000000000000017
[    1.830871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81328b30
[    1.830880] RBP: ffff88005bb69eb8 R08: 00000000833df7a7 R09: 0720072007200720
[    1.830890] R10: 0720072007200720 R11: 0720072007200720 R12: 0000000000000000
[    1.830899] R13: ffffffff81328b30 R14: 0000000000000000 R15: 0000000000000000
[    1.830913] FS:  0000000000000000(0000) GS:ffff88005d600000(0000) knlGS:0000000000000000
[    1.830926] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.830935] CR2: 0000000000000024 CR3: 0000000001a0c000 CR4: 0000000000040660
[    1.830945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.830955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.830965] Process swapper/0 (pid: 1, threadinfo ffff88005bb68000, task ffff88005bb627f0)
[    1.830975] Stack:
[    1.830981]  0000000000000030 0000000000000000 ffffffff81ae8f60 000000006d1ed4e7
[    1.831007]  ffff88005bb69ec8 ffffffff81328b8b ffff88005bb69ed8 ffffffff81ae8f72
[    1.831033]  ffff88005bb69f08 ffffffff81002124 0000000000000030 0000000000000007
[    1.831057] Call Trace:
[    1.831057]  [<ffffffff81ae8f60>] ? pcie_portdrv_init+0x7a/0x7a
[    1.831057]  [<ffffffff81328b8b>] aer_acpi_firmware_first+0x1b/0x30
[    1.831057]  [<ffffffff81ae8f72>] aer_service_init+0x12/0x2b
[    1.831057]  [<ffffffff81002124>] do_one_initcall+0x124/0x170
[    1.831057]  [<ffffffff81645404>] kernel_init+0x174/0x2f0
[    1.831057]  [<ffffffff81abd5ca>] ? parse_early_options+0x2b/0x2b
[    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
[    1.831057]  [<ffffffff81663ffc>] ret_from_fork+0x7c/0xb0
[    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
[    1.831057] Code: 90 55 80 3d 50 5f 8d 00 00 b8 ea ff ff ff 48 89 e5 41 56 49 89 f6 41 55 49 89 fd 41 54 53 0f 85 bd 00 00 00 48 8b 15 fe 7c 71 00 <44> 8b 4a 24 45 85 c9 0f 84 e1 00 00 00 0f b7 42 28 31 db 48 8d 
[    1.831057] RIP  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
[    1.831057]  RSP <ffff88005bb69e98>
[    1.831057] CR2: 0000000000000024
[    2.028436] ---[ end trace dad4411f23c0dcf5 ]---
[    2.028459] swapper/0 (1) used greatest stack depth: 5176 bytes left
[    2.028476] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    2.028476] 
Parsing config from test.xm
Daemon running with PID 5069

This is what git bisect tells me:

git bisect start
# good: [eb2689e06b3526c7684b09beecf26070f05ee825] Merge tag 'regmap-domain-deps' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect good eb2689e06b3526c7684b09beecf26070f05ee825
# bad: [8793422fd9ac5037f5047f80473007301df3689f] Merge tag 'pm+acpi-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 8793422fd9ac5037f5047f80473007301df3689f
# good: [dff8360a4a079692e65e55fbaa6c5dc605528403] Merge tag 'gpio-for-v3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
git bisect good dff8360a4a079692e65e55fbaa6c5dc605528403
# good: [8287361abca36504da813638310d2547469283eb] Merge tag 'headers' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 8287361abca36504da813638310d2547469283eb
# good: [3c2e81ef344a90bb0a39d84af6878b4aeff568a2] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect good 3c2e81ef344a90bb0a39d84af6878b4aeff568a2
# good: [478740a14826c50595649b3dafed71576796dd95] s390/pci: define read*_relaxed functions
git bisect good 478740a14826c50595649b3dafed71576796dd95
# good: [42976ad0b26b2465f33c9a9146eb15f3a644d269] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 42976ad0b26b2465f33c9a9146eb15f3a644d269
# good: [88cff241596f29122e9125a41b20d21dfed873cd] Merge tag 'regmap-3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect good 88cff241596f29122e9125a41b20d21dfed873cd
# good: [10b6339e93244156fac901560117e94bf9dca120] Merge tag 'clk-for-linus' of git://git.linaro.org/people/mturquette/linux
git bisect good 10b6339e93244156fac901560117e94bf9dca120
# bad: [95ecb407699825278f4031f153dbbe0f0713ff28] Merge branch 'pm-tools'
git bisect bad 95ecb407699825278f4031f153dbbe0f0713ff28
# bad: [48694bdb38769c8b9fad4750df25681e32bd815a] Merge branch 'acpica'
git bisect bad 48694bdb38769c8b9fad4750df25681e32bd815a
# good: [3f654bad3257427bea7ba1c4d43a23d99a03622b] ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
git bisect good 3f654bad3257427bea7ba1c4d43a23d99a03622b
# bad: [b17b537ac1429a609addb55bf985f5ebfcf4ae7b] ACPI / scan: Drop the second argument of acpi_device_unregister()
git bisect bad b17b537ac1429a609addb55bf985f5ebfcf4ae7b
# bad: [209d3b1743c8187c67cc75dbe9fefbcd3121fba0] ACPI: Replace ACPI device add_type field with a match_driver flag
git bisect bad 209d3b1743c8187c67cc75dbe9fefbcd3121fba0
# bad: [a2d06a1a0851fb3d7e775b9d878cdffb9e0300ee] ACPI: Replace struct acpi_bus_ops with enum type
git bisect bad a2d06a1a0851fb3d7e775b9d878cdffb9e0300ee
# bad: [92ef2a25c763338905dce8344a0584606f842920] ACPI: Change the ordering of PCI root bridge driver registrarion
git bisect bad 92ef2a25c763338905dce8344a0584606f842920
# bad: [805d410fb0dbd65e1a57a810858fa2491e75822d] ACPI: Separate adding ACPI device objects from probing ACPI drivers
git bisect bad 805d410fb0dbd65e1a57a810858fa2491e75822d


and just to double-check, if I use commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jan 2 18:13:21 2013 -0800

    Linux 3.8-rc2

(which is the baseline for 805d410fb0dbd65e1a57a810858fa2491e75822d)
the it boots up fine.


And here is with a good (so with 3.8-rc2):

[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 3901.188 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001186] Mount-cache hash table entries: 256
[    0.001416] Initializing cgroup subsys cpuacct
[    0.001422] Initializing cgroup subsys freezer
[    0.001477] tseg: 00adf00000
[    0.001484] CPU: Physical Processor ID: 0
[    0.001489] CPU: Processor Core ID: 6
[    0.001495] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.001495] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.001495] tlb_flushall_shift: 5
[    0.022164] cpu 0 spinlock event irq 17
[    0.022202] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.022211] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.022219] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.022227] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.022236] calling  init_hw_perf_events+0x0/0x414 @ 1
[    0.022242] Performance Events: 
[    0.022247] perf: AMD core performance counters detected
[    0.022254] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.022261] no hardware sampling interrupt available.
[    0.022277] Broken PMU hardware detected, using software events only.
[    0.022284] Failed to access perfctr msr (MSR c0010201 is 0)
[    0.022292] initcall init_hw_perf_events+0x0/0x414 returned 0 after 0 usecs
[    0.022299] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
[    0.022307] initcall register_trigger_all_cpu_backtrace+0x0/0x16 returned 0 after 0 usecs
[    0.022316] calling  spawn_ksoftirqd+0x0/0x28 @ 1
[    0.022360] initcall spawn_ksoftirqd+0x0/0x28 returned 0 after 0 usecs
[    0.022368] calling  init_workqueues+0x0/0x33a @ 1
[    0.022543] initcall init_workqueues+0x0/0x33a returned 0 after 0 usecs
[    0.022552] calling  migration_init+0x0/0x71 @ 1
[    0.022560] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.022568] calling  cpu_stop_init+0x0/0xb4 @ 1
[    0.022606] initcall cpu_stop_init+0x0/0xb4 returned 0 after 0 usecs
[    0.022615] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.022622] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.022630] calling  rcu_spawn_gp_kthread+0x0/0x89 @ 1
[    0.022684] initcall rcu_spawn_gp_kthread+0x0/0x89 returned 0 after 0 usecs
[    0.022692] calling  relay_init+0x0/0x14 @ 1
[    0.022698] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.022705] calling  tracer_alloc_buffers+0x0/0x1fc @ 1
[    0.022746] initcall tracer_alloc_buffers+0x0/0x1fc returned 0 after 0 usecs
[    0.022753] calling  init_events+0x0/0x61 @ 1
[    0.022761] initcall init_events+0x0/0x61 returned 0 after 0 usecs
[    0.022768] calling  init_trace_printk+0x0/0x12 @ 1
[    0.022775] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.022782] calling  jump_label_init_module+0x0/0x12 @ 1
[    0.022789] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
[    0.022797] calling  mce_amd_init+0x0/0x110 @ 1
[    0.022803] MCE: In-kernel MCE decoding enabled.
[    0.022811] initcall mce_amd_init+0x0/0x110 returned 0 after 0 usecs
[    0.022903] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.023115] installing Xen timer for CPU 1
[    0.023134] cpu 1 spinlock event irq 24
[    0.023185] SMP alternatives: switching to SMP code
[    0.042382] installing Xen timer for CPU 2
[    0.042402] cpu 2 spinlock event irq 31
[    0.042544] Brought up 3 CPUs
[    0.044906] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.044915] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.044923] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.044930] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.044938] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.044948] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.044957] calling  net_ns_init+0x0/0xfd @ 1
[    0.044990] initcall net_ns_init+0x0/0xfd returned 0 after 0 usecs
[    0.045019] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.045027] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
[    0.045036] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.045044] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.046007] calling  reboot_init+0x0/0x1d @ 1
[    0.046017] initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
[    0.046025] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.046032] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.046040] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
[    0.046049] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
[    0.046057] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.046065] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.046073] calling  ksysfs_init+0x0/0x94 @ 1
[    0.046094] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.046103] calling  pm_init+0x0/0x4e @ 1
[    0.046117] initcall pm_init+0x0/0x4e returned 0 after 0 usecs
[    0.046125] calling  pm_disk_init+0x0/0x19 @ 1
[    0.046136] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.046146] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.046154] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.046162] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.046172] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.046181] calling  event_trace_enable+0x0/0xa9 @ 1
[    0.046213] initcall event_trace_enable+0x0/0xa9 returned 0 after 0 usecs
[    0.046222] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.046229] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.046237] calling  fsnotify_init+0x0/0x26 @ 1
[    0.046246] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.046254] calling  filelock_init+0x0/0x2a @ 1
[    0.046281] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.046290] calling  init_misc_binfmt+0x0/0x31 @ 1
[    0.046298] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.046306] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.046314] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046322] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.046330] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046338] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
[    0.046346] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046354] calling  debugfs_init+0x0/0x5c @ 1
[    0.046364] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.046371] calling  securityfs_init+0x0/0x53 @ 1
[    0.046381] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.046389] calling  prandom_init+0x0/0xd9 @ 1
[    0.046397] initcall prandom_init+0x0/0xd9 returned 0 after 0 usecs
[    0.046406] calling  virtio_init+0x0/0x30 @ 1
[    0.046429] kworker/u:0 (26) used greatest stack depth: 6136 bytes left
[    0.046429] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    0.046429] calling  __gnttab_init+0x0/0x30 @ 1
[    0.046429] Grant tables using version 2 layout.
[    0.046429] Grant table initialized
[    0.046429] initcall __gnttab_init+0x0/0x30 returned 0 after 0 usecs
[    0.046429] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.065694] RTC time: 165:165:165, date: 165/165/65
[    0.065702] initcall early_resume_init+0x0/0x1d0 returned 0 after 18554 usecs
[    0.065711] calling  cpufreq_core_init+0x0/0xc7 @ 1
[    0.065719] initcall cpufreq_core_init+0x0/0xc7 returned -19 after 0 usecs
[    0.065727] calling  cpuidle_init+0x0/0x40 @ 1
[    0.065734] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
[    0.065742] calling  bsp_pm_check_init+0x0/0x14 @ 1
[    0.065749] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
[    0.065756] calling  sock_init+0x0/0x89 @ 1
[    0.065842] initcall sock_init+0x0/0x89 returned 0 after 0 usecs
[    0.065850] calling  net_inuse_init+0x0/0x26 @ 1
[    0.065859] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.065867] calling  netpoll_init+0x0/0x31 @ 1
[    0.065874] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.065881] calling  netlink_proto_init+0x0/0x1b3 @ 1
[    0.065897] NET: Registered protocol family 16
[    0.065917] initcall netlink_proto_init+0x0/0x1b3 returned 0 after 0 usecs
[    0.065938] calling  bdi_class_init+0x0/0x4d @ 1
[    0.066049] initcall bdi_class_init+0x0/0x4d returned 0 after 976 usecs
[    0.066060] calling  kobject_uevent_init+0x0/0x12 @ 1
[    0.066071] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.066079] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.066096] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.066096] calling  pci_driver_init+0x0/0x19 @ 1
[    0.066096] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    0.066096] calling  backlight_class_init+0x0/0x5d @ 1
[    0.067045] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.067045] calling  video_output_class_init+0x0/0x19 @ 1
[    0.067063] kworker/u:0 (31) used greatest stack depth: 5592 bytes left
[    0.067063] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.067063] calling  xenbus_init+0x0/0x21a @ 1
[    0.067093] initcall xenbus_init+0x0/0x21a returned 0 after 0 usecs
[    0.067093] calling  tty_class_init+0x0/0x38 @ 1
[    0.067093] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.067093] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.067093] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.067093] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.067093] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.067093] calling  register_node_type+0x0/0x34 @ 1
[    0.067093] initcall register_node_type+0x0/0x34 returned 0 after 0 usecs
[    0.067093] calling  i2c_init+0x0/0x77 @ 1
[    0.068032] initcall i2c_init+0x0/0x77 returned 0 after 976 usecs
[    0.068043] calling  amd_postcore_init+0x0/0x143 @ 1
[    0.068130] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
[    0.068160] calling  set_real_mode_permissions+0x0/0xa9 @ 1
[    0.068216] initcall set_real_mode_permissions+0x0/0xa9 returned 0 after 0 usecs
[    0.068227] calling  arch_kdebugfs_init+0x0/0x233 @ 1
[    0.068268] initcall arch_kdebugfs_init+0x0/0x233 returned 0 after 0 usecs
[    0.068278] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.068286] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.068294] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.068303] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.068311] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.068319] calling  activate_jump_labels+0x0/0x32 @ 1
[    0.068327] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
[    0.068335] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.068343] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.068352] calling  dma_bus_init+0x0/0x19 @ 1
[    0.068371] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.068371] calling  dma_channel_table_init+0x0/0x119 @ 1
[    0.068371] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
[    0.068371] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.070221] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 1953 usecs
[    0.070233] calling  register_xen_pci_notifier+0x0/0x38 @ 1
[    0.070241] initcall register_xen_pci_notifier+0x0/0x38 returned 0 after 0 usecs
[    0.070249] calling  xen_pcpu_init+0x0/0xcc @ 1
[    0.070256] initcall xen_pcpu_init+0x0/0xcc returned -19 after 0 usecs
[    0.070264] calling  dmi_id_init+0x0/0x31d @ 1
[    0.070272] initcall dmi_id_init+0x0/0x31d returned -19 after 0 usecs
[    0.070280] calling  dca_init+0x0/0x20 @ 1
[    0.070286] dca service started, version 1.12.1
[    0.070358] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
[    0.070366] calling  pci_arch_init+0x0/0x69 @ 1
[    0.071009] PCI: setting up Xen PCI frontend stub
[    0.071016] PCI: pci_cache_line_size set to 64 bytes
[    0.071024] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
[    0.071045] calling  topology_init+0x0/0x98 @ 1
[    0.071262] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    0.071271] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.071278] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.071286] calling  init_vdso+0x0/0x135 @ 1
[    0.071296] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    0.071304] calling  sysenter_setup+0x0/0x2dd @ 1
[    0.071314] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    0.071322] calling  param_sysfs_init+0x0/0x192 @ 1
[    0.083778] initcall param_sysfs_init+0x0/0x192 returned 0 after 11718 usecs
[    0.083790] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.083800] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.083808] calling  default_bdi_init+0x0/0x37 @ 1
[    0.083946] initcall default_bdi_init+0x0/0x37 returned 0 after 0 usecs
[    0.084039] calling  init_bio+0x0/0xe8 @ 1
[    0.084059] bio: create slab <bio-0> at 0
[    0.084078] initcall init_bio+0x0/0xe8 returned 0 after 0 usecs
[    0.084087] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.084105] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.084114] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.084122] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.084130] calling  blk_settings_init+0x0/0x2c @ 1
[    0.084138] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.084146] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.084157] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.084165] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.084174] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.084181] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.084189] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.084197] calling  genhd_device_init+0x0/0x85 @ 1
[    0.084326] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    0.084337] calling  pci_slot_init+0x0/0x50 @ 1
[    0.084347] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.084355] calling  fbmem_init+0x0/0x98 @ 1
[    0.084428] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.084438] calling  acpi_init+0x0/0xbc @ 1
[    0.084444] ACPI: Interpreter disabled.
[    0.084451] initcall acpi_init+0x0/0xbc returned -19 after 0 usecs
[    0.084459] calling  dock_init+0x0/0x7b @ 1
[    0.084467] initcall dock_init+0x0/0x7b returned 0 after 0 usecs
[    0.084475] calling  acpi_pci_root_init+0x0/0x32 @ 1
[    0.084483] initcall acpi_pci_root_init+0x0/0x32 returned 0 after 0 usecs
[    0.084491] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.084499] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
[    0.084507] calling  pnp_init+0x0/0x19 @ 1
[    0.084576] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
[    0.084586] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.084600] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 0 usecs
[    0.084600] calling  balloon_init+0x0/0x133 @ 1
[    0.084600] xen/balloon: Initialising balloon driver.
[    0.084600] initcall balloon_init+0x0/0x133 returned 0 after 0 usecs
[    0.084600] calling  xenbus_probe_backend_init+0x0/0x34 @ 1
[    0.085058] initcall xenbus_probe_backend_init+0x0/0x34 returned 0 after 976 usecs
[    0.085058] calling  xenbus_probe_frontend_init+0x0/0x34 @ 1
[    0.085110] initcall xenbus_probe_frontend_init+0x0/0x34 returned 0 after 0 usecs
[    0.085110] calling  xen_acpi_pad_init+0x0/0x47 @ 1
[    0.085110] initcall xen_acpi_pad_init+0x0/0x47 returned -19 after 0 usecs
[    0.085110] calling  balloon_init+0x0/0xfa @ 1
[    0.085110] xen-balloon: Initialising balloon driver.
[    0.086035] initcall balloon_init+0x0/0xfa returned 0 after 976 usecs
[    0.086035] calling  xen_selfballoon_init+0x0/0xb9 @ 1
[    0.086043] initcall xen_selfballoon_init+0x0/0xb9 returned -19 after 0 usecs
[    0.086051] calling  misc_init+0x0/0xba @ 1
[    0.086151] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    0.086159] calling  vga_arb_device_init+0x0/0xde @ 1
[    0.086269] vgaarb: loaded
[    0.086276] initcall vga_arb_device_init+0x0/0xde returned 0 after 0 usecs
[    0.086285] calling  cn_init+0x0/0xc0 @ 1
[    0.086302] initcall cn_init+0x0/0xc0 returned 0 after 0 usecs
[    0.086310] calling  phy_init+0x0/0x2e @ 1
[    0.086493] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.086501] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    0.086564] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    0.086572] calling  usb_init+0x0/0x170 @ 1
[    0.086726] usbcore: registered new interface driver usbfs
[    0.086798] usbcore: registered new interface driver hub
[    0.086890] usbcore: registered new device driver usb
[    0.086898] initcall usb_init+0x0/0x170 returned 0 after 0 usecs
[    0.086906] calling  serio_init+0x0/0x38 @ 1
[    0.086974] initcall serio_init+0x0/0x38 returned 0 after 0 usecs
[    0.086982] calling  input_init+0x0/0x103 @ 1
[    0.087087] initcall input_init+0x0/0x103 returned 0 after 0 usecs
[    0.087095] calling  rtc_init+0x0/0x71 @ 1
[    0.087158] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.087166] calling  pps_init+0x0/0xb7 @ 1
[    0.087227] pps_core: LinuxPPS API ver. 1 registered
[    0.088018] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.088030] initcall pps_init+0x0/0xb7 returned 0 after 976 usecs
[    0.088038] calling  ptp_init+0x0/0xa4 @ 1
[    0.088113] PTP clock support registered
[    0.088122] initcall ptp_init+0x0/0xa4 returned 0 after 0 usecs
[    0.088130] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.088195] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.088204] calling  hwmon_init+0x0/0xf6 @ 1
[    0.088268] initcall hwmon_init+0x0/0xf6 returned 0 after 0 usecs
[    0.088277] calling  leds_init+0x0/0x48 @ 1
[    0.088340] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.088349] calling  iommu_init+0x0/0x58 @ 1
[    0.088359] initcall iommu_init+0x0/0x58 returned 0 after 0 usecs
[    0.088367] calling  pci_subsys_init+0x0/0x4f @ 1
[    0.088374] PCI: System does not support PCI
[    0.088381] PCI: System does not support PCI
[    0.088388] initcall pci_subsys_init+0x0/0x4f returned 0 after 0 usecs
[    0.088396] calling  proto_init+0x0/0x12 @ 1
[    0.088407] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.088415] calling  net_dev_init+0x0/0x1c7 @ 1
[    0.088739] initcall net_dev_init+0x0/0x1c7 returned 0 after 0 usecs
[    0.088748] calling  neigh_init+0x0/0x80 @ 1
[    0.088757] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.088765] calling  fib_rules_init+0x0/0xaf @ 1
[    0.088773] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    0.088781] calling  pktsched_init+0x0/0xfe @ 1
[    0.088792] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
[    0.088800] calling  tc_filter_init+0x0/0x55 @ 1
[    0.088807] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    0.088816] calling  tc_action_init+0x0/0x55 @ 1
[    0.088823] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    0.088831] calling  genl_init+0x0/0x75 @ 1
[    0.088845] initcall genl_init+0x0/0x75 returned 0 after 0 usecs
[    0.088853] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.088862] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.088870] calling  netlbl_init+0x0/0x81 @ 1
[    0.088876] NetLabel: Initializing
[    0.088882] NetLabel:  domain hash size = 128
[    0.088888] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.088910] NetLabel:  unlabeled traffic allowed by default
[    0.088919] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.088926] calling  rfkill_init+0x0/0x79 @ 1
[    0.089030] initcall rfkill_init+0x0/0x79 returned 0 after 976 usecs
[    0.089054] calling  xen_p2m_debugfs+0x0/0x4a @ 1
[    0.089087] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 0 usecs
[    0.089095] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
[    0.089219] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 0 usecs
[    0.089228] calling  hpet_late_init+0x0/0x101 @ 1
[    0.089235] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
[    0.089243] calling  init_amd_nbs+0x0/0xb8 @ 1
[    0.089251] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
[    0.089260] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.089267] Switching to clocksource xen
[    0.089294] initcall clocksource_done_booting+0x0/0x5a returned 0 after 11 usecs
[    0.089303] calling  tracer_init_debugfs+0x0/0x3a4 @ 1
[    0.089711] initcall tracer_init_debugfs+0x0/0x3a4 returned 0 after 391 usecs
[    0.089720] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.089734] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 6 usecs
[    0.089743] calling  event_trace_init+0x0/0x271 @ 1
[    0.099475] initcall event_trace_init+0x0/0x271 returned 0 after 9769 usecs
[    0.099485] calling  init_kprobe_trace+0x0/0x93 @ 1
[    0.099505] initcall init_kprobe_trace+0x0/0x93 returned 0 after 12 usecs
[    0.099513] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.099543] initcall init_pipe_fs+0x0/0x4c returned 0 after 22 usecs
[    0.099552] calling  eventpoll_init+0x0/0xda @ 1
[    0.099566] initcall eventpoll_init+0x0/0xda returned 0 after 6 usecs
[    0.099574] calling  anon_inode_init+0x0/0x5b @ 1
[    0.099604] initcall anon_inode_init+0x0/0x5b returned 0 after 21 usecs
[    0.099612] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.099620] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.287868] calling  acpi_event_init+0x0/0x81 @ 1
[    0.287878] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
[    0.287887] calling  pnp_system_init+0x0/0x12 @ 1
[    0.288027] initcall pnp_system_init+0x0/0x12 returned 0 after 127 usecs
[    0.288036] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.288044] pnp: PnP ACPI: disabled
[    0.288052] initcall pnpacpi_init+0x0/0x8c returned 0 after 6 usecs
[    0.288100] calling  pcistub_init+0x0/0x29f @ 1
[    0.288197] initcall pcistub_init+0x0/0x29f returned 0 after 86 usecs
[    0.288207] calling  chr_dev_init+0x0/0xc6 @ 1
[    0.293859] initcall chr_dev_init+0x0/0xc6 returned 0 after 5511 usecs
[    0.293869] calling  firmware_class_init+0x0/0xda @ 1
[    0.293941] initcall firmware_class_init+0x0/0xda returned 0 after 60 usecs
[    0.293951] calling  init_pcmcia_bus+0x0/0x6c @ 1
[    0.294023] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 62 usecs
[    0.294032] calling  thermal_init+0x0/0x75 @ 1
[    0.294193] initcall thermal_init+0x0/0x75 returned 0 after 149 usecs
[    0.294203] calling  thermal_gov_step_wise_init+0x0/0x12 @ 1
[    0.294212] initcall thermal_gov_step_wise_init+0x0/0x12 returned 0 after 0 usecs
[    0.294221] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.294229] initcall cpufreq_gov_performance_init+0x0/0x12 returned -19 after 0 usecs
[    0.294239] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    0.294247] initcall init_acpi_pm_clocksource+0x0/0xec returned -19 after 0 usecs
[    0.294256] calling  pcibios_assign_resources+0x0/0xf8 @ 1
[    0.294267] initcall pcibios_assign_resources+0x0/0xf8 returned 0 after 2 usecs
[    0.294276] calling  sysctl_core_init+0x0/0x2c @ 1
[    0.294295] initcall sysctl_core_init+0x0/0x2c returned 0 after 11 usecs
[    0.294303] calling  inet_init+0x0/0x2a1 @ 1
[    0.294332] NET: Registered protocol family 2
[    0.294575] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.294649] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.294697] TCP: Hash tables configured (established 16384 bind 16384)
[    0.294733] TCP: reno registered
[    0.294747] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.294767] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.294857] initcall inet_init+0x0/0x2a1 returned 0 after 533 usecs
[    0.294866] calling  ipv4_offload_init+0x0/0x68 @ 1
[    0.294875] initcall ipv4_offload_init+0x0/0x68 returned 0 after 0 usecs
[    0.294883] calling  af_unix_init+0x0/0x55 @ 1
[    0.294891] NET: Registered protocol family 1
[    0.294907] initcall af_unix_init+0x0/0x55 returned 0 after 16 usecs
[    0.294916] calling  ipv6_offload_init+0x0/0x6e @ 1
[    0.294925] initcall ipv6_offload_init+0x0/0x6e returned 0 after 1 usecs
[    0.294933] calling  init_sunrpc+0x0/0x69 @ 1
[    0.295092] RPC: Registered named UNIX socket transport module.
[    0.295101] RPC: Registered udp transport module.
[    0.295108] RPC: Registered tcp transport module.
[    0.295114] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.295123] initcall init_sunrpc+0x0/0x69 returned 0 after 177 usecs
[    0.295131] calling  pci_apply_final_quirks+0x0/0x117 @ 1
[    0.295139] PCI: CLS 0 bytes, default 64
[    0.295146] initcall pci_apply_final_quirks+0x0/0x117 returned 0 after 6 usecs
[    0.295155] calling  populate_rootfs+0x0/0x10d @ 1
[    0.295384] Unpacking initramfs...
[    0.854446] Freeing initrd memory: 339316k freed
[    0.941088] initcall populate_rootfs+0x0/0x10d returned 0 after 630779 usecs
[    0.941109] calling  pci_iommu_init+0x0/0x41 @ 1
[    0.941118] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    0.941126] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    0.941135] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    0.941164] calling  irqfd_module_init+0x0/0x33 @ 1
[    0.941260] initcall irqfd_module_init+0x0/0x33 returned 0 after 85 usecs
[    0.941270] calling  i8259A_init_ops+0x0/0x21 @ 1
[    0.941278] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    0.941286] calling  vsyscall_init+0x0/0x27 @ 1
[    0.941303] initcall vsyscall_init+0x0/0x27 returned 0 after 6 usecs
[    0.941312] calling  sbf_init+0x0/0xf6 @ 1
[    0.941320] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    0.941330] calling  init_tsc_clocksource+0x0/0x89 @ 1
[    0.941343] initcall init_tsc_clocksource+0x0/0x89 returned 0 after 3 usecs
[    0.941353] calling  add_rtc_cmos+0x0/0x96 @ 1
[    0.941554] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.941575] initcall add_rtc_cmos+0x0/0x96 returned 0 after 204 usecs
[    0.941587] calling  i8237A_init_ops+0x0/0x14 @ 1
[    0.941597] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.941610] calling  cache_sysfs_init+0x0/0x6c @ 1
[    0.941692] initcall cache_sysfs_init+0x0/0x6c returned 0 after 70 usecs
[    0.941703] calling  intel_uncore_init+0x0/0x3fa @ 1
[    0.941712] initcall intel_uncore_init+0x0/0x3fa returned -19 after 0 usecs
[    0.941721] calling  inject_init+0x0/0x30 @ 1
[    0.941728] Machine check injector initialized
[    0.941737] initcall inject_init+0x0/0x30 returned 0 after 7 usecs
[    0.941745] calling  thermal_throttle_init_device+0x0/0x9d @ 1
[    0.941754] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 0 usecs
[    0.941763] calling  amd_ibs_init+0x0/0x48d @ 1
[    0.941772] initcall amd_ibs_init+0x0/0x48d returned -19 after 0 usecs
[    0.941781] calling  msr_init+0x0/0x162 @ 1
[    0.941942] initcall msr_init+0x0/0x162 returned 0 after 149 usecs
[    0.941952] calling  cpuid_init+0x0/0x162 @ 1
[    0.942124] initcall cpuid_init+0x0/0x162 returned 0 after 159 usecs
[    0.942133] calling  ioapic_init_ops+0x0/0x14 @ 1
[    0.942141] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.942149] calling  add_pcspkr+0x0/0x40 @ 1
[    0.942229] initcall add_pcspkr+0x0/0x40 returned 0 after 70 usecs
[    0.942238] calling  microcode_init+0x0/0x1b1 @ 1
[    0.942318] microcode: CPU0: patch_level=0x06000626
[    0.942401] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.942412] initcall microcode_init+0x0/0x1b1 returned 0 after 162 usecs
[    0.942422] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    0.942430] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    0.942439] calling  audit_classes_init+0x0/0xaf @ 1
[    0.942452] initcall audit_classes_init+0x0/0xaf returned 0 after 5 usecs
[    0.942460] calling  pt_dump_init+0x0/0x30 @ 1
[    0.942485] initcall pt_dump_init+0x0/0x30 returned 0 after 16 usecs
[    0.942494] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.942507] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 5 usecs
[    0.942515] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.942529] initcall proc_execdomains_init+0x0/0x22 returned 0 after 5 usecs
[    0.942538] calling  ioresources_init+0x0/0x3c @ 1
[    0.942552] initcall ioresources_init+0x0/0x3c returned 0 after 6 usecs
[    0.942561] calling  uid_cache_init+0x0/0xa5 @ 1
[    0.942574] initcall uid_cache_init+0x0/0xa5 returned 0 after 5 usecs
[    0.942582] calling  init_posix_timers+0x0/0x1f4 @ 1
[    0.942598] initcall init_posix_timers+0x0/0x1f4 returned 0 after 7 usecs
[    0.942606] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    0.942614] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    0.942623] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.942634] initcall proc_schedstat_init+0x0/0x22 returned 0 after 3 usecs
[    0.942642] calling  snapshot_device_init+0x0/0x12 @ 1
[    0.942724] initcall snapshot_device_init+0x0/0x12 returned 0 after 72 usecs
[    0.942733] calling  create_proc_profile+0x0/0x2c0 @ 1
[    0.942741] initcall create_proc_profile+0x0/0x2c0 returned 0 after 0 usecs
[    0.942749] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    0.942757] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.942765] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    0.942913] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 136 usecs
[    0.942923] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.942934] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 3 usecs
[    0.942943] calling  alarmtimer_init+0x0/0x15d @ 1
[    0.943122] initcall alarmtimer_init+0x0/0x15d returned 0 after 166 usecs
[    0.943131] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.943143] initcall init_tstats_procfs+0x0/0x2c returned 0 after 4 usecs
[    0.943150] calling  futex_init+0x0/0x65 @ 1
[    0.943163] initcall futex_init+0x0/0x65 returned 0 after 5 usecs
[    0.943170] calling  proc_dma_init+0x0/0x22 @ 1
[    0.943181] initcall proc_dma_init+0x0/0x22 returned 0 after 3 usecs
[    0.943188] calling  proc_modules_init+0x0/0x22 @ 1
[    0.943199] initcall proc_modules_init+0x0/0x22 returned 0 after 3 usecs
[    0.943207] calling  kallsyms_init+0x0/0x25 @ 1
[    0.943217] initcall kallsyms_init+0x0/0x25 returned 0 after 2 usecs
[    0.943224] calling  crash_save_vmcoreinfo_init+0x0/0x4a9 @ 1
[    1.054869] initcall crash_save_vmcoreinfo_init+0x0/0x4a9 returned 0 after 14 usecs
[    1.054879] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    1.054891] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 3 usecs
[    1.054900] calling  pid_namespaces_init+0x0/0x2d @ 1
[    1.054910] initcall pid_namespaces_init+0x0/0x2d returned 0 after 2 usecs
[    1.054918] calling  ikconfig_init+0x0/0x3a @ 1
[    1.054929] initcall ikconfig_init+0x0/0x3a returned 0 after 3 usecs
[    1.054936] calling  audit_init+0x0/0x141 @ 1
[    1.054943] audit: initializing netlink socket (disabled)
[    1.054961] type=2000 audit(1361569587.289:1): initialized
[    1.054971] initcall audit_init+0x0/0x141 returned 0 after 26 usecs
[    1.054979] calling  audit_watch_init+0x0/0x3a @ 1
[    1.054986] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    1.054994] calling  audit_tree_init+0x0/0x49 @ 1
[    1.055003] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    1.055010] calling  init_kprobes+0x0/0x16c @ 1
[    1.065934] initcall init_kprobes+0x0/0x16c returned 0 after 10660 usecs
[    1.065947] calling  hung_task_init+0x0/0x56 @ 1
[    1.065990] initcall hung_task_init+0x0/0x56 returned 0 after 33 usecs
[    1.065998] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    1.066009] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.066017] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.066031] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 6 usecs
[    1.066039] calling  init_tracepoints+0x0/0x20 @ 1
[    1.066047] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    1.066083] calling  init_blk_tracer+0x0/0x5a @ 1
[    1.066092] initcall init_blk_tracer+0x0/0x5a returned 0 after 1 usecs
[    1.066100] calling  perf_event_sysfs_init+0x0/0x9a @ 1
[    1.066383] initcall perf_event_sysfs_init+0x0/0x9a returned 0 after 268 usecs
[    1.066394] calling  init_per_zone_wmark_min+0x0/0x8c @ 1
[    1.066511] initcall init_per_zone_wmark_min+0x0/0x8c returned 0 after 105 usecs
[    1.066521] calling  kswapd_init+0x0/0x76 @ 1
[    1.066562] initcall kswapd_init+0x0/0x76 returned 0 after 32 usecs
[    1.066571] calling  extfrag_debug_init+0x0/0x7e @ 1
[    1.066600] initcall extfrag_debug_init+0x0/0x7e returned 0 after 20 usecs
[    1.066609] calling  setup_vmstat+0x0/0xc8 @ 1
[    1.066630] initcall setup_vmstat+0x0/0xc8 returned 0 after 13 usecs
[    1.066639] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.066649] initcall mm_sysfs_init+0x0/0x29 returned 0 after 2 usecs
[    1.066657] calling  slab_proc_init+0x0/0x25 @ 1
[    1.066668] initcall slab_proc_init+0x0/0x25 returned 0 after 3 usecs
[    1.066676] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.066687] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    1.066695] calling  procswaps_init+0x0/0x22 @ 1
[    1.066706] initcall procswaps_init+0x0/0x22 returned 0 after 3 usecs
[    1.066714] calling  init_frontswap+0x0/0x96 @ 1
[    1.066761] initcall init_frontswap+0x0/0x96 returned 0 after 37 usecs
[    1.066771] calling  hugetlb_init+0x0/0x415 @ 1
[    1.066781] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.066813] initcall hugetlb_init+0x0/0x415 returned 0 after 31 usecs
[    1.066822] calling  mmu_notifier_init+0x0/0x12 @ 1
[    1.066833] initcall mmu_notifier_init+0x0/0x12 returned 0 after 2 usecs
[    1.066843] calling  slab_proc_init+0x0/0x8 @ 1
[    1.066852] initcall slab_proc_init+0x0/0x8 returned 0 after 0 usecs
[    1.066861] calling  cpucache_init+0x0/0x52 @ 1
[    1.066871] initcall cpucache_init+0x0/0x52 returned 0 after 1 usecs
[    1.066881] calling  hugepage_init+0x0/0x191 @ 1
[    1.066890] initcall hugepage_init+0x0/0x191 returned -22 after 0 usecs
[    1.066900] initcall hugepage_init+0x0/0x191 returned with error code -22 
[    1.066910] calling  init_cleancache+0x0/0x96 @ 1
[    1.066956] initcall init_cleancache+0x0/0x96 returned 0 after 35 usecs
[    1.066964] calling  fcntl_init+0x0/0x2a @ 1
[    1.066974] initcall fcntl_init+0x0/0x2a returned 0 after 2 usecs
[    1.066983] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.066997] initcall proc_filesystems_init+0x0/0x22 returned 0 after 6 usecs
[    1.067005] calling  dio_init+0x0/0x2d @ 1
[    1.067017] initcall dio_init+0x0/0x2d returned 0 after 4 usecs
[    1.067025] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    1.067086] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 51 usecs
[    1.067094] calling  dnotify_init+0x0/0x7b @ 1
[    1.067112] initcall dnotify_init+0x0/0x7b returned 0 after 9 usecs
[    1.067120] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.067135] initcall inotify_user_setup+0x0/0x70 returned 0 after 6 usecs
[    1.067143] calling  aio_setup+0x0/0x7c @ 1
[    1.067160] initcall aio_setup+0x0/0x7c returned 0 after 9 usecs
[    1.067168] calling  proc_locks_init+0x0/0x22 @ 1
[    1.067179] initcall proc_locks_init+0x0/0x22 returned 0 after 3 usecs
[    1.067187] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    1.255161] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 71 usecs
[    1.255177] calling  dquot_init+0x0/0x121 @ 1
[    1.255185] VFS: Disk quotas dquot_6.5.2
[    1.255226] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.255238] initcall dquot_init+0x0/0x121 returned 0 after 50 usecs
[    1.255249] calling  init_v2_quota_format+0x0/0x22 @ 1
[    1.255259] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    1.255267] calling  quota_init+0x0/0x26 @ 1
[    1.255286] initcall quota_init+0x0/0x26 returned 0 after 8 usecs
[    1.255296] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.255312] initcall proc_cmdline_init+0x0/0x22 returned 0 after 5 usecs
[    1.255323] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.255338] initcall proc_consoles_init+0x0/0x22 returned 0 after 4 usecs
[    1.255349] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.255362] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 3 usecs
[    1.255371] calling  proc_devices_init+0x0/0x22 @ 1
[    1.255383] initcall proc_devices_init+0x0/0x22 returned 0 after 4 usecs
[    1.255393] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.255407] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    1.255418] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.255432] initcall proc_loadavg_init+0x0/0x22 returned 0 after 3 usecs
[    1.255442] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.255457] initcall proc_meminfo_init+0x0/0x22 returned 0 after 4 usecs
[    1.255467] calling  proc_stat_init+0x0/0x22 @ 1
[    1.255481] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    1.255491] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.255505] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    1.255516] calling  proc_version_init+0x0/0x22 @ 1
[    1.255530] initcall proc_version_init+0x0/0x22 returned 0 after 4 usecs
[    1.255540] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.255554] initcall proc_softirqs_init+0x0/0x22 returned 0 after 4 usecs
[    1.255565] calling  proc_kcore_init+0x0/0xb5 @ 1
[    1.255581] initcall proc_kcore_init+0x0/0xb5 returned 0 after 7 usecs
[    1.255592] calling  vmcore_init+0x0/0x370 @ 1
[    1.255602] initcall vmcore_init+0x0/0x370 returned 0 after 0 usecs
[    1.255612] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.255627] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
[    1.255637] calling  proc_page_init+0x0/0x42 @ 1
[    1.255655] initcall proc_page_init+0x0/0x42 returned 0 after 7 usecs
[    1.255665] calling  init_devpts_fs+0x0/0x62 @ 1
[    1.255717] initcall init_devpts_fs+0x0/0x62 returned 0 after 40 usecs
[    1.255728] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.255738] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255747] calling  init_hugetlbfs_fs+0x0/0x15d @ 1
[    1.255811] initcall init_hugetlbfs_fs+0x0/0x15d returned 0 after 53 usecs
[    1.255819] calling  init_fat_fs+0x0/0x4f @ 1
[    1.255837] initcall init_fat_fs+0x0/0x4f returned 0 after 9 usecs
[    1.255845] calling  init_vfat_fs+0x0/0x12 @ 1
[    1.255854] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255862] calling  init_msdos_fs+0x0/0x12 @ 1
[    1.255870] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255878] calling  init_iso9660_fs+0x0/0x70 @ 1
[    1.255905] initcall init_iso9660_fs+0x0/0x70 returned 0 after 18 usecs
[    1.255913] calling  init_nfs_fs+0x0/0x16c @ 1
[    1.256045] initcall init_nfs_fs+0x0/0x16c returned 0 after 120 usecs
[    1.256077] calling  init_nfs_v2+0x0/0x14 @ 1
[    1.256086] initcall init_nfs_v2+0x0/0x14 returned 0 after 1 usecs
[    1.256093] calling  init_nfs_v3+0x0/0x14 @ 1
[    1.256101] initcall init_nfs_v3+0x0/0x14 returned 0 after 0 usecs
[    1.256108] calling  init_nfs_v4+0x0/0x3b @ 1
[    1.256115] NFS: Registering the id_resolver key type
[    1.256134] Key type id_resolver registered
[    1.256140] Key type id_legacy registered
[    1.256151] initcall init_nfs_v4+0x0/0x3b returned 0 after 34 usecs
[    1.256159] calling  init_nlm+0x0/0x4c @ 1
[    1.256171] initcall init_nlm+0x0/0x4c returned 0 after 5 usecs
[    1.256179] calling  init_nls_cp437+0x0/0x12 @ 1
[    1.256187] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    1.256194] calling  init_nls_ascii+0x0/0x12 @ 1
[    1.256202] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    1.256209] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    1.256217] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    1.256225] calling  init_nls_utf8+0x0/0x2b @ 1
[    1.256233] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
[    1.256240] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    1.256246] NTFS driver 2.1.30 [Flags: R/W].
[    1.455160] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 194248 usecs
[    1.455177] calling  init_autofs4_fs+0x0/0x2a @ 1
[    1.455306] initcall init_autofs4_fs+0x0/0x2a returned 0 after 117 usecs
[    1.455315] calling  init_pstore_fs+0x0/0x12 @ 1
[    1.455324] initcall init_pstore_fs+0x0/0x12 returned 0 after 0 usecs
[    1.455331] calling  ipc_init+0x0/0x2f @ 1
[    1.455345] msgmni has been set to 2923
[    1.455359] initcall ipc_init+0x0/0x2f returned 0 after 19 usecs
[    1.455367] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.455381] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 6 usecs
[    1.455389] calling  init_mqueue_fs+0x0/0xa2 @ 1
[    1.455434] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 36 usecs
[    1.455442] calling  key_proc_init+0x0/0x5e @ 1
[    1.455456] initcall key_proc_init+0x0/0x5e returned 0 after 6 usecs
[    1.455464] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    1.455471] SELinux:  Registering netfilter hooks
[    1.455652] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 175 usecs
[    1.455661] calling  init_sel_fs+0x0/0xa5 @ 1
[    1.455945] initcall init_sel_fs+0x0/0xa5 returned 0 after 269 usecs
[    1.455954] calling  selnl_init+0x0/0x56 @ 1
[    1.455967] initcall selnl_init+0x0/0x56 returned 0 after 5 usecs
[    1.455975] calling  sel_netif_init+0x0/0x5c @ 1
[    1.455984] initcall sel_netif_init+0x0/0x5c returned 0 after 2 usecs
[    1.455992] calling  sel_netnode_init+0x0/0x6a @ 1
[    1.456001] initcall sel_netnode_init+0x0/0x6a returned 0 after 1 usecs
[    1.456008] calling  sel_netport_init+0x0/0x6a @ 1
[    1.456017] initcall sel_netport_init+0x0/0x6a returned 0 after 1 usecs
[    1.456025] calling  aurule_init+0x0/0x2d @ 1
[    1.456033] initcall aurule_init+0x0/0x2d returned 0 after 0 usecs
[    1.456040] calling  crypto_wq_init+0x0/0x33 @ 1
[    1.456101] initcall crypto_wq_init+0x0/0x33 returned 0 after 51 usecs
[    1.456110] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.456121] initcall crypto_algapi_init+0x0/0xd returned 0 after 3 usecs
[    1.456129] calling  skcipher_module_init+0x0/0x35 @ 1
[    1.456137] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
[    1.456145] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.456153] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456161] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.456169] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456176] calling  hmac_module_init+0x0/0x12 @ 1
[    1.456184] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456192] calling  md5_mod_init+0x0/0x12 @ 1
[    1.456254] initcall md5_mod_init+0x0/0x12 returned 0 after 53 usecs
[    1.456263] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    1.456315] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456324] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.456332] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456340] calling  des_generic_mod_init+0x0/0x17 @ 1
[    1.456434] initcall des_generic_mod_init+0x0/0x17 returned 0 after 84 usecs
[    1.456442] calling  aes_init+0x0/0x12 @ 1
[    1.456493] initcall aes_init+0x0/0x12 returned 0 after 42 usecs
[    1.456501] calling  zlib_mod_init+0x0/0x12 @ 1
[    1.456551] initcall zlib_mod_init+0x0/0x12 returned 0 after 41 usecs
[    1.456559] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    1.456567] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456575] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    1.456584] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456592] calling  lzo_mod_init+0x0/0x12 @ 1
[    1.456643] initcall lzo_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456651] calling  krng_mod_init+0x0/0x12 @ 1
[    1.456702] initcall krng_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456710] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.456724] initcall proc_genhd_init+0x0/0x3c returned 0 after 6 usecs
[    1.456732] calling  bsg_init+0x0/0x12e @ 1
[    1.456803] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.456812] initcall bsg_init+0x0/0x12e returned 0 after 71 usecs
[    1.456820] calling  noop_init+0x0/0x12 @ 1
[    1.456827] io scheduler noop registered
[    1.456834] initcall noop_init+0x0/0x12 returned 0 after 7 usecs
[    1.456842] calling  deadline_init+0x0/0x12 @ 1
[    1.456849] io scheduler deadline registered
[    1.456856] initcall deadline_init+0x0/0x12 returned 0 after 6 usecs
[    1.456864] calling  cfq_init+0x0/0x8b @ 1
[    1.456878] io scheduler cfq registered (default)
[    1.456885] initcall cfq_init+0x0/0x8b returned 0 after 14 usecs
[    1.456893] calling  percpu_counter_startup+0x0/0x38 @ 1
[    1.456902] initcall percpu_counter_startup+0x0/0x38 returned 0 after 1 usecs
[    1.456910] calling  pci_proc_init+0x0/0x6a @ 1
[    1.654703] initcall pci_proc_init+0x0/0x6a returned 0 after 8 usecs
[    1.654716] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    1.654876] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 148 usecs
[    1.654885] calling  aer_service_init+0x0/0x2b @ 1
[    1.654958] initcall aer_service_init+0x0/0x2b returned 0 after 63 usecs
[    1.654967] calling  pci_hotplug_init+0x0/0x1d @ 1
[    1.654974] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.654982] initcall pci_hotplug_init+0x0/0x1d returned 0 after 6 usecs
[    1.654990] calling  pcifront_init+0x0/0x3f @ 1
[    1.655085] initcall pcifront_init+0x0/0x3f returned 0 after 85 usecs
[    1.655094] calling  genericbl_driver_init+0x0/0x12 @ 1
[    1.655169] initcall genericbl_driver_init+0x0/0x12 returned 0 after 65 usecs
[    1.655178] calling  cirrusfb_init+0x0/0xcc @ 1
[    1.655265] initcall cirrusfb_init+0x0/0xcc returned 0 after 75 usecs
[    1.655277] calling  efifb_init+0x0/0x298 @ 1
[    1.655287] initcall efifb_init+0x0/0x298 returned -19 after 1 usecs
[    1.655297] calling  intel_idle_init+0x0/0x326 @ 1
[    1.655305] initcall intel_idle_init+0x0/0x326 returned -19 after 0 usecs
[    1.655313] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    1.655322] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 usecs
[    1.655330] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    1.655338] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 0 usecs
[    1.655347] calling  acpi_ac_init+0x0/0x28 @ 1
[    1.655357] initcall acpi_ac_init+0x0/0x28 returned -19 after 0 usecs
[    1.655369] calling  acpi_button_driver_init+0x0/0x12 @ 1
[    1.655379] initcall acpi_button_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655390] calling  acpi_fan_driver_init+0x0/0x12 @ 1
[    1.655399] initcall acpi_fan_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655409] calling  acpi_processor_init+0x0/0x6d @ 1
[    1.655419] initcall acpi_processor_init+0x0/0x6d returned 0 after 0 usecs
[    1.655429] calling  acpi_container_init+0x0/0x4a @ 1
[    1.655439] initcall acpi_container_init+0x0/0x4a returned -19 after 0 usecs
[    1.655450] calling  acpi_thermal_init+0x0/0x42 @ 1
[    1.655458] initcall acpi_thermal_init+0x0/0x42 returned -19 after 0 usecs
[    1.655466] calling  acpi_battery_init+0x0/0x16 @ 1
[    1.655478] initcall acpi_battery_init+0x0/0x16 returned 0 after 3 usecs
[    1.655486] calling  acpi_hed_driver_init+0x0/0x12 @ 1
[    1.655494] initcall acpi_hed_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655502] calling  erst_init+0x0/0x2bb @ 1
[    1.655510] initcall erst_init+0x0/0x2bb returned 0 after 0 usecs
[    1.655518] calling  ghes_init+0x0/0x171 @ 1
[    1.655527] initcall ghes_init+0x0/0x171 returned -19 after 0 usecs
[    1.655535] calling  einj_init+0x0/0x49d @ 1
[    1.655543] initcall einj_init+0x0/0x49d returned -19 after 0 usecs
[    1.655551] calling  ioat_init_module+0x0/0x80 @ 1
[    1.655559] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.655595] calling  1_acpi_battery_init_async+0x0/0x1b @ 6
[    1.655603] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 0 usecs
[    1.655672] initcall ioat_init_module+0x0/0x80 returned 0 after 109 usecs
[    1.655683] calling  virtio_mmio_init+0x0/0x12 @ 1
[    1.655766] initcall virtio_mmio_init+0x0/0x12 returned 0 after 72 usecs
[    1.655777] calling  init+0x0/0x12 @ 1
[    1.655855] initcall init+0x0/0x12 returned 0 after 67 usecs
[    1.655864] calling  xenbus_probe_initcall+0x0/0x39 @ 1
[    1.655873] initcall xenbus_probe_initcall+0x0/0x39 returned 0 after 0 usecs
[    1.655882] calling  xenbus_init+0x0/0x3d @ 1
[    1.655975] initcall xenbus_init+0x0/0x3d returned 0 after 81 usecs
[    1.655985] calling  xenbus_backend_init+0x0/0x51 @ 1
[    1.655993] initcall xenbus_backend_init+0x0/0x51 returned -19 after 0 usecs
[    1.656002] calling  gntdev_init+0x0/0x4d @ 1
[    1.656125] initcall gntdev_init+0x0/0x4d returned 0 after 111 usecs
[    1.656134] calling  gntalloc_init+0x0/0x3d @ 1
[    1.656209] initcall gntalloc_init+0x0/0x3d returned 0 after 66 usecs
[    1.656217] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    1.656225] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    1.656233] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    1.656254] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 13 usecs
[    1.656262] calling  platform_pci_module_init+0x0/0x1b @ 1
[    1.656336] initcall platform_pci_module_init+0x0/0x1b returned 0 after 64 usecs
[    1.656344] calling  xen_tmem_init+0x0/0x9a @ 1
[    1.656352] initcall xen_tmem_init+0x0/0x9a returned 0 after 0 usecs
[    1.656360] calling  xen_late_init_mcelog+0x0/0x3d @ 1
[    1.656367] initcall xen_late_init_mcelog+0x0/0x3d returned -19 after 0 usecs
[    1.656375] calling  xen_pcibk_init+0x0/0x13f @ 1
[    1.656383] initcall xen_pcibk_init+0x0/0x13f returned -19 after 0 usecs
[    1.854937] calling  xen_acpi_processor_init+0x0/0x41f @ 1
[    1.854949] initcall xen_acpi_processor_init+0x0/0x41f returned -19 after 0 usecs
[    1.854957] calling  pty_init+0x0/0x453 @ 1
[    1.890528] initcall pty_init+0x0/0x453 returned 0 after 34728 usecs
[    1.890543] calling  sysrq_init+0x0/0x78 @ 1
[    1.890557] initcall sysrq_init+0x0/0x78 returned 0 after 5 usecs
[    1.890564] calling  xen_hvc_init+0x0/0x249 @ 1
[    1.891318] initcall xen_hvc_init+0x0/0x249 returned 0 after 728 usecs
[    1.891328] calling  serial8250_init+0x0/0x17d @ 1
[    1.891335] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.891949] initcall serial8250_init+0x0/0x17d returned 0 after 598 usecs
[    1.891959] calling  serial_pci_driver_init+0x0/0x1b @ 1
[    1.892030] initcall serial_pci_driver_init+0x0/0x1b returned 0 after 62 usecs
[    1.892040] calling  init_kgdboc+0x0/0x16 @ 1
[    1.892048] initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
[    1.892103] calling  rand_initialize+0x0/0x30 @ 1
[    1.892125] initcall rand_initialize+0x0/0x30 returned 0 after 10 usecs
[    1.892135] calling  init+0x0/0x111 @ 1
[    1.892349] initcall init+0x0/0x111 returned 0 after 201 usecs
[    1.892358] calling  hpet_init+0x0/0x6a @ 1
[    1.892517] initcall hpet_init+0x0/0x6a returned -19 after 147 usecs
[    1.892526] calling  nvram_init+0x0/0x82 @ 1
[    1.892602] Non-volatile memory driver v1.3
[    1.892610] initcall nvram_init+0x0/0x82 returned 0 after 74 usecs
[    1.892618] calling  mod_init+0x0/0x5a @ 1
[    1.892625] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    1.892633] calling  rng_init+0x0/0x12 @ 1
[    1.892709] initcall rng_init+0x0/0x12 returned 0 after 66 usecs
[    1.892718] calling  agp_init+0x0/0x26 @ 1
[    1.892725] Linux agpgart interface v0.103
[    1.892732] initcall agp_init+0x0/0x26 returned 0 after 6 usecs
[    1.892739] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    1.892876] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 125 usecs
[    1.892885] calling  agp_intel_init+0x0/0x29 @ 1
[    1.892955] initcall agp_intel_init+0x0/0x29 returned 0 after 60 usecs
[    1.892964] calling  agp_sis_init+0x0/0x29 @ 1
[    1.893035] initcall agp_sis_init+0x0/0x29 returned 0 after 61 usecs
[    1.893043] calling  agp_via_init+0x0/0x29 @ 1
[    1.893136] initcall agp_via_init+0x0/0x29 returned 0 after 83 usecs
[    1.893144] calling  drm_core_init+0x0/0x139 @ 1
[    1.893223] [drm] Initialized drm 1.1.0 20060810
[    1.893231] initcall drm_core_init+0x0/0x139 returned 0 after 77 usecs
[    1.893239] calling  cn_proc_init+0x0/0x3d @ 1
[    1.893247] initcall cn_proc_init+0x0/0x3d returned 0 after 1 usecs
[    1.893256] calling  topology_sysfs_init+0x0/0x58 @ 1
[    1.893274] initcall topology_sysfs_init+0x0/0x58 returned 0 after 9 usecs
[    1.893282] calling  loop_init+0x0/0x137 @ 1
[    1.895048] loop: module loaded
[    1.895089] initcall loop_init+0x0/0x137 returned 0 after 1757 usecs
[    1.895098] calling  xen_blkif_init+0x0/0x25f @ 1
[    1.895308] initcall xen_blkif_init+0x0/0x25f returned 0 after 197 usecs
[    1.895316] calling  mac_hid_init+0x0/0x22 @ 1
[    1.895328] initcall mac_hid_init+0x0/0x22 returned 0 after 4 usecs
[    1.895336] calling  macvlan_init_module+0x0/0x3d @ 1
[    1.895345] initcall macvlan_init_module+0x0/0x3d returned 0 after 1 usecs
[    1.895353] calling  macvtap_init+0x0/0x100 @ 1
[    1.895419] initcall macvtap_init+0x0/0x100 returned 0 after 56 usecs
[    1.895427] calling  net_olddevs_init+0x0/0x86 @ 1
[    1.895436] initcall net_olddevs_init+0x0/0x86 returned 0 after 1 usecs
[    1.895444] calling  fixed_mdio_bus_init+0x0/0x105 @ 1
[    1.895589] libphy: Fixed MDIO Bus: probed
[    1.895597] initcall fixed_mdio_bus_init+0x0/0x105 returned 0 after 141 usecs
[    1.895605] calling  tun_init+0x0/0x93 @ 1
[    1.895612] tun: Universal TUN/TAP device driver, 1.6
[    1.895618] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.895698] initcall tun_init+0x0/0x93 returned 0 after 83 usecs
[    1.895706] calling  tg3_init+0x0/0x1b @ 1
[    1.895780] initcall tg3_init+0x0/0x1b returned 0 after 65 usecs
[    1.895788] calling  ixgbevf_init_module+0x0/0x4c @ 1
[    2.055322] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
[    2.055332] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    2.055427] initcall ixgbevf_init_module+0x0/0x4c returned 0 after 101 usecs
[    2.055436] calling  init_nic+0x0/0x1b @ 1
[    2.055512] initcall init_nic+0x0/0x1b returned 0 after 66 usecs
[    2.055521] calling  netback_init+0x0/0x212 @ 1
[    2.055638] initcall netback_init+0x0/0x212 returned 0 after 106 usecs
[    2.055647] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    2.055656] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 1 usecs
[    2.055664] calling  yenta_socket_init+0x0/0x1b @ 1
[    2.055744] initcall yenta_socket_init+0x0/0x1b returned 0 after 70 usecs
[    2.055754] calling  mon_init+0x0/0xfe @ 1
[    2.055909] initcall mon_init+0x0/0xfe returned 0 after 144 usecs
[    2.055918] calling  ehci_hcd_init+0x0/0xb7 @ 1
[    2.055925] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.055933] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    2.055951] initcall ehci_hcd_init+0x0/0xb7 returned 0 after 24 usecs
[    2.055959] calling  ehci_pci_init+0x0/0x69 @ 1
[    2.055966] ehci-pci: EHCI PCI platform driver
[    2.056038] initcall ehci_pci_init+0x0/0x69 returned 0 after 68 usecs
[    2.056047] calling  ohci_hcd_mod_init+0x0/0xbf @ 1
[    2.056086] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.056094] ohci_hcd: block sizes: ed 80 td 96
[    2.056181] initcall ohci_hcd_mod_init+0x0/0xbf returned 0 after 92 usecs
[    2.056190] calling  uhci_hcd_init+0x0/0x129 @ 1
[    2.056197] uhci_hcd: USB Universal Host Controller Interface driver
[    2.056290] initcall uhci_hcd_init+0x0/0x129 returned 0 after 89 usecs
[    2.056299] calling  usblp_driver_init+0x0/0x1b @ 1
[    2.056375] usbcore: registered new interface driver usblp
[    2.056384] initcall usblp_driver_init+0x0/0x1b returned 0 after 75 usecs
[    2.056393] calling  kgdbdbgp_start_thread+0x0/0x4f @ 1
[    2.056401] initcall kgdbdbgp_start_thread+0x0/0x4f returned 0 after 0 usecs
[    2.056409] calling  i8042_init+0x0/0x3c5 @ 1
[    2.056657] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.068374] i8042: No controller found
[    3.068394] initcall i8042_init+0x0/0x3c5 returned -19 after 988256 usecs
[    3.068403] calling  serport_init+0x0/0x34 @ 1
[    3.068412] initcall serport_init+0x0/0x34 returned 0 after 1 usecs
[    3.068420] calling  mousedev_init+0x0/0x62 @ 1
[    3.068590] mousedev: PS/2 mouse device common for all mice
[    3.068600] initcall mousedev_init+0x0/0x62 returned 0 after 167 usecs
[    3.068608] calling  evdev_init+0x0/0x12 @ 1
[    3.068617] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    3.068625] calling  atkbd_init+0x0/0x27 @ 1
[    3.068713] initcall atkbd_init+0x0/0x27 returned 0 after 78 usecs
[    3.068724] calling  psmouse_init+0x0/0x7b @ 1
[    3.068871] initcall psmouse_init+0x0/0x7b returned 0 after 132 usecs
[    3.068888] calling  cmos_init+0x0/0x6a @ 1
[    3.129156] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    3.129267] rtc_cmos: probe of rtc_cmos failed with error -38
[    3.129462] initcall cmos_init+0x0/0x6a returned -19 after 59144 usecs
[    3.129471] calling  i2c_i801_init+0x0/0xad @ 1
[    3.129552] initcall i2c_i801_init+0x0/0xad returned 0 after 70 usecs
[    3.129562] calling  cpufreq_gov_dbs_init+0x0/0x95 @ 1
[    3.129571] initcall cpufreq_gov_dbs_init+0x0/0x95 returned -19 after 1 usecs
[    3.129580] calling  init_ladder+0x0/0x12 @ 1
[    3.129588] initcall init_ladder+0x0/0x12 returned -19 after 0 usecs
[    3.129596] calling  init_menu+0x0/0x12 @ 1
[    3.129603] initcall init_menu+0x0/0x12 returned -19 after 0 usecs
[    3.129612] calling  efivars_init+0x0/0x105 @ 1
[    3.129619] EFI Variables Facility v0.08 2004-May-17
[    3.129626] initcall efivars_init+0x0/0x105 returned 0 after 6 usecs
[    3.129635] calling  vhost_net_init+0x0/0x30 @ 1
[    3.129714] initcall vhost_net_init+0x0/0x30 returned 0 after 68 usecs
[    3.129723] calling  staging_init+0x0/0x8 @ 1
[    3.129731] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    3.129739] calling  zram_init+0x0/0x2e4 @ 1
[    3.129746] zram: num_devices not specified. Using default: 1
[    3.129753] zram: Creating 1 devices ...
[    3.130028] initcall zram_init+0x0/0x2e4 returned 0 after 273 usecs
[    3.130038] calling  zcache_init+0x0/0x297 @ 1
[    3.130115] initcall zcache_init+0x0/0x297 returned 0 after 67 usecs
[    3.130127] calling  zs_init+0x0/0x90 @ 1
[    3.130139] initcall zs_init+0x0/0x90 returned 0 after 3 usecs
[    3.130149] calling  eeepc_laptop_init+0x0/0x58 @ 1
[    3.130320] initcall eeepc_laptop_init+0x0/0x58 returned -19 after 157 usecs
[    3.130331] calling  sock_diag_init+0x0/0x12 @ 1
[    3.130347] initcall sock_diag_init+0x0/0x12 returned 0 after 8 usecs
[    3.130355] calling  flow_cache_init_global+0x0/0x19f @ 1
[    3.130373] initcall flow_cache_init_global+0x0/0x19f returned 0 after 10 usecs
[    3.130382] calling  llc_init+0x0/0x20 @ 1
[    3.130390] initcall llc_init+0x0/0x20 returned 0 after 1 usecs
[    3.130397] calling  snap_init+0x0/0x38 @ 1
[    3.130408] initcall snap_init+0x0/0x38 returned 0 after 1 usecs
[    3.130417] calling  blackhole_module_init+0x0/0x12 @ 1
[    3.130427] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    3.130436] calling  nfnetlink_init+0x0/0x27 @ 1
[    3.130444] Netfilter messages via NETLINK v0.30.
[    3.130464] initcall nfnetlink_init+0x0/0x27 returned 0 after 18 usecs
[    3.130474] calling  nfnetlink_log_init+0x0/0xdb @ 1
[    3.130491] initcall nfnetlink_log_init+0x0/0xdb returned 0 after 9 usecs
[    3.130499] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    3.130507] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.130600] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 90 usecs
[    3.130609] calling  ctnetlink_init+0x0/0xa4 @ 1
[    3.130616] ctnetlink v0.93: registering with nfnetlink.
[    3.130623] initcall ctnetlink_init+0x0/0xa4 returned 0 after 6 usecs
[    3.130631] calling  nf_conntrack_ftp_init+0x0/0x1ca @ 1
[    3.130639] initcall nf_conntrack_ftp_init+0x0/0x1ca returned 0 after 0 usecs
[    3.130647] calling  nf_conntrack_irc_init+0x0/0x173 @ 1
[    3.130658] initcall nf_conntrack_irc_init+0x0/0x173 returned 0 after 3 usecs
[    3.130666] calling  nf_conntrack_sip_init+0x0/0x215 @ 1
[    3.130675] initcall nf_conntrack_sip_init+0x0/0x215 returned 0 after 0 usecs
[    3.130683] calling  xt_init+0x0/0x118 @ 1
[    3.130693] initcall xt_init+0x0/0x118 returned 0 after 1 usecs
[    3.130701] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    3.130709] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    3.130717] calling  connsecmark_tg_init+0x0/0x12 @ 1
[    3.268638] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268647] calling  nflog_tg_init+0x0/0x12 @ 1
[    3.268656] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268664] calling  secmark_tg_init+0x0/0x12 @ 1
[    3.268671] initcall secmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268679] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    3.268687] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[    3.268696] calling  conntrack_mt_init+0x0/0x17 @ 1
[    3.268707] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
[    3.268715] calling  policy_mt_init+0x0/0x17 @ 1
[    3.268723] initcall policy_mt_init+0x0/0x17 returned 0 after 0 usecs
[    3.268730] calling  state_mt_init+0x0/0x12 @ 1
[    3.268738] initcall state_mt_init+0x0/0x12 returned 0 after 0 usecs
[    3.268746] calling  sysctl_ipv4_init+0x0/0x92 @ 1
[    3.268793] initcall sysctl_ipv4_init+0x0/0x92 returned 0 after 37 usecs
[    3.268804] calling  init_syncookies+0x0/0x19 @ 1
[    3.268835] initcall init_syncookies+0x0/0x19 returned 0 after 21 usecs
[    3.268845] calling  tunnel4_init+0x0/0x72 @ 1
[    3.268854] initcall tunnel4_init+0x0/0x72 returned 0 after 0 usecs
[    3.268865] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[    3.268876] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
[    3.268886] calling  nf_conntrack_l3proto_ipv4_init+0x0/0xb8 @ 1
[    3.269010] initcall nf_conntrack_l3proto_ipv4_init+0x0/0xb8 returned 0 after 110 usecs
[    3.269021] calling  nf_defrag_init+0x0/0x17 @ 1
[    3.269029] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    3.269037] calling  ip_tables_init+0x0/0xaa @ 1
[    3.269064] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.269072] initcall ip_tables_init+0x0/0xaa returned 0 after 26 usecs
[    3.269083] calling  iptable_filter_init+0x0/0x51 @ 1
[    3.269107] initcall iptable_filter_init+0x0/0x51 returned 0 after 13 usecs
[    3.269118] calling  iptable_mangle_init+0x0/0x51 @ 1
[    3.269139] initcall iptable_mangle_init+0x0/0x51 returned 0 after 10 usecs
[    3.269150] calling  reject_tg_init+0x0/0x12 @ 1
[    3.269159] initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.269169] calling  ulog_tg_init+0x0/0x104 @ 1
[    3.269184] initcall ulog_tg_init+0x0/0x104 returned 0 after 5 usecs
[    3.269195] calling  cubictcp_register+0x0/0x5c @ 1
[    3.269204] TCP: cubic registered
[    3.269213] initcall cubictcp_register+0x0/0x5c returned 0 after 9 usecs
[    3.269221] calling  xfrm_user_init+0x0/0x4a @ 1
[    3.269230] Initializing XFRM netlink socket
[    3.269244] initcall xfrm_user_init+0x0/0x4a returned 0 after 12 usecs
[    3.269255] calling  inet6_init+0x0/0x315 @ 1
[    3.269288] NET: Registered protocol family 10
[    3.269523] initcall inet6_init+0x0/0x315 returned 0 after 252 usecs
[    3.269532] calling  ah6_init+0x0/0x79 @ 1
[    3.269539] initcall ah6_init+0x0/0x79 returned 0 after 0 usecs
[    3.269547] calling  esp6_init+0x0/0x79 @ 1
[    3.269555] initcall esp6_init+0x0/0x79 returned 0 after 0 usecs
[    3.269563] calling  xfrm6_transport_init+0x0/0x17 @ 1
[    3.269571] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 0 usecs
[    3.269579] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[    3.269587] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 usecs
[    3.269595] calling  xfrm6_beet_init+0x0/0x17 @ 1
[    3.269602] initcall xfrm6_beet_init+0x0/0x17 returned 0 after 0 usecs
[    3.269610] calling  ip6_tables_init+0x0/0xaa @ 1
[    3.269627] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.269635] initcall ip6_tables_init+0x0/0xaa returned 0 after 16 usecs
[    3.269643] calling  ip6table_filter_init+0x0/0x51 @ 1
[    3.269764] initcall ip6table_filter_init+0x0/0x51 returned 0 after 110 usecs
[    3.269773] calling  ip6table_mangle_init+0x0/0x51 @ 1
[    3.269822] initcall ip6table_mangle_init+0x0/0x51 returned 0 after 40 usecs
[    3.269831] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x8a @ 1
[    3.269846] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x8a returned 0 after 6 usecs
[    3.269855] calling  nf_defrag_init+0x0/0x54 @ 1
[    3.269868] initcall nf_defrag_init+0x0/0x54 returned 0 after 5 usecs
[    3.269876] calling  ipv6header_mt6_init+0x0/0x12 @ 1
[    3.269884] initcall ipv6header_mt6_init+0x0/0x12 returned 0 after 0 usecs
[    3.269892] calling  reject_tg6_init+0x0/0x12 @ 1
[    3.269900] initcall reject_tg6_init+0x0/0x12 returned 0 after 0 usecs
[    3.269908] calling  sit_init+0x0/0x8c @ 1
[    3.269914] sit: IPv6 over IPv4 tunneling driver
[    3.270252] initcall sit_init+0x0/0x8c returned 0 after 329 usecs
[    3.270261] calling  packet_init+0x0/0x47 @ 1
[    3.270268] NET: Registered protocol family 17
[    3.270280] initcall packet_init+0x0/0x47 returned 0 after 11 usecs
[    3.468657] calling  br_init+0x0/0xa2 @ 1
[    3.468683] initcall br_init+0x0/0xa2 returned 0 after 16 usecs
[    3.468691] calling  init_rpcsec_gss+0x0/0x64 @ 1
[    3.468734] initcall init_rpcsec_gss+0x0/0x64 returned 0 after 32 usecs
[    3.468745] calling  dcbnl_init+0x0/0x4d @ 1
[    3.468756] initcall dcbnl_init+0x0/0x4d returned 0 after 0 usecs
[    3.468765] calling  init_dns_resolver+0x0/0xe4 @ 1
[    3.468790] Key type dns_resolver registered
[    3.468801] initcall init_dns_resolver+0x0/0xe4 returned 0 after 23 usecs
[    3.468812] calling  mcheck_init_device+0x0/0x123 @ 1
[    3.468822] initcall mcheck_init_device+0x0/0x123 returned -5 after 0 usecs
[    3.468833] initcall mcheck_init_device+0x0/0x123 returned with error code -5 
[    3.468865] calling  tboot_late_init+0x0/0x216 @ 1
[    3.468875] initcall tboot_late_init+0x0/0x216 returned 0 after 0 usecs
[    3.468885] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    3.468915] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 19 usecs
[    3.468923] calling  severities_debugfs_init+0x0/0x3c @ 1
[    3.468942] initcall severities_debugfs_init+0x0/0x3c returned 0 after 7 usecs
[    3.468954] calling  threshold_init_device+0x0/0x8d @ 1
[    3.468964] initcall threshold_init_device+0x0/0x8d returned 0 after 0 usecs
[    3.468975] calling  hpet_insert_resource+0x0/0x23 @ 1
[    3.468985] initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
[    3.468995] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[    3.469007] calling  update_mp_table+0x0/0x56d @ 1
[    3.469018] initcall update_mp_table+0x0/0x56d returned 0 after 0 usecs
[    3.469028] calling  lapic_insert_resource+0x0/0x3f @ 1
[    3.469037] initcall lapic_insert_resource+0x0/0x3f returned -1 after 0 usecs
[    3.469047] initcall lapic_insert_resource+0x0/0x3f returned with error code -1 
[    3.469072] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    3.469083] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    3.469092] calling  print_ICs+0x0/0x508 @ 1
[    3.469102] initcall print_ICs+0x0/0x508 returned 0 after 0 usecs
[    3.469112] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    3.469122] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    3.469133] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    3.469156] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 13 usecs
[    3.469169] calling  init_oops_id+0x0/0x40 @ 1
[    3.469189] initcall init_oops_id+0x0/0x40 returned 0 after 4 usecs
[    3.469199] calling  printk_late_init+0x0/0x59 @ 1
[    3.469211] initcall printk_late_init+0x0/0x59 returned 0 after 1 usecs
[    3.469220] calling  pm_qos_power_init+0x0/0x7b @ 1
[    3.469460] initcall pm_qos_power_init+0x0/0x7b returned 0 after 223 usecs
[    3.469469] calling  pm_debugfs_init+0x0/0x24 @ 1
[    3.469483] initcall pm_debugfs_init+0x0/0x24 returned 0 after 6 usecs
[    3.469492] calling  software_resume+0x0/0x290 @ 1
[    3.469499] PM: Hibernation image not present or could not be loaded.
[    3.469507] initcall software_resume+0x0/0x290 returned -2 after 7 usecs
[    3.469515] initcall software_resume+0x0/0x290 returned with error code -2 
[    3.469524] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    3.469551] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 19 usecs
[    3.469559] calling  taskstats_init+0x0/0x95 @ 1
[    3.469570] registered taskstats version 1
[    3.469577] initcall taskstats_init+0x0/0x95 returned 0 after 10 usecs
[    3.469585] calling  clear_boot_tracer+0x0/0x2d @ 1
[    3.469593] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    3.469601] calling  max_swapfiles_check+0x0/0x8 @ 1
[    3.469608] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    3.469617] calling  set_recommended_min_free_kbytes+0x0/0xa0 @ 1
[    3.469625] initcall set_recommended_min_free_kbytes+0x0/0xa0 returned 0 after 0 usecs
[    3.469634] calling  fail_make_request_debugfs+0x0/0x2a @ 1
[    3.469692] initcall fail_make_request_debugfs+0x0/0x2a returned 0 after 49 usecs
[    3.469701] calling  prandom_reseed+0x0/0xb4 @ 1
[    3.469722] initcall prandom_reseed+0x0/0xb4 returned 0 after 13 usecs
[    3.469730] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    3.469740] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 1 usecs
[    3.469748] calling  pci_sysfs_init+0x0/0x51 @ 1
[    3.469757] initcall pci_sysfs_init+0x0/0x51 returned 0 after 1 usecs
[    3.469765] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    3.669552] XENBUS: Device with no driver: device/vif/0
[    3.669562] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 12 usecs
[    3.669575] calling  random_int_secret_init+0x0/0x19 @ 1
[    3.669594] initcall random_int_secret_init+0x0/0x19 returned 0 after 10 usecs
[    3.669604] calling  deferred_probe_initcall+0x0/0x60 @ 1
[    3.669664] initcall deferred_probe_initcall+0x0/0x60 returned 0 after 50 usecs
[    3.669681] calling  late_resume_init+0x0/0x1d0 @ 1
[    3.669690]   Magic number: 1:252:3141
[    3.669768] initcall late_resume_init+0x0/0x1d0 returned 0 after 75 usecs
[    3.669778] calling  firmware_memmap_init+0x0/0x38 @ 1
[    3.669805] initcall firmware_memmap_init+0x0/0x38 returned 0 after 18 usecs
[    3.669815] calling  pci_mmcfg_late_insert_resources+0x0/0x50 @ 1
[    3.669824] initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 usecs
[    3.669835] calling  net_secret_init+0x0/0x19 @ 1
[    3.669857] initcall net_secret_init+0x0/0x19 returned 0 after 11 usecs
[    3.669866] calling  tcp_congestion_default+0x0/0x12 @ 1
[    3.669878] initcall tcp_congestion_default+0x0/0x12 returned 0 after 1 usecs
[    3.669889] calling  tcp_fastopen_init+0x0/0x30 @ 1
[    3.669910] initcall tcp_fastopen_init+0x0/0x30 returned 0 after 11 usecs
[    3.669921] calling  ip_auto_config+0x0/0xe62 @ 1
[    3.669937] initcall ip_auto_config+0x0/0xe62 returned 0 after 5 usecs
[    3.669947] calling  initialize_hashrnd+0x0/0x19 @ 1
[    3.669961] initcall initialize_hashrnd+0x0/0x19 returned 0 after 4 usecs
[    3.670862] Freeing unused kernel memory: 756k freed
[    3.671087] Write protecting the kernel read-only data: 10240k
[    3.677203] Freeing unused kernel memory: 1620k freed
[    3.677696] Freeing unused kernel memory: 136k freed
init started: BusyBox v1.14.3 (2013-01-15 17:27:03 EST)
[    3.683393] consoletype (1029) used greatest stack depth: 5288 bytes left
Mounting directories  [  OK  ]
mount: mount point /proc/bus/usb does not exist
[    3.991865] calling  privcmd_init+0x0/0x1000 [xen_privcmd] @ 1058
[    3.991978] initcall privcmd_init+0x0/0x1000 [xen_privcmd] returned 0 after 93 usecs
[    3.992361] calling  xenfs_init+0x0/0x1000 [xenfs] @ 1058
[    3.992373] initcall xenfs_init+0x0/0x1000 [xenfs] returned 0 after 1 usecs
[    3.992538] modprobe (1058) used greatest stack depth: 5272 bytes left
mount: mount point /sys/kernel/config does not exist
[    4.003403] core_filesystem (1030) used greatest stack depth: 4984 bytes left
[    4.012398] calling  xenkbd_init+0x0/0x1000 [xen_kbdfront] @ 1069
[    4.012500] initcall xenkbd_init+0x0/0x1000 [xen_kbdfront] returned 0 after 84 usecs
[    4.015993] calling  xenfb_init+0x0/0x1000 [xen_fbfront] @ 1072
[    4.016125] initcall xenfb_init+0x0/0x1000 [xen_fbfront] returned 0 after 113 usecs
[    4.019032] calling  netif_init+0x0/0x1000 [xen_netfront] @ 1079
[    4.019044] Initialising Xen virtual ethernet driver.
[    4.119124] initcall netif_init+0x0/0x1000 [xen_netfront] returned 0 after 97731 usecs
[    4.121939] calling  xlblk_init+0x0/0x1000 [xen_blkfront] @ 1085
[    4.122045] initcall xlblk_init+0x0/0x1000 [xen_blkfront] returned 0 after 87 usecs
[    4.136417] udevd (1091): /proc/1091/oom_adj is deprecated, please use /proc/1091/oom_score_adj instead.
udevd-work[1093]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory

[    4.190158] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 1112
[    4.190457] initcall crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] returned 0 after 273 usecs
[    4.294865] ip (1240) used greatest stack depth: 3896 bytes left
Waiting for devices [  OK  ]
Waiting for fb [  OK  ]
Starting..[/dev/fb0]
Could not open; err: 2
FATAL: Module agpgart_intel not found.
[    4.617936] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @ 1861
[    4.618103] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned 0 after 143 usecs
[    4.622178] calling  ttm_init+0x0/0x1000 [ttm] @ 1861
[    4.622835] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 623 usecs
[    4.638477] calling  radeon_init+0x0/0x1000 [radeon] @ 1861
[    4.638494] [drm] radeon kernel modesetting enabled.
[    4.639366] initcall radeon_init+0x0/0x1000 [radeon] returned 0 after 831 usecs
[    4.644900] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1872
[    4.644911] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned -19 after 0 usecs
[    4.645279] calling  fb_console_init+0x0/0x1000 [fbcon] @ 1863
WARNING: Error inserting video (/lib/modules/3.8.0-rc2upstream/kernel/drivers/acpi/video.ko): No such device
WARNING: Error inserting mxm_wmi (/lib/modules/3.8.0-rc2upstream/kernel/drivers/platform/x86/mxm-wmi.ko): No such device
WARNING: Error inserting drm_kms_helper (/lib/modules/3.8.0-rc2upstream/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
WARNING: Error inserting ttm (/lib/modules/3.8.0-rc2upstream/kernel/drivers/gpu/drm/ttm/ttm.ko): No such device
FATAL: Error inserting nouveau (/lib/modules/3.8.0-rc2upstream/kernel/drivers/gpu/drm/nouveau/nouveau.ko): No such device
[    4.648295] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 after 2934 usecs
[    4.648680] calling  acpi_video_init+0x0/0xfee [video] @ 1877
[    4.648692] initcall acpi_video_init+0x0/0xfee [video] returned -19 after 1 usecs
WARNING: Error inserting drm_kms_helper (/lib/modules/3.8.0-rc2upstream/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
FATAL: Error inserting i915 (/lib/modules/3.8.0-rc2upstream/kernel/drivers/gpu/drm/i915/i915.ko): No such device
Starting..[/dev/fb0]
Could not open; err: 2
VGA: 0000:
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [    4.919737] device eth0 entered promiscuous mode
[  OK  ]
Bringing up interface switch:  
Determining IP information for switch...[    4.973883] switch: port 1(eth0) entered forwarding state
[    4.973901] switch: port 1(eth0) entered forwarding state
 done.
[  OK  ]
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [2158]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2158] ignoring start request
FATAL: Module dump_dma not found.
ERROR: Module dump_dma does not exist in /proc/modules
[    7.304760] calling  crc32c_mod_init+0x0/0x1000 [crc32c] @ 2192
[    7.304839] initcall crc32c_mod_init+0x0/0x1000 [crc32c] returned 0 after 60 usecs
[    7.307385] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 2195
[    7.307403] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned 0 after 2 usecs
[    7.313643] calling  init_scsi+0x0/0x91 [scsi_mod] @ 2197
[    7.314342] SCSI subsystem initialized
[    7.314356] initcall init_scsi+0x0/0x91 [scsi_mod] returned 0 after 679 usecs
[    7.316111] calling  iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] @ 2197
[    7.316129] Loading iSCSI transport class v2.0-870.
[    7.317289] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] returned 0 after 1129 usecs
[    7.319114] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 2197
[    7.319320] iscsi: registered transport (tcp)
[    7.319329] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned 0 after 198 usecs
iscsistart: transport class version 2.0-870. iscsid version 2.0-872
Could not get list of targets from firmware.
Feb 22 21:46:33 g-pvops syslogd 1.5.0: restart.
Running in PV context on Xen v4.2.
FATAL: Module evtchn not found.
[    7.371756] calling  evtchn_init+0x0/0x1000 [xen_evtchn] @ 2237
[    7.372190] Event-channel device installed.
[    7.372199] initcall evtchn_init+0x0/0x1000 [xen_evtchn] returned 0 after 420 usecs
           CPU0       
 16:       2640  xen-percpu-virq      timer0
 17:          0  xen-percpu-ipi       spinlock0
 18:         29  xen-percpu-ipi       resched0
 19:          3  xen-percpu-ipi       callfunc0
 20:          0  xen-percpu-virq      debug0
 21:          1  xen-percpu-ipi       callfuncsingle0
 22:          0  xen-percpu-ipi       irqwork0
 23:         85   xen-dyn-event     hvc_console
 24:         20   xen-dyn-event     eth0
 37:        139   xen-dyn-event     xenbus
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
IWI:          0   IRQ work interrupts
RTR:          0   APIC ICR read retries
RES:         29   Rescheduling interrupts
CAL:          4   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:          0   Machine check polls
ERR:          0
MIS:          0
00000000-0000ffff : reserved
00010000-0009ffff : System RAM
000a0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-5ddfffff : System RAM
  01000000-01668597 : Kernel code
  01668598-01aa69ff : Kernel data
  01b6c000-01c6efff : Kernel bss
MemTotal:        1499108 kB
MemFree:         1111008 kB
Buffers:               0 kB
Cached:           353132 kB
SwapCached:            0 kB
Active:            21064 kB
Inactive:         331820 kB
Active(anon):      15064 kB
Inactive(anon):   160104 kB
Active(file):       6000 kB
Inactive(file):   171716 kB
Unevictable:        4928 kB
Mlocked:            4928 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          4748 kB
Mapped:             5124 kB
Shmem:            171788 kB
Slab:              18968 kB
SReclaimable:      11300 kB
SUnreclaim:         7668 kB
KernelStack:         464 kB
PageTables:          736 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      749552 kB
Committed_AS:     180652 kB
VmallocTotal:   34359738367 kB
VmallocUsed:        3924 kB
VmallocChunk:   34359734387 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:     1538048 kB
DirectMap2M:           0 kB
Waiting for init.late [  OK  ]
PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 1ms
rtt min/avg/max/mdev = 0.310/0.310/0.310/0.000 ms
[    7.471343] mount.nfs (2258) used greatest stack depth: 3480 bytes left
NFS done
 [0x0->0x5de00] pfn
 [0x0->0x5de00] level entry
 [0x5de00->0x80000] level middle
 [0x5de00->0x7cfffff] missing
 [0x80000->0x7cfffff] level top
libxl: error: libxl.c:87:libxl_ctx_alloc: Is xenstore daemon running?
failed to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
[    8.469522] calling  dm_init+0x0/0x48 [dm_mod] @ 2272
[    8.470002] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    8.470021] initcall dm_init+0x0/0x48 [dm_mod] returned 0 after 467 usecs
[    8.471073] calling  dm_multipath_init+0x0/0x1000 [dm_multipath] @ 2272
[    8.471163] device-mapper: multipath: version 1.5.0 loaded
[    8.471175] initcall dm_multipath_init+0x0/0x1000 [dm_multipath] returned 0 after 83 usecs
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]
[    8.734032] scsi0 : iSCSI Initiator over TCP/IP
[    8.991392] scsi 0:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[    8.995124] calling  init_sd+0x0/0x1000 [sd_mod] @ 2290
[    8.995995] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 833 usecs
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260] successful.
[    8.999267] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.999841] sd 0:0:0:0: [sda] Write Protect is off
[    8.999852] sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
[    9.000230] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    9.003886]  sda: unknown partition table
[    9.005627] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.008859] calling  init_sg+0x0/0x1000 [sg] @ 2303
[    9.009224] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.009265] initcall init_sg+0x0/0x1000 [sg] returned 0 after 380 usecs
Feb 22 21:46:35 g-pvops iscsid: Connection1:0 to [target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260] through [iface: default] is operational now
  PV /dev/sda   VG guests   lvm2 [931.51 GiB / 176.51 GiB free]
  Total: 1 [931.51 GiB] / in use: 1 [931.51 GiB] / in no VG: 0 [0   ]
[   14.059832] bio: create slab <bio-1> at 1
  26 logical volume(s) in volume group "guests" now active
22 Feb 21:46:44 ntpdate[2421]: step time server 17.171.4.34 offset 0.785497 sec
Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access method.
Fri Feb 22 21:46:44 UTC 2013
Feb 22 21:46:44 g-pvops init: starting pid 2437, tty '/dev/tty0': '/bin/sh'
Feb 22 21:46:44 g-pvops init: starting pid 2438, tty '/dev/tty1': '/bin/sh'
Feb 22 21:46:44 g-pvops init: starting pid 2439, tty '/dev/ttyS0': '/bin/sh'


BusyBox v1.14.3 (2013-01-15 17:27:03 EST) built-in shell (ash)
Enter 'help' for a list of built-in commands.

# Feb 22 21:46:44 g-pvops init: starting pid 2440, tty '/dev/hvc0': '/bin/sh'
Feb 22 21:46:45 g-pvops init: process '/bin/sh' (pid 2439) exited. Scheduling for restart.
Feb 22 21:46:45 g-pvops init: starting pid 2441, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:46 g-pvops init: process '/bin/sh' (pid 2441) exited. Scheduling for restart.
Feb 22 21:46:46 g-pvops init: starting pid 2442, tty '/dev/ttyS0': '/bin/sh'
[   20.000116] switch: port 1(eth0) entered forwarding state
Feb 22 21:46:47 g-pvops init: process '/bin/sh' (pid 2442) exited. Scheduling for restart.
Feb 22 21:46:47 g-pvops init: starting pid 2443, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:48 g-pvops init: process '/bin/sh' (pid 2443) exited. Scheduling for restart.
Feb 22 21:46:48 g-pvops init: starting pid 2444, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:49 g-pvops init: process '/bin/sh' (pid 2444) exited. Scheduling for restart.
Feb 22 21:46:49 g-pvops init: starting pid 2445, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:50 g-pvops init: process '/bin/sh' (pid 2445) exited. Scheduling for restart.
Feb 22 21:46:50 g-pvops init: starting pid 2446, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:51 g-pvops init: process '/bin/sh' (pid 2446) exited. Scheduling for restart.
Feb 22 21:46:51 g-pvops init: starting pid 2447, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:52 g-pvops init: process '/bin/sh' (pid 2447) exited. Scheduling for restart.
Feb 22 21:46:52 g-pvops init: starting pid 2448, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:53 g-pvops init: process '/bin/sh' (pid 2448) exited. Scheduling for restart.
Feb 22 21:46:53 g-pvops init: starting pid 2449, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:54 g-pvops init: process '/bin/sh' (pid 2449) exited. Scheduling for restart.
Feb 22 21:46:54 g-pvops init: starting pid 2450, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:55 g-pvops init: process '/bin/sh' (pid 2450) exited. Scheduling for restart.
Feb 22 21:46:55 g-pvops init: starting pid 2451, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:56 g-pvops init: process '/bin/sh' (pid 2451) exited. Scheduling for restart.
Feb 22 21:46:56 g-pvops init: starting pid 2452, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:57 g-pvops init: process '/bin/sh' (pid 2452) exited. Scheduling for restart.
Feb 22 21:46:57 g-pvops init: starting pid 2453, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:58 g-pvops init: process '/bin/sh' (pid 2453) exited. Scheduling for restart.
Feb 22 21:46:58 g-pvops init: starting pid 2454, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:46:59 g-pvops init: process '/bin/sh' (pid 2454) exited. Scheduling for restart.
Feb 22 21:46:59 g-pvops init: starting pid 2455, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:47:00 g-pvops init: process '/bin/sh' (pid 2455) exited. Scheduling for restart.
Feb 22 21:47:00 g-pvops init: starting pid 2456, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:47:01 g-pvops init: process '/bin/sh' (pid 2456) exited. Scheduling for restart.
Feb 22 21:47:01 g-pvops init: starting pid 2457, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:47:02 g-pvops init: process '/bin/sh' (pid 2457) exited. Scheduling for restart.
Feb 22 21:47:02 g-pvops init: starting pid 2458, tty '/dev/ttyS0': '/bin/sh'
Feb 22 21:47:03 g-pvops init: process '/bin/sh' (pid 2458) exited. Scheduling for restart.
Feb 22 21:47:03 g-pvops init: starting pid 2459, tty '/dev/ttyS0': '/bin/sh'
kill -Feb 22 21:47:04 g-pvops init: process '/bin/sh' (pid 2459) exited. Scheduling for restart.
Feb 22 21:47:04 g-pvops init: starting pid 2460, tty '/dev/ttyS0': '/bin/sh'
1 1
# Feb 22 21:47:05 g-pvops init: reloading /etc/inittab
dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc2upstream (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Fri Feb 22 16:38:14 EST 2013
[    0.000000] Command line: console=hvc0 debug earlyprintk=xen memblock=debug loglevel=8 initcall_debug
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000005ddfffff] usable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x5de00 max_arch_pfn = 0x400000000
[    0.000000] memblock_reserve: [0x00000001c6f000-0x00000001c7e000] setup_arch+0x5e5/0xbc6
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x5dd90000 reserved size = 0x15b87000
[    0.000000]  memory.cnt  = 0x2
[    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
[    0.000000]  memory[0x1]	[0x00000000100000-0x0000005ddfffff], 0x5dd00000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]	[0x00000001000000-0x00000001c7dfff], 0xc7e000 bytes
[    0.000000]  reserved[0x1]	[0x0000000208c000-0x00000016edafff], 0x14e4f000 bytes
[    0.000000]  reserved[0x2]	[0x00000016ede000-0x00000016f97fff], 0xba000 bytes
[    0.000000] initial memory mapped: [mem 0x00000000-0x16be8fff]
[    0.000000] memblock_reserve: [0x0000000009a000-0x000000000a0000] setup_real_mode+0x69/0x19b
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x5ddfffff]
[    0.000000]  [mem 0x00000000-0x5ddfffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x5ddfffff @ [mem 0x01d9a000-0x0208bfff]
[    0.000000] memblock_reserve: [0x00000001d9a000-0x00000001fd0000] native_pagetable_reserve+0xc/0xe
[    0.000000] xen: setting RW the range 1fd0000 - 208c000
[    0.000000] RAMDISK: [mem 0x0208c000-0x16be8fff]
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000005ddfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x5ddfffff]
[    0.000000] memblock_reserve: [0x0000005ddfc000-0x0000005de00000] memblock_alloc_base_nid+0x3f/0x52
[    0.000000]   NODE_DATA [mem 0x5ddfc000-0x5ddfffff]
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x5dd90000 reserved size = 0x15dc7000
[    0.000000]  memory.cnt  = 0x2
[    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes on node 0
[    0.000000]  memory[0x1]	[0x00000000100000-0x0000005ddfffff], 0x5dd00000 bytes on node 0
[    0.000000]  reserved.cnt  = 0x6
[    0.000000]  reserved[0x0]	[0x0000000009a000-0x0000000009ffff], 0x6000 bytes
[    0.000000]  reserved[0x1]	[0x00000001000000-0x00000001c7dfff], 0xc7e000 bytes
[    0.000000]  reserved[0x2]	[0x00000001d9a000-0x00000001fcffff], 0x236000 bytes
[    0.000000]  reserved[0x3]	[0x0000000208c000-0x00000016edafff], 0x14e4f000 bytes
[    0.000000]  reserved[0x4]	[0x00000016ede000-0x00000016f97fff], 0xba000 bytes
[    0.000000]  reserved[0x5]	[0x0000005ddfc000-0x0000005ddfffff], 0x4000 bytes
[    0.000000] memblock_reserve: [0x0000005ddfb000-0x0000005ddfc000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d9fb000-0x0000005ddfb000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d9fae80-0x0000005d9fb000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5fae80-0x0000005d9fae80] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005bc00000-0x0000005d400000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f9000-0x0000005d5fa000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f8000-0x0000005d5f9000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f7000-0x0000005d5f8000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f6000-0x0000005d5f7000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f5000-0x0000005d5f6000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f4000-0x0000005d5f5000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f3000-0x0000005d5f4000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f2000-0x0000005d5f3000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f1000-0x0000005d5f2000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5f0000-0x0000005d5f1000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5ef000-0x0000005d5f0000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5ee000-0x0000005d5ef000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d5ed000-0x0000005d5ee000] __alloc_memory_core_early+0x5c/0x64
[    0.000000]    memblock_free: [0x0000005d100000-0x0000005d400000] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005d5fae80-0x0000005d9fae80] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005d9fb000-0x0000005ddfb000] free_bootmem+0x9/0xb
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x5ddfffff]
[    0.000000] On node 0 totalpages: 384400
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000] memblock_reserve: [0x0000005dde3000-0x0000005ddfb000] __alloc_memory_core_early+0x5c/0x64
[    0.000000]   DMA32 zone: 5201 pages used for memmap
[    0.000000]   DMA32 zone: 375215 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x0000005ddcb000-0x0000005dde3000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dadc000-0x0000005ddcb000] __alloc_memory_core_early+0x5c/0x64
[    0.000000]    memblock_free: [0x00000016be9000-0x00000016ed8000] xen_pagetable_init+0xc9/0x1d8
[    0.000000] memblock_reserve: [0x0000005dadb000-0x0000005dadc000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dada000-0x0000005dadb000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad9000-0x0000005dada000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad8000-0x0000005dad9000] __alloc_memory_core_early+0x5c/0x64
[    0.000000] smpboot: Allowing 3 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] memblock_reserve: [0x0000005dad7f00-0x0000005dad7fe0] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7e80-0x0000005dad7ee8] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7e00-0x0000005dad7e68] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7d80-0x0000005dad7de8] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7d40-0x0000005dad7d60] __alloc_memory_core_early+0x5c/0x64
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] e820: [mem 0x5de00000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.2.0 (preserve-AD)
[    0.000000] memblock_reserve: [0x0000005dad7cc0-0x0000005dad7d0c] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7c40-0x0000005dad7c8c] __alloc_memory_core_early+0x5c/0x64
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:3 nr_node_ids:1
[    0.000000] memblock_reserve: [0x0000005dad6c40-0x0000005dad7c40] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5c40-0x0000005dad6c40] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005d600000-0x0000005d800000] __alloc_memory_core_early+0x5c/0x64
[    0.000000]    memblock_free: [0x0000005d61c000-0x0000005d680000] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005d69c000-0x0000005d700000] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005d71c000-0x0000005d780000] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005d780000-0x0000005d800000] free_bootmem+0x9/0xb
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88005d600000 s84480 r8192 d22016 u524288
[    0.000000] memblock_reserve: [0x0000005dad5c00-0x0000005dad5c08] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5bc0-0x0000005dad5bc8] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5b80-0x0000005dad5b8c] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5b40-0x0000005dad5b58] __alloc_memory_core_early+0x5c/0x64
[    0.000000] pcpu-alloc: s84480 r8192 d22016 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 - 
[    0.000000] memblock_reserve: [0x0000005dad5a00-0x0000005dad5b30] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5980-0x0000005dad59d0] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad5900-0x0000005dad5950] __alloc_memory_core_early+0x5c/0x64
[    0.000000]    memblock_free: [0x0000005dad6c40-0x0000005dad7c40] free_bootmem+0x9/0xb
[    0.000000]    memblock_free: [0x0000005dad5c40-0x0000005dad6c40] free_bootmem+0x9/0xb
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 379137
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: console=hvc0 debug earlyprintk=xen memblock=debug loglevel=8 initcall_debug
[    0.000000] memblock_reserve: [0x0000005dacd900-0x0000005dad5900] __alloc_memory_core_early+0x5c/0x64
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] memblock_reserve: [0x0000005dad7900-0x0000005dad7c40] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad78c0-0x0000005dad78cc] __alloc_memory_core_early+0x5c/0x64
[    0.000000] memblock_reserve: [0x0000005dad7880-0x0000005dad788c] __alloc_memory_core_early+0x5c/0x64
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1157280k/1538048k available (6561k kernel code, 448k absent, 380320k reserved, 4345k data, 756k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=3.
[    0.000000] NR_IRQS:33024 nr_irqs:296 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 3901.188 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001186] Mount-cache hash table entries: 256
[    0.001416] Initializing cgroup subsys cpuacct
[    0.001422] Initializing cgroup subsys freezer
[    0.001477] tseg: 00adf00000
[    0.001484] CPU: Physical Processor ID: 0
[    0.001489] CPU: Processor Core ID: 6
[    0.001495] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.001495] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.001495] tlb_flushall_shift: 5
[    0.022164] cpu 0 spinlock event irq 17
[    0.022202] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.022211] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.022219] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.022227] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.022236] calling  init_hw_perf_events+0x0/0x414 @ 1
[    0.022242] Performance Events: 
[    0.022247] perf: AMD core performance counters detected
[    0.022254] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.022261] no hardware sampling interrupt available.
[    0.022277] Broken PMU hardware detected, using software events only.
[    0.022284] Failed to access perfctr msr (MSR c0010201 is 0)
[    0.022292] initcall init_hw_perf_events+0x0/0x414 returned 0 after 0 usecs
[    0.022299] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
[    0.022307] initcall register_trigger_all_cpu_backtrace+0x0/0x16 returned 0 after 0 usecs
[    0.022316] calling  spawn_ksoftirqd+0x0/0x28 @ 1
[    0.022360] initcall spawn_ksoftirqd+0x0/0x28 returned 0 after 0 usecs
[    0.022368] calling  init_workqueues+0x0/0x33a @ 1
[    0.022543] initcall init_workqueues+0x0/0x33a returned 0 after 0 usecs
[    0.022552] calling  migration_init+0x0/0x71 @ 1
[    0.022560] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.022568] calling  cpu_stop_init+0x0/0xb4 @ 1
[    0.022606] initcall cpu_stop_init+0x0/0xb4 returned 0 after 0 usecs
[    0.022615] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.022622] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.022630] calling  rcu_spawn_gp_kthread+0x0/0x89 @ 1
[    0.022684] initcall rcu_spawn_gp_kthread+0x0/0x89 returned 0 after 0 usecs
[    0.022692] calling  relay_init+0x0/0x14 @ 1
[    0.022698] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.022705] calling  tracer_alloc_buffers+0x0/0x1fc @ 1
[    0.022746] initcall tracer_alloc_buffers+0x0/0x1fc returned 0 after 0 usecs
[    0.022753] calling  init_events+0x0/0x61 @ 1
[    0.022761] initcall init_events+0x0/0x61 returned 0 after 0 usecs
[    0.022768] calling  init_trace_printk+0x0/0x12 @ 1
[    0.022775] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.022782] calling  jump_label_init_module+0x0/0x12 @ 1
[    0.022789] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
[    0.022797] calling  mce_amd_init+0x0/0x110 @ 1
[    0.022803] MCE: In-kernel MCE decoding enabled.
[    0.022811] initcall mce_amd_init+0x0/0x110 returned 0 after 0 usecs
[    0.022903] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.023115] installing Xen timer for CPU 1
[    0.023134] cpu 1 spinlock event irq 24
[    0.023185] SMP alternatives: switching to SMP code
[    0.042382] installing Xen timer for CPU 2
[    0.042402] cpu 2 spinlock event irq 31
[    0.042544] Brought up 3 CPUs
[    0.044906] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.044915] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.044923] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.044930] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.044938] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.044948] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.044957] calling  net_ns_init+0x0/0xfd @ 1
[    0.044990] initcall net_ns_init+0x0/0xfd returned 0 after 0 usecs
[    0.045019] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.045027] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
[    0.045036] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.045044] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.046007] calling  reboot_init+0x0/0x1d @ 1
[    0.046017] initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
[    0.046025] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.046032] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.046040] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
[    0.046049] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
[    0.046057] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.046065] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.046073] calling  ksysfs_init+0x0/0x94 @ 1
[    0.046094] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.046103] calling  pm_init+0x0/0x4e @ 1
[    0.046117] initcall pm_init+0x0/0x4e returned 0 after 0 usecs
[    0.046125] calling  pm_disk_init+0x0/0x19 @ 1
[    0.046136] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.046146] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.046154] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.046162] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.046172] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.046181] calling  event_trace_enable+0x0/0xa9 @ 1
[    0.046213] initcall event_trace_enable+0x0/0xa9 returned 0 after 0 usecs
[    0.046222] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.046229] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.046237] calling  fsnotify_init+0x0/0x26 @ 1
[    0.046246] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.046254] calling  filelock_init+0x0/0x2a @ 1
[    0.046281] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.046290] calling  init_misc_binfmt+0x0/0x31 @ 1
[    0.046298] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.046306] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.046314] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046322] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.046330] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046338] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
[    0.046346] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.046354] calling  debugfs_init+0x0/0x5c @ 1
[    0.046364] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.046371] calling  securityfs_init+0x0/0x53 @ 1
[    0.046381] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.046389] calling  prandom_init+0x0/0xd9 @ 1
[    0.046397] initcall prandom_init+0x0/0xd9 returned 0 after 0 usecs
[    0.046406] calling  virtio_init+0x0/0x30 @ 1
[    0.046429] kworker/u:0 (26) used greatest stack depth: 6136 bytes left
[    0.046429] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    0.046429] calling  __gnttab_init+0x0/0x30 @ 1
[    0.046429] Grant tables using version 2 layout.
[    0.046429] Grant table initialized
[    0.046429] initcall __gnttab_init+0x0/0x30 returned 0 after 0 usecs
[    0.046429] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.065694] RTC time: 165:165:165, date: 165/165/65
[    0.065702] initcall early_resume_init+0x0/0x1d0 returned 0 after 18554 usecs
[    0.065711] calling  cpufreq_core_init+0x0/0xc7 @ 1
[    0.065719] initcall cpufreq_core_init+0x0/0xc7 returned -19 after 0 usecs
[    0.065727] calling  cpuidle_init+0x0/0x40 @ 1
[    0.065734] initcall cpuidle_init+0x0/0x40 returned -19 after 0 usecs
[    0.065742] calling  bsp_pm_check_init+0x0/0x14 @ 1
[    0.065749] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
[    0.065756] calling  sock_init+0x0/0x89 @ 1
[    0.065842] initcall sock_init+0x0/0x89 returned 0 after 0 usecs
[    0.065850] calling  net_inuse_init+0x0/0x26 @ 1
[    0.065859] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.065867] calling  netpoll_init+0x0/0x31 @ 1
[    0.065874] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.065881] calling  netlink_proto_init+0x0/0x1b3 @ 1
[    0.065897] NET: Registered protocol family 16
[    0.065917] initcall netlink_proto_init+0x0/0x1b3 returned 0 after 0 usecs
[    0.065938] calling  bdi_class_init+0x0/0x4d @ 1
[    0.066049] initcall bdi_class_init+0x0/0x4d returned 0 after 976 usecs
[    0.066060] calling  kobject_uevent_init+0x0/0x12 @ 1
[    0.066071] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.066079] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.066096] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.066096] calling  pci_driver_init+0x0/0x19 @ 1
[    0.066096] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    0.066096] calling  backlight_class_init+0x0/0x5d @ 1
[    0.067045] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.067045] calling  video_output_class_init+0x0/0x19 @ 1
[    0.067063] kworker/u:0 (31) used greatest stack depth: 5592 bytes left
[    0.067063] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.067063] calling  xenbus_init+0x0/0x21a @ 1
[    0.067093] initcall xenbus_init+0x0/0x21a returned 0 after 0 usecs
[    0.067093] calling  tty_class_init+0x0/0x38 @ 1
[    0.067093] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.067093] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.067093] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.067093] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.067093] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.067093] calling  register_node_type+0x0/0x34 @ 1
[    0.067093] initcall register_node_type+0x0/0x34 returned 0 after 0 usecs
[    0.067093] calling  i2c_init+0x0/0x77 @ 1
[    0.068032] initcall i2c_init+0x0/0x77 returned 0 after 976 usecs
[    0.068043] calling  amd_postcore_init+0x0/0x143 @ 1
[    0.068130] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
[    0.068160] calling  set_real_mode_permissions+0x0/0xa9 @ 1
[    0.068216] initcall set_real_mode_permissions+0x0/0xa9 returned 0 after 0 usecs
[    0.068227] calling  arch_kdebugfs_init+0x0/0x233 @ 1
[    0.068268] initcall arch_kdebugfs_init+0x0/0x233 returned 0 after 0 usecs
[    0.068278] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.068286] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.068294] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.068303] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.068311] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.068319] calling  activate_jump_labels+0x0/0x32 @ 1
[    0.068327] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
[    0.068335] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.068343] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.068352] calling  dma_bus_init+0x0/0x19 @ 1
[    0.068371] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.068371] calling  dma_channel_table_init+0x0/0x119 @ 1
[    0.068371] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
[    0.068371] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.070221] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 1953 usecs
[    0.070233] calling  register_xen_pci_notifier+0x0/0x38 @ 1
[    0.070241] initcall register_xen_pci_notifier+0x0/0x38 returned 0 after 0 usecs
[    0.070249] calling  xen_pcpu_init+0x0/0xcc @ 1
[    0.070256] initcall xen_pcpu_init+0x0/0xcc returned -19 after 0 usecs
[    0.070264] calling  dmi_id_init+0x0/0x31d @ 1
[    0.070272] initcall dmi_id_init+0x0/0x31d returned -19 after 0 usecs
[    0.070280] calling  dca_init+0x0/0x20 @ 1
[    0.070286] dca service started, version 1.12.1
[    0.070358] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
[    0.070366] calling  pci_arch_init+0x0/0x69 @ 1
[    0.071009] PCI: setting up Xen PCI frontend stub
[    0.071016] PCI: pci_cache_line_size set to 64 bytes
[    0.071024] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
[    0.071045] calling  topology_init+0x0/0x98 @ 1
[    0.071262] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    0.071271] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.071278] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.071286] calling  init_vdso+0x0/0x135 @ 1
[    0.071296] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    0.071304] calling  sysenter_setup+0x0/0x2dd @ 1
[    0.071314] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    0.071322] calling  param_sysfs_init+0x0/0x192 @ 1
[    0.083778] initcall param_sysfs_init+0x0/0x192 returned 0 after 11718 usecs
[    0.083790] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.083800] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.083808] calling  default_bdi_init+0x0/0x37 @ 1
[    0.083946] initcall default_bdi_init+0x0/0x37 returned 0 after 0 usecs
[    0.084039] calling  init_bio+0x0/0xe8 @ 1
[    0.084059] bio: create slab <bio-0> at 0
[    0.084078] initcall init_bio+0x0/0xe8 returned 0 after 0 usecs
[    0.084087] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.084105] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.084114] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.084122] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.084130] calling  blk_settings_init+0x0/0x2c @ 1
[    0.084138] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.084146] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.084157] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.084165] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.084174] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.084181] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.084189] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.084197] calling  genhd_device_init+0x0/0x85 @ 1
[    0.084326] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    0.084337] calling  pci_slot_init+0x0/0x50 @ 1
[    0.084347] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.084355] calling  fbmem_init+0x0/0x98 @ 1
[    0.084428] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.084438] calling  acpi_init+0x0/0xbc @ 1
[    0.084444] ACPI: Interpreter disabled.
[    0.084451] initcall acpi_init+0x0/0xbc returned -19 after 0 usecs
[    0.084459] calling  dock_init+0x0/0x7b @ 1
[    0.084467] initcall dock_init+0x0/0x7b returned 0 after 0 usecs
[    0.084475] calling  acpi_pci_root_init+0x0/0x32 @ 1
[    0.084483] initcall acpi_pci_root_init+0x0/0x32 returned 0 after 0 usecs
[    0.084491] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.084499] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
[    0.084507] calling  pnp_init+0x0/0x19 @ 1
[    0.084576] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
[    0.084586] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.084600] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 0 usecs
[    0.084600] calling  balloon_init+0x0/0x133 @ 1
[    0.084600] xen/balloon: Initialising balloon driver.
[    0.084600] initcall balloon_init+0x0/0x133 returned 0 after 0 usecs
[    0.084600] calling  xenbus_probe_backend_init+0x0/0x34 @ 1
[    0.085058] initcall xenbus_probe_backend_init+0x0/0x34 returned 0 after 976 usecs
[    0.085058] calling  xenbus_probe_frontend_init+0x0/0x34 @ 1
[    0.085110] initcall xenbus_probe_frontend_init+0x0/0x34 returned 0 after 0 usecs
[    0.085110] calling  xen_acpi_pad_init+0x0/0x47 @ 1
[    0.085110] initcall xen_acpi_pad_init+0x0/0x47 returned -19 after 0 usecs
[    0.085110] calling  balloon_init+0x0/0xfa @ 1
[    0.085110] xen-balloon: Initialising balloon driver.
[    0.086035] initcall balloon_init+0x0/0xfa returned 0 after 976 usecs
[    0.086035] calling  xen_selfballoon_init+0x0/0xb9 @ 1
[    0.086043] initcall xen_selfballoon_init+0x0/0xb9 returned -19 after 0 usecs
[    0.086051] calling  misc_init+0x0/0xba @ 1
[    0.086151] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    0.086159] calling  vga_arb_device_init+0x0/0xde @ 1
[    0.086269] vgaarb: loaded
[    0.086276] initcall vga_arb_device_init+0x0/0xde returned 0 after 0 usecs
[    0.086285] calling  cn_init+0x0/0xc0 @ 1
[    0.086302] initcall cn_init+0x0/0xc0 returned 0 after 0 usecs
[    0.086310] calling  phy_init+0x0/0x2e @ 1
[    0.086493] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.086501] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    0.086564] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    0.086572] calling  usb_init+0x0/0x170 @ 1
[    0.086726] usbcore: registered new interface driver usbfs
[    0.086798] usbcore: registered new interface driver hub
[    0.086890] usbcore: registered new device driver usb
[    0.086898] initcall usb_init+0x0/0x170 returned 0 after 0 usecs
[    0.086906] calling  serio_init+0x0/0x38 @ 1
[    0.086974] initcall serio_init+0x0/0x38 returned 0 after 0 usecs
[    0.086982] calling  input_init+0x0/0x103 @ 1
[    0.087087] initcall input_init+0x0/0x103 returned 0 after 0 usecs
[    0.087095] calling  rtc_init+0x0/0x71 @ 1
[    0.087158] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.087166] calling  pps_init+0x0/0xb7 @ 1
[    0.087227] pps_core: LinuxPPS API ver. 1 registered
[    0.088018] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.088030] initcall pps_init+0x0/0xb7 returned 0 after 976 usecs
[    0.088038] calling  ptp_init+0x0/0xa4 @ 1
[    0.088113] PTP clock support registered
[    0.088122] initcall ptp_init+0x0/0xa4 returned 0 after 0 usecs
[    0.088130] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.088195] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.088204] calling  hwmon_init+0x0/0xf6 @ 1
[    0.088268] initcall hwmon_init+0x0/0xf6 returned 0 after 0 usecs
[    0.088277] calling  leds_init+0x0/0x48 @ 1
[    0.088340] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.088349] calling  iommu_init+0x0/0x58 @ 1
[    0.088359] initcall iommu_init+0x0/0x58 returned 0 after 0 usecs
[    0.088367] calling  pci_subsys_init+0x0/0x4f @ 1
[    0.088374] PCI: System does not support PCI
[    0.088381] PCI: System does not support PCI
[    0.088388] initcall pci_subsys_init+0x0/0x4f returned 0 after 0 usecs
[    0.088396] calling  proto_init+0x0/0x12 @ 1
[    0.088407] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.088415] calling  net_dev_init+0x0/0x1c7 @ 1
[    0.088739] initcall net_dev_init+0x0/0x1c7 returned 0 after 0 usecs
[    0.088748] calling  neigh_init+0x0/0x80 @ 1
[    0.088757] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.088765] calling  fib_rules_init+0x0/0xaf @ 1
[    0.088773] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    0.088781] calling  pktsched_init+0x0/0xfe @ 1
[    0.088792] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
[    0.088800] calling  tc_filter_init+0x0/0x55 @ 1
[    0.088807] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    0.088816] calling  tc_action_init+0x0/0x55 @ 1
[    0.088823] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    0.088831] calling  genl_init+0x0/0x75 @ 1
[    0.088845] initcall genl_init+0x0/0x75 returned 0 after 0 usecs
[    0.088853] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.088862] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.088870] calling  netlbl_init+0x0/0x81 @ 1
[    0.088876] NetLabel: Initializing
[    0.088882] NetLabel:  domain hash size = 128
[    0.088888] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.088910] NetLabel:  unlabeled traffic allowed by default
[    0.088919] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.088926] calling  rfkill_init+0x0/0x79 @ 1
[    0.089030] initcall rfkill_init+0x0/0x79 returned 0 after 976 usecs
[    0.089054] calling  xen_p2m_debugfs+0x0/0x4a @ 1
[    0.089087] initcall xen_p2m_debugfs+0x0/0x4a returned 0 after 0 usecs
[    0.089095] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
[    0.089219] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 0 usecs
[    0.089228] calling  hpet_late_init+0x0/0x101 @ 1
[    0.089235] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
[    0.089243] calling  init_amd_nbs+0x0/0xb8 @ 1
[    0.089251] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
[    0.089260] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.089267] Switching to clocksource xen
[    0.089294] initcall clocksource_done_booting+0x0/0x5a returned 0 after 11 usecs
[    0.089303] calling  tracer_init_debugfs+0x0/0x3a4 @ 1
[    0.089711] initcall tracer_init_debugfs+0x0/0x3a4 returned 0 after 391 usecs
[    0.089720] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.089734] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 6 usecs
[    0.089743] calling  event_trace_init+0x0/0x271 @ 1
[    0.099475] initcall event_trace_init+0x0/0x271 returned 0 after 9769 usecs
[    0.099485] calling  init_kprobe_trace+0x0/0x93 @ 1
[    0.099505] initcall init_kprobe_trace+0x0/0x93 returned 0 after 12 usecs
[    0.099513] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.099543] initcall init_pipe_fs+0x0/0x4c returned 0 after 22 usecs
[    0.099552] calling  eventpoll_init+0x0/0xda @ 1
[    0.099566] initcall eventpoll_init+0x0/0xda returned 0 after 6 usecs
[    0.099574] calling  anon_inode_init+0x0/0x5b @ 1
[    0.099604] initcall anon_inode_init+0x0/0x5b returned 0 after 21 usecs
[    0.099612] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.099620] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.287868] calling  acpi_event_init+0x0/0x81 @ 1
[    0.287878] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
[    0.287887] calling  pnp_system_init+0x0/0x12 @ 1
[    0.288027] initcall pnp_system_init+0x0/0x12 returned 0 after 127 usecs
[    0.288036] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.288044] pnp: PnP ACPI: disabled
[    0.288052] initcall pnpacpi_init+0x0/0x8c returned 0 after 6 usecs
[    0.288100] calling  pcistub_init+0x0/0x29f @ 1
[    0.288197] initcall pcistub_init+0x0/0x29f returned 0 after 86 usecs
[    0.288207] calling  chr_dev_init+0x0/0xc6 @ 1
[    0.293859] initcall chr_dev_init+0x0/0xc6 returned 0 after 5511 usecs
[    0.293869] calling  firmware_class_init+0x0/0xda @ 1
[    0.293941] initcall firmware_class_init+0x0/0xda returned 0 after 60 usecs
[    0.293951] calling  init_pcmcia_bus+0x0/0x6c @ 1
[    0.294023] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 62 usecs
[    0.294032] calling  thermal_init+0x0/0x75 @ 1
[    0.294193] initcall thermal_init+0x0/0x75 returned 0 after 149 usecs
[    0.294203] calling  thermal_gov_step_wise_init+0x0/0x12 @ 1
[    0.294212] initcall thermal_gov_step_wise_init+0x0/0x12 returned 0 after 0 usecs
[    0.294221] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.294229] initcall cpufreq_gov_performance_init+0x0/0x12 returned -19 after 0 usecs
[    0.294239] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    0.294247] initcall init_acpi_pm_clocksource+0x0/0xec returned -19 after 0 usecs
[    0.294256] calling  pcibios_assign_resources+0x0/0xf8 @ 1
[    0.294267] initcall pcibios_assign_resources+0x0/0xf8 returned 0 after 2 usecs
[    0.294276] calling  sysctl_core_init+0x0/0x2c @ 1
[    0.294295] initcall sysctl_core_init+0x0/0x2c returned 0 after 11 usecs
[    0.294303] calling  inet_init+0x0/0x2a1 @ 1
[    0.294332] NET: Registered protocol family 2
[    0.294575] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.294649] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.294697] TCP: Hash tables configured (established 16384 bind 16384)
[    0.294733] TCP: reno registered
[    0.294747] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.294767] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.294857] initcall inet_init+0x0/0x2a1 returned 0 after 533 usecs
[    0.294866] calling  ipv4_offload_init+0x0/0x68 @ 1
[    0.294875] initcall ipv4_offload_init+0x0/0x68 returned 0 after 0 usecs
[    0.294883] calling  af_unix_init+0x0/0x55 @ 1
[    0.294891] NET: Registered protocol family 1
[    0.294907] initcall af_unix_init+0x0/0x55 returned 0 after 16 usecs
[    0.294916] calling  ipv6_offload_init+0x0/0x6e @ 1
[    0.294925] initcall ipv6_offload_init+0x0/0x6e returned 0 after 1 usecs
[    0.294933] calling  init_sunrpc+0x0/0x69 @ 1
[    0.295092] RPC: Registered named UNIX socket transport module.
[    0.295101] RPC: Registered udp transport module.
[    0.295108] RPC: Registered tcp transport module.
[    0.295114] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.295123] initcall init_sunrpc+0x0/0x69 returned 0 after 177 usecs
[    0.295131] calling  pci_apply_final_quirks+0x0/0x117 @ 1
[    0.295139] PCI: CLS 0 bytes, default 64
[    0.295146] initcall pci_apply_final_quirks+0x0/0x117 returned 0 after 6 usecs
[    0.295155] calling  populate_rootfs+0x0/0x10d @ 1
[    0.295384] Unpacking initramfs...
[    0.854446] Freeing initrd memory: 339316k freed
[    0.941088] initcall populate_rootfs+0x0/0x10d returned 0 after 630779 usecs
[    0.941109] calling  pci_iommu_init+0x0/0x41 @ 1
[    0.941118] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    0.941126] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    0.941135] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    0.941164] calling  irqfd_module_init+0x0/0x33 @ 1
[    0.941260] initcall irqfd_module_init+0x0/0x33 returned 0 after 85 usecs
[    0.941270] calling  i8259A_init_ops+0x0/0x21 @ 1
[    0.941278] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    0.941286] calling  vsyscall_init+0x0/0x27 @ 1
[    0.941303] initcall vsyscall_init+0x0/0x27 returned 0 after 6 usecs
[    0.941312] calling  sbf_init+0x0/0xf6 @ 1
[    0.941320] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    0.941330] calling  init_tsc_clocksource+0x0/0x89 @ 1
[    0.941343] initcall init_tsc_clocksource+0x0/0x89 returned 0 after 3 usecs
[    0.941353] calling  add_rtc_cmos+0x0/0x96 @ 1
[    0.941554] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.941575] initcall add_rtc_cmos+0x0/0x96 returned 0 after 204 usecs
[    0.941587] calling  i8237A_init_ops+0x0/0x14 @ 1
[    0.941597] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.941610] calling  cache_sysfs_init+0x0/0x6c @ 1
[    0.941692] initcall cache_sysfs_init+0x0/0x6c returned 0 after 70 usecs
[    0.941703] calling  intel_uncore_init+0x0/0x3fa @ 1
[    0.941712] initcall intel_uncore_init+0x0/0x3fa returned -19 after 0 usecs
[    0.941721] calling  inject_init+0x0/0x30 @ 1
[    0.941728] Machine check injector initialized
[    0.941737] initcall inject_init+0x0/0x30 returned 0 after 7 usecs
[    0.941745] calling  thermal_throttle_init_device+0x0/0x9d @ 1
[    0.941754] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 0 usecs
[    0.941763] calling  amd_ibs_init+0x0/0x48d @ 1
[    0.941772] initcall amd_ibs_init+0x0/0x48d returned -19 after 0 usecs
[    0.941781] calling  msr_init+0x0/0x162 @ 1
[    0.941942] initcall msr_init+0x0/0x162 returned 0 after 149 usecs
[    0.941952] calling  cpuid_init+0x0/0x162 @ 1
[    0.942124] initcall cpuid_init+0x0/0x162 returned 0 after 159 usecs
[    0.942133] calling  ioapic_init_ops+0x0/0x14 @ 1
[    0.942141] initcall ioapic_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.942149] calling  add_pcspkr+0x0/0x40 @ 1
[    0.942229] initcall add_pcspkr+0x0/0x40 returned 0 after 70 usecs
[    0.942238] calling  microcode_init+0x0/0x1b1 @ 1
[    0.942318] microcode: CPU0: patch_level=0x06000626
[    0.942401] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.942412] initcall microcode_init+0x0/0x1b1 returned 0 after 162 usecs
[    0.942422] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    0.942430] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    0.942439] calling  audit_classes_init+0x0/0xaf @ 1
[    0.942452] initcall audit_classes_init+0x0/0xaf returned 0 after 5 usecs
[    0.942460] calling  pt_dump_init+0x0/0x30 @ 1
[    0.942485] initcall pt_dump_init+0x0/0x30 returned 0 after 16 usecs
[    0.942494] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.942507] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 5 usecs
[    0.942515] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.942529] initcall proc_execdomains_init+0x0/0x22 returned 0 after 5 usecs
[    0.942538] calling  ioresources_init+0x0/0x3c @ 1
[    0.942552] initcall ioresources_init+0x0/0x3c returned 0 after 6 usecs
[    0.942561] calling  uid_cache_init+0x0/0xa5 @ 1
[    0.942574] initcall uid_cache_init+0x0/0xa5 returned 0 after 5 usecs
[    0.942582] calling  init_posix_timers+0x0/0x1f4 @ 1
[    0.942598] initcall init_posix_timers+0x0/0x1f4 returned 0 after 7 usecs
[    0.942606] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    0.942614] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    0.942623] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.942634] initcall proc_schedstat_init+0x0/0x22 returned 0 after 3 usecs
[    0.942642] calling  snapshot_device_init+0x0/0x12 @ 1
[    0.942724] initcall snapshot_device_init+0x0/0x12 returned 0 after 72 usecs
[    0.942733] calling  create_proc_profile+0x0/0x2c0 @ 1
[    0.942741] initcall create_proc_profile+0x0/0x2c0 returned 0 after 0 usecs
[    0.942749] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    0.942757] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    0.942765] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    0.942913] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 136 usecs
[    0.942923] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.942934] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 3 usecs
[    0.942943] calling  alarmtimer_init+0x0/0x15d @ 1
[    0.943122] initcall alarmtimer_init+0x0/0x15d returned 0 after 166 usecs
[    0.943131] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.943143] initcall init_tstats_procfs+0x0/0x2c returned 0 after 4 usecs
[    0.943150] calling  futex_init+0x0/0x65 @ 1
[    0.943163] initcall futex_init+0x0/0x65 returned 0 after 5 usecs
[    0.943170] calling  proc_dma_init+0x0/0x22 @ 1
[    0.943181] initcall proc_dma_init+0x0/0x22 returned 0 after 3 usecs
[    0.943188] calling  proc_modules_init+0x0/0x22 @ 1
[    0.943199] initcall proc_modules_init+0x0/0x22 returned 0 after 3 usecs
[    0.943207] calling  kallsyms_init+0x0/0x25 @ 1
[    0.943217] initcall kallsyms_init+0x0/0x25 returned 0 after 2 usecs
[    0.943224] calling  crash_save_vmcoreinfo_init+0x0/0x4a9 @ 1
[    1.054869] initcall crash_save_vmcoreinfo_init+0x0/0x4a9 returned 0 after 14 usecs
[    1.054879] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    1.054891] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 3 usecs
[    1.054900] calling  pid_namespaces_init+0x0/0x2d @ 1
[    1.054910] initcall pid_namespaces_init+0x0/0x2d returned 0 after 2 usecs
[    1.054918] calling  ikconfig_init+0x0/0x3a @ 1
[    1.054929] initcall ikconfig_init+0x0/0x3a returned 0 after 3 usecs
[    1.054936] calling  audit_init+0x0/0x141 @ 1
[    1.054943] audit: initializing netlink socket (disabled)
[    1.054961] type=2000 audit(1361569587.289:1): initialized
[    1.054971] initcall audit_init+0x0/0x141 returned 0 after 26 usecs
[    1.054979] calling  audit_watch_init+0x0/0x3a @ 1
[    1.054986] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    1.054994] calling  audit_tree_init+0x0/0x49 @ 1
[    1.055003] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    1.055010] calling  init_kprobes+0x0/0x16c @ 1
[    1.065934] initcall init_kprobes+0x0/0x16c returned 0 after 10660 usecs
[    1.065947] calling  hung_task_init+0x0/0x56 @ 1
[    1.065990] initcall hung_task_init+0x0/0x56 returned 0 after 33 usecs
[    1.065998] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    1.066009] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    1.066017] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.066031] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 6 usecs
[    1.066039] calling  init_tracepoints+0x0/0x20 @ 1
[    1.066047] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    1.066083] calling  init_blk_tracer+0x0/0x5a @ 1
[    1.066092] initcall init_blk_tracer+0x0/0x5a returned 0 after 1 usecs
[    1.066100] calling  perf_event_sysfs_init+0x0/0x9a @ 1
[    1.066383] initcall perf_event_sysfs_init+0x0/0x9a returned 0 after 268 usecs
[    1.066394] calling  init_per_zone_wmark_min+0x0/0x8c @ 1
[    1.066511] initcall init_per_zone_wmark_min+0x0/0x8c returned 0 after 105 usecs
[    1.066521] calling  kswapd_init+0x0/0x76 @ 1
[    1.066562] initcall kswapd_init+0x0/0x76 returned 0 after 32 usecs
[    1.066571] calling  extfrag_debug_init+0x0/0x7e @ 1
[    1.066600] initcall extfrag_debug_init+0x0/0x7e returned 0 after 20 usecs
[    1.066609] calling  setup_vmstat+0x0/0xc8 @ 1
[    1.066630] initcall setup_vmstat+0x0/0xc8 returned 0 after 13 usecs
[    1.066639] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.066649] initcall mm_sysfs_init+0x0/0x29 returned 0 after 2 usecs
[    1.066657] calling  slab_proc_init+0x0/0x25 @ 1
[    1.066668] initcall slab_proc_init+0x0/0x25 returned 0 after 3 usecs
[    1.066676] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.066687] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    1.066695] calling  procswaps_init+0x0/0x22 @ 1
[    1.066706] initcall procswaps_init+0x0/0x22 returned 0 after 3 usecs
[    1.066714] calling  init_frontswap+0x0/0x96 @ 1
[    1.066761] initcall init_frontswap+0x0/0x96 returned 0 after 37 usecs
[    1.066771] calling  hugetlb_init+0x0/0x415 @ 1
[    1.066781] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.066813] initcall hugetlb_init+0x0/0x415 returned 0 after 31 usecs
[    1.066822] calling  mmu_notifier_init+0x0/0x12 @ 1
[    1.066833] initcall mmu_notifier_init+0x0/0x12 returned 0 after 2 usecs
[    1.066843] calling  slab_proc_init+0x0/0x8 @ 1
[    1.066852] initcall slab_proc_init+0x0/0x8 returned 0 after 0 usecs
[    1.066861] calling  cpucache_init+0x0/0x52 @ 1
[    1.066871] initcall cpucache_init+0x0/0x52 returned 0 after 1 usecs
[    1.066881] calling  hugepage_init+0x0/0x191 @ 1
[    1.066890] initcall hugepage_init+0x0/0x191 returned -22 after 0 usecs
[    1.066900] initcall hugepage_init+0x0/0x191 returned with error code -22 
[    1.066910] calling  init_cleancache+0x0/0x96 @ 1
[    1.066956] initcall init_cleancache+0x0/0x96 returned 0 after 35 usecs
[    1.066964] calling  fcntl_init+0x0/0x2a @ 1
[    1.066974] initcall fcntl_init+0x0/0x2a returned 0 after 2 usecs
[    1.066983] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.066997] initcall proc_filesystems_init+0x0/0x22 returned 0 after 6 usecs
[    1.067005] calling  dio_init+0x0/0x2d @ 1
[    1.067017] initcall dio_init+0x0/0x2d returned 0 after 4 usecs
[    1.067025] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    1.067086] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 51 usecs
[    1.067094] calling  dnotify_init+0x0/0x7b @ 1
[    1.067112] initcall dnotify_init+0x0/0x7b returned 0 after 9 usecs
[    1.067120] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.067135] initcall inotify_user_setup+0x0/0x70 returned 0 after 6 usecs
[    1.067143] calling  aio_setup+0x0/0x7c @ 1
[    1.067160] initcall aio_setup+0x0/0x7c returned 0 after 9 usecs
[    1.067168] calling  proc_locks_init+0x0/0x22 @ 1
[    1.067179] initcall proc_locks_init+0x0/0x22 returned 0 after 3 usecs
[    1.067187] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    1.255161] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 71 usecs
[    1.255177] calling  dquot_init+0x0/0x121 @ 1
[    1.255185] VFS: Disk quotas dquot_6.5.2
[    1.255226] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.255238] initcall dquot_init+0x0/0x121 returned 0 after 50 usecs
[    1.255249] calling  init_v2_quota_format+0x0/0x22 @ 1
[    1.255259] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    1.255267] calling  quota_init+0x0/0x26 @ 1
[    1.255286] initcall quota_init+0x0/0x26 returned 0 after 8 usecs
[    1.255296] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.255312] initcall proc_cmdline_init+0x0/0x22 returned 0 after 5 usecs
[    1.255323] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.255338] initcall proc_consoles_init+0x0/0x22 returned 0 after 4 usecs
[    1.255349] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.255362] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 3 usecs
[    1.255371] calling  proc_devices_init+0x0/0x22 @ 1
[    1.255383] initcall proc_devices_init+0x0/0x22 returned 0 after 4 usecs
[    1.255393] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.255407] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    1.255418] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.255432] initcall proc_loadavg_init+0x0/0x22 returned 0 after 3 usecs
[    1.255442] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.255457] initcall proc_meminfo_init+0x0/0x22 returned 0 after 4 usecs
[    1.255467] calling  proc_stat_init+0x0/0x22 @ 1
[    1.255481] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    1.255491] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.255505] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    1.255516] calling  proc_version_init+0x0/0x22 @ 1
[    1.255530] initcall proc_version_init+0x0/0x22 returned 0 after 4 usecs
[    1.255540] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.255554] initcall proc_softirqs_init+0x0/0x22 returned 0 after 4 usecs
[    1.255565] calling  proc_kcore_init+0x0/0xb5 @ 1
[    1.255581] initcall proc_kcore_init+0x0/0xb5 returned 0 after 7 usecs
[    1.255592] calling  vmcore_init+0x0/0x370 @ 1
[    1.255602] initcall vmcore_init+0x0/0x370 returned 0 after 0 usecs
[    1.255612] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.255627] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
[    1.255637] calling  proc_page_init+0x0/0x42 @ 1
[    1.255655] initcall proc_page_init+0x0/0x42 returned 0 after 7 usecs
[    1.255665] calling  init_devpts_fs+0x0/0x62 @ 1
[    1.255717] initcall init_devpts_fs+0x0/0x62 returned 0 after 40 usecs
[    1.255728] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.255738] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255747] calling  init_hugetlbfs_fs+0x0/0x15d @ 1
[    1.255811] initcall init_hugetlbfs_fs+0x0/0x15d returned 0 after 53 usecs
[    1.255819] calling  init_fat_fs+0x0/0x4f @ 1
[    1.255837] initcall init_fat_fs+0x0/0x4f returned 0 after 9 usecs
[    1.255845] calling  init_vfat_fs+0x0/0x12 @ 1
[    1.255854] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255862] calling  init_msdos_fs+0x0/0x12 @ 1
[    1.255870] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    1.255878] calling  init_iso9660_fs+0x0/0x70 @ 1
[    1.255905] initcall init_iso9660_fs+0x0/0x70 returned 0 after 18 usecs
[    1.255913] calling  init_nfs_fs+0x0/0x16c @ 1
[    1.256045] initcall init_nfs_fs+0x0/0x16c returned 0 after 120 usecs
[    1.256077] calling  init_nfs_v2+0x0/0x14 @ 1
[    1.256086] initcall init_nfs_v2+0x0/0x14 returned 0 after 1 usecs
[    1.256093] calling  init_nfs_v3+0x0/0x14 @ 1
[    1.256101] initcall init_nfs_v3+0x0/0x14 returned 0 after 0 usecs
[    1.256108] calling  init_nfs_v4+0x0/0x3b @ 1
[    1.256115] NFS: Registering the id_resolver key type
[    1.256134] Key type id_resolver registered
[    1.256140] Key type id_legacy registered
[    1.256151] initcall init_nfs_v4+0x0/0x3b returned 0 after 34 usecs
[    1.256159] calling  init_nlm+0x0/0x4c @ 1
[    1.256171] initcall init_nlm+0x0/0x4c returned 0 after 5 usecs
[    1.256179] calling  init_nls_cp437+0x0/0x12 @ 1
[    1.256187] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    1.256194] calling  init_nls_ascii+0x0/0x12 @ 1
[    1.256202] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    1.256209] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    1.256217] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    1.256225] calling  init_nls_utf8+0x0/0x2b @ 1
[    1.256233] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
[    1.256240] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    1.256246] NTFS driver 2.1.30 [Flags: R/W].
[    1.455160] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 194248 usecs
[    1.455177] calling  init_autofs4_fs+0x0/0x2a @ 1
[    1.455306] initcall init_autofs4_fs+0x0/0x2a returned 0 after 117 usecs
[    1.455315] calling  init_pstore_fs+0x0/0x12 @ 1
[    1.455324] initcall init_pstore_fs+0x0/0x12 returned 0 after 0 usecs
[    1.455331] calling  ipc_init+0x0/0x2f @ 1
[    1.455345] msgmni has been set to 2923
[    1.455359] initcall ipc_init+0x0/0x2f returned 0 after 19 usecs
[    1.455367] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.455381] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 6 usecs
[    1.455389] calling  init_mqueue_fs+0x0/0xa2 @ 1
[    1.455434] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 36 usecs
[    1.455442] calling  key_proc_init+0x0/0x5e @ 1
[    1.455456] initcall key_proc_init+0x0/0x5e returned 0 after 6 usecs
[    1.455464] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    1.455471] SELinux:  Registering netfilter hooks
[    1.455652] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 175 usecs
[    1.455661] calling  init_sel_fs+0x0/0xa5 @ 1
[    1.455945] initcall init_sel_fs+0x0/0xa5 returned 0 after 269 usecs
[    1.455954] calling  selnl_init+0x0/0x56 @ 1
[    1.455967] initcall selnl_init+0x0/0x56 returned 0 after 5 usecs
[    1.455975] calling  sel_netif_init+0x0/0x5c @ 1
[    1.455984] initcall sel_netif_init+0x0/0x5c returned 0 after 2 usecs
[    1.455992] calling  sel_netnode_init+0x0/0x6a @ 1
[    1.456001] initcall sel_netnode_init+0x0/0x6a returned 0 after 1 usecs
[    1.456008] calling  sel_netport_init+0x0/0x6a @ 1
[    1.456017] initcall sel_netport_init+0x0/0x6a returned 0 after 1 usecs
[    1.456025] calling  aurule_init+0x0/0x2d @ 1
[    1.456033] initcall aurule_init+0x0/0x2d returned 0 after 0 usecs
[    1.456040] calling  crypto_wq_init+0x0/0x33 @ 1
[    1.456101] initcall crypto_wq_init+0x0/0x33 returned 0 after 51 usecs
[    1.456110] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.456121] initcall crypto_algapi_init+0x0/0xd returned 0 after 3 usecs
[    1.456129] calling  skcipher_module_init+0x0/0x35 @ 1
[    1.456137] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
[    1.456145] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.456153] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456161] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.456169] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456176] calling  hmac_module_init+0x0/0x12 @ 1
[    1.456184] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456192] calling  md5_mod_init+0x0/0x12 @ 1
[    1.456254] initcall md5_mod_init+0x0/0x12 returned 0 after 53 usecs
[    1.456263] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    1.456315] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456324] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.456332] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456340] calling  des_generic_mod_init+0x0/0x17 @ 1
[    1.456434] initcall des_generic_mod_init+0x0/0x17 returned 0 after 84 usecs
[    1.456442] calling  aes_init+0x0/0x12 @ 1
[    1.456493] initcall aes_init+0x0/0x12 returned 0 after 42 usecs
[    1.456501] calling  zlib_mod_init+0x0/0x12 @ 1
[    1.456551] initcall zlib_mod_init+0x0/0x12 returned 0 after 41 usecs
[    1.456559] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    1.456567] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456575] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    1.456584] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.456592] calling  lzo_mod_init+0x0/0x12 @ 1
[    1.456643] initcall lzo_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456651] calling  krng_mod_init+0x0/0x12 @ 1
[    1.456702] initcall krng_mod_init+0x0/0x12 returned 0 after 42 usecs
[    1.456710] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.456724] initcall proc_genhd_init+0x0/0x3c returned 0 after 6 usecs
[    1.456732] calling  bsg_init+0x0/0x12e @ 1
[    1.456803] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.456812] initcall bsg_init+0x0/0x12e returned 0 after 71 usecs
[    1.456820] calling  noop_init+0x0/0x12 @ 1
[    1.456827] io scheduler noop registered
[    1.456834] initcall noop_init+0x0/0x12 returned 0 after 7 usecs
[    1.456842] calling  deadline_init+0x0/0x12 @ 1
[    1.456849] io scheduler deadline registered
[    1.456856] initcall deadline_init+0x0/0x12 returned 0 after 6 usecs
[    1.456864] calling  cfq_init+0x0/0x8b @ 1
[    1.456878] io scheduler cfq registered (default)
[    1.456885] initcall cfq_init+0x0/0x8b returned 0 after 14 usecs
[    1.456893] calling  percpu_counter_startup+0x0/0x38 @ 1
[    1.456902] initcall percpu_counter_startup+0x0/0x38 returned 0 after 1 usecs
[    1.456910] calling  pci_proc_init+0x0/0x6a @ 1
[    1.654703] initcall pci_proc_init+0x0/0x6a returned 0 after 8 usecs
[    1.654716] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    1.654876] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 148 usecs
[    1.654885] calling  aer_service_init+0x0/0x2b @ 1
[    1.654958] initcall aer_service_init+0x0/0x2b returned 0 after 63 usecs
[    1.654967] calling  pci_hotplug_init+0x0/0x1d @ 1
[    1.654974] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.654982] initcall pci_hotplug_init+0x0/0x1d returned 0 after 6 usecs
[    1.654990] calling  pcifront_init+0x0/0x3f @ 1
[    1.655085] initcall pcifront_init+0x0/0x3f returned 0 after 85 usecs
[    1.655094] calling  genericbl_driver_init+0x0/0x12 @ 1
[    1.655169] initcall genericbl_driver_init+0x0/0x12 returned 0 after 65 usecs
[    1.655178] calling  cirrusfb_init+0x0/0xcc @ 1
[    1.655265] initcall cirrusfb_init+0x0/0xcc returned 0 after 75 usecs
[    1.655277] calling  efifb_init+0x0/0x298 @ 1
[    1.655287] initcall efifb_init+0x0/0x298 returned -19 after 1 usecs
[    1.655297] calling  intel_idle_init+0x0/0x326 @ 1
[    1.655305] initcall intel_idle_init+0x0/0x326 returned -19 after 0 usecs
[    1.655313] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    1.655322] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 usecs
[    1.655330] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    1.655338] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 0 usecs
[    1.655347] calling  acpi_ac_init+0x0/0x28 @ 1
[    1.655357] initcall acpi_ac_init+0x0/0x28 returned -19 after 0 usecs
[    1.655369] calling  acpi_button_driver_init+0x0/0x12 @ 1
[    1.655379] initcall acpi_button_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655390] calling  acpi_fan_driver_init+0x0/0x12 @ 1
[    1.655399] initcall acpi_fan_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655409] calling  acpi_processor_init+0x0/0x6d @ 1
[    1.655419] initcall acpi_processor_init+0x0/0x6d returned 0 after 0 usecs
[    1.655429] calling  acpi_container_init+0x0/0x4a @ 1
[    1.655439] initcall acpi_container_init+0x0/0x4a returned -19 after 0 usecs
[    1.655450] calling  acpi_thermal_init+0x0/0x42 @ 1
[    1.655458] initcall acpi_thermal_init+0x0/0x42 returned -19 after 0 usecs
[    1.655466] calling  acpi_battery_init+0x0/0x16 @ 1
[    1.655478] initcall acpi_battery_init+0x0/0x16 returned 0 after 3 usecs
[    1.655486] calling  acpi_hed_driver_init+0x0/0x12 @ 1
[    1.655494] initcall acpi_hed_driver_init+0x0/0x12 returned -19 after 0 usecs
[    1.655502] calling  erst_init+0x0/0x2bb @ 1
[    1.655510] initcall erst_init+0x0/0x2bb returned 0 after 0 usecs
[    1.655518] calling  ghes_init+0x0/0x171 @ 1
[    1.655527] initcall ghes_init+0x0/0x171 returned -19 after 0 usecs
[    1.655535] calling  einj_init+0x0/0x49d @ 1
[    1.655543] initcall einj_init+0x0/0x49d returned -19 after 0 usecs
[    1.655551] calling  ioat_init_module+0x0/0x80 @ 1
[    1.655559] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.655595] calling  1_acpi_battery_init_async+0x0/0x1b @ 6
[    1.655603] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 0 usecs
[    1.655672] initcall ioat_init_module+0x0/0x80 returned 0 after 109 usecs
[    1.655683] calling  virtio_mmio_init+0x0/0x12 @ 1
[    1.655766] initcall virtio_mmio_init+0x0/0x12 returned 0 after 72 usecs
[    1.655777] calling  init+0x0/0x12 @ 1
[    1.655855] initcall init+0x0/0x12 returned 0 after 67 usecs
[    1.655864] calling  xenbus_probe_initcall+0x0/0x39 @ 1
[    1.655873] initcall xenbus_probe_initcall+0x0/0x39 returned 0 after 0 usecs
[    1.655882] calling  xenbus_init+0x0/0x3d @ 1
[    1.655975] initcall xenbus_init+0x0/0x3d returned 0 after 81 usecs
[    1.655985] calling  xenbus_backend_init+0x0/0x51 @ 1
[    1.655993] initcall xenbus_backend_init+0x0/0x51 returned -19 after 0 usecs
[    1.656002] calling  gntdev_init+0x0/0x4d @ 1
[    1.656125] initcall gntdev_init+0x0/0x4d returned 0 after 111 usecs
[    1.656134] calling  gntalloc_init+0x0/0x3d @ 1
[    1.656209] initcall gntalloc_init+0x0/0x3d returned 0 after 66 usecs
[    1.656217] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    1.656225] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    1.656233] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    1.656254] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 13 usecs
[    1.656262] calling  platform_pci_module_init+0x0/0x1b @ 1
[    1.656336] initcall platform_pci_module_init+0x0/0x1b returned 0 after 64 usecs
[    1.656344] calling  xen_tmem_init+0x0/0x9a @ 1
[    1.656352] initcall xen_tmem_init+0x0/0x9a returned 0 after 0 usecs
[    1.656360] calling  xen_late_init_mcelog+0x0/0x3d @ 1
[    1.656367] initcall xen_late_init_mcelog+0x0/0x3d returned -19 after 0 usecs
[    1.656375] calling  xen_pcibk_init+0x0/0x13f @ 1
[    1.656383] initcall xen_pcibk_init+0x0/0x13f returned -19 after 0 usecs
[    1.854937] calling  xen_acpi_processor_init+0x0/0x41f @ 1
[    1.854949] initcall xen_acpi_processor_init+0x0/0x41f returned -19 after 0 usecs
[    1.854957] calling  pty_init+0x0/0x453 @ 1
[    1.890528] initcall pty_init+0x0/0x453 returned 0 after 34728 usecs
[    1.890543] calling  sysrq_init+0x0/0x78 @ 1
[    1.890557] initcall sysrq_init+0x0/0x78 returned 0 after 5 usecs
[    1.890564] calling  xen_hvc_init+0x0/0x249 @ 1
[    1.891318] initcall xen_hvc_init+0x0/0x249 returned 0 after 728 usecs
[    1.891328] calling  serial8250_init+0x0/0x17d @ 1
[    1.891335] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.891949] initcall serial8250_init+0x0/0x17d returned 0 after 598 usecs
[    1.891959] calling  serial_pci_driver_init+0x0/0x1b @ 1
[    1.892030] initcall serial_pci_driver_init+0x0/0x1b returned 0 after 62 usecs
[    1.892040] calling  init_kgdboc+0x0/0x16 @ 1
[    1.892048] initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
[    1.892103] calling  rand_initialize+0x0/0x30 @ 1
[    1.892125] initcall rand_initialize+0x0/0x30 returned 0 after 10 usecs
[    1.892135] calling  init+0x0/0x111 @ 1
[    1.892349] initcall init+0x0/0x111 returned 0 after 201 usecs
[    1.892358] calling  hpet_init+0x0/0x6a @ 1
[    1.892517] initcall hpet_init+0x0/0x6a returned -19 after 147 usecs
[    1.892526] calling  nvram_init+0x0/0x82 @ 1
[    1.892602] Non-volatile memory driver v1.3
[    1.892610] initcall nvram_init+0x0/0x82 returned 0 after 74 usecs
[    1.892618] calling  mod_init+0x0/0x5a @ 1
[    1.892625] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    1.892633] calling  rng_init+0x0/0x12 @ 1
[    1.892709] initcall rng_init+0x0/0x12 returned 0 after 66 usecs
[    1.892718] calling  agp_init+0x0/0x26 @ 1
[    1.892725] Linux agpgart interface v0.103
[    1.892732] initcall agp_init+0x0/0x26 returned 0 after 6 usecs
[    1.892739] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    1.892876] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 125 usecs
[    1.892885] calling  agp_intel_init+0x0/0x29 @ 1
[    1.892955] initcall agp_intel_init+0x0/0x29 returned 0 after 60 usecs
[    1.892964] calling  agp_sis_init+0x0/0x29 @ 1
[    1.893035] initcall agp_sis_init+0x0/0x29 returned 0 after 61 usecs
[    1.893043] calling  agp_via_init+0x0/0x29 @ 1
[    1.893136] initcall agp_via_init+0x0/0x29 returned 0 after 83 usecs
[    1.893144] calling  drm_core_init+0x0/0x139 @ 1
[    1.893223] [drm] Initialized drm 1.1.0 20060810
[    1.893231] initcall drm_core_init+0x0/0x139 returned 0 after 77 usecs
[    1.893239] calling  cn_proc_init+0x0/0x3d @ 1
[    1.893247] initcall cn_proc_init+0x0/0x3d returned 0 after 1 usecs
[    1.893256] calling  topology_sysfs_init+0x0/0x58 @ 1
[    1.893274] initcall topology_sysfs_init+0x0/0x58 returned 0 after 9 usecs
[    1.893282] calling  loop_init+0x0/0x137 @ 1
[    1.895048] loop: module loaded
[    1.895089] initcall loop_init+0x0/0x137 returned 0 after 1757 usecs
p[    1.895098] calling  xen_blkif_init+0x0/0x25f @ 1
[    1.895308] initcall xen_blkif_init+0x0/0x25f returned 0 after 197 usecs
[    1.895316] calling  mac_hid_init+0x0/0x22 @ 1
[    1.895328] initcall mac_hid_init+0x0/0x22 returned 0 after 4 usecs
[    1.895336] calling  macvlan_init_module+0x0/0x3d @ 1
[    1.895345] initcall macvlan_init_module+0x0/0x3d returned 0 after 1 usecs
[    1.895353] calling  macvtap_init+0x0/0x100 @ 1
[    1.895419] initcall macvtap_init+0x0/0x100 returned 0 after 56 usecs
[    1.895427] calling  net_olddevs_init+0x0/0x86 @ 1
[    1.895436] initcall net_olddevs_init+0x0/0x86 returned 0 after 1 usecs
[    1.895444] calling  fixed_mdio_bus_init+0x0/0x105 @ 1
[    1.895589] libphy: Fixed MDIO Bus: probed
[    1.895597] initcall fixed_mdio_bus_init+0x0/0x105 returned 0 after 141 usecs
[    1.895605] calling  tun_init+0x0/0x93 @ 1
[    1.895612] tun: Universal TUN/TAP device driver, 1.6
[    1.895618] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.895698] initcall tun_init+0x0/0x93 returned 0 after 83 usecs
[    1.895706] calling  tg3_init+0x0/0x1b @ 1
[    1.895780] initcall tg3_init+0x0/0x1b returned 0 after 65 usecs
[    1.895788] calling  ixgbevf_init_module+0x0/0x4c @ 1
[    2.055322] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
[    2.055332] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    2.055427] initcall ixgbevf_init_module+0x0/0x4c returned 0 after 101 usecs
[    2.055436] calling  init_nic+0x0/0x1b @ 1
[    2.055512] initcall init_nic+0x0/0x1b returned 0 after 66 usecs
[    2.055521] calling  netback_init+0x0/0x212 @ 1
[    2.055638] initcall netback_init+0x0/0x212 returned 0 after 106 usecs
[    2.055647] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    2.055656] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 1 usecs
[    2.055664] calling  yenta_socket_init+0x0/0x1b @ 1
[    2.055744] initcall yenta_socket_init+0x0/0x1b returned 0 after 70 usecs
[    2.055754] calling  mon_init+0x0/0xfe @ 1
[    2.055909] initcall mon_init+0x0/0xfe returned 0 after 144 usecs
[    2.055918] calling  ehci_hcd_init+0x0/0xb7 @ 1
[    2.055925] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.055933] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    2.055951] initcall ehci_hcd_init+0x0/0xb7 returned 0 after 24 usecs
[    2.055959] calling  ehci_pci_init+0x0/0x69 @ 1
[    2.055966] ehci-pci: EHCI PCI platform driver
[    2.056038] initcall ehci_pci_init+0x0/0x69 returned 0 after 68 usecs
[    2.056047] calling  ohci_hcd_mod_init+0x0/0xbf @ 1
[    2.056086] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.056094] ohci_hcd: block sizes: ed 80 td 96
[    2.056181] initcall ohci_hcd_mod_init+0x0/0xbf returned 0 after 92 usecs
[    2.056190] calling  uhci_hcd_init+0x0/0x129 @ 1
[    2.056197] uhci_hcd: USB Universal Host Controller Interface driver
[    2.056290] initcall uhci_hcd_init+0x0/0x129 returned 0 after 89 usecs
[    2.056299] calling  usblp_driver_init+0x0/0x1b @ 1
[    2.056375] usbcore: registered new interface driver usblp
[    2.056384] initcall usblp_driver_init+0x0/0x1b returned 0 after 75 usecs
[    2.056393] calling  kgdbdbgp_start_thread+0x0/0x4f @ 1
[    2.056401] initcall kgdbdbgp_start_thread+0x0/0x4f returned 0 after 0 usecs
[    2.056409] calling  i8042_init+0x0/0x3c5 @ 1
[    2.056657] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.068374] i8042: No controller found
[    3.068394] initcall i8042_init+0x0/0x3c5 returned -19 after 988256 usecs
[    3.068403] calling  serport_init+0x0/0x34 @ 1
[    3.068412] initcall serport_init+0x0/0x34 returned 0 after 1 usecs
[    3.068420] calling  mousedev_init+0x0/0x62 @ 1
[    3.068590] mousedev: PS/2 mouse device common for all mice
[    3.068600] initcall mousedev_init+0x0/0x62 returned 0 after 167 usecs
[    3.068608] calling  evdev_init+0x0/0x12 @ 1
[    3.068617] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    3.068625] calling  atkbd_init+0x0/0x27 @ 1
[    3.068713] initcall atkbd_init+0x0/0x27 returned 0 after 78 usecs
[    3.068724] calling  psmouse_init+0x0/0x7b @ 1
[    3.068871] initcall psmouse_init+0x0/0x7b returned 0 after 132 usecs
[    3.068888] calling  cmos_init+0x0/0x6a @ 1
[    3.129156] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    3.129267] rtc_cmos: probe of rtc_cmos failed with error -38
[    3.129462] initcall cmos_init+0x0/0x6a returned -19 after 59144 usecs
[    3.129471] calling  i2c_i801_init+0x0/0xad @ 1
[    3.129552] initcall i2c_i801_init+0x0/0xad returned 0 after 70 usecs
ow[    3.129562] calling  cpufreq_gov_dbs_init+0x0/0x95 @ 1
[    3.129571] initcall cpufreq_gov_dbs_init+0x0/0x95 returned -19 after 1 usecs
[    3.129580] calling  init_ladder+0x0/0x12 @ 1
[    3.129588] initcall init_ladder+0x0/0x12 returned -19 after 0 usecs
[    3.129596] calling  init_menu+0x0/0x12 @ 1
[    3.129603] initcall init_menu+0x0/0x12 returned -19 after 0 usecs
[    3.129612] calling  efivars_init+0x0/0x105 @ 1
[    3.129619] EFI Variables Facility v0.08 2004-May-17
[    3.129626] initcall efivars_init+0x0/0x105 returned 0 after 6 usecs
[    3.129635] calling  vhost_net_init+0x0/0x30 @ 1
[    3.129714] initcall vhost_net_init+0x0/0x30 returned 0 after 68 usecs
[    3.129723] calling  staging_init+0x0/0x8 @ 1
[    3.129731] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    3.129739] calling  zram_init+0x0/0x2e4 @ 1
[    3.129746] zram: num_devices not specified. Using default: 1
[    3.129753] zram: Creating 1 devices ...
[    3.130028] initcall zram_init+0x0/0x2e4 returned 0 after 273 usecs
[    3.130038] calling  zcache_init+0x0/0x297 @ 1
[    3.130115] initcall zcache_init+0x0/0x297 returned 0 after 67 usecs
[    3.130127] calling  zs_init+0x0/0x90 @ 1
[    3.130139] initcall zs_init+0x0/0x90 returned 0 after 3 usecs
[    3.130149] calling  eeepc_laptop_init+0x0/0x58 @ 1
[    3.130320] initcall eeepc_laptop_init+0x0/0x58 returned -19 after 157 usecs
[    3.130331] calling  sock_diag_init+0x0/0x12 @ 1
[    3.130347] initcall sock_diag_init+0x0/0x12 returned 0 after 8 usecs
[    3.130355] calling  flow_cache_init_global+0x0/0x19f @ 1
[    3.130373] initcall flow_cache_init_global+0x0/0x19f returned 0 after 10 usecs
[    3.130382] calling  llc_init+0x0/0x20 @ 1
[    3.130390] initcall llc_init+0x0/0x20 returned 0 after 1 usecs
[    3.130397] calling  snap_init+0x0/0x38 @ 1
[    3.130408] initcall snap_init+0x0/0x38 returned 0 after 1 usecs
[    3.130417] calling  blackhole_module_init+0x0/0x12 @ 1
[    3.130427] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    3.130436] calling  nfnetlink_init+0x0/0x27 @ 1
[    3.130444] Netfilter messages via NETLINK v0.30.
[    3.130464] initcall nfnetlink_init+0x0/0x27 returned 0 after 18 usecs
[    3.130474] calling  nfnetlink_log_init+0x0/0xdb @ 1
[    3.130491] initcall nfnetlink_log_init+0x0/0xdb returned 0 after 9 usecs
[    3.130499] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    3.130507] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.130600] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 90 usecs
[    3.130609] calling  ctnetlink_init+0x0/0xa4 @ 1
[    3.130616] ctnetlink v0.93: registering with nfnetlink.
[    3.130623] initcall ctnetlink_init+0x0/0xa4 returned 0 after 6 usecs
[    3.130631] calling  nf_conntrack_ftp_init+0x0/0x1ca @ 1
[    3.130639] initcall nf_conntrack_ftp_init+0x0/0x1ca returned 0 after 0 usecs
[    3.130647] calling  nf_conntrack_irc_init+0x0/0x173 @ 1
[    3.130658] initcall nf_conntrack_irc_init+0x0/0x173 returned 0 after 3 usecs
[    3.130666] calling  nf_conntrack_sip_init+0x0/0x215 @ 1
[    3.130675] initcall nf_conntrack_sip_init+0x0/0x215 returned 0 after 0 usecs
[    3.130683] calling  xt_init+0x0/0x118 @ 1
[    3.130693] initcall xt_init+0x0/0x118 returned 0 after 1 usecs
[    3.130701] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    3.130709] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    3.130717] calling  connsecmark_tg_init+0x0/0x12 @ 1
[    3.268638] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268647] calling  nflog_tg_init+0x0/0x12 @ 1
[    3.268656] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268664] calling  secmark_tg_init+0x0/0x12 @ 1
[    3.268671] initcall secmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.268679] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    3.268687] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[    3.268696] calling  conntrack_mt_init+0x0/0x17 @ 1
[    3.268707] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
er[    3.268715] calling  policy_mt_init+0x0/0x17 @ 1
[    3.268723] initcall policy_mt_init+0x0/0x17 returned 0 after 0 usecs
[    3.268730] calling  state_mt_init+0x0/0x12 @ 1
[    3.268738] initcall state_mt_init+0x0/0x12 returned 0 after 0 usecs
[    3.268746] calling  sysctl_ipv4_init+0x0/0x92 @ 1
[    3.268793] initcall sysctl_ipv4_init+0x0/0x92 returned 0 after 37 usecs
[    3.268804] calling  init_syncookies+0x0/0x19 @ 1
[    3.268835] initcall init_syncookies+0x0/0x19 returned 0 after 21 usecs
[    3.268845] calling  tunnel4_init+0x0/0x72 @ 1
[    3.268854] initcall tunnel4_init+0x0/0x72 returned 0 after 0 usecs
[    3.268865] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[    3.268876] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
[    3.268886] calling  nf_conntrack_l3proto_ipv4_init+0x0/0xb8 @ 1
[    3.269010] initcall nf_conntrack_l3proto_ipv4_init+0x0/0xb8 returned 0 after 110 usecs
[    3.269021] calling  nf_defrag_init+0x0/0x17 @ 1
[    3.269029] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    3.269037] calling  ip_tables_init+0x0/0xaa @ 1
[    3.269064] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.269072] initcall ip_tables_init+0x0/0xaa returned 0 after 26 usecs
[    3.269083] calling  iptable_filter_init+0x0/0x51 @ 1
[    3.269107] initcall iptable_filter_init+0x0/0x51 returned 0 after 13 usecs
[    3.269118] calling  iptable_mangle_init+0x0/0x51 @ 1
[    3.269139] initcall iptable_mangle_init+0x0/0x51 returned 0 after 10 usecs
[    3.269150] calling  reject_tg_init+0x0/0x12 @ 1
[    3.269159] initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
[    3.269169] calling  ulog_tg_init+0x0/0x104 @ 1
[    3.269184] initcall ulog_tg_init+0x0/0x104 returned 0 after 5 usecs
[    3.269195] calling  cubictcp_register+0x0/0x5c @ 1
[    3.269204] TCP: cubic registered
[    3.269213] initcall cubictcp_register+0x0/0x5c returned 0 after 9 usecs
[    3.269221] calling  xfrm_user_init+0x0/0x4a @ 1
[    3.269230] Initializing XFRM netlink socket
[    3.269244] initcall xfrm_user_init+0x0/0x4a returned 0 after 12 usecs
[    3.269255] calling  inet6_init+0x0/0x315 @ 1
[    3.269288] NET: Registered protocol family 10
[    3.269523] initcall inet6_init+0x0/0x315 returned 0 after 252 usecs
[    3.269532] calling  ah6_init+0x0/0x79 @ 1
[    3.269539] initcall ah6_init+0x0/0x79 returned 0 after 0 usecs
[    3.269547] calling  esp6_init+0x0/0x79 @ 1
[    3.269555] initcall esp6_init+0x0/0x79 returned 0 after 0 usecs
[    3.269563] calling  xfrm6_transport_init+0x0/0x17 @ 1
[    3.269571] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 0 usecs
[    3.269579] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[    3.269587] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 usecs
[    3.269595] calling  xfrm6_beet_init+0x0/0x17 @ 1
[    3.269602] initcall xfrm6_beet_init+0x0/0x17 returned 0 after 0 usecs
[    3.269610] calling  ip6_tables_init+0x0/0xaa @ 1
[    3.269627] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.269635] initcall ip6_tables_init+0x0/0xaa returned 0 after 16 usecs
[    3.269643] calling  ip6table_filter_init+0x0/0x51 @ 1
[    3.269764] initcall ip6table_filter_init+0x0/0x51 returned 0 after 110 usecs
[    3.269773] calling  ip6table_mangle_init+0x0/0x51 @ 1
[    3.269822] initcall ip6table_mangle_init+0x0/0x51 returned 0 after 40 usecs
[    3.269831] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x8a @ 1
[    3.269846] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x8a returned 0 after 6 usecs
[    3.269855] calling  nf_defrag_init+0x0/0x54 @ 1
[    3.269868] initcall nf_defrag_init+0x0/0x54 returned 0 after 5 usecs
[    3.269876] calling  ipv6header_mt6_init+0x0/0x12 @ 1
[    3.269884] initcall ipv6header_mt6_init+0x0/0x12 returned 0 after 0 usecs
[    3.269892] calling  reject_tg6_init+0x0/0x12 @ 1
[    3.269900] initcall reject_tg6_init+0x0/0x12 returned 0 after 0 usecs
[    3.269908] calling  sit_init+0x0/0x8c @ 1
[    3.269914] sit: IPv6 over IPv4 tunneling driver
[    3.270252] initcall sit_init+0x0/0x8c returned 0 after 329 usecs
[    3.270261] calling  packet_init+0x0/0x47 @ 1
[    3.270268] NET: Registered protocol family 17
[    3.270280] initcall packet_init+0x0/0x47 returned 0 after 11 usecs
[    3.468657] calling  br_init+0x0/0xa2 @ 1
of[    3.468683] initcall br_init+0x0/0xa2 returned 0 after 16 usecs
[    3.468691] calling  init_rpcsec_gss+0x0/0x64 @ 1
[    3.468734] initcall init_rpcsec_gss+0x0/0x64 returned 0 after 32 usecs
[    3.468745] calling  dcbnl_init+0x0/0x4d @ 1
[    3.468756] initcall dcbnl_init+0x0/0x4d returned 0 after 0 usecs
[    3.468765] calling  init_dns_resolver+0x0/0xe4 @ 1
[    3.468790] Key type dns_resolver registered
[    3.468801] initcall init_dns_resolver+0x0/0xe4 returned 0 after 23 usecs
[    3.468812] calling  mcheck_init_device+0x0/0x123 @ 1
[    3.468822] initcall mcheck_init_device+0x0/0x123 returned -5 after 0 usecs
[    3.468833] initcall mcheck_init_device+0x0/0x123 returned with error code -5 
[    3.468865] calling  tboot_late_init+0x0/0x216 @ 1
[    3.468875] initcall tboot_late_init+0x0/0x216 returned 0 after 0 usecs
[    3.468885] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    3.468915] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 19 usecs
[    3.468923] calling  severities_debugfs_init+0x0/0x3c @ 1
[    3.468942] initcall severities_debugfs_init+0x0/0x3c returned 0 after 7 usecs
[    3.468954] calling  threshold_init_device+0x0/0x8d @ 1
[    3.468964] initcall threshold_init_device+0x0/0x8d returned 0 after 0 usecs
[    3.468975] calling  hpet_insert_resource+0x0/0x23 @ 1
[    3.468985] initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
[    3.468995] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[    3.469007] calling  update_mp_table+0x0/0x56d @ 1
[    3.469018] initcall update_mp_table+0x0/0x56d returned 0 after 0 usecs
[    3.469028] calling  lapic_insert_resource+0x0/0x3f @ 1
[    3.469037] initcall lapic_insert_resource+0x0/0x3f returned -1 after 0 usecs
[    3.469047] initcall lapic_insert_resource+0x0/0x3f returned with error code -1 
[    3.469072] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    3.469083] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    3.469092] calling  print_ICs+0x0/0x508 @ 1
[    3.469102] initcall print_ICs+0x0/0x508 returned 0 after 0 usecs
[    3.469112] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    3.469122] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    3.469133] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    3.469156] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 13 usecs
[    3.469169] calling  init_oops_id+0x0/0x40 @ 1
[    3.469189] initcall init_oops_id+0x0/0x40 returned 0 after 4 usecs
[    3.469199] calling  printk_late_init+0x0/0x59 @ 1
[    3.469211] initcall printk_late_init+0x0/0x59 returned 0 after 1 usecs
[    3.469220] calling  pm_qos_power_init+0x0/0x7b @ 1
[    3.469460] initcall pm_qos_power_init+0x0/0x7b returned 0 after 223 usecs
[    3.469469] calling  pm_debugfs_init+0x0/0x24 @ 1
[    3.469483] initcall pm_debugfs_init+0x0/0x24 returned 0 after 6 usecs
[    3.469492] calling  software_resume+0x0/0x290 @ 1
[    3.469499] PM: Hibernation image not present or could not be loaded.
[    3.469507] initcall software_resume+0x0/0x290 returned -2 after 7 usecs
[    3.469515] initcall software_resume+0x0/0x290 returned with error code -2 
[    3.469524] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    3.469551] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 19 usecs
[    3.469559] calling  taskstats_init+0x0/0x95 @ 1
[    3.469570] registered taskstats version 1
[    3.469577] initcall taskstats_init+0x0/0x95 returned 0 after 10 usecs
[    3.469585] calling  clear_boot_tracer+0x0/0x2d @ 1
[    3.469593] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    3.469601] calling  max_swapfiles_check+0x0/0x8 @ 1
[    3.469608] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    3.469617] calling  set_recommended_min_free_kbytes+0x0/0xa0 @ 1
[    3.469625] initcall set_recommended_min_free_kbytes+0x0/0xa0 returned 0 after 0 usecs
[    3.469634] calling  fail_make_request_debugfs+0x0/0x2a @ 1
[    3.469692] initcall fail_make_request_debugfs+0x0/0x2a returned 0 after 49 usecs
[    3.469701] calling  prandom_reseed+0x0/0xb4 @ 1
[    3.469722] initcall prandom_reseed+0x0/0xb4 returned 0 after 13 usecs
[    3.469730] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    3.469740] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 1 usecs
[    3.469748] calling  pci_sysfs_init+0x0/0x51 @ 1
[    3.469757] initcall pci_sysfs_init+0x0/0x51 returned 0 after 1 usecs
[    3.469765] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    3.669552] XENBUS: Device with no driver: device/vif/0
[    3.669562] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 12 usecs
[    3.669575] calling  random_int_secret_init+0x0/0x19 @ 1
[    3.669594] initcall random_int_secret_init+0x0/0x19 returned 0 after 10 usecs
[    3.669604] calling  deferred_probe_initcall+0x0/0x60 @ 1
[    3.669664] initcall deferred_probe_initcall+0x0/0x60 returned 0 after 50 usecs
f[    3.669681] calling  late_resume_init+0x0/0x1d0 @ 1
[    3.669690]   Magic number: 1:252:3141
[    3.669768] initcall late_resume_init+0x0/0x1d0 returned 0 after 75 usecs
[    3.669778] calling  firmware_memmap_init+0x0/0x38 @ 1
[    3.669805] initcall firmware_memmap_init+0x0/0x38 returned 0 after 18 usecs
[    3.669815] calling  pci_mmcfg_late_insert_resources+0x0/0x50 @ 1
[    3.669824] initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 usecs
[    3.669835] calling  net_secret_init+0x0/0x19 @ 1
[    3.669857] initcall net_secret_init+0x0/0x19 returned 0 after 11 usecs
[    3.669866] calling  tcp_congestion_default+0x0/0x12 @ 1
[    3.669878] initcall tcp_congestion_default+0x0/0x12 returned 0 after 1 usecs
[    3.669889] calling  tcp_fastopen_init+0x0/0x30 @ 1
[    3.669910] initcall tcp_fastopen_init+0x0/0x30 returned 0 after 11 usecs
[    3.669921] calling  ip_auto_config+0x0/0xe62 @ 1
[    3.669937] initcall ip_auto_config+0x0/0xe62 returned 0 after 5 usecs
[    3.669947] calling  initialize_hashrnd+0x0/0x19 @ 1
[    3.669961] initcall initialize_hashrnd+0x0/0x19 returned 0 after 4 usecs
[    3.670862] Freeing unused kernel memory: 756k freed
[    3.671087] Write protecting the kernel read-only data: 10240k
[    3.677203] Freeing unused kernel memory: 1620k freed
[    3.677696] Freeing unused kernel memory: 136k freed
[    3.683393] consoletype (1029) used greatest stack depth: 5288 bytes left
[    3.991865] calling  privcmd_init+0x0/0x1000 [xen_privcmd] @ 1058
[    3.991978] initcall privcmd_init+0x0/0x1000 [xen_privcmd] returned 0 after 93 usecs
[    3.992361] calling  xenfs_init+0x0/0x1000 [xenfs] @ 1058
[    3.992373] initcall xenfs_init+0x0/0x1000 [xenfs] returned 0 after 1 usecs
[    3.992538] modprobe (1058) used greatest stack depth: 5272 bytes left
[    4.003403] core_filesystem (1030) used greatest stack depth: 4984 bytes left
[    4.012398] calling  xenkbd_init+0x0/0x1000 [xen_kbdfront] @ 1069
[    4.012500] initcall xenkbd_init+0x0/0x1000 [xen_kbdfront] returned 0 after 84 usecs
[    4.015993] calling  xenfb_init+0x0/0x1000 [xen_fbfront] @ 1072
[    4.016125] initcall xenfb_init+0x0/0x1000 [xen_fbfront] returned 0 after 113 usecs
[    4.019032] calling  netif_init+0x0/0x1000 [xen_netfront] @ 1079
[    4.019044] Initialising Xen virtual ethernet driver.
[    4.119124] initcall netif_init+0x0/0x1000 [xen_netfront] returned 0 after 97731 usecs
[    4.121939] calling  xlblk_init+0x0/0x1000 [xen_blkfront] @ 1085
[    4.122045] initcall xlblk_init+0x0/0x1000 [xen_blkfront] returned 0 after 87 usecs
[    4.136417] udevd (1091): /proc/1091/oom_adj is deprecated, please use /proc/1091/oom_score_adj instead.
[    4.190158] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 1112
[    4.190457] initcall crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] returned 0 after 273 usecs
[    4.294865] ip (1240) used greatest stack depth: 3896 bytes left
[    4.617936] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @ 1861
[    4.618103] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned 0 after 143 usecs
[    4.622178] calling  ttm_init+0x0/0x1000 [ttm] @ 1861
[    4.622835] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 623 usecs
[    4.638477] calling  radeon_init+0x0/0x1000 [radeon] @ 1861
[    4.638494] [drm] radeon kernel modesetting enabled.
[    4.639366] initcall radeon_init+0x0/0x1000 [radeon] returned 0 after 831 usecs
[    4.644900] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1872
[    4.644911] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned -19 after 0 usecs
[    4.645279] calling  fb_console_init+0x0/0x1000 [fbcon] @ 1863
[    4.648295] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 after 2934 usecs
[    4.648680] calling  acpi_video_init+0x0/0xfee [video] @ 1877
[    4.648692] initcall acpi_video_init+0x0/0xfee [video] returned -19 after 1 usecs
[    4.919737] device eth0 entered promiscuous mode
[    4.973883] switch: port 1(eth0) entered forwarding state
[    4.973901] switch: port 1(eth0) entered forwarding state
[    7.304760] calling  crc32c_mod_init+0x0/0x1000 [crc32c] @ 2192
[    7.304839] initcall crc32c_mod_init+0x0/0x1000 [crc32c] returned 0 after 60 usecs
[    7.307385] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 2195
[    7.307403] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned 0 after 2 usecs
[    7.313643] calling  init_scsi+0x0/0x91 [scsi_mod] @ 2197
[    7.314342] SCSI subsystem initialized
[    7.314356] initcall init_scsi+0x0/0x91 [scsi_mod] returned 0 after 679 usecs
[    7.316111] calling  iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] @ 2197
[    7.316129] Loading iSCSI transport class v2.0-870.
[    7.317289] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] returned 0 after 1129 usecs
[    7.319114] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 2197
[    7.319320] iscsi: registered transport (tcp)
[    7.319329] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned 0 after 198 usecs
[    7.371756] calling  evtchn_init+0x0/0x1000 [xen_evtchn] @ 2237
[    7.372190] Event-channel device installed.
[    7.372199] initcall evtchn_init+0x0/0x1000 [xen_evtchn] returned 0 after 420 usecs
[    7.471343] mount.nfs (2258) used greatest stack depth: 3480 bytes left
[    8.469522] calling  dm_init+0x0/0x48 [dm_mod] @ 2272
[    8.470002] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    8.470021] initcall dm_init+0x0/0x48 [dm_mod] returned 0 after 467 usecs
[    8.471073] calling  dm_multipath_init+0x0/0x1000 [dm_multipath] @ 2272
[    8.471163] device-mapper: multipath: version 1.5.0 loaded
[    8.471175] initcall dm_multipath_init+0x0/0x1000 [dm_multipath] returned 0 after 83 usecs
[    8.734032] scsi0 : iSCSI Initiator over TCP/IP
[    8.991392] scsi 0:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[    8.995124] calling  init_sd+0x0/0x1000 [sd_mod] @ 2290
[    8.995995] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 833 usecs
[    8.999267] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.999841] sd 0:0:0:0: [sda] Write Protect is off
[    8.999852] sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
[    9.000230] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    9.003886]  sda: unknown partition table
[    9.005627] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.008859] calling  init_sg+0x0/0x1000 [sg] @ 2303
[    9.009224] sd 0:0:0:0: Attached scsi generic sg0 type 0

[    9.009265] initcall init_sg+0x0/0x1000 [sg] returned 0 after 380 usecs
[   14.059832] bio: create slab <bio-1> at 1
[   20.000116] switch: port 1(eth0) entered forwarding state
# poweroff
Feb 22 21:47:09 g-pvops init: starting pid 2464, tty '': '/etc/init.d/halt'
# Usage: /etc/init.d/halt {start}
The system is going down NOW!
Sent SIGTERM to all processes
Feb 22 21:47:09 g-pvops exiting on signal 15
Sent SIGKILL to all processes
Requesting system poweroff
[   44.590513] sd 0:0:0:0: shutdown
[   44.590947] vif vif-0: shutdown
[   44.603898] PM: Calling i8259A_shutdown+0x0/0x10
[   44.603928] System halted.
Parsing config from test.xm
Daemon running with PID 6859

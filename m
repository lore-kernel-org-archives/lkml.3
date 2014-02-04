Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaBDKqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:46:55 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51484 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaBDKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:46:46 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 4 Feb 2014 11:46:24 +0100
Message-ID: <CAH9NwWfSvvh5W4xB=TG+rAm5g5EVjHSwAGL5L15QG_vHmxvqQg@mail.gmail.com>
Subject: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some filesystem anomalies and and enabled all kind of debug
stuff and got the following:

[    1.265237]
[    1.266761] ======================================================
[    1.272969] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[    1.279699] 3.12.9 #1 Not tainted
[    1.283032] ------------------------------------------------------
[    1.289240] kworker/u4:2/43 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    1.296052]  (prepare_lock){+.+.+.}, at: [<c03bc8f0>]
clk_prepare_lock+0x3c/0xd8
[    1.303583]
[    1.303583] and this task is already holding:
[    1.309441]  (&(&host->lock)->rlock#2){-.-...}, at: [<c03a2e70>]
sdhci_do_set_ios+0x18/0x700
[    1.318035] which would create a new lock dependency:
[    1.323107]  (&(&host->lock)->rlock#2){-.-...} -> (prepare_lock){+.+.+.}
[    1.330019]
[    1.330019] but this new dependency connects a HARDIRQ-irq-safe lock:
[    1.337964]  (&(&host->lock)->rlock#2){-.-...}
... which became HARDIRQ-irq-safe at:
[    1.345915]   [<c0080008>] __lock_acquire+0xac4/0x1df8
[    1.351113]   [<c0081934>] lock_acquire+0xa4/0x158
[    1.355956]   [<c0487480>] _raw_spin_lock+0x40/0x50
[    1.360889]   [<c03a1838>] sdhci_irq+0x18/0xa2c
[    1.365469]   [<c006a190>] handle_irq_event_percpu+0x70/0x2d0
[    1.371276]   [<c006a42c>] handle_irq_event+0x3c/0x5c
[    1.376376]   [<c006d16c>] handle_fasteoi_irq+0xa4/0x138
[    1.381741]   [<c0069b58>] generic_handle_irq+0x20/0x30
[    1.387017]   [<c000eb54>] handle_IRQ+0x38/0x90
[    1.391600]   [<c000850c>] gic_handle_irq+0x28/0x5c
[    1.396526]   [<c0488304>] __irq_svc+0x44/0x78
[    1.401021]   [<c0487c78>] _raw_spin_unlock_irqrestore+0x64/0x68
[    1.407083]   [<c03b0a5c>] of_find_node_by_phandle+0x48/0x58
[    1.412797]   [<c03b108c>] __of_parse_phandle_with_args+0xc0/0x1f8
[    1.419033]   [<c03b1248>] of_parse_phandle_with_args+0x28/0x30
[    1.425008]   [<c027a654>] of_get_named_gpio_flags+0x60/0x88
[    1.430727]   [<c03a652c>] gpio_led_probe+0xa4/0x338
[    1.435747]   [<c02eb1e0>] platform_drv_probe+0x18/0x1c
[    1.441026]   [<c02ea2b0>] driver_probe_device+0xf4/0x208
[    1.446486]   [<c02ea458>] __driver_attach+0x94/0x98
[    1.451501]   [<c02e89ec>] bus_for_each_dev+0x54/0x88
[    1.456605]   [<c02e9984>] bus_add_driver+0xdc/0x264
[    1.461621]   [<c02ea85c>] driver_register+0x78/0xf4
[    1.466638]   [<c0008748>] do_one_initcall+0x34/0x15c
[    1.471741]   [<c0668c24>] kernel_init_freeable+0x158/0x228
[    1.477374]   [<c047d33c>] kernel_init+0x8/0xe4
[    1.481962]   [<c000e328>] ret_from_fork+0x14/0x2c
[    1.486807]
[    1.486807] to a HARDIRQ-irq-unsafe lock:
[    1.492321]  (prepare_lock){+.+.+.}
... which became HARDIRQ-irq-unsafe at:
[    1.499470] ...  [<c007e048>] mark_held_locks+0x64/0x138
[    1.504863]   [<c007e1c4>] trace_hardirqs_on_caller+0xa8/0x230
[    1.510749]   [<c0482de8>] mutex_trylock+0x160/0x1f0
[    1.515764]   [<c03bc8c0>] clk_prepare_lock+0xc/0xd8
[    1.520782]   [<c03bd180>] clk_notifier_register+0x24/0xe8
[    1.526321]   [<c0008748>] do_one_initcall+0x34/0x15c
[    1.531422]   [<c0668c24>] kernel_init_freeable+0x158/0x228
[    1.537050]   [<c047d33c>] kernel_init+0x8/0xe4
[    1.541630]   [<c000e328>] ret_from_fork+0x14/0x2c
[    1.546474]
[    1.546474] other info that might help us debug this:
[    1.546474]
[    1.554515]  Possible interrupt unsafe locking scenario:
[    1.554515]
[    1.561333]        CPU0                    CPU1
[    1.565884]        ----                    ----
[    1.570435]   lock(prepare_lock);
[    1.573816]                                local_irq_disable();
[    1.579759]                                lock(&(&host->lock)->rlock#2);
[    1.586640]                                lock(prepare_lock);
[    1.592542]   <Interrupt>
[    1.595180]     lock(&(&host->lock)->rlock#2);
[    1.599713]
[    1.599713]  *** DEADLOCK ***
[    1.599713]
[    1.605667] 3 locks held by kworker/u4:2/43:
[    1.609961]  #0:  (kmmcd){.+.+..}, at: [<c003cf38>]
process_one_work+0x12c/0x50c
[    1.617507]  #1:  ((&(&host->detect)->work)){+.+...}, at:
[<c003cf38>] process_one_work+0x12c/0x50c
[    1.626704]  #2:  (&(&host->lock)->rlock#2){-.-...}, at:
[<c03a2e70>] sdhci_do_set_ios+0x18/0x700
[    1.635752]
the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[    1.643396] -> (&(&host->lock)->rlock#2){-.-...} ops: 67 {
[    1.649045]    IN-HARDIRQ-W at:
[    1.652229]                     [<c0080008>] __lock_acquire+0xac4/0x1df8
[    1.658987]                     [<c0081934>] lock_acquire+0xa4/0x158
[    1.665394]                     [<c0487480>] _raw_spin_lock+0x40/0x50
[    1.671888]                     [<c03a1838>] sdhci_irq+0x18/0xa2c
[    1.678033]                     [<c006a190>]
handle_irq_event_percpu+0x70/0x2d0
[    1.685403]                     [<c006a42c>] handle_irq_event+0x3c/0x5c
[    1.692072]                     [<c006d16c>] handle_fasteoi_irq+0xa4/0x138
[    1.698999]                     [<c0069b58>] generic_handle_irq+0x20/0x30
[    1.705841]                     [<c000eb54>] handle_IRQ+0x38/0x90
[    1.711988]                     [<c000850c>] gic_handle_irq+0x28/0x5c
[    1.718479]                     [<c0488304>] __irq_svc+0x44/0x78
[    1.724539]                     [<c0487c78>]
_raw_spin_unlock_irqrestore+0x64/0x68
[    1.732166]                     [<c03b0a5c>]
of_find_node_by_phandle+0x48/0x58
[    1.739445]                     [<c03b108c>]
__of_parse_phandle_with_args+0xc0/0x1f8
[    1.747246]                     [<c03b1248>]
of_parse_phandle_with_args+0x28/0x30
[    1.754784]                     [<c027a654>]
of_get_named_gpio_flags+0x60/0x88
[    1.762066]                     [<c03a652c>] gpio_led_probe+0xa4/0x338
[    1.768646]                     [<c02eb1e0>] platform_drv_probe+0x18/0x1c
[    1.775488]                     [<c02ea2b0>] driver_probe_device+0xf4/0x208
[    1.782506]                     [<c02ea458>] __driver_attach+0x94/0x98
[    1.789087]                     [<c02e89ec>] bus_for_each_dev+0x54/0x88
[    1.795754]                     [<c02e9984>] bus_add_driver+0xdc/0x264
[    1.802334]                     [<c02ea85c>] driver_register+0x78/0xf4
[    1.808914]                     [<c0008748>] do_one_initcall+0x34/0x15c
[    1.815581]                     [<c0668c24>] kernel_init_freeable+0x158/0x228
[    1.822772]                     [<c047d33c>] kernel_init+0x8/0xe4
[    1.828920]                     [<c000e328>] ret_from_fork+0x14/0x2c
[    1.835331]    IN-SOFTIRQ-W at:
[    1.838514]                     [<c007fb08>] __lock_acquire+0x5c4/0x1df8
[    1.845270]                     [<c0081934>] lock_acquire+0xa4/0x158
[    1.851676]                     [<c0487580>] _raw_spin_lock_irqsave+0x4c/0x60
[    1.858866]                     [<c03a28b4>] sdhci_tasklet_finish+0x14/0x10c
[    1.865968]                     [<c00293ec>] tasklet_action+0x6c/0x108
[    1.872552]                     [<c0028874>] __do_softirq+0x108/0x2f0
[    1.879046]                     [<c0028b14>] do_softirq+0x68/0x70
[    1.885189]                     [<c0028e14>] irq_exit+0xb0/0xf4
[    1.891160]                     [<c000eb58>] handle_IRQ+0x3c/0x90
[    1.897307]                     [<c000850c>] gic_handle_irq+0x28/0x5c
[    1.903799]                     [<c0488304>] __irq_svc+0x44/0x78
[    1.909857]                     [<c0487c78>]
_raw_spin_unlock_irqrestore+0x64/0x68
[    1.917484]                     [<c03b0a5c>]
of_find_node_by_phandle+0x48/0x58
[    1.924762]                     [<c03b108c>]
__of_parse_phandle_with_args+0xc0/0x1f8
[    1.932562]                     [<c03b1248>]
of_parse_phandle_with_args+0x28/0x30
[    1.940101]                     [<c027a654>]
of_get_named_gpio_flags+0x60/0x88
[    1.947380]                     [<c03a652c>] gpio_led_probe+0xa4/0x338
[    1.953960]                     [<c02eb1e0>] platform_drv_probe+0x18/0x1c
[    1.960799]                     [<c02ea2b0>] driver_probe_device+0xf4/0x208
[    1.967816]                     [<c02ea458>] __driver_attach+0x94/0x98
[    1.974397]                     [<c02e89ec>] bus_for_each_dev+0x54/0x88
[    1.981063]                     [<c02e9984>] bus_add_driver+0xdc/0x264
[    1.987643]                     [<c02ea85c>] driver_register+0x78/0xf4
[    1.994223]                     [<c0008748>] do_one_initcall+0x34/0x15c
[    2.000890]                     [<c0668c24>] kernel_init_freeable+0x158/0x228
[    2.008082]                     [<c047d33c>] kernel_init+0x8/0xe4
[    2.014228]                     [<c000e328>] ret_from_fork+0x14/0x2c
[    2.020636]    INITIAL USE at:
[    2.023731]                    [<c007f844>] __lock_acquire+0x300/0x1df8
[    2.030400]                    [<c0081934>] lock_acquire+0xa4/0x158
[    2.036720]                    [<c0487580>] _raw_spin_lock_irqsave+0x4c/0x60
[    2.043823]                    [<c03a2e70>] sdhci_do_set_ios+0x18/0x700
[    2.050491]                    [<c03907d0>] mmc_power_up+0x78/0xdc
[    2.056726]                    [<c03913d4>] mmc_start_host+0x38/0x50
[    2.063133]                    [<c03920ac>] mmc_add_host+0x58/0x74
[    2.069368]                    [<c03a3d50>] sdhci_add_host+0x7f0/0xba8
[    2.075950]                    [<c03a50c8>] sdhci_esdhc_imx_probe+0x28c/0x4f0
[    2.083139]                    [<c02eb1e0>] platform_drv_probe+0x18/0x1c
[    2.089892]                    [<c02ea2b0>] driver_probe_device+0xf4/0x208
[    2.096823]                    [<c02ea458>] __driver_attach+0x94/0x98
[    2.103317]                    [<c02e89ec>] bus_for_each_dev+0x54/0x88
[    2.109897]                    [<c02e9984>] bus_add_driver+0xdc/0x264
[    2.116390]                    [<c02ea85c>] driver_register+0x78/0xf4
[    2.122883]                    [<c0008748>] do_one_initcall+0x34/0x15c
[    2.129465]                    [<c0668c24>] kernel_init_freeable+0x158/0x228
[    2.136571]                    [<c047d33c>] kernel_init+0x8/0xe4
[    2.142631]                    [<c000e328>] ret_from_fork+0x14/0x2c
[    2.148953]  }
[    2.150636]  ... key      at: [<c0cbebb8>] __key.24056+0x0/0x8
[    2.156525]  ... acquired at:
[    2.159512]    [<c007d58c>] check_irq_usage+0x50/0xb0
[    2.164616]    [<c0080560>] __lock_acquire+0x101c/0x1df8
[    2.169980]    [<c0081934>] lock_acquire+0xa4/0x158
[    2.174908]    [<c04849f8>] mutex_lock_nested+0x58/0x3e0
[    2.180270]    [<c03bc8f0>] clk_prepare_lock+0x3c/0xd8
[    2.185461]    [<c03bd3f0>] clk_get_rate+0xc/0x5c
[    2.190214]    [<c03a4940>] esdhc_pltfm_set_clock+0x14/0x1cc
[    2.195925]    [<c03a24d4>] sdhci_set_clock+0x44/0x410
[    2.201113]    [<c03a3168>] sdhci_do_set_ios+0x310/0x700
[    2.206474]    [<c0390468>] mmc_set_chip_select+0x18/0x1c
[    2.211924]    [<c0394838>] mmc_go_idle+0xdc/0xf8
[    2.216680]    [<c0392b34>] mmc_init_card+0x48/0x1424
[    2.221781]    [<c03940e0>] mmc_attach_mmc+0xc4/0x1cc
[    2.226882]    [<c039134c>] mmc_rescan+0x280/0x2d0
[    2.231720]    [<c003cfb4>] process_one_work+0x1a8/0x50c
[    2.237082]    [<c003d748>] worker_thread+0x144/0x3a4
[    2.242182]    [<c0043de0>] kthread+0xa4/0xb0
[    2.246595]    [<c000e328>] ret_from_fork+0x14/0x2c
[    2.251524]
[    2.253033]
the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[    2.261455] -> (prepare_lock){+.+.+.} ops: 312 {
[    2.266213]    HARDIRQ-ON-W at:
[    2.269396]                     [<c007e048>] mark_held_locks+0x64/0x138
[    2.276067]                     [<c007e1c4>]
trace_hardirqs_on_caller+0xa8/0x230
[    2.283521]                     [<c0482de8>] mutex_trylock+0x160/0x1f0
[    2.290101]                     [<c03bc8c0>] clk_prepare_lock+0xc/0xd8
[    2.296682]                     [<c03bd180>] clk_notifier_register+0x24/0xe8
[    2.303785]                     [<c0008748>] do_one_initcall+0x34/0x15c
[    2.310452]                     [<c0668c24>] kernel_init_freeable+0x158/0x228
[    2.317645]                     [<c047d33c>] kernel_init+0x8/0xe4
[    2.323791]                     [<c000e328>] ret_from_fork+0x14/0x2c
[    2.330199]    SOFTIRQ-ON-W at:
[    2.333383]                     [<c007e048>] mark_held_locks+0x64/0x138
[    2.340053]                     [<c007e228>]
trace_hardirqs_on_caller+0x10c/0x230
[    2.347594]                     [<c0482de8>] mutex_trylock+0x160/0x1f0
[    2.354175]                     [<c03bc8c0>] clk_prepare_lock+0xc/0xd8
[    2.360755]                     [<c03bd180>] clk_notifier_register+0x24/0xe8
[    2.367858]                     [<c0008748>] do_one_initcall+0x34/0x15c
[    2.374525]                     [<c0668c24>] kernel_init_freeable+0x158/0x228
[    2.381716]                     [<c047d33c>] kernel_init+0x8/0xe4
[    2.387862]                     [<c000e328>] ret_from_fork+0x14/0x2c
[    2.394270]    RECLAIM_FS-ON-W at:
[    2.397715]                        [<c007e048>] mark_held_locks+0x64/0x138
[    2.404645]                        [<c007e9e8>]
lockdep_trace_alloc+0x90/0x10c
[    2.411926]                        [<c0106494>]
kmem_cache_alloc_trace+0x34/0x1e0
[    2.419470]                        [<c03bd204>]
clk_notifier_register+0xa8/0xe8
[    2.426837]                        [<c0008748>] do_one_initcall+0x34/0x15c
[    2.433765]                        [<c0668c24>]
kernel_init_freeable+0x158/0x228
[    2.441220]                        [<c047d33c>] kernel_init+0x8/0xe4
[    2.447627]                        [<c000e328>] ret_from_fork+0x14/0x2c
[    2.454297]    INITIAL USE at:
[    2.457393]                    [<c007f844>] __lock_acquire+0x300/0x1df8
[    2.464064]                    [<c0081934>] lock_acquire+0xa4/0x158
[    2.470386]                    [<c0482d7c>] mutex_trylock+0xf4/0x1f0
[    2.476792]                    [<c03bc8c0>] clk_prepare_lock+0xc/0xd8
[    2.483285]                    [<c03be6bc>] __clk_init+0x18/0x428
[    2.489435]                    [<c03beb94>] _clk_register+0xc8/0x15c
[    2.495842]                    [<c03beccc>] clk_register+0x38/0x80
[    2.502075]                    [<c03bf5f0>] clk_register_fixed_rate+0x84/0xcc
[    2.509267]                    [<c03bf698>] of_fixed_clk_setup+0x60/0x88
[    2.516022]                    [<c06975d0>] of_clk_init+0x3c/0x64
[    2.522176]                    [<c0671eb8>] imx6q_timer_init+0xc/0x4c
[    2.528674]                    [<c066b2f4>] time_init+0x1c/0x2c
[    2.534652]                    [<c0668954>] start_kernel+0x1c4/0x33c
[    2.541061]                    [<10008074>] 0x10008074
[    2.546249]  }
[    2.547933]  ... key      at: [<c06ee6d8>] prepare_lock+0x38/0x48
[    2.554087]  ... acquired at:
[    2.557075]    [<c007d58c>] check_irq_usage+0x50/0xb0
[    2.562180]    [<c0080560>] __lock_acquire+0x101c/0x1df8
[    2.567542]    [<c0081934>] lock_acquire+0xa4/0x158
[    2.572470]    [<c04849f8>] mutex_lock_nested+0x58/0x3e0
[    2.577831]    [<c03bc8f0>] clk_prepare_lock+0x3c/0xd8
[    2.583021]    [<c03bd3f0>] clk_get_rate+0xc/0x5c
[    2.587774]    [<c03a4940>] esdhc_pltfm_set_clock+0x14/0x1cc
[    2.593486]    [<c03a24d4>] sdhci_set_clock+0x44/0x410
[    2.598673]    [<c03a3168>] sdhci_do_set_ios+0x310/0x700
[    2.604036]    [<c0390468>] mmc_set_chip_select+0x18/0x1c
[    2.609487]    [<c0394838>] mmc_go_idle+0xdc/0xf8
[    2.614241]    [<c0392b34>] mmc_init_card+0x48/0x1424
[    2.619341]    [<c03940e0>] mmc_attach_mmc+0xc4/0x1cc
[    2.624442]    [<c039134c>] mmc_rescan+0x280/0x2d0
[    2.629282]    [<c003cfb4>] process_one_work+0x1a8/0x50c
[    2.634644]    [<c003d748>] worker_thread+0x144/0x3a4
[    2.639745]    [<c0043de0>] kthread+0xa4/0xb0
[    2.644154]    [<c000e328>] ret_from_fork+0x14/0x2c
[    2.649085]
[    2.650594]
[    2.650594] stack backtrace:
[    2.654984] CPU: 1 PID: 43 Comm: kworker/u4:2 Not tainted 3.12.9 #1
[    2.661285] Workqueue: kmmcd mmc_rescan
[    2.665188] [<c00144d4>] (unwind_backtrace+0x0/0xf8) from
[<c0011a3c>] (show_stack+0x10/0x14)
[    2.673766] [<c0011a3c>] (show_stack+0x10/0x14) from [<c0481f58>]
(dump_stack+0x64/0xa4)
[    2.681905] [<c0481f58>] (dump_stack+0x64/0xa4) from [<c007d368>]
(check_usage+0x408/0x5dc)
[    2.690302] [<c007d368>] (check_usage+0x408/0x5dc) from
[<c007d58c>] (check_irq_usage+0x50/0xb0)
[    2.699130] [<c007d58c>] (check_irq_usage+0x50/0xb0) from
[<c0080560>] (__lock_acquire+0x101c/0x1df8)
[    2.708395] [<c0080560>] (__lock_acquire+0x101c/0x1df8) from
[<c0081934>] (lock_acquire+0xa4/0x158)
[    2.717483] [<c0081934>] (lock_acquire+0xa4/0x158) from
[<c04849f8>] (mutex_lock_nested+0x58/0x3e0)
[    2.726576] [<c04849f8>] (mutex_lock_nested+0x58/0x3e0) from
[<c03bc8f0>] (clk_prepare_lock+0x3c/0xd8)
[    2.735929] [<c03bc8f0>] (clk_prepare_lock+0x3c/0xd8) from
[<c03bd3f0>] (clk_get_rate+0xc/0x5c)
[    2.744670] [<c03bd3f0>] (clk_get_rate+0xc/0x5c) from [<c03a4940>]
(esdhc_pltfm_set_clock+0x14/0x1cc)
[    2.753932] [<c03a4940>] (esdhc_pltfm_set_clock+0x14/0x1cc) from
[<c03a24d4>] (sdhci_set_clock+0x44/0x410)
[    2.763631] [<c03a24d4>] (sdhci_set_clock+0x44/0x410) from
[<c03a3168>] (sdhci_do_set_ios+0x310/0x700)
[    2.772982] [<c03a3168>] (sdhci_do_set_ios+0x310/0x700) from
[<c0390468>] (mmc_set_chip_select+0x18/0x1c)
[    2.782595] [<c0390468>] (mmc_set_chip_select+0x18/0x1c) from
[<c0394838>] (mmc_go_idle+0xdc/0xf8)
[    2.791597] [<c0394838>] (mmc_go_idle+0xdc/0xf8) from [<c0392b34>]
(mmc_init_card+0x48/0x1424)
[    2.800249] [<c0392b34>] (mmc_init_card+0x48/0x1424) from
[<c03940e0>] (mmc_attach_mmc+0xc4/0x1cc)
[    2.809251] [<c03940e0>] (mmc_attach_mmc+0xc4/0x1cc) from
[<c039134c>] (mmc_rescan+0x280/0x2d0)
[    2.817988] [<c039134c>] (mmc_rescan+0x280/0x2d0) from [<c003cfb4>]
(process_one_work+0x1a8/0x50c)
[    2.826988] [<c003cfb4>] (process_one_work+0x1a8/0x50c) from
[<c003d748>] (worker_thread+0x144/0x3a4)
[    2.836253] [<c003d748>] (worker_thread+0x144/0x3a4) from
[<c0043de0>] (kthread+0xa4/0xb0)
[    2.844562] [<c0043de0>] (kthread+0xa4/0xb0) from [<c000e328>]
(ret_from_fork+0x14/0x2c)
[    2.854183] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.860894] [drm] No driver support for vblank timestamp query.
[    2.866875] [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
[    2.874731] imx-ipuv3 2400000.ipu: IPUv3H probed
[    2.880040] imx-ipuv3 2800000.ipu: IPUv3H probed
[    2.885687] TCP: cubic registered
[    2.889041] NET: Registered protocol family 17
[    2.893719] Key type dns_resolver registered
[    2.898360] ThumbEE CPU extension supported.
[    2.902728] Registering SWP/SWPB emulation handler
[    2.908105] registered taskstats version 1
[    2.913186] ci_hdrc ci_hdrc.0: doesn't support gadget
[    2.918284] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    2.923253] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[    2.924028] mmc0: BKOPS_EN bit is not set
[    2.930922] mmc0: new high speed MMC card at address 0001
[    2.939922] mmcblk0: mmc0:0001 SEM04G 3.68 GiB
[    2.945589]  mmcblk0: p1 p2
[    2.959204] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00

Any ideas?

--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner

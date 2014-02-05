Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaBEQK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:10:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51351 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaBEQK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:10:56 -0500
Message-ID: <52F26F53.20408@ti.com>
Date: Wed, 5 Feb 2014 19:05:23 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Illia Smyrnov <illia.smyrnov@globallogic.com>,
        =?ISO-8859-1?Q?Beno=EE?= =?ISO-8859-1?Q?t_Cousson?= 
	<bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: hwmod: Fix SOFTRESET logic for OMAP4
References: <1391612769-27890-1-git-send-email-illia.smyrnov@globallogic.com>
In-Reply-To: <1391612769-27890-1-git-send-email-illia.smyrnov@globallogic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
On 02/05/2014 05:06 PM, Illia Smyrnov wrote:
> Commit 313a76e (ARM: OMAP2+: hwmod: Fix SOFTRESET logic) introduced
> softreset bit cleaning right after set one. It is caused L3 error for
> OMAP4 ISS because ISS register write occurs when ISS reset process is in
> progress. Avoid this situation by cleaning softreset bit later, when reset
> process is successfully finished.

I'd like to mention that this issue has been caught while upgrading
custom Linux Kernel 3.4 to the last Stable Kernel linux-3.4.y.
So, the same OMAP4+ functionality can be broken in all Stable trees
where commit "ARM: OMAP2+: hwmod: Fix SOFTRESET logic" was merged to.

On OMAP4+ we should always try to wait until IP reset is finished before proceed.

Reviewed-by: "Grygorii Strashko <grygorii.strashko@ti.com>"

Error log example (k3.4): 

[ 5766.575347] ------------[ cut here ]------------
[ 5766.580749] WARNING: at arch/arm/mach-omap2/omap_l3_noc.c:97 l3_interrupt_handler+0xc0/0x170()
[ 5766.590209] L3 standard error: TARGET:ISS  at address 0x10
[ 5766.596435] Modules linked in: wlcore_sdio(O) wl18xx(O) wl12xx(O) wlcore(O) mac80211(O) pvrsrvkm_sgx544_112(O) cfg80211(O) compat(O)
[ 5766.611022] Backtrace:
[ 5766.614013] [<c00180ec>] (dump_backtrace+0x0/0x10c) from [<c065d448>] (dump_stack+0x18/0x1c)
[ 5766.623413]  r6:c003a19c r5:00000009 r4:c0921d80 r3:c0982f10
[ 5766.630340] [<c065d430>] (dump_stack+0x0/0x1c) from [<c0046cf4>] (warn_slowpath_common+0x54/0x6c)
[ 5766.640258] [<c0046ca0>] (warn_slowpath_common+0x0/0x6c) from [<c0046db0>] (warn_slowpath_fmt+0x38/0x40)
[ 5766.650787]  r8:00000000 r7:00000018 r6:c06712c4 r5:80080001 r4:e08f4400
[ 5766.658630] r3:00000009
[ 5766.661926] [<c0046d78>] (warn_slowpath_fmt+0x0/0x40) from [<c003a19c>] (l3_interrupt_handler+0xc0/0x170)
[ 5766.672546]  r3:c080790c r2:c0807858
[ 5766.676910] [<c003a0dc>] (l3_interrupt_handler+0x0/0x170) from [<c00a8bc0>] (handle_irq_event_percpu+0x64/0x2b0)
[ 5766.688201]  r8:00000000 r7:0000002a r6:0000002a r5:c0924190 r4:d6cbeac0
[ 5766.696533] [<c00a8b5c>] (handle_irq_event_percpu+0x0/0x2b0) from [<c00a8e50>] (handle_irq_event+0x44/0x64)
[ 5766.707244] [<c00a8e0c>] (handle_irq_event+0x0/0x64) from [<c00abb80>] (handle_fasteoi_irq+0xa0/0x160)
[ 5766.717620]  r6:c0920000 r5:c0924190 r4:c0924140 r3:00000000
[ 5766.724639] [<c00abae0>] (handle_fasteoi_irq+0x0/0x160) from [<c00a83ac>] (generic_handle_irq+0x30/0x44)
[ 5766.735198]  r5:c091e538 r4:c0946d40
[ 5766.739562] [<c00a837c>] (generic_handle_irq+0x0/0x44) from [<c0014b88>] (handle_IRQ+0x54/0xb8)
[ 5766.749267] [<c0014b34>] (handle_IRQ+0x0/0xb8) from [<c00084d0>] (gic_handle_irq+0x2c/0x60)
[ 5766.758453]  r8:00000000 r7:c0921ed4 r6:c0921ea0 r5:c0945a00 r4:e0802100
[ 5766.766448] r3:c008aeb8
[ 5766.769744] [<c00084a4>] (gic_handle_irq+0x0/0x60) from [<c06678c0>] (__irq_svc+0x40/0x70)
[ 5766.778991] Exception stack(0xc0921ea0 to 0xc0921ee8)
[ 5766.784637] 1ea0: c0921ee8 000be65e a237f8b7 0000053e a2378182 0000053e c1858498 00000000
[ 5766.793762] 1ec0: 00000000 c095645c c0a3350c c0921f14 00001686 c0921ee8 c008aeb8 c042e5b4
[ 5766.802886] 1ee0: 60070013 ffffffff
[ 5766.806823]  r6:ffffffff r5:60070013 r4:c042e5b4 r3:c008aeb8
[ 5766.813903] [<c042e564>] (cpuidle_wrap_enter+0x0/0x9c) from [<c042db94>] (cpuidle_enter_tk+0x18/0x1c)
[ 5766.824035]  r7:c09c35b4 r6:c1858498 r5:00000000 r4:c1858498
[ 5766.830963] [<c042db7c>] (cpuidle_enter_tk+0x0/0x1c) from [<c042e0b0>] (cpuidle_enter_state+0x1c/0x78)
[ 5766.841339] [<c042e094>] (cpuidle_enter_state+0x0/0x78) from [<c042e1ec>] (cpuidle_idle_call+0xe0/0x31c)
[ 5766.851898]  r6:c0920000 r5:00000000 r4:c1858498 r3:0000004c
[ 5766.858825] [<c042e10c>] (cpuidle_idle_call+0x0/0x31c) from [<c00152b4>] (cpu_idle+0xa4/0x10c)
[ 5766.868438] [<c0015210>] (cpu_idle+0x0/0x10c) from [<c063ce50>] (rest_init+0x74/0x8c)
[ 5766.877227] [<c063cddc>] (rest_init+0x0/0x8c) from [<c08c7864>] (start_kernel+0x2b4/0x304)
[ 5766.886352]  r4:c0946b20 r3:c0982f10
[ 5766.890808] [<c08c75b0>] (start_kernel+0x0/0x304) from [<80008044>] (0x80008044)
[ 5766.898986] Board Information:
[ 5766.898986]  Revision : 20edb4
[ 5766.899017]  Serial  : 0000000000000000
[ 5766.899017] SoC Information:
[ 5766.899017]  CPU     : OMAP4470
[ 5766.899017]  Rev     : ES1.0
[ 5766.899047]  Type    : HS
[ 5766.899047]  Production ID: 0002B975-000000CC
[ 5766.899047]  Die ID  : 76080000-30002FFF-01518C70-0D00F007
[ 5766.899047]
[ 5766.935028] ---[ end trace 5f7d6da5db258915 ]---
[ 5766.948150] virtio_rpmsg_bus virtio1: destroying channel rpmsg-resmgr addr 0x66
[ 5767.098541] virtio_rpmsg_bus virtio1: creating channel rpmsg-resmgr addr 0x66
[ 5769.519683] ------------[ cut here ]------------
[ 5769.524749] WARNING: at arch/arm/mach-omap2/omap_l3_noc.c:97 l3_interrupt_handler+0xc0/0x170()
[ 5769.534149] L3 standard error: TARGET:ISS  at address 0x10
[ 5769.540100] Modules linked in: wlcore_sdio(O) wl18xx(O) wl12xx(O) wlcore(O) mac80211(O) pvrsrvkm_sgx544_112(O) cfg80211(O) compat(O)
[ 5769.553802] Backtrace:
[ 5769.556610] [<c00180ec>] (dump_backtrace+0x0/0x10c) from [<c065d448>] (dump_stack+0x18/0x1c)
[ 5769.565734]  r6:c003a19c r5:00000009 r4:ca453a68 r3:c0982f10
[ 5769.572296] [<c065d430>] (dump_stack+0x0/0x1c) from [<c0046cf4>] (warn_slowpath_common+0x54/0x6c)
[ 5769.581970] [<c0046ca0>] (warn_slowpath_common+0x0/0x6c) from [<c0046db0>] (warn_slowpath_fmt+0x38/0x40)
[ 5769.592285]  r8:00000000 r7:00000018 r6:c06712c4 r5:80080001 r4:e08f4400
[ 5769.599700] r3:00000009
[ 5769.602783] [<c0046d78>] (warn_slowpath_fmt+0x0/0x40) from [<c003a19c>] (l3_interrupt_handler+0xc0/0x170)
[ 5769.613189]  r3:c080790c r2:c0807858
[ 5769.617340] [<c003a0dc>] (l3_interrupt_handler+0x0/0x170) from [<c00a8bc0>] (handle_irq_event_percpu+0x64/0x2b0)
[ 5769.628356]  r8:00000000 r7:0000002a r6:0000002a r5:c0924190 r4:d6cbeac0
[ 5769.636108] [<c00a8b5c>] (handle_irq_event_percpu+0x0/0x2b0) from [<c00a8e50>] (handle_irq_event+0x44/0x64)
[ 5769.646728] [<c00a8e0c>] (handle_irq_event+0x0/0x64) from [<c00abb80>] (handle_fasteoi_irq+0xa0/0x160)
[ 5769.656860]  r6:ca452000 r5:c0924190 r4:c0924140 r3:00000000
[ 5769.663360] [<c00abae0>] (handle_fasteoi_irq+0x0/0x160) from [<c00a83ac>] (generic_handle_irq+0x30/0x44)
[ 5769.673675]  r5:c091e538 r4:c0946d40
[ 5769.677764] [<c00a837c>] (generic_handle_irq+0x0/0x44) from [<c0014b88>] (handle_IRQ+0x54/0xb8)
[ 5769.687255] [<c0014b34>] (handle_IRQ+0x0/0xb8) from [<c00084d0>] (gic_handle_irq+0x2c/0x60)
[ 5769.696380]  r8:d6cf3f40 r7:ca453bbc r6:ca453b88 r5:c0945a00 r4:e0802100
[ 5769.703857] r3:c0029070
[ 5769.706909] [<c00084a4>] (gic_handle_irq+0x0/0x60) from [<c06678c0>] (__irq_svc+0x40/0x70)
[ 5769.715881] Exception stack(0xca453b88 to 0xca453bd0)
[ 5769.721435] 3b80:                   c0964d98 a0000013 00000010 00000000 00000000 c0964d98
[ 5769.730377] 3ba0: a0000013 d6cf3f40 d6cf3f40 3b9aca00 00000000 ca453bdc ca453be0 ca453bd0
[ 5769.739227] 3bc0: c0029070 c0666d68 60000013 ffffffff
[ 5769.744781]  r6:ffffffff r5:60000013 r4:c0666d68 r3:c0029070
[ 5769.751281] [<c0666d44>] (_raw_spin_unlock_irqrestore+0x0/0x50) from [<c0029070>] (omap_hwmod_reset+0x3c/0x4c)
[ 5769.762176] [<c0029034>] (omap_hwmod_reset+0x0/0x4c) from [<c0024d30>] (omap_cam_deactivate+0x30/0x48)
[ 5769.772308]  r6:d6cf3fc0 r5:d6cf3fc0 r4:00000001 r3:d6cf3f80
[ 5769.778869] [<c0024d00>] (omap_cam_deactivate+0x0/0x48) from [<c0040bc4>] (_omap_device_deactivate+0xb4/0x14c)
[ 5769.789703]  r5:d6cf1608 r4:d6cf3fc0
[ 5769.793853] [<c0040b10>] (_omap_device_deactivate+0x0/0x14c) from [<c0041434>] (omap_device_idle+0x30/0x5c)
[ 5769.804473] [<c0041404>] (omap_device_idle+0x0/0x5c) from [<c0041520>] (omap_device_runtime_suspend+0x24/0x2c)
[ 5769.815277]  r4:00000000 r3:00000000
[ 5769.819396] [<c00414fc>] (omap_device_runtime_suspend+0x0/0x2c) from [<c02f1d5c>] (__rpm_callback+0x3c/0x78)
[ 5769.830078]  r5:d6cf1668 r4:d6cf1608
[ 5769.834167] [<c02f1d20>] (__rpm_callback+0x0/0x78) from [<c02f2270>] (rpm_suspend+0x254/0x728)
[ 5769.843566]  r6:00000000 r5:00000000 r4:d6cf1608 r3:c09827ec
[ 5769.850067] [<c02f201c>] (rpm_suspend+0x0/0x728) from [<c02f385c>] (__pm_runtime_suspend+0x60/0x84)
[ 5769.859924] [<c02f37fc>] (__pm_runtime_suspend+0x0/0x84) from [<c02eea28>] (pm_generic_runtime_idle+0x4c/0x58)
[ 5769.870819]  r7:60000013 r6:c0040978 r5:d6cf1668 r4:d6cf1608
[ 5769.877319] [<c02ee9dc>] (pm_generic_runtime_idle+0x0/0x58) from [<c0040988>] (_od_runtime_idle+0x10/0x14)
[ 5769.887817]  r4:d6cf1608 r3:00000000
[ 5769.891967] [<c0040978>] (_od_runtime_idle+0x0/0x14) from [<c02f1d5c>] (__rpm_callback+0x3c/0x78)
[ 5769.901580] [<c02f1d20>] (__rpm_callback+0x0/0x78) from [<c02f28c0>] (rpm_idle+0x100/0x290)
[ 5769.910675]  r6:00000000 r5:00000004 r4:d6cf1608 r3:00000088
[ 5769.917236] [<c02f27c0>] (rpm_idle+0x0/0x290) from [<c02f2b2c>] (__pm_runtime_idle+0x60/0x84)
[ 5769.926452]  r8:ce7b2c00 r7:60000013 r6:d6cf1668 r5:00000004 r4:d6cf1608
[ 5769.933959] r3:d6cf16ec
[ 5769.937042] [<c02f2acc>] (__pm_runtime_idle+0x0/0x84) from [<c0473100>] (_device_release+0x34/0x38)
[ 5769.946899]  r7:cf2a3288 r6:ce7b2c08 r5:d6cf1608 r4:d5f9b440
[ 5769.953460] [<c04730cc>] (_device_release+0x0/0x38) from [<c0473b74>] (rprm_iss_release+0x10/0x38)
[ 5769.963165]  r5:ce7b2c08 r4:cf2a32c0
[ 5769.967315] [<c0473b64>] (rprm_iss_release+0x0/0x38) from [<c0471f90>] (_resource_release+0x40/0xdc)
[ 5769.977172]  r4:cf2a32c0 r3:c0473b64
[ 5769.981323] [<c0471f50>] (_resource_release+0x0/0xdc) from [<c04722f8>] (rprm_cb+0x270/0x680)
[ 5769.990631]  r6:00000000 r5:ce7b2c08 r4:cf2a32a0 r3:00000000
[ 5769.997131] [<c0472088>] (rprm_cb+0x0/0x680) from [<c0470e50>] (rpmsg_recv_done+0x108/0x220)
[ 5770.006347] [<c0470d48>] (rpmsg_recv_done+0x0/0x220) from [<c02ab2f8>] (vring_interrupt+0x40/0x58)
[ 5770.016113] [<c02ab2b8>] (vring_interrupt+0x0/0x58) from [<c046f728>] (rproc_vq_interrupt+0x3c/0x50)
[ 5770.026000] [<c046f6ec>] (rproc_vq_interrupt+0x0/0x50) from [<c04707c4>] (_vq_interrupt_thread+0x1c/0x44)
[ 5770.036437] [<c04707a8>] (_vq_interrupt_thread+0x0/0x44) from [<c0066764>] (kthread+0x90/0x9c)
[ 5770.045806]  r5:cf2e9cc0 r4:cf937e44
[ 5770.049896] [<c00666d4>] (kthread+0x0/0x9c) from [<c004ac04>] (do_exit+0x0/0x7b4)
[ 5770.058074]  r6:c004ac04 r5:c00666d4 r4:cf937e44
[ 5770.063385] Board Information:
[ 5770.063385]  Revision : 20edb4
[ 5770.063385]  Serial  : 0000000000000000
[ 5770.063385] SoC Information:
[ 5770.063385]  CPU     : OMAP4470
[ 5770.063385]  Rev     : ES1.0
[ 5770.063415]  Type    : HS
[ 5770.063415]  Production ID: 0002B975-000000CC
[ 5770.063415]  Die ID  : 76080000-30002FFF-01518C70-0D00F007
[ 5770.063415]
[ 5770.098297] ---[ end trace 5f7d6da5db258916 ]---
[ 5770.110778] virtio_rpmsg_bus virtio1: destroying channel rpmsg-resmgr addr 0x66
[ 5770.266723] virtio_rpmsg_bus virtio1: creating channel rpmsg-resmgr addr 0x66


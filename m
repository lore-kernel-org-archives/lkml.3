Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaE3WqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:46:13 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:63949 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaE3WqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:46:11 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140530190502.GA15360@redhat.com>
References: <20140530190502.GA15360@redhat.com>
Date: Sat, 31 May 2014 00:46:10 +0200
Message-ID: <CAKMK7uFe=kCq31DGpCwn+S-DZ1YnwVbFbDbt5h85v4tqGU96Tw@mail.gmail.com>
Subject: Re: 3.15-rc7 i915 related dma-debug warning.
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

You'll get piles of those, and you get to rewrite the (x86) dma
implementation to fix them.

There's two parts of the problem:
- We hang onto dma mappings forever, and we don't enforce any
ownership. Actually we can't since our userspace _wants_ to access
some memory ranges while the gpu is doing the same, usually in a write
ahead or read behind ringbuffer thing. Not sure how to convey this to
the dma functions.
- x86 dma believes everything is cache coherent, which isn't true. So
i915 gets to do it's own dma coherency tracking and cpu flushing
behind everyone's back. Also coherency can be decided on a
per-transaction level, so atm not possible to map that onto the dma
api even. Would be nice though since on atom socs there's other
devices/drivers with noncoherent access, and they all reinvent that
wheel.

Dunno what to do about the warning, it's definitely bogus though.
Adding dri-devel.
-Daniel


On Fri, May 30, 2014 at 9:05 PM, Dave Jones <davej@redhat.com> wrote:
> WARNING: CPU: 1 PID: 24000 at lib/dma-debug.c:593 debug_dma_assert_idle+0x1a4/0x220()
> i915 0000:00:02.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x0000000004401d40]
> Modules linked in: ccm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iTCO_wdt iTCO_vendor_support arc4 x86_pkg_temp_thermal coretemp iwldvm kvm_intel mac80211 kvm snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc snd_hda_codec_realtek videobuf2_memops snd_hda_codec_generic btusb videobuf2_core bluetooth videodev iwlwifi snd_hda_intel sdhci_pci microcode snd_hda_controller snd_hda_codec sdhci serio_raw media snd_hwdep snd_seq snd_seq_device mmc_core snd_pcm lpc_ich mfd_core cfg80211
>  i2c_i801 mei_me snd_timer mei thinkpad_acpi snd soundcore rfkill shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c dm_crypt nouveau crct10dif_pclmul crc32_pclmul crc32c_intel mxm_wmi ghash_clmulni_intel i915 ttm i2c_algo_bit drm_kms_helper drm e1000e i2c_core ptp wmi pps_core video
> CPU: 1 PID: 24000 Comm: bash Not tainted 3.15.0-0.rc7.git2.1.fc21.x86_64 #1
> Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
>  0000000000000000 000000002464519d ffff880113655c58 ffffffff817ea4ea
>  ffff880113655ca0 ffff880113655c90 ffffffff81095cbd ffff8801372ed150
>  ffff8801363456c0 0000000001ffa1f0 ffffea000450c880 ffff88011b3b9078
> Call Trace:
>  [<ffffffff817ea4ea>] dump_stack+0x4d/0x66
>  [<ffffffff81095cbd>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81095d3c>] warn_slowpath_fmt+0x5c/0x80
>  [<ffffffff814006d4>] debug_dma_assert_idle+0x1a4/0x220
>  [<ffffffff811e28b5>] do_wp_page+0xe5/0x960
>  [<ffffffff811e5e44>] handle_mm_fault+0x924/0x1110
>  [<ffffffff817f7c9c>] ? __do_page_fault+0x16c/0x600
>  [<ffffffff817f7d06>] __do_page_fault+0x1d6/0x600
>  [<ffffffff810addfb>] ? __set_current_blocked+0x2b/0x50
>  [<ffffffff810f951d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff817f2e2c>] ? _raw_spin_unlock_irq+0x2c/0x40
>  [<ffffffff817f8152>] do_page_fault+0x22/0x30
>  [<ffffffff817f3ef8>] page_fault+0x28/0x30
> ---[ end trace 301c1ffd35eb28d9 ]---
> Mapped at:
>  [<ffffffff813feca2>] debug_dma_map_sg+0x52/0x190
>  [<ffffffffa0177eeb>] i915_gem_gtt_prepare_object+0xdb/0x110 [i915]
>  [<ffffffffa017f05d>] i915_gem_object_pin+0x42d/0x780 [i915]
>  [<ffffffffa0181a5f>] i915_gem_fault+0x2ff/0x410 [i915]
>  [<ffffffff811e0cfc>] __do_fault+0x4c/0x120
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

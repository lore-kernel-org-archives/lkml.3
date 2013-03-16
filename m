Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3CPQL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:11:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51635 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3CPQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130315132607.GA4565@quad>
References: <20130315132607.GA4565@quad>
Date: Sat, 16 Mar 2013 12:11:26 -0400
Message-ID: <CAOULuObGX24KK+i88WT1PSN4_o3zFYuyyyZAcQPXqm-3xGrW0g@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Parag Warudkar <parag.lkml@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
        akpm@linux-foundation.org, acme@redhat.com, jolsa@redhat.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:26 AM, Stephane Eranian <eranian@google.com> wrote:
>
> This patch fixes a kernel crash when using precise sampling (PEBS)
> after a suspend/resume. Turns out the CPU notifier code is not invoked
> on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
> by the kernel and keeps it power-on/resume value of 0 causing any PEBS
> measurement to crash when running on CPU0.
>
> The workaround is to add a hook in the actual resume code to restore
> the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
> the DS_AREA will be restored twice but this is harmless.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 826054a..0e9bdd3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -729,3 +729,11 @@ void intel_ds_init(void)
>                 }
>         }
>  }
> +
> +void perf_restore_debug_store(void)
> +{
> +       if (!x86_pmu.bts && !x86_pmu.pebs)
> +               return;
> +
> +       init_debug_store_on_cpu(smp_processor_id());
> +}

This seems to trigger a WARN_ON during suspend/resume.

[ 1479.919313] WARNING: at kernel/smp.c:244
smp_call_function_single+0x11b/0x170()
[ 1479.919314] Hardware name: iMac12,1
[ 1479.919347] Modules linked in: nfsd auth_rpcgss nfs_acl lockd
sunrpc ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc
be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3
mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core
iscsi_tcp libiscsi_tcp libiscsi rfcomm bnep scsi_transport_iscsi
nls_utf8 hfsplus arc4 ath9k ath9k_common ath9k_hw ath mac80211
snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_intel snd_hda_codec
snd_hwdep vhost_net uvcvideo cfg80211 btusb tun macvtap macvlan
snd_seq snd_seq_device snd_pcm coretemp bluetooth tg3 snd_page_alloc
kvm_intel videobuf2_vmalloc videobuf2_memops snd_timer videobuf2_core
snd crc32c_intel
[ 1479.919361]  kvm iTCO_wdt iTCO_vendor_support videodev rfkill ptp
media ghash_clmulni_intel joydev soundcore lpc_ich pcspkr applesmc
input_polldev mfd_core i2c_i801 microcode pps_core apple_bl
binfmt_misc uinput hid_logitech_dj usb_storage radeon i915 ttm
i2c_algo_bit drm_kms_helper drm firewire_ohci firewire_core crc_itu_t
i2c_core video
[ 1479.919364] Pid: 3246, comm: pm-suspend Not tainted 3.9.0-rc2+ #2
[ 1479.919364] Call Trace:
[ 1479.919370]  [<ffffffff8105e9df>] warn_slowpath_common+0x7f/0xc0
[ 1479.919374]  [<ffffffff8131ed40>] ? __rdmsr_on_cpu+0x50/0x50
[ 1479.919376]  [<ffffffff8105ea3a>] warn_slowpath_null+0x1a/0x20
[ 1479.919377]  [<ffffffff810be0eb>] smp_call_function_single+0x11b/0x170
[ 1479.919379]  [<ffffffff8131efd3>] wrmsr_on_cpu+0x43/0x50
[ 1479.919382]  [<ffffffff81028d59>] init_debug_store_on_cpu+0x39/0x40
[ 1479.919384]  [<ffffffff81029731>] perf_restore_debug_store+0x21/0x30
[ 1479.919387]  [<ffffffff815363a5>] restore_processor_state+0x225/0x230
[ 1479.919390]  [<ffffffff81036da7>] acpi_suspend_lowlevel+0xf7/0x120
[ 1479.919393]  [<ffffffff8136075b>] acpi_suspend_enter+0x3b/0xb7
[ 1479.919395]  [<ffffffff810a84ef>] suspend_devices_and_enter+0x37f/0x430
[ 1479.919397]  [<ffffffff810a873a>] pm_suspend+0x19a/0x230
[ 1479.919399]  [<ffffffff810a7577>] state_store+0x87/0xf0
[ 1479.919402]  [<ffffffff812fba7f>] kobj_attr_store+0xf/0x20
[ 1479.919405]  [<ffffffff81210078>] sysfs_write_file+0xd8/0x150
[ 1479.919408]  [<ffffffff8119bccc>] vfs_write+0xac/0x180
[ 1479.919410]  [<ffffffff8119c012>] sys_write+0x52/0xa0
[ 1479.919412]  [<ffffffff8166369e>] ? do_page_fault+0xe/0x10
[ 1479.919414]  [<ffffffff81667cd9>] system_call_fastpath+0x16/0x1b
[ 1479.919415] ---[ end trace 2af7ebe5ffee87a9 ]---
[ 1479.919416] ACPI: Low-level resume complete

--Parag

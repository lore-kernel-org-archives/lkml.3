Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCJWk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaCJWky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:40:54 -0400
Date: Mon, 10 Mar 2014 23:40:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140310224023.GA1205@krava.redhat.com>
References: <20140308065153.GA30311@localhost>
 <20140310125319.GE26334@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310125319.GE26334@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 01:53:19PM +0100, Jiri Olsa wrote:
> On Sat, Mar 08, 2014 at 02:51:53PM +0800, Fengguang Wu wrote:
> > 
> > Hi all,
> > 
> > This is a very old WARNING, too old to be bisectable. The below 3 different
> > back traces show that it's always triggered by trinity at system reboot time.
> > Any ideas to quiet it? Thank you!
> 
> hi,
> is there cpu hotplug involved? like writing to:
>   /sys/devices/system/cpu/cpu*/online
> 

I think there's race with hotplug code,
I can reproduce this with:

  $ ./perf record -e faults ./perf bench sched pipe

and put one of the cpus offline:

  [root@krava cpu]# pwd
  /sys/devices/system/cpu
  [root@krava cpu]# echo 0 > cpu1/online 

working on fix ;-)

thanks,
jirka

---
[  133.726229] ------------[ cut here ]------------
[  133.726236] WARNING: CPU: 1 PID: 1194 at kernel/events/core.c:5640 perf_swevent_add+0x112/0x120()
[  133.726237] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc ccm nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack snd_hda_codec_hdmi snd_hda_codec_conexant uvcvideo x86_pkg_temp_thermal coretemp snd_hda_intel kvm_intel arc4 iwldvm videobuf2_vmalloc kvm snd_hda_codec videobuf2_memops snd_hwdep videobuf2_core mac80211 videodev sdhci_pci iTCO_wdt iTCO_vendor_support sdhci lpc_ich microcode iwlwifi media snd_seq snd_seq_device snd_pcm i2c_i801 serio_raw cfg80211 mfd_core mmc_core btusb mei_me shpchp snd_page_alloc bluetooth snd_timer nfsd e1000e mei ptp auth_rpcgss pps_core thinkpad_acpi nfs_acl lockd snd soundcore rfkill sunrpc wmi binfmt_misc dm_crypt i915 crct10dif_pclmul crc32_pclmul
[  133.726266]  i2c_algo_bit drm_kms_helper crc32c_intel drm i2c_core ghash_clmulni_intel video
[  133.726270] CPU: 1 PID: 1194 Comm: sched-pipe Not tainted 3.13.5-103.fc19.x86_64 #1
[  133.726271] Hardware name: LENOVO 4291EJ3/4291EJ3, BIOS 8DET56WW (1.26 ) 12/01/2011
[  133.726272]  0000000000000009 ffff8802091c5b18 ffffffff81680604 0000000000000000
[  133.726274]  ffff8802091c5b50 ffffffff8106d35d ffff880209084c00 ffff8800d015ec00
[  133.726276]  ffff88021e257748 ffff88021e25774c 00000000227a1324 ffff8802091c5b60
[  133.726277] Call Trace:
[  133.726282]  [<ffffffff81680604>] dump_stack+0x45/0x56
[  133.726285]  [<ffffffff8106d35d>] warn_slowpath_common+0x7d/0xa0
[  133.726287]  [<ffffffff8106d43a>] warn_slowpath_null+0x1a/0x20
[  133.726289]  [<ffffffff8113a9b2>] perf_swevent_add+0x112/0x120
[  133.726291]  [<ffffffff8113ea70>] event_sched_in.isra.78+0x90/0x1d0
[  133.726293]  [<ffffffff8113ec1a>] group_sched_in+0x6a/0x1e0
[  133.726296]  [<ffffffff8101b1c3>] ? native_sched_clock+0x13/0x80
[  133.726297]  [<ffffffff8101b239>] ? sched_clock+0x9/0x10
[  133.726299]  [<ffffffff8113ee9e>] ctx_sched_in+0x10e/0x1d0
[  133.726300]  [<ffffffff8113efc0>] perf_event_sched_in+0x60/0x90
[  133.726302]  [<ffffffff8113f468>] perf_event_context_sched_in+0x78/0xc0
[  133.726303]  [<ffffffff8113fb62>] __perf_event_task_sched_in+0x182/0x1a0
[  133.726306]  [<ffffffff8109a238>] finish_task_switch+0xa8/0xf0
[  133.726308]  [<ffffffff81683b52>] __schedule+0x2e2/0x740
[  133.726310]  [<ffffffff81683fd9>] schedule+0x29/0x70
[  133.726313]  [<ffffffff811c0301>] pipe_wait+0x61/0xa0
[  133.726315]  [<ffffffff810ae8a0>] ? abort_exclusive_wait+0xb0/0xb0
[  133.726316]  [<ffffffff811c0bbd>] pipe_read+0x2fd/0x4f0
[  133.726319]  [<ffffffff811b781a>] do_sync_read+0x5a/0x90
[  133.726321]  [<ffffffff811b7e85>] vfs_read+0x95/0x160
[  133.726322]  [<ffffffff811b8999>] SyS_read+0x49/0xa0
[  133.726325]  [<ffffffff8168f5e9>] system_call_fastpath+0x16/0x1b
[  133.726326] ---[ end trace 75f3a06e52d51e52 ]---
[  133.731360] kvm: disabling virtualization on CPU1
[  133.731367] smpboot: CPU 1 is now offline


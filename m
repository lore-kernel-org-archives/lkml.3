Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbaFSCIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:08:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbaFSCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:08:41 -0400
Date: Wed, 18 Jun 2014 21:08:31 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v2 0/3] ftrace, kprobes: Introduce IPMODIFY flag for
 ftrace_ops to detect conflicts
Message-ID: <20140619020831.GA21146@treble.redhat.com>
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:04:36AM +0000, Masami Hiramatsu wrote:
> Hi,
> 
> Here is the version 2 of the series of patches which introduces
> IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
> who can modify regs->ip in their handler.
> In this version, I fixed some bugs in previous version and
> added a patch which made kprobe itself free from IPMODIFY
> except for jprobe.

Hi Masami,

This seems better, but I still saw a few issues.  I'm not sure if the
issues are specific to stap or kprobes.  For the following issues I used
this command to set a kprobe:

  stap -v -e 'probe kernel.function("meminfo_proc_show") {printf("meminfo_proc_show called\n");}'

With patches 1-2, when I used stap to kprobe the function after it was
already kpatched, stap didn't return an error and instead acted like it
succeeded (though the probe didn't work):

  $ sudo stap -v -e 'probe kernel.function("meminfo_proc_show") {printf("meminfo_proc_show called\n");}'
  Pass 1: parsed user script and 112 library script(s) using 221516virt/41612res/6028shr/36228data kb, in 130usr/0sys/132real ms.
  Pass 2: analyzed script: 1 probe(s), 0 function(s), 0 embed(s), 0 global(s) using 255840virt/77132res/7132shr/70552data kb, in 510usr/20sys/577real ms.
  Pass 3: translated to C into "/tmp/stap3Qunba/stap_2690192fea570fb7bba78c7ed7fa1e0d_898_src.c" using 255840virt/77392res/7392shr/70552data kb, in 10usr/0sys/4real ms.
  Pass 4: compiled C into "stap_2690192fea570fb7bba78c7ed7fa1e0d_898.ko" in 5020usr/640sys/7105real ms.
  Pass 5: starting run.
  (no error)

With all 3 patches, I expected kprobes and kpatch to be able to ftrace
the same function.  But when I tried to kpatch the function after it was
kprobed, I got the following oops in stap:

  [  455.842797] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [  455.843388] IP: [<ffffffffa0833d1e>] _stp_module_notifier+0x1e/0x320 [stap_2690192fea570fb7bba78c7ed7fa1e_20189]
  [  455.844011] PGD 33f898067 PUD 422083067 PMD 0 
  [  455.844638] Oops: 0000 [#1] SMP 
  [  455.845255] Modules linked in: kpatch(OE+) stap_2690192fea570fb7bba78c7ed7fa1e_20189(OE) rfcomm ipt_MASQUERADE fuse ccm xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 iwldvm mac80211 iTCO_wdt snd_hda_codec_hdmi iTCO_vendor_support x86_pkg_temp_thermal snd_hda_codec_realtek coretemp iwlwifi snd_hda_codec_generic kvm_intel snd_hda_intel kvm uvcvideo snd_hda_controller cfg80211 snd_hda_codec btusb videobuf2_vmalloc bluetooth videobuf2_memops snd_hwdep snd_seq nfsd videobuf2_core
  [  455.848272]  v4l2_common videodev snd_seq_device e1000e microcode snd_pcm sdhci_pci media joydev sdhci serio_raw i2c_i801 pcspkr mmc_core thinkpad_acpi mei_me snd_timer auth_rpcgss mei snd lpc_ich ptp mfd_core shpchp nfs_acl lockd pps_core wmi tpm_tis soundcore tpm rfkill sunrpc dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_core video
  [  455.850887] CPU: 3 PID: 19857 Comm: insmod Tainted: G        W  OE 3.16.0-rc1+ #2
  [  455.851768] Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
  [  455.852638] task: ffff880095d65460 ti: ffff88039d1d4000 task.ti: ffff88039d1d4000
  [  455.853456] RIP: 0010:[<ffffffffa0833d1e>]  [<ffffffffa0833d1e>] _stp_module_notifier+0x1e/0x320 [stap_2690192fea570fb7bba78c7ed7fa1e_20189]
  [  455.854335] RSP: 0018:ffff88039d1d7ce0  EFLAGS: 00010246
  [  455.855212] RAX: ffffffffa0837f50 RBX: 0000000000000000 RCX: 00000000ffffffff
  [  455.856109] RDX: ffffffffa08400e0 RSI: 0000000000000001 RDI: ffffffffa0837f50
  [  455.856986] RBP: ffff88039d1d7d00 R08: 0000000000000000 R09: 0000000000000000
  [  455.857880] R10: 0000000000000001 R11: ffffc9001aed2d8f R12: ffffffff81c593e0
  [  455.858761] R13: 0000000000000001 R14: ffffffffa08400e0 R15: 0000000000000000
  [  455.859640] FS:  00007feac5f10740(0000) GS:ffff88043e2c0000(0000) knlGS:0000000000000000
  [  455.860523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  455.861403] CR2: 0000000000000020 CR3: 00000004224e7000 CR4: 00000000001407e0
  [  455.862309] Stack:
  [  455.863236]  00000000fffffffd ffffffff81c593e0 0000000000000001 ffffffffa08400e0
  [  455.864163]  ffff88039d1d7d38 ffffffff810b45bc ffffffff81c557c0 0000000000000000
  [  455.865103]  0000000000000001 ffffffffa08400e0 00000000ffffffff ffff88039d1d7d78
  [  455.866067] Call Trace:
  [  455.867100]  [<ffffffff810b45bc>] notifier_call_chain+0x4c/0x70
  [  455.868202]  [<ffffffff810b491d>] __blocking_notifier_call_chain+0x4d/0x70
  [  455.869155]  [<ffffffff810b4956>] blocking_notifier_call_chain+0x16/0x20
  [  455.870111]  [<ffffffff8110749c>] load_module+0x1aac/0x25f0
  [  455.871067]  [<ffffffff811f6720>] ? kernel_read+0x50/0x80
  [  455.872022]  [<ffffffff81108196>] SyS_finit_module+0xa6/0xd0
  [  455.872982]  [<ffffffff817082e9>] system_call_fastpath+0x16/0x1b
  [  455.873941] Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 83 fe 01 48 89 e5 41 56 49 89 d6 41 55 41 54 53 48 8b 9a d0 01 00 00 <8b> 43 20 0f 84 59 01 00 00 48 85 f6 75 44 85 c0 74 4a 83 e8 01 
  [  455.876073] RIP  [<ffffffffa0833d1e>] _stp_module_notifier+0x1e/0x320 [stap_2690192fea570fb7bba78c7ed7fa1e_20189]
  [  455.877146]  RSP <ffff88039d1d7ce0>
  [  455.878243] CR2: 0000000000000020
  [  455.883707] ---[ end trace 388d9e62d4390d42 ]---

-- 
Josh

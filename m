Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaFLD25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:28:57 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:56501 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaFLD2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:28:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH ftrace/core  0/2] ftrace, kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>
	<20140611165826.GA5087@treble.redhat.com>
Date: Thu, 12 Jun 2014 12:28:53 +0900
In-Reply-To: <20140611165826.GA5087@treble.redhat.com> (Josh Poimboeuf's
	message of "Wed, 11 Jun 2014 11:58:26 -0500")
Message-ID: <87d2eeajre.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Wed, 11 Jun 2014 11:58:26 -0500, Josh Poimboeuf wrote:
> On Tue, Jun 10, 2014 at 10:50:01AM +0000, Masami Hiramatsu wrote:
>> Hi,
>> 
>> Here is a pair of patches which introduces IPMODIFY flag for
>> ftrace_ops to detect conflicts of ftrace users who can modify
>> regs->ip in their handler.
>> Currently, only kprobes can change the regs->ip in the handler,
>> but recently kpatch is also want to change it. Moreover, since
>> the ftrace itself exported to modules, it might be considerable
>> senario.
>> 
>> Here we talked on github.
>>  https://github.com/dynup/kpatch/issues/47
>> 
>> To protect modified regs-ip from each other, this series
>> introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
>> the flag can be set on each function entry location. If there
>> is someone who already reserve regs->ip on target function
>> entry, ftrace_set_filter_ip or register_ftrace_function will
>> return -EBUSY. Users must handle that.
>> 
>> At this point, all kprobes will reserve regs->ip, since jprobe
>> requires it.
>
> Masami, thanks very much for this!
>
> One issue with this approach is that it _always_ makes kprobes and
> kpatch incompatible when probing/patching the same function, even when
> kprobes doesn't need to touch regs->ip.
>
> Is it possible to add a kprobes flag (KPROBE_FLAG_IPMODIFY), which is
> only set by those kprobes users (just jprobes?) which need to modify IP?
> Then kprobes could only set the corresponding ftrace flag when it's
> really needed.  And I think kprobes could even enforce the fact that
> !KPROBE_FLAG_IPMODIFY users don't change regs->ip.
>
>
> BTW, I've done some testing with this patch set by patching/probing the
> same function with FTRACE_OPS_FL_IPMODIFY, and got some warnings.  I saw
> the following warning when attempting to kpatch a kprobed function:
>
>
>   WARNING: CPU: 2 PID: 18351 at kernel/trace/ftrace.c:419 __unregister_ftrace_function+0x1be/0x1d0()
>   Modules linked in: kpatch_meminfo_string(OE+) kpatch(OE) stap_8d70d6e041605bd1e144cba4801652_14636(OE) rfcomm fuse ipt_MASQUERADE ccm xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack bnep ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller kvm snd_hda_codec iwlwifi snd_hwdep uvcvideo snd_seq videobuf2_vmalloc videobuf2_memops snd_seq_dev
>  ice
>    videobuf2_core btusb v4l2_common snd_pcm videodev nfsd cfg80211 microcode e1000e bluetooth media thinkpad_acpi joydev sdhci_pci sdhci pcspkr serio_raw snd_timer i2c_i801 snd mmc_core auth_rpcgss mei_me mei lpc_ich mfd_core shpchp ptp pps_core wmi tpm_tis soundcore tpm rfkill nfs_acl lockd sunrpc dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_core video
>   CPU: 2 PID: 18351 Comm: insmod Tainted: G        W  OE 3.15.0-IPMODIFY+ #1
>   Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
>    0000000000000000 00000000b39bd289 ffff8803b78d7bc0 ffffffff816f31ed
>    0000000000000000 ffff8803b78d7bf8 ffffffff8108914d ffffffffa07f9040
>    00000000fffffff0 0000000000000000 0000000000000001 ffff8803e7ac4200
>   Call Trace:
>    [<ffffffff816f31ed>] dump_stack+0x45/0x56
>    [<ffffffff8108914d>] warn_slowpath_common+0x7d/0xa0
>    [<ffffffff8108927a>] warn_slowpath_null+0x1a/0x20
>    [<ffffffff81135bae>] __unregister_ftrace_function+0x1be/0x1d0
>    [<ffffffff81137294>] ftrace_startup+0x1e4/0x220
>    [<ffffffff81137313>] register_ftrace_function+0x43/0x60
>    [<ffffffffa07f6c84>] kpatch_register+0x664/0x830 [kpatch]
>    [<ffffffffa0810000>] ? 0xffffffffa080ffff
>    [<ffffffffa0810000>] ? 0xffffffffa080ffff
>    [<ffffffffa0046194>] patch_init+0x194/0x1000 [kpatch_meminfo_string]
>    [<ffffffffa0046000>] ? 0xffffffffa0045fff
>    [<ffffffff81002144>] do_one_initcall+0xd4/0x210
>    [<ffffffff81059d43>] ? set_memory_nx+0x43/0x50
>    [<ffffffff81102e42>] load_module+0x1d92/0x25e0
>    [<ffffffff810feb60>] ? store_uevent+0x70/0x70
>    [<ffffffff811eba30>] ? kernel_read+0x50/0x80
>    [<ffffffff81103846>] SyS_finit_module+0xa6/0xd0
>    [<ffffffff81703179>] system_call_fastpath+0x16/0x1b
>
>
> That warning happened because __unregister_ftrace_function() doesn't
> expect FTRACE_OPS_FL_ENABLED to be cleared in the ftrace_startup error
> path.  I tried removing the FTRACE_OPS_FL_ENABLED clearing line in
> ftrace_startup, but I saw more warnings.  

Did you just remove the clearing line or actually clear the flag after
__unregister_ftrace_function() was called?


> This one happened when attempting to kprobe a kpatched function:
>
>
>   WARNING: CPU: 3 PID: 4444 at kernel/kprobes.c:953 arm_kprobe+0xa7/0xe0()
>   Failed to init kprobe-ftrace (-16)
>   Modules linked in: stap_b2ea0de23f179d8ded86fcc19fcc533_4444(OE) kpatch_meminfo_string(OE) kpatch(OE) rfcomm fuse ccm ipt_MASQUERADE xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack bnep ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 iwldvm mac80211 iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_hdmi iwlwifi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq uvcvideo btusb cfg80211 bluetooth videobuf2_vmalloc vide
>  obuf2_memops
>    videobuf2_core v4l2_common videodev snd_seq_device snd_pcm sdhci_pci media sdhci joydev nfsd i2c_i801 serio_raw pcspkr mmc_core microcode snd_timer e1000e lpc_ich thinkpad_acpi mfd_core shpchp snd wmi tpm_tis soundcore tpm ptp rfkill mei_me auth_rpcgss mei pps_core nfs_acl lockd sunrpc dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_core video [last unloaded: kpatch_meminfo_string]
>   CPU: 3 PID: 4444 Comm: stapio Tainted: G     U  W  OE 3.15.0-IPMODIFY+ #1
>   Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
>    0000000000000000 000000009cd22363 ffff880427bdfd80 ffffffff816f31ed
>    ffff880427bdfdc8 ffff880427bdfdb8 ffffffff8108914d ffffffffa08258e0
>    ffffffffa08258f0 0000000000000000 0000000000000000 0000000000000000
>   Call Trace:
>    [<ffffffff816f31ed>] dump_stack+0x45/0x56
>    [<ffffffff8108914d>] warn_slowpath_common+0x7d/0xa0
>    [<ffffffff810891cc>] warn_slowpath_fmt+0x5c/0x80
>    [<ffffffff816ff9d7>] arm_kprobe+0xa7/0xe0
>    [<ffffffff817007f7>] register_kprobe+0x557/0x5d0
>    [<ffffffff81254da0>] ? meminfo_proc_open+0x30/0x30
>    [<ffffffffa0820c95>] _stp_ctl_write_cmd+0x8d5/0x930 [stap_b2ea0de23f179d8ded86fcc19fcc533_4444]
>    [<ffffffff811e5daa>] vfs_write+0xba/0x1e0
>    [<ffffffff811e6965>] SyS_write+0x55/0xd0
>    [<ffffffff81703179>] system_call_fastpath+0x16/0x1b

This one looks fairly normal as kpatch set FTRACE_FL_IPMODIFY and kprobe
see it again..


>
>
> And this one happened after unregistering a probe and then attempting to
> register kpatch:
>
>
>   WARNING: CPU: 1 PID: 18041 at kernel/trace/ftrace.c:1584 __ftrace_hash_rec_update.part.35+0x20a/0x240()
>   Modules linked in: kpatch_meminfo_string(OE+) kpatch(OE) rfcomm fuse ipt_MASQUERADE ccm xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge bnep stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 iwldvm iTCO_wdt iTCO_vendor_support mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller x86_pkg_temp_thermal snd_hda_codec coretemp iwlwifi kvm_intel kvm snd_hwdep snd_seq cfg80211 snd_seq_device uvcvideo btusb videobuf2_vmalloc snd_pcm videobuf2_memops videobuf2_core v4l2
>  _common
>    videodev microcode bluetooth media e1000e pcspkr snd_timer sdhci_pci sdhci thinkpad_acpi i2c_i801 joydev snd serio_raw mmc_core lpc_ich ptp mei_me mfd_core pps_core mei shpchp soundcore rfkill tpm_tis wmi tpm nfsd auth_rpcgss nfs_acl lockd sunrpc dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_core video [last unloaded: stap_bc293456f85bd78c424ce27a4ab459_18005]
>   CPU: 1 PID: 18041 Comm: insmod Tainted: G        W  OE 3.15.0-IPMODIFY+ #1
>   Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
>    ffff8803b4717ad8 00000000af73dd79 ffff8803b4717ae8 ffffffff816f31ed
>    0000000000000000 ffff8803b4717b20 ffffffff8108914d 0000000000000000
>    0000000000000001 ffff8804280a0ea0 00000000000020ea ffff88042dc04aa0
>   Call Trace:
>    [<ffffffff816f31ed>] dump_stack+0x45/0x56
>    [<ffffffff8108914d>] warn_slowpath_common+0x7d/0xa0
>    [<ffffffff8108927a>] warn_slowpath_null+0x1a/0x20
>    [<ffffffff811359ba>] __ftrace_hash_rec_update.part.35+0x20a/0x240
>    [<ffffffff81135e25>] ftrace_hash_move+0x1d5/0x200
>    [<ffffffff81137e16>] ftrace_set_hash+0x126/0x1d0
>    [<ffffffff81254da0>] ? meminfo_proc_open+0x30/0x30
>    [<ffffffff81254da0>] ? meminfo_proc_open+0x30/0x30
>    [<ffffffff81137f20>] ftrace_set_filter_ip+0x60/0x70
>    [<ffffffffa07efa50>] kpatch_register+0x430/0x830 [kpatch]
>    [<ffffffffa0809000>] ? 0xffffffffa0808fff
>    [<ffffffffa0809000>] ? 0xffffffffa0808fff
>    [<ffffffffa0047194>] patch_init+0x194/0x1000 [kpatch_meminfo_string]
>    [<ffffffffa0047000>] ? 0xffffffffa0046fff
>    [<ffffffff81002144>] do_one_initcall+0xd4/0x210
>    [<ffffffffa0047000>] ? 0xffffffffa0046fff
>    [<ffffffff81102e42>] load_module+0x1d92/0x25e0
>    [<ffffffff810feb60>] ? store_uevent+0x70/0x70
>    [<ffffffff811eba30>] ? kernel_read+0x50/0x80
>    [<ffffffff81103846>] SyS_finit_module+0xa6/0xd0
>    [<ffffffff81703179>] system_call_fastpath+0x16/0x1b

But this is weird since kpatch_register() calls ftrace_set_filter_ip()
before registering kpatch_ftrace_ops.  So the ops->flags should not have
FTRACE_OPS_FL_ENABLED and it makes __ftrace_hash_rec_update() return
immediately.

So I guessed a following scenario:

  register kprobe   (success)
  register kpatch   (-EBUSY, but not reset _FL_ENABLED)
  unregister kprobe (success)
  register kpatch   (boom...)


Thanks,
Namhyung

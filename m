Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaFMKJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:09:54 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49642 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaFMKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:09:52 -0400
Message-ID: <539ACDE8.7010703@hitachi.com>
Date: Fri, 13 Jun 2014 19:09:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: [PATCH ftrace/core  0/2] ftrace, kprobes: Introduce IPMODIFY
 flag for ftrace_ops to detect conflicts
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal> <20140611165826.GA5087@treble.redhat.com> <53993E43.9040705@hitachi.com> <20140612124332.GA3863@treble.redhat.com>
In-Reply-To: <20140612124332.GA3863@treble.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/12 21:43), Josh Poimboeuf wrote:
>>>  I tried removing the FTRACE_OPS_FL_ENABLED clearing line in
>>> ftrace_startup, but I saw more warnings.  This one happened when
>>> attempting to kprobe a kpatched function:
>>
>> Oops! yes, this should happen...
> 
> Instead of a warning here I'd expect to see register_kprobe return an
> error and a staprun failure.

Actually, since kprobes has "disabled" state, not only register_kprobe
but also enable_kprobe also can be failed. :)


>>>   WARNING: CPU: 3 PID: 4444 at kernel/kprobes.c:953 arm_kprobe+0xa7/0xe0()
>>>   Failed to init kprobe-ftrace (-16)
>>>   Modules linked in: stap_b2ea0de23f179d8ded86fcc19fcc533_4444(OE) kpatch_meminfo_string(OE) kpatch(OE) rfcomm fuse ccm ipt_MASQUERADE xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack bnep ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 iwldvm mac80211 iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_hdmi iwlwifi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq uvcvideo btusb cfg80211 bluetooth videobuf2_vmalloc videobuf2_memops
>>>    videobuf2_core v4l2_common videodev snd_seq_device snd_pcm sdhci_pci media sdhci joydev nfsd i2c_i801 serio_raw pcspkr mmc_core microcode snd_timer e1000e lpc_ich thinkpad_acpi mfd_core shpchp snd wmi tpm_tis soundcore tpm ptp rfkill mei_me auth_rpcgss mei pps_core nfs_acl lockd sunrpc dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_core video [last unloaded: kpatch_meminfo_string]
>>>   CPU: 3 PID: 4444 Comm: stapio Tainted: G     U  W  OE 3.15.0-IPMODIFY+ #1
>>>   Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
>>>    0000000000000000 000000009cd22363 ffff880427bdfd80 ffffffff816f31ed
>>>    ffff880427bdfdc8 ffff880427bdfdb8 ffffffff8108914d ffffffffa08258e0
>>>    ffffffffa08258f0 0000000000000000 0000000000000000 0000000000000000
>>>   Call Trace:
>>>    [<ffffffff816f31ed>] dump_stack+0x45/0x56
>>>    [<ffffffff8108914d>] warn_slowpath_common+0x7d/0xa0
>>>    [<ffffffff810891cc>] warn_slowpath_fmt+0x5c/0x80
>>>    [<ffffffff816ff9d7>] arm_kprobe+0xa7/0xe0
>>>    [<ffffffff817007f7>] register_kprobe+0x557/0x5d0
>>>    [<ffffffff81254da0>] ? meminfo_proc_open+0x30/0x30
>>>    [<ffffffffa0820c95>] _stp_ctl_write_cmd+0x8d5/0x930 [stap_b2ea0de23f179d8ded86fcc19fcc533_4444]
>>>    [<ffffffff811e5daa>] vfs_write+0xba/0x1e0
>>>    [<ffffffff811e6965>] SyS_write+0x55/0xd0
>>>    [<ffffffff81703179>] system_call_fastpath+0x16/0x1b
>>>
>>>
>>> And this one happened after unregistering a probe and then attempting to
>>> register kpatch:
>>
>> Did you see this on unpatching? it seems to happen on disabling a hash...
> 
> No, I think it was in the patching path, after removing the kprobe.
> kpatch was calling ftrace_set_filter_ip(), and had not called
> register_ftrace_function() yet.

OK, anyway, I'll make a test case for checking it.
Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



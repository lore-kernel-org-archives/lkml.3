Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaCXL0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:26:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36952 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCXL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:26:14 -0400
Message-ID: <5330164D.6030507@hitachi.com>
Date: Mon, 24 Mar 2014 20:26:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
In-Reply-To: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/24 14:10), Takao Indoh wrote:
> Hi all,
> 
> I noticed the following ftrace waring message when I insmod module.
> 
> [  409.337936] ------------[ cut here ]------------
> [  409.337945] WARNING: CPU: 12 PID: 10028 at /mnt/repos/linux/kernel/trace/ftrace.c:1716 ftrace_bug+0x206/0x270()
> [  409.337971] Modules linked in: test2(O+) test1(O+) ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel sg aes_x86_64 glue_helper nfsd lrw gf128mul ablk_helper auth_rpcgss oid_registry cryptd exportfs nfs_acl lockd iTCO_wdt iTCO_vendor_support i7core_edac lpc_ich dm_mirror microcode serio_raw pcspkr i2c_i801 ioatdma dm_region_hash mfd_core edac_core ipmi_si dm_log shpchp tpm_infineon acpi_cpufreq dm_mod ipmi_msghandler uinput sunrpc ext4 mbcache jbd2 igb ptp mptsas pps_core lpfc i2c_algo_bit scsi_transport_sas scsi_transport_fc i2c_core mptscsih mptbase scsi_tgt megaraid_sas dca ipv6 autofs4 [last unloaded: test2]
> [  409.337974] CPU: 12 PID: 10028 Comm: insmod Tainted: G           O 3.14.0-rc5 #6
> [  409.337975] Hardware name: FUJITSU-SV PRIMERGY BX920 S2/D3030, BIOS 080015 Rev.3D81.3030 02/10/2012
> [  409.337979]  0000000000000009 ffff88023f7efc50 ffffffff81547bfe 0000000000000000
> [  409.337981]  ffff88023f7efc88 ffffffff81049a0d 0000000000000000 ffffffffa0364000
> [  409.337983]  ffff88023f6775c0 0000000000000000 ffff880238570000 ffff88023f7efc98
> [  409.337983] Call Trace:
> [  409.337990]  [<ffffffff81547bfe>] dump_stack+0x45/0x56
> [  409.337993]  [<ffffffff81049a0d>] warn_slowpath_common+0x7d/0xa0
> [  409.337997]  [<ffffffffa0364000>] ? 0xffffffffa0363fff
> [  409.337999]  [<ffffffff81049aea>] warn_slowpath_null+0x1a/0x20
> [  409.338001]  [<ffffffff810e79f6>] ftrace_bug+0x206/0x270
> [  409.338004]  [<ffffffffa0364000>] ? 0xffffffffa0363fff
> [  409.338006]  [<ffffffff810e7d8e>] ftrace_process_locs+0x32e/0x710
> [  409.338008]  [<ffffffff810e8206>] ftrace_module_notify_enter+0x96/0xf0
> [  409.338012]  [<ffffffff81551dec>] notifier_call_chain+0x4c/0x70
> [  409.338018]  [<ffffffff8106fbfd>] __blocking_notifier_call_chain+0x4d/0x70
> [  409.338020]  [<ffffffff8106fc36>] blocking_notifier_call_chain+0x16/0x20
> [  409.338026]  [<ffffffff810bf3f4>] load_module+0x1f54/0x25d0
> [  409.338028]  [<ffffffff810baab0>] ? store_uevent+0x40/0x40
> [  409.338031]  [<ffffffff810bfbe6>] SyS_finit_module+0x86/0xb0
> [  409.338036]  [<ffffffff81556752>] system_call_fastpath+0x16/0x1b
> [  409.338037] ---[ end trace e7e27c36e7a65831 ]---
> [  409.338040] ftrace faulted on writing [<ffffffffa0364000>] handler_pre+0x0/0x10 [test2]
> 
> To cause this problem,
> o Insmod two modules almost at the same time
> o At least one of them use kprobe.
> 
> Let's say I'm trying to insmod module A and module B at the same time,
> and module A calls register_kprobe() in it's module_init funciton.
> 
> <insmod module A>
> init_module
>   load_module
>     do_init_module
>       do_one_initcall
>         kprobe_init
>           register_kprobe
>             arm_kprobe
>               arm_kprobe_ftrace
>                 register_ftrace_function
>                   mutex_lock(&ftrace_lock) ------------------- (1)
>                   ftrace_startup
>                     ftrace_startup_enable
>                       ftrace_run_update_code
>                         ftrace_arch_code_modify_post_process
>                           set_all_modules_text_ro ------------ (2)
>                   mutex_unlock(&ftrace_lock) ----------------- (3)
> 
> 
> <insmod module B>
> init_module
>   load_module
>     do_init_module
>       blocking_notifier_call_chain
>         ftrace_module_notify_enter
>           ftrace_init_module
>             ftrace_process_locs
>              mutex_lock(&ftrace_lock) ------------------------ (4)
>              ftrace_update_code
>                __ftrace_replace_code
>                  ftrace_make_nop
>                    ftrace_modify_code_direct
>                      do_ftrace_mod_code
>                        probe_kernel_write -------------------- (5)
> 
> 
> o Frist of all, module A gets ftrace_lock at (1)
> o Module B also tries to get ftrace_lock at (4) somewhat late, and wait
>   here because modules A got ftrace_lock.
> o Module A sets all modules text to ReadOnly at (2), and then release
>   ftrace_lock at (3)
> o Module B wakes up and tries to rewrite its text at (5), but it fails
>   because it is already changed to RO at (2) by modules A. The ftrace
>   waring message is outputted.

Thank you for reporting with this pretty backtrace :)
Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).

If the ftrace can set loading module text read only before the module subsystem
expected, I think it should be protected by the module subsystem itself
(e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



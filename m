Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbaKWLMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 06:12:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47797 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaKWLMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 06:12:23 -0500
Date: Sun, 23 Nov 2014 12:12:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        x86-ml <x86@kernel.org>
Subject: task_stat splat
Message-ID: <20141123111220.GA6436@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I'm seeing the oops below on rc5 + tip/master from the 17th merged
ontop. I've seen it twice already after resuming the box so maybe not a
glitch.

So from looking at the splat I *think* I can see conky trying to read
/proc/.../stat and we end up in

proc_tgid_stat
|-> do_task_stat
    |-> thread_group_cputime_adjusted
        |-> thread_group_cputime

where we end up with a zero PMD. RIP is corrupted too so we're somewhere
off in the fields.

Machine wedges in completely after the NMI hardlockup detector dumps
splats on each core. I have those too, if anyone wants to see them.

Comment over thread_group_cputime() talks about dead tasks accounting
which might be relevant as we're seeing not mapped page hierarchy so
something must have gone away recently but we try to look at it.

So let me CC the people who have touched kernel/sched/cputime.c
recently, they might have an idea... :)

Thanks.

[   10.324923] PM: Image loading progress: 100%
[   10.325017] PM: Image loading done.
[   10.325127] PM: Read 3730208 kbytes in 6.37 seconds (585.58 MB/s)
[   10.329329] PM: Image successfully loaded
[   10.332518] serial 00:06: disabled
[   10.332591] serial 00:06: System wakeup disabled by ACPI
[42142.200246] r8169 0000:02:00.0 eth0: link up
[42460.368298] BUG: unable to handle kernel NULL pointer dereference at           (null)
[42460.371094] IP: [<          (null)>]           (null)
[42460.373859] PGD 42612c067 PUD 41ba89067 PMD 0 
[42460.376676] Oops: 0010 [#1] PREEMPT SMP 
[42460.379428] Modules linked in: tun ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_mangle iptable_nat nf_conntra
ck_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables sha256_ssse3 sha256_gene
ric cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative binfmt_misc ipv6 vfat fat fuse dm_cryp
t dm_mod kvm_amd kvm crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd radeon amd64
_edac_mod k10temp fam15h_power edac_core drm_kms_helper ttm cfbfillrect cfbimgblt cfbcopyarea acpi_cpufreq
[42460.389566] CPU: 1 PID: 3739 Comm: conky Not tainted 3.18.0-rc5+ #1
[42460.389570] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[42460.389573] task: ffff880426b53a50 ti: ffff8800b4e9c000 task.ti: ffff8800b4e9c000
[42460.389581] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[42460.389584] RSP: 0018:ffff8800b4e9fbc0  EFLAGS: 00010092
[42460.389587] RAX: ffff88042e3d3c80 RBX: ffff88042bb9a6e0 RCX: 0000015005a00fff
[42460.389589] RDX: ffffffff81672140 RSI: ffff88042d9d0dd8 RDI: ffff88042e3d3c80
[42460.389591] RBP: ffff8800b4e9fbf8 R08: 0000000000000118 R09: 0000000000000000
[42460.389594] R10: 0000000000000001 R11: 0000000000000028 R12: ffff88042babe900
[42460.389596] R13: ffff88042bb9aa98 R14: ffff88042bb9a6e0 R15: ffff8800b4e9fc90
[42460.389599] FS:  00007febc82e8700(0000) GS:ffff88042d800000(0000) knlGS:0000000000000000
[42460.389602] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[42460.389604] CR2: 0000000000000000 CR3: 0000000426b88000 CR4: 00000000000407e0
[42460.389605] Stack:
[42460.389612]  ffffffff810813d9 ffff8800b4e9fbe8 ffff88042e3d3c80 ffff88042bb9a6e0
[42460.389618]  0000000000000082 ffff88042bb9a6e0 ffff88042babe900 ffff8800b4e9fc78
[42460.389624]  ffffffff81088b5c ffffffff81088e2b 0000000400000003 ffff88042babeb38
[42460.389625] Call Trace:
[42460.389635]  [<ffffffff810813d9>] ? task_sched_runtime+0x99/0xc0
[42460.389643]  [<ffffffff81088b5c>] thread_group_cputime+0x17c/0x2d0
[42460.389649]  [<ffffffff81088e2b>] ? thread_group_cputime_adjusted+0x2b/0x60
[42460.389656]  [<ffffffff81061f23>] ? __lock_task_sighand+0xc3/0x2f0
[42460.389662]  [<ffffffff81088e2b>] thread_group_cputime_adjusted+0x2b/0x60
[42460.389670]  [<ffffffff811ed9b9>] do_task_stat+0x8e9/0xb60
[42460.389682]  [<ffffffff811ee7e4>] proc_tgid_stat+0x14/0x20
[42460.389687]  [<ffffffff811e815f>] proc_single_show+0x5f/0xa0
[42460.389694]  [<ffffffff811a8e50>] seq_read+0xe0/0x3c0
[42460.389700]  [<ffffffff811a2658>] ? __fdget_pos+0x48/0x50
[42460.389707]  [<ffffffff81181282>] vfs_read+0xa2/0x160
[42460.389713]  [<ffffffff81181da2>] SyS_read+0x52/0xc0
[42460.389721]  [<ffffffff816563d6>] system_call_fastpath+0x16/0x1b
[42460.389730] Code:  Bad RIP value.
[42460.389733] RIP  [<          (null)>]           (null)
[42460.389734]  RSP <ffff8800b4e9fbc0>
[42460.389736] CR2: 0000000000000000
[42460.389740] ---[ end trace 9f7e43df784ab3e3 ]---
[42460.389769] note: conky[3739] exited with preempt_count 3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

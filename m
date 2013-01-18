Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3ARTSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3ARTSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:18:36 -0500
Date: Fri, 18 Jan 2013 14:18:27 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: kernel BUG at kernel/smpboot.c:125!
Message-ID: <20130118191827.GA419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.7, we've started seeing reports of this BUG_ON in kernel/smpboot.c being hit..

121                 if (kthread_should_park()) {
122                         __set_current_state(TASK_RUNNING);
123                         preempt_enable();
124                         if (ht->park && td->status == HP_THREAD_ACTIVE) {
125                                 BUG_ON(td->cpu != smp_processor_id());
126                                 ht->park(td->cpu);
127                                 td->status = HP_THREAD_PARKED;
128                         }
129                         kthread_parkme();
130                         /* We might have been woken for stop */
131                         continue;
132                 }

In all reports, it seems that it happens when coming back from suspend/hibernate.

Example trace below. More reports at https://bugzilla.redhat.com/show_bug.cgi?id=891088

 > kernel BUG at kernel/smpboot.c:125!
 > invalid opcode: 0000 [#1] SMP 
 > Modules linked in: cpufreq_stats des_generic md4 nls_utf8 cifs dns_resolver
 > fscache fuse ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast
 > ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat
 > nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
 > nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep
 > snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel arc4 snd_hda_codec
 > snd_hwdep snd_seq uvcvideo snd_seq_device iwldvm snd_pcm videobuf2_vmalloc
 > iTCO_wdt videobuf2_memops iTCO_vendor_support videobuf2_core mac80211 videodev
 > asus_nb_wmi asus_wmi media vhost_net sparse_keymap coretemp snd_page_alloc
 > btusb tun iwlwifi macvtap macvlan bluetooth microcode snd_timer kvm_intel snd
 > joydev serio_raw lpc_ich i2c_i801 cfg80211 soundcore kvm mfd_core mei rfkill
 > uinput dm_crypt nouveau crc32c_intel i915 mxm_wmi i2c_algo_bit drm_kms_helper
 > ghash_clmulni_intel ttm drm i2c_core wmi video
 > CPU 0 
 > Pid: 22, comm: watchdog/3 Not tainted 3.7.1-1.fc19.x86_64 #1 ASUSTeK COMPUTER
 > INC. UX32VD/UX32VD
 > RIP: 0010:[<ffffffff8108aae3>]  [<ffffffff8108aae3>]
 > smpboot_thread_fn+0x193/0x1a0
 > RSP: 0000:ffff88029fc71e78  EFLAGS: 00010206
 > RAX: ffffffff810eb4b0 RBX: ffff88029fc35c80 RCX: 0000000000000000
 > RDX: 0000000000000000 RSI: ffff88029fc35c80 RDI: 0000000000000003
 > RBP: ffff88029fc71eb8 R08: ffff88029fc70000 R09: 0000000000000001
 > R10: 0000000000000000 R11: 0000000000000001 R12: ffff8802a4400940
 > R13: ffffffff81c3b9a0 R14: ffff88029fc35c80 R15: 0000000000000000
 > FS:  0000000000000000(0000) GS:ffff8802aee00000(0000) knlGS:0000000000000000
 > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > CR2: 00007f825e2b6000 CR3: 000000027a915000 CR4: 00000000001407f0
 > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > Process watchdog/3 (pid: 22, threadinfo ffff88029fc70000, task
 > ffff88029fc35c80)
 > Stack:
 >  ffff88029fc71e88 0000000000000000 ffff88029fc71eb8 0000000000000001
 >  ffff8802a00e5d18 ffff8802a4400940 ffffffff8108a950 0000000000000000
 >  ffff88029fc71f48 ffffffff81081d50 0000000000000001 0000000000000005
 > Call Trace:
 >  [<ffffffff8108a950>] ? lg_global_unlock+0x60/0x60
 >  [<ffffffff81081d50>] kthread+0xc0/0xd0
 >  [<ffffffff81010808>] ? perf_trace_xen_mmu_flush_tlb_all+0x88/0xc0
 >  [<ffffffff81081c90>] ? kthread_create_on_node+0x120/0x120
 >  [<ffffffff8163d92c>] ret_from_fork+0x7c/0xb0
 >  [<ffffffff81081c90>] ? kthread_create_on_node+0x120/0x120
 > Code: bf 77 00 0f a3 3a 19 d2 31 f6 85 d2 40 0f 95 c6 ff d0 4c 89 e7 e8 ce 4f
 > 0f 00 48 83 c4 20 31 c0 5b 41 5c 41 5d 41 5e 5d c3 0f 0b <0f> 0b 66 66 2e 0f 1f
 > 84 00 00 00 00 00 0f 1f 44 00 00 55 48 c7 
 > RIP  [<ffffffff8108aae3>] smpboot_thread_fn+0x193/0x1a0
 >  RSP <ffff88029fc71e78>


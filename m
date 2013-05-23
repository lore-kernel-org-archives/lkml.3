Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3EWDRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:17:03 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52277 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3EWDRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:17:00 -0400
Date: Wed, 22 May 2013 23:16:56 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        xfs@oss.sgi.com
Message-ID: <1483868349.4996990.1369279016162.JavaMail.root@redhat.com>
In-Reply-To: <20130522095300.GK29466@dastard>
References: <40971621.4497871.1369211701112.JavaMail.root@redhat.com> <1805266998.4499261.1369211998387.JavaMail.root@redhat.com> <20130522095300.GK29466@dastard>
Subject: Re: 3.9.2: xfstests triggered panic
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2: xfstests triggered panic
Thread-Index: z5p65HRRrfi1ak1fHTug1+i/WpPDkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com
> Sent: Wednesday, May 22, 2013 5:53:00 PM
> Subject: Re: 3.9.2: xfstests triggered panic
> 
> On Wed, May 22, 2013 at 04:39:58AM -0400, CAI Qian wrote:
> > Reproduced on almost all s390x guests by running xfstests.
> > 
> > 14634.396658¨ XFS (dm-1): Mounting Filesystem
> > 14634.525522¨ XFS (dm-1): Ending clean mount
> > 14640.413007¨  <000000000017c6d4>¨ idle_balance+0x1a0/0x340
> > 14640.413010¨  <000000000063303e>¨ __schedule+0xa22/0xaf0
> > 14640.428279¨  <0000000000630da6>¨ schedule_timeout+0x186/0x2c0
> > 14640.428289¨  <00000000001cf864>¨ rcu_gp_kthread+0x1bc/0x298
> > 14640.428300¨  <0000000000158c5a>¨ kthread+0xe6/0xec
> > 14640.428304¨  <0000000000634de6>¨ kernel_thread_starter+0x6/0xc
> > 14640.428308¨  <0000000000634de0>¨ kernel_thread_starter+0x0/0xc
> > 14640.428311¨ Last Breaking-Event-Address:
> > 14640.428314¨  <000000000016bd76>¨ walk_tg_tree_from+0x3a/0xf4
> > 14640.428319¨  list_add corruption. next->prev should be prev
> > (0000000000000918
> > ), but was           (null). (next=          (null)).
> 
> Where's XFS in this? walk_tg_tree_from() is part of the scheduler
> code. This kind of implies a stack corruption....
> 
> > Sometimes, this pops up,
> > [16907.275002] WARNING: at kernel/rcutree.c:1960
> > 
> > or this,
> > 15316.154171¨ XFS (dm-1): Mounting Filesystem
> > 15316.255796¨ XFS (dm-1): Ending clean mount
> > 15320.364246¨            00000000006367a2: e310b0080004        lg
> > %r1,8(%r
> > 11)
> > 15320.364249¨            00000000006367a8: 41101010            la
> > %r1,16(%
> > r1)
> > 15320.364251¨            00000000006367ac: e33010000004        lg
> > %r3,0(%r
> > 1)
> > 15320.364252¨ Call Trace:
> > 15320.364252¨ Last Breaking-Event-Address:
> > 15320.364253¨  � <0000000000000000>¨ Kernel stack overflow.
> > 15320.364308¨ CPU: 0 Tainted: GF       W    3.9.2 #1
> > 15320.364309¨ Process rhts-test-runne (pid: 625, task: 000000003dccc890,
> > ksp: 0
> 
> .... and there you go - a stack overflow. Your kernel stack size is
> too small.
> 
> I'd suggest that you need 16k stacks on s390 - IIRC every function
> call has 128 byte stack frame, and there are call chains 70-80
> functions deep in the storage stack...
Hmm, I am unsure how to set to 16k stack there, and power 7 has looks
like has the same problem.

[14927.117017] XFS (dm-0): Mounting Filesystem 
[14927.299854] XFS (dm-0): Ending clean mount 
[14927.668909] Unable to handle kernel paging request for data at address 0x00000040 
[14927.668913] Unable to handle kernel paging request for data at address 0x000000f8 
[14927.668914] Unable to handle kernel paging request for data at address 0x000000bb 
[14927.668915] Faulting instruction address: 0xc0000000000d1bd8 
[14927.668916] Faulting instruction address: 0xc0000000000d1bd8 
[14927.668919] Unable to handle kernel paging request for data at address 0x00000018 
[14927.668920] Faulting instruction address: 0xc0000000003d34b8 
[14927.668922] Oops: Kernel access of bad area, sig: 11 [#1] 
[14927.668924] SMP NR_CPUS=1024 NUMA pSeries 
[14927.668927] Modules linked in: binfmt_misc(F) tun(F) ipt_ULOG(F) rds(F) scsi_transport_iscsi(F) atm(F) nfc(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) af_802154(F) af_key(F) sctp(F) btrfs(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfs(F) lockd(F) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F) nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F)[14927.668955] Faulting instruction address: 0xc0000000000d1bd8 
 fuse(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) ehea(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) ibmvscsi(F) scsi_transport_srp(F) scsi_tgt(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: brd] 
[14927.669041] NIP: c0000000000d1bd8 LR: c0000000000d1b94 CTR: c0000000000d7e30 
[14927.669048] REGS: c0000001fbfb3120 TRAP: 0300   Tainted: GF             (3.9.3) 
[14927.669053] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 28000028  XER: 00000000 
[14927.669069] SOFTE: 0 
[14927.669072] CFAR: c00000000000908c 
[14927.669076] DAR: 00000000000000f8, DSISR: 40000000 
[14927.669080] TASK = c0000001fbf14880[0] 'swapper/2' THREAD: c0000001fbfb0000 CPU: 2 
GPR00: c0000000000d1b94 c0000001fbfb33a0 c0000000010f3038 00000d939e66add6  
GPR04: 0000000000000000 00000001001651f2 0000000000000099 c000000000af3038  
GPR08: c000000001163038 0000000000000002 00000000000000b8 000c3420953d115d  
GPR12: 0000000048000022 c00000000ed90800 c0000001fbfb3f90 000000000eee7bc0  
GPR16: 0000000010200040 00000001001651f2 c000000001152100 0000000000000000  
GPR20: c000000000af3f80 c000000001152180 0000000000000000 0000000000000000  
GPR24: c0000000007801e8 0000000000000001 0000000000200200 c0000000015550d0  
GPR28: c000000001554880 0000000000000000 c0000001f5564200 0000000000000000  
[14927.669159] NIP [c0000000000d1bd8] .update_blocked_averages+0xc8/0x5c0 
[14927.669165] LR [c0000000000d1b94] .update_blocked_averages+0x84/0x5c0 
[14927.669170] Call Trace: 
[14927.669174] [c0000001fbfb33a0] [c0000000000d1b94] .update_blocked_averages+0x84/0x5c0 (unreliable) 
[14927.669183] [c0000001fbfb3490] [c0000000000d7c54] .rebalance_domains+0x84/0x260 
[14927.669190] [c0000001fbfb3570] [c0000000000d7eb4] .run_rebalance_domains+0x84/0x230 
[14927.669198] [c0000001fbfb3650] [c000000000091228] .__do_softirq+0x148/0x310 
[14927.669205] [c0000001fbfb3740] [c000000000091608] .irq_exit+0xc8/0xe0 
[14927.669212] [c0000001fbfb37c0] [c00000000001d214] .timer_interrupt+0x154/0x2e0 
[14927.669220] [c0000001fbfb3870] [c0000000000024d4] decrementer_common+0x154/0x180 
[14927.669230] --- Exception: 901 at .plpar_hcall_norets+0x84/0xd4 
[14927.669230]     LR = .check_and_cede_processor+0x24/0x40 
[14927.669240] [c0000001fbfb3b60] [0000000000000001] 0x1 (unreliable) 
[14927.669247] [c0000001fbfb3bd0] [c00000000006d070] .shared_cede_loop+0x50/0xe0 
[14927.669256] [c0000001fbfb3c90] [c0000000005b818c] .cpuidle_enter+0x2c/0x40 
[14927.669263] [c0000001fbfb3d00] [c0000000005b8ad0] .cpuidle_idle_call+0xf0/0x300 
[14927.669270] [c0000001fbfb3db0] [c00000000005dab0] .pSeries_idle+0x10/0x40 
[14927.669278] [c0000001fbfb3e20] [c0000000000171b8] .cpu_idle+0x158/0x2a0 
[14927.669285] [c0000001fbfb3ed0] [c00000000074c030] .start_secondary+0x3a4/0x3ac 
[14927.669293] [c0000001fbfb3f90] [c00000000000976c] .start_secondary_prolog+0x10/0x14 
[14927.669299] Instruction dump: 
[14927.669303] 7fbbf040 3bdeff50 419e01f0 3f400020 3f02ff69 3ae00000 3ac00000 3b18d1b0  
[14927.669314] 635a0200 60000000 e93c0912 e95e00c0 <e90a0040> e94a0048 79291f24 7fe8482a  
[14927.669334] ---[ end trace ac4936baffc8b47b ]--- 
[14927.671261]  
[14927.671266] Oops: Kernel access of bad area, sig: 11 [#2] 
[14927.671272] SMP NR_CPUS=1024 NUMA pSeries 

CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

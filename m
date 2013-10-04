Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3JDRHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:07:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3JDRHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:07:37 -0400
Date: Fri, 4 Oct 2013 13:07:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131004170732.GA30728@redhat.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
 <20131003214525.GA12183@kmo-pixel>
 <20131003225009.GA24173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003225009.GA24173@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03 2013 at  6:50pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Oct 03 2013 at  5:45pm -0400,
> Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > On Wed, Oct 02, 2013 at 11:23:21PM -0400, Mike Snitzer wrote:
> > > Great, thanks for finding this, I'll test and review the code further.
> > 
> > Cool - let me know if you find anything else (how thoroughly do you
> > think you've tested it so far?)
> 
> Not very, the issue you resolved was a blocker for DM.  But I haven't
> even verified your fix yet though... will do tomorrow with more
> extensive testing using the dm-thinp and dm-cache test-suite.

With your latest fix I was able to create a thin device and format with
XFS.  Unfortunately, when I tried to run the thinp-test-suite the very
first BasicTests test (test_dd_benchmark) fails -- need to look closer
but it would seem to me the thinp saved bio_endio path isn't happy.  We
likely need an appropriately placed atomic_inc(&bio->bi_remaining); like
you did in dm-cache-target.c

------------[ cut here ]------------
kernel BUG at fs/bio.c:1722!
invalid opcode: 0000 [#1] SMP
Modules linked in: dm_cache_cleaner dm_cache_mq dm_cache dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio dm_mod xfs exportfs libcrc32c ebtable_nat ebtables xt_C
HECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe 8021q libfcoe libfc garp stp llc scsi_
transport_fc scsi_tgt sunrpc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_stat
e nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap
 macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_cor
e mdio sg ses enclosure acpi_cpufreq freq_table ext4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix sd_mod crc_t10dif crct10dif_common megaraid_sas [last unl
oaded: dm_cache_mq]
CPU: 0 PID: 342 Comm: kworker/u24:7 Tainted: G        W    3.12.0-rc2.snitm+ #76
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
Workqueue: dm-thin do_worker [dm_thin_pool]
task: ffff88032cd88ab0 ti: ffff88032c5e6000 task.ti: ffff88032c5e6000
RIP: 0010:[<ffffffff811b1464>]  [<ffffffff811b1464>] bio_endio+0x74/0x80
RSP: 0018:ffff88032c5e7d48  EFLAGS: 00010246
RAX: ffff88032f10a784 RBX: ffff88032d097450 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88032f10a740
RBP: ffff88032c5e7d48 R08: ffff88033fc12d00 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000002 R12: ffff88032f10a740
R13: ffff88032def5880 R14: ffff88032d0c7c00 R15: ffff88032d457a05
FS:  0000000000000000(0000) GS:ffff88033fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003bfea13000 CR3: 0000000001a0b000 CR4: 00000000000007f0
Stack:
 ffff88032c5e7d98 ffffffffa05f2ef9 ffff88032c5e7da8 0000000000000000
 ffff88032d0c7c00 ffff88032c5e7da8 ffff88032d0c7d98 ffff88032d0974a8
 ffff88032d0c7d14 ffff88032d457a05 ffff88032c5e7dd8 ffffffffa05f2ba7
Call Trace:
 [<ffffffffa05f2ef9>] process_prepared_mapping+0x79/0x150 [dm_thin_pool]
 [<ffffffffa05f2ba7>] process_prepared+0x87/0xa0 [dm_thin_pool]
 [<ffffffffa05f58f3>] do_worker+0x33/0x60 [dm_thin_pool]
 [<ffffffff81067862>] process_one_work+0x182/0x3b0
 [<ffffffff81068c80>] worker_thread+0x120/0x3a0
 [<ffffffff81068b60>] ? manage_workers+0x160/0x160
 [<ffffffff8106eace>] kthread+0xce/0xe0
 [<ffffffff8106ea00>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff8152b1ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106ea00>] ? kthread_freezable_should_stop+0x70/0x70
Code: 1f 84 00 00 00 00 00 48 8b 57 10 83 e2 01 0f 44 f1 eb cd 0f 1f 40 00 48 8b 7f 50 48 85 ff 74 dd 8b 57 44 48 8d 47 44 85 d2 7f ac <0f> 0b eb fe 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 
RIP  [<ffffffff811b1464>] bio_endio+0x74/0x80
 RSP <ffff88032c5e7d48>
---[ end trace acb5a7d638591b7b ]---

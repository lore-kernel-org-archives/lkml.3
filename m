Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3F1ToT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:44:19 -0400
Received: from server506g.appriver.com ([50.56.144.37]:61603 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017Ab3F1ToQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:44:16 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:44:15 EDT
X-Note-AR-ScanTimeLocal: 6/28/2013 2:39:12 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G338 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Subject: Re: [PATCH 10/26] block: Convert drivers to immutable biovecs
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1370744348-15407-11-git-send-email-koverstreet@google.com>
Date: Fri, 28 Jun 2013 15:39:09 -0400
CC: <axboe@kernel.dk>, <tytso@mit.edu>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, <dm-devel@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-ID: <841EA87E-AA26-4ED6-A04F-A360E2C5F2F0@coraid.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com> <1370744348-15407-11-git-send-email-koverstreet@google.com>
To: Kent Overstreet <koverstreet@google.com>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kent Overstreet.

I tried your patches in the block branch of your git://evilpiepirate.org/~kent/linux-bcache.git repository.  Please let me know if I should be using some other branch than linux-bcache/block.

The AoE targets that work without the patches are not completing their initialization.  It looks like they get to the part where the kernel (outside the aoe driver) attempts to read the partition table, and then there's a general protection fault when memcpy runs from skb_copy_bits.  (Console messages below.)

With the upstream 3.10.0-rc5 running in this paravirtualized Xen guest, the partition tables are read within the first second after loading the aoe module, and the devices are ready for use.

I'm using a Coraid SRX, but a convenient way to do (non-performance, simple) tests with AoE targets is to create them as needed using vblade,

  http://sourceforge.net/projects/aoetools/files/vblade/

... to export sparse files as block devices over AoE.  A handy check is aoe-stat from the aoetools,

  http://sourceforge.net/projects/aoetools/files/aoetools/35/

... which will show output with "(NA)" in the last columns if the devices can't finish initializing.  If you'd like to use aoe-stat, here's the expected behavior with jumbo frames and 500GB targets, as seen with 3.10-rc5:

ecashin@tolstoy ~$ sudo aoe-stat | sed 2q 
     e82.0       500.107GB  eth0,eth1 8192  up            
     e82.1       500.107GB  eth0,eth1 8192  up            
ecashin@tolstoy ~$ 

Compare to 3.10.0-rc5+ from linux-bcache/block:

ecashin@tolstoy ~$ sudo aoe-stat
     e82.0       500.107GB   (NA) (NA)         
     e82.1       500.107GB   (NA) (NA)         
ecashin@tolstoy ~$ 


Kernel 3.10.0-rc5+ on an x86_64

tolstoy.coraid.com login: ixgbe 0000:00:00.1: removed PHC on eth1
ixgbe 0000:00:00.1: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
ixgbe 0000:00:00.1: registered PHC device on eth1
ixgbe 0000:00:00.0: removed PHC on eth0
ixgbe 0000:00:00.1 eth1: detected SFP+: 4
ixgbe 0000:00:00.0: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
ixgbe 0000:00:00.0: registered PHC device on eth0
ixgbe 0000:00:00.0 eth0: detected SFP+: 3
ixgbe 0000:00:00.1 eth1: NIC Link is Up 10 Gbps, Flow Control: RX/TX
ixgbe 0000:00:00.0 eth0: NIC Link is Up 10 Gbps, Flow Control: RX/TX
aoe: AoE v81 initialised.
aoe: e82.23: setting 8192 byte data frames
aoe: e82.22: setting 8192 byte data frames
aoe: e82.21: setting 8192 byte data frames
aoe: e82.20: setting 8192 byte data frames
aoe: e82.19: setting 8192 byte data frames
aoe: e82.18: setting 8192 byte data frames
aoe: e82.17: setting 8192 byte data frames
aoe: e82.16: setting 8192 byte data frames
aoe: e82.15: setting 8192 byte data frames
aoe: e82.14: setting 8192 byte data frames
aoe: e82.13: setting 8192 byte data frames
aoe: e82.12: setting 8192 byte data frames
aoe: e82.11: setting 8192 byte data frames
aoe: e82.10: setting 8192 byte data frames
aoe: e82.9: setting 8192 byte data frames
aoe: e82.8: setting 8192 byte data frames
aoe: e82.7: setting 8192 byte data frames
aoe: e82.6: setting 8192 byte data frames
aoe: e82.5: setting 8192 byte data frames
aoe: e82.4: setting 8192 byte data frames
aoe: e82.3: setting 8192 byte data frames
aoe: e82.2: setting 8192 byte data frames
aoe: e82.1: setting 8192 byte data frames
aoe: e82.0: setting 8192 byte data frames
aoe: 002590643b25 e82.23 vace0 has 976772992 sectors
aoe: 002590643b24 e82.22 vace0 has 976772992 sectors
aoe: 002590643b24 e82.21 vace0 has 976772992 sectors
aoe: 002590643b25 e82.20 vace0 has 976772992 sectors
aoe: 002590643b25 e82.19 vace0 has 5860532992 sectors
aoe: 002590643b25 e82.18 vace0 has 976772992 sectors
aoe: 002590643b25 e82.17 vace0 has 976772992 sectors
aoe: 002590643b24 e82.16 vace0 has 5860532992 sectors
aoe: 002590643b24 e82.15 vace0 has 976772992 sectors
aoe: 002590643b24 e82.14 vace0 has 976772992 sectors
aoe: 002590643b24 e82.13 vace0 has 5860532992 sectors
aoe: 002590643b24 e82.12 vace0 has 976772992 sectors
aoe: 002590643b24 e82.11 vace0 has 976772992 sectors
aoe: 002590643b24 e82.10 vace0 has 976772992 sectors
aoe: 002590643b24 e82.9 vace0 has 976772992 sectors
aoe: 002590643b25 e82.8 vace0 has 5860532992 sectors
aoe: 002590643b25 e82.7 vace0 has 976772992 sectors
aoe: 002590643b25 e82.6 vace0 has 976772992 sectors
aoe: 002590643b25 e82.5 vace0 has 976772992 sectors
aoe: 002590643b25 e82.4 vace0 has 976772992 sectors
aoe: 002590643b25 e82.3 vace0 has 976772992 sectors
aoe: 002590643b25 e82.2 vace0 has 976772992 sectors
aoe: 002590643b25 e82.1 vace0 has 976772992 sectors
aoe: 002590643b25 e82.0 vace0 has 976772992 sectors
general protection fault: 0000 [#1] SMP
Modules linked in: aoe bnx2fc cnic uio fcoe libfcoe libfc 8021q scsi_transport_fc garp scsi_tgt stp llc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 xen_netfront coretemp microcode ixgbe dca ptp pps_core mdio pcspkr ext4 jbd2 mbcache xen_blkfront dm_mirror dm_region_hash dm_log dm_mod
CPU: 7 PID: 1557 Comm: aoe_ktio Not tainted 3.10.0-rc5+ #4
task: ffff880076504240 ti: ffff880076554000 task.ti: ffff880076554000
RIP: e030:[<ffffffff8129908d>]  [<ffffffff8129908d>] memcpy+0xd/0x110
RSP: e02b:ffff880076555ce0  EFLAGS: 00010202
RAX: 0008b045cc646fff RBX: 0000000000001000 RCX: 00000000000000fb
RDX: 0000000000000004 RSI: ffff8800737e7024 RDI: 0008b045cc646fff
RBP: ffff880076555d48 R08: 00000000000007dc R09: 0008b045cc646fff
R10: ffff88000667bbc0 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000000007dc R15: 00000000000007dc
FS:  00007f7a0ddcb700(0000) GS:ffff88007ce00000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 0000000073856000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffffffff814a8875 ffff880076555d08 ffffffff8109653f ffff880076554000
 0008b045cc646fff ffff88000667bbc0 00000000000007dc ffff880076504240
 ffff8800058047c0 0000000000001000 ffff880005804820 ffff880004be1180
Call Trace:
 [<ffffffff814a8875>] ? skb_copy_bits+0x155/0x2b0
 [<ffffffff8109653f>] ? local_clock+0x6f/0x80
 [<ffffffffa035b9d8>] ktiocomplete+0x3c8/0x540 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035bb88>] ktio+0x38/0x80 [aoe]
 [<ffffffffa035a61c>] kthread+0xac/0x100 [aoe]
 [<ffffffff81094f70>] ? try_to_wake_up+0x300/0x300
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffff81081c5e>] kthread+0xee/0x100
 [<ffffffff810c3b5b>] ? __lock_release+0x13b/0x1b0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8159c02c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
Code: 0f b6 c0 5b c9 c3 0f 1f 84 00 00 00 00 00 e8 6b f8 ff ff 80 7b 25 00 74 c8 eb d3 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c
RIP  [<ffffffff8129908d>] memcpy+0xd/0x110
 RSP <ffff880076555ce0>
---[ end trace ff5308cca9a17603 ]---
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 0, pid: 1557, name: aoe_ktio
INFO: lockdep is turned off.
CPU: 7 PID: 1557 Comm: aoe_ktio Tainted: G      D      3.10.0-rc5+ #4
 000000000000000b ffff880076555ad8 ffffffff8158e8e7 ffff880076555af8
 ffffffff8108e2a5 ffffffff81a30250 ffff8800765e5128 ffff880076555b28
 ffffffff8158fba6 0000000000000000 ffff880076504240 ffff880076504240
Call Trace:
 [<ffffffff8158e8e7>] dump_stack+0x19/0x22
 [<ffffffff8108e2a5>] __might_sleep+0xf5/0x130
 [<ffffffff8158fba6>] down_read+0x26/0xa0
 [<ffffffff8106e464>] exit_signals+0x24/0x140
 [<ffffffff810884a6>] ? blocking_notifier_call_chain+0x16/0x20
 [<ffffffff8105dac2>] do_exit+0xb2/0x480
 [<ffffffff81594161>] oops_end+0xb1/0x100
 [<ffffffff81017a7b>] die+0x5b/0x90
 [<ffffffff81593c4c>] do_general_protection+0xdc/0x160
 [<ffffffff81593223>] ? restore_args+0x30/0x30
 [<ffffffff81593498>] general_protection+0x28/0x30
 [<ffffffff8129908d>] ? memcpy+0xd/0x110
 [<ffffffff814a8875>] ? skb_copy_bits+0x155/0x2b0
 [<ffffffff8109653f>] ? local_clock+0x6f/0x80
 [<ffffffffa035b9d8>] ktiocomplete+0x3c8/0x540 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035bb88>] ktio+0x38/0x80 [aoe]
 [<ffffffffa035a61c>] kthread+0xac/0x100 [aoe]
 [<ffffffff81094f70>] ? try_to_wake_up+0x300/0x300
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffff81081c5e>] kthread+0xee/0x100
 [<ffffffff810c3b5b>] ? __lock_release+0x13b/0x1b0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8159c02c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
BUG: scheduling while atomic: aoe_ktio/1557/0x10000002
INFO: lockdep is turned off.
Modules linked in: aoe bnx2fc cnic uio fcoe libfcoe libfc 8021q scsi_transport_fc garp scsi_tgt stp llc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 xen_netfront coretemp microcode ixgbe dca ptp pps_core mdio pcspkr ext4 jbd2 mbcache xen_blkfront dm_mirror dm_region_hash dm_log dm_mod
CPU: 7 PID: 1557 Comm: aoe_ktio Tainted: G      D      3.10.0-rc5+ #4
 0000000000000007 ffff880076555a18 ffffffff8158e8e7 ffff880076555a38
 ffffffff8108ea5a ffff88007cfd4cc0 ffff88007cfd4cc0 ffff880076555ac8
 ffffffff815907ee ffff880076555aa8 ffff880076554000 ffff880076555fd8
Call Trace:
 [<ffffffff8158e8e7>] dump_stack+0x19/0x22
 [<ffffffff8108ea5a>] __schedule_bug+0x6a/0x90
 [<ffffffff815907ee>] __schedule+0x68e/0x740
 [<ffffffff810938da>] __cond_resched+0x2a/0x40
 [<ffffffff81590930>] _cond_resched+0x30/0x40
 [<ffffffff8158fbaf>] down_read+0x2f/0xa0
 [<ffffffff8106e464>] exit_signals+0x24/0x140
 [<ffffffff810884a6>] ? blocking_notifier_call_chain+0x16/0x20
 [<ffffffff8105dac2>] do_exit+0xb2/0x480
 [<ffffffff81594161>] oops_end+0xb1/0x100
 [<ffffffff81017a7b>] die+0x5b/0x90
 [<ffffffff81593c4c>] do_general_protection+0xdc/0x160
 [<ffffffff81593223>] ? restore_args+0x30/0x30
 [<ffffffff81593498>] general_protection+0x28/0x30
 [<ffffffff8129908d>] ? memcpy+0xd/0x110
 [<ffffffff814a8875>] ? skb_copy_bits+0x155/0x2b0
 [<ffffffff8109653f>] ? local_clock+0x6f/0x80
 [<ffffffffa035b9d8>] ktiocomplete+0x3c8/0x540 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffffa035bb88>] ktio+0x38/0x80 [aoe]
 [<ffffffffa035a61c>] kthread+0xac/0x100 [aoe]
 [<ffffffff81094f70>] ? try_to_wake_up+0x300/0x300
 [<ffffffffa035a570>] ? aoe_ktstart+0xd0/0xd0 [aoe]
 [<ffffffff81081c5e>] kthread+0xee/0x100
 [<ffffffff810c3b5b>] ? __lock_release+0x13b/0x1b0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8159c02c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81081b70>] ? __init_kthread_worker+0x70/0x70
note: aoe_ktio[1557] exited with preempt_count 1

On Jun 8, 2013, at 10:18 PM, Kent Overstreet wrote:

> Now that we've got a mechanism for immutable biovecs -
> bi_iter.bi_bvec_done - we need to convert drivers to use primitives that
> respect it instead of using the bvec array directly.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: "Ed L. Cashin" <ecashin@coraid.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> ---
> drivers/block/aoe/aoe.h    |  10 +---
> drivers/block/aoe/aoecmd.c | 127 +++++++++++++++++----------------------------
> drivers/block/umem.c       |  50 ++++++++----------
> drivers/md/dm-crypt.c      |  52 ++++++++-----------
> drivers/md/dm-io.c         |  31 ++++++-----
> drivers/md/dm-raid1.c      |   8 +--
> drivers/md/dm-verity.c     |  52 +++++--------------
> include/linux/dm-io.h      |   4 +-
> 8 files changed, 131 insertions(+), 203 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
> index 1756494..e959e6b 100644
> --- a/drivers/block/aoe/aoe.h
> +++ b/drivers/block/aoe/aoe.h
> @@ -100,11 +100,8 @@ enum {
> 
> struct buf {
> 	ulong nframesout;
> -	ulong resid;
> -	ulong bv_resid;
> -	sector_t sector;
> 	struct bio *bio;
> -	struct bio_vec *bv;
> +	struct bvec_iter iter;
> 	struct request *rq;
> };
> 
> @@ -120,13 +117,10 @@ struct frame {
> 	ulong waited;
> 	ulong waited_total;
> 	struct aoetgt *t;		/* parent target I belong to */
> -	sector_t lba;
> 	struct sk_buff *skb;		/* command skb freed on module exit */
> 	struct sk_buff *r_skb;		/* response skb for async processing */
> 	struct buf *buf;
> -	struct bio_vec *bv;
> -	ulong bcnt;
> -	ulong bv_off;
> +	struct bvec_iter iter;
> 	char flags;
> };
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index a52975a..0733ba1 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -183,8 +183,7 @@ aoe_freetframe(struct frame *f)
> 
> 	t = f->t;
> 	f->buf = NULL;
> -	f->lba = 0;
> -	f->bv = NULL;
> +	memset(&f->iter, 0, sizeof(f->iter));
> 	f->r_skb = NULL;
> 	f->flags = 0;
> 	list_add(&f->head, &t->ffree);
> @@ -282,21 +281,17 @@ newframe(struct aoedev *d)
> }
> 
> static void
> -skb_fillup(struct sk_buff *skb, struct bio_vec *bv, ulong off, ulong cnt)
> +skb_fillup(struct sk_buff *skb, struct bio *bio, struct bvec_iter *iter)
> {
> 	int frag = 0;
> -	ulong fcnt;
> -loop:
> -	fcnt = bv->bv_len - (off - bv->bv_offset);
> -	if (fcnt > cnt)
> -		fcnt = cnt;
> -	skb_fill_page_desc(skb, frag++, bv->bv_page, off, fcnt);
> -	cnt -= fcnt;
> -	if (cnt <= 0)
> -		return;
> -	bv++;
> -	off = bv->bv_offset;
> -	goto loop;
> +
> +	while (iter->bi_size) {
> +		struct bio_vec bv = bio_iovec_iter(bio, *iter);
> +
> +		skb_fill_page_desc(skb, frag++, bv.bv_page,
> +				   bv.bv_offset, bv.bv_len);
> +		bio_advance_iter(bio, iter, bv.bv_len);
> +	}
> }
> 
> static void
> @@ -333,12 +328,10 @@ ata_rw_frameinit(struct frame *f)
> 	t->nout++;
> 	f->waited = 0;
> 	f->waited_total = 0;
> -	if (f->buf)
> -		f->lba = f->buf->sector;
> 
> 	/* set up ata header */
> -	ah->scnt = f->bcnt >> 9;
> -	put_lba(ah, f->lba);
> +	ah->scnt = f->iter.bi_size >> 9;
> +	put_lba(ah, f->iter.bi_sector);
> 	if (t->d->flags & DEVFL_EXT) {
> 		ah->aflags |= AOEAFL_EXT;
> 	} else {
> @@ -347,11 +340,11 @@ ata_rw_frameinit(struct frame *f)
> 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
> 	}
> 	if (f->buf && bio_data_dir(f->buf->bio) == WRITE) {
> -		skb_fillup(skb, f->bv, f->bv_off, f->bcnt);
> +		skb->len += f->iter.bi_size;
> +		skb->data_len = f->iter.bi_size;
> +		skb->truesize += f->iter.bi_size;
> +		skb_fillup(skb, f->buf->bio, &f->iter);
> 		ah->aflags |= AOEAFL_WRITE;
> -		skb->len += f->bcnt;
> -		skb->data_len = f->bcnt;
> -		skb->truesize += f->bcnt;
> 		t->wpkts++;
> 	} else {
> 		t->rpkts++;
> @@ -370,7 +363,7 @@ aoecmd_ata_rw(struct aoedev *d)
> 	struct aoetgt *t;
> 	struct sk_buff *skb;
> 	struct sk_buff_head queue;
> -	ulong bcnt, fbcnt;
> +	ulong bcnt;
> 
> 	buf = nextbuf(d);
> 	if (buf == NULL)
> @@ -382,36 +375,19 @@ aoecmd_ata_rw(struct aoedev *d)
> 	bcnt = d->maxbcnt;
> 	if (bcnt == 0)
> 		bcnt = DEFAULTBCNT;
> -	if (bcnt > buf->resid)
> -		bcnt = buf->resid;
> -	fbcnt = bcnt;
> -	f->bv = buf->bv;
> -	f->bv_off = f->bv->bv_offset + (f->bv->bv_len - buf->bv_resid);
> -	do {
> -		if (fbcnt < buf->bv_resid) {
> -			buf->bv_resid -= fbcnt;
> -			buf->resid -= fbcnt;
> -			break;
> -		}
> -		fbcnt -= buf->bv_resid;
> -		buf->resid -= buf->bv_resid;
> -		if (buf->resid == 0) {
> -			d->ip.buf = NULL;
> -			break;
> -		}
> -		buf->bv++;
> -		buf->bv_resid = buf->bv->bv_len;
> -		WARN_ON(buf->bv_resid == 0);
> -	} while (fbcnt);
> +	if (bcnt > buf->iter.bi_size)
> +		bcnt = buf->iter.bi_size;
> +
> +	bio_advance_iter(buf->bio, &buf->iter, bcnt);
> 
> 	/* initialize the headers & frame */
> 	f->buf = buf;
> -	f->bcnt = bcnt;
> +	f->iter = buf->iter;
> +	f->iter.bi_size = bcnt;
> 	ata_rw_frameinit(f);
> 
> 	/* mark all tracking fields and load out */
> 	buf->nframesout += 1;
> -	buf->sector += bcnt >> 9;
> 
> 	skb = skb_clone(f->skb, GFP_ATOMIC);
> 	if (skb) {
> @@ -604,10 +580,7 @@ reassign_frame(struct frame *f)
> 	skb = nf->skb;
> 	nf->skb = f->skb;
> 	nf->buf = f->buf;
> -	nf->bcnt = f->bcnt;
> -	nf->lba = f->lba;
> -	nf->bv = f->bv;
> -	nf->bv_off = f->bv_off;
> +	nf->iter = f->iter;
> 	nf->waited = 0;
> 	nf->waited_total = f->waited_total;
> 	nf->sent = f->sent;
> @@ -626,6 +599,7 @@ probe(struct aoetgt *t)
> 	struct sk_buff_head queue;
> 	size_t n, m;
> 	int frag;
> +	ulong bcnt;
> 
> 	d = t->d;
> 	f = newtframe(d, t);
> @@ -639,19 +613,20 @@ probe(struct aoetgt *t)
> 	}
> 	f->flags |= FFL_PROBE;
> 	ifrotate(t);
> -	f->bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
> +	bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
> +	f->iter.bi_size = bcnt;
> 	ata_rw_frameinit(f);
> 	skb = f->skb;
> -	for (frag = 0, n = f->bcnt; n > 0; ++frag, n -= m) {
> +	for (frag = 0, n = bcnt; n > 0; ++frag, n -= m) {
> 		if (n < PAGE_SIZE)
> 			m = n;
> 		else
> 			m = PAGE_SIZE;
> 		skb_fill_page_desc(skb, frag, empty_page, 0, m);
> 	}
> -	skb->len += f->bcnt;
> -	skb->data_len = f->bcnt;
> -	skb->truesize += f->bcnt;
> +	skb->len += bcnt;
> +	skb->data_len = bcnt;
> +	skb->truesize += bcnt;
> 
> 	skb = skb_clone(f->skb, GFP_ATOMIC);
> 	if (skb) {
> @@ -923,12 +898,8 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
> 	memset(buf, 0, sizeof(*buf));
> 	buf->rq = rq;
> 	buf->bio = bio;
> -	buf->resid = bio->bi_iter.bi_size;
> -	buf->sector = bio->bi_iter.bi_sector;
> +	buf->iter = bio->bi_iter;
> 	bio_pageinc(bio);
> -	buf->bv = __bio_iovec(bio);
> -	buf->bv_resid = buf->bv->bv_len;
> -	WARN_ON(buf->bv_resid == 0);
> }
> 
> static struct buf *
> @@ -1113,24 +1084,23 @@ gettgt(struct aoedev *d, char *addr)
> }
> 
> static void
> -bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, long cnt)
> +bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter *iter, long cnt)
> {
> -	ulong fcnt;
> 	char *p;
> 	int soff = 0;
> -loop:
> -	fcnt = bv->bv_len - (off - bv->bv_offset);
> -	if (fcnt > cnt)
> -		fcnt = cnt;
> -	p = page_address(bv->bv_page) + off;
> -	skb_copy_bits(skb, soff, p, fcnt);
> -	soff += fcnt;
> -	cnt -= fcnt;
> -	if (cnt <= 0)
> -		return;
> -	bv++;
> -	off = bv->bv_offset;
> -	goto loop;
> +
> +	do {
> +		struct bio_vec bv = bio_iovec_iter(bio, *iter);
> +
> +		p = page_address(bv.bv_page) + bv.bv_offset;
> +		skb_copy_bits(skb, soff, p, bv.bv_len);
> +
> +		bio_advance_iter(bio, iter, bv.bv_len);
> +		soff += bv.bv_len;
> +		cnt -= bv.bv_len;
> +		if (cnt <= 0)
> +			return;
> +	} while (cnt > 0);
> }
> 
> void
> @@ -1223,7 +1193,7 @@ noskb:		if (buf)
> 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
> 			break;
> 		}
> -		bvcpy(f->bv, f->bv_off, skb, n);
> +		bvcpy(skb, f->buf->bio, &f->iter, n);
> 	case ATA_CMD_PIO_WRITE:
> 	case ATA_CMD_PIO_WRITE_EXT:
> 		spin_lock_irq(&d->lock);
> @@ -1266,7 +1236,7 @@ out:
> 
> 	aoe_freetframe(f);
> 
> -	if (buf && --buf->nframesout == 0 && buf->resid == 0)
> +	if (buf && --buf->nframesout == 0 && buf->iter.bi_size == 0)
> 		aoe_end_buf(d, buf);
> 
> 	spin_unlock_irq(&d->lock);
> @@ -1697,7 +1667,6 @@ aoe_failbuf(struct aoedev *d, struct buf *buf)
> {
> 	if (buf == NULL)
> 		return;
> -	buf->resid = 0;
> 	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
> 	if (buf->nframesout == 0)
> 		aoe_end_buf(d, buf);
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index dab4f1a..00145e8 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -108,8 +108,7 @@ struct cardinfo {
> 				    * have been written
> 				    */
> 	struct bio	*bio, *currentbio, **biotail;
> -	int		current_idx;
> -	sector_t	current_sector;
> +	struct bvec_iter current_iter;
> 
> 	struct request_queue *queue;
> 
> @@ -118,7 +117,7 @@ struct cardinfo {
> 		struct mm_dma_desc	*desc;
> 		int	 		cnt, headcnt;
> 		struct bio		*bio, **biotail;
> -		int			idx;
> +		struct bvec_iter	iter;
> 	} mm_pages[2];
> #define DESC_PER_PAGE ((PAGE_SIZE*2)/sizeof(struct mm_dma_desc))
> 
> @@ -344,16 +343,13 @@ static int add_bio(struct cardinfo *card)
> 	dma_addr_t dma_handle;
> 	int offset;
> 	struct bio *bio;
> -	struct bio_vec *vec;
> -	int idx;
> +	struct bio_vec vec;
> 	int rw;
> -	int len;
> 
> 	bio = card->currentbio;
> 	if (!bio && card->bio) {
> 		card->currentbio = card->bio;
> -		card->current_idx = card->bio->bi_iter.bi_idx;
> -		card->current_sector = card->bio->bi_iter.bi_sector;
> +		card->current_iter = card->bio->bi_iter;
> 		card->bio = card->bio->bi_next;
> 		if (card->bio == NULL)
> 			card->biotail = &card->bio;
> @@ -362,18 +358,17 @@ static int add_bio(struct cardinfo *card)
> 	}
> 	if (!bio)
> 		return 0;
> -	idx = card->current_idx;
> 
> 	rw = bio_rw(bio);
> 	if (card->mm_pages[card->Ready].cnt >= DESC_PER_PAGE)
> 		return 0;
> 
> -	vec = bio_iovec_idx(bio, idx);
> -	len = vec->bv_len;
> +	vec = bio_iovec_iter(bio, card->current_iter);
> +
> 	dma_handle = pci_map_page(card->dev,
> -				  vec->bv_page,
> -				  vec->bv_offset,
> -				  len,
> +				  vec.bv_page,
> +				  vec.bv_offset,
> +				  vec.bv_len,
> 				  (rw == READ) ?
> 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
> 
> @@ -381,7 +376,7 @@ static int add_bio(struct cardinfo *card)
> 	desc = &p->desc[p->cnt];
> 	p->cnt++;
> 	if (p->bio == NULL)
> -		p->idx = idx;
> +		p->iter = card->current_iter;
> 	if ((p->biotail) != &bio->bi_next) {
> 		*(p->biotail) = bio;
> 		p->biotail = &(bio->bi_next);
> @@ -391,8 +386,8 @@ static int add_bio(struct cardinfo *card)
> 	desc->data_dma_handle = dma_handle;
> 
> 	desc->pci_addr = cpu_to_le64((u64)desc->data_dma_handle);
> -	desc->local_addr = cpu_to_le64(card->current_sector << 9);
> -	desc->transfer_size = cpu_to_le32(len);
> +	desc->local_addr = cpu_to_le64(card->current_iter.bi_sector << 9);
> +	desc->transfer_size = cpu_to_le32(vec.bv_len);
> 	offset = (((char *)&desc->sem_control_bits) - ((char *)p->desc));
> 	desc->sem_addr = cpu_to_le64((u64)(p->page_dma+offset));
> 	desc->zero1 = desc->zero2 = 0;
> @@ -407,10 +402,9 @@ static int add_bio(struct cardinfo *card)
> 		desc->control_bits |= cpu_to_le32(DMASCR_TRANSFER_READ);
> 	desc->sem_control_bits = desc->control_bits;
> 
> -	card->current_sector += (len >> 9);
> -	idx++;
> -	card->current_idx = idx;
> -	if (idx >= bio->bi_vcnt)
> +
> +	bio_advance_iter(bio, &card->current_iter, vec.bv_len);
> +	if (!card->current_iter.bi_size)
> 		card->currentbio = NULL;
> 
> 	return 1;
> @@ -439,23 +433,25 @@ static void process_page(unsigned long data)
> 		struct mm_dma_desc *desc = &page->desc[page->headcnt];
> 		int control = le32_to_cpu(desc->sem_control_bits);
> 		int last = 0;
> -		int idx;
> +		struct bio_vec vec;
> 
> 		if (!(control & DMASCR_DMA_COMPLETE)) {
> 			control = dma_status;
> 			last = 1;
> 		}
> +
> 		page->headcnt++;
> -		idx = page->idx;
> -		page->idx++;
> -		if (page->idx >= bio->bi_vcnt) {
> +		vec = bio_iovec_iter(bio, page->iter);
> +		bio_advance_iter(bio, &page->iter, vec.bv_len);
> +
> +		if (!page->iter.bi_size) {
> 			page->bio = bio->bi_next;
> 			if (page->bio)
> -				page->idx = page->bio->bi_iter.bi_idx;
> +				page->iter = page->bio->bi_iter;
> 		}
> 
> 		pci_unmap_page(card->dev, desc->data_dma_handle,
> -			       bio_iovec_idx(bio, idx)->bv_len,
> +			       vec.bv_len,
> 				 (control & DMASCR_TRANSFER_READ) ?
> 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
> 		if (control & DMASCR_HARD_ERROR) {
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index fca3bba..d97d824 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -38,10 +38,8 @@ struct convert_context {
> 	struct completion restart;
> 	struct bio *bio_in;
> 	struct bio *bio_out;
> -	unsigned int offset_in;
> -	unsigned int offset_out;
> -	unsigned int idx_in;
> -	unsigned int idx_out;
> +	struct bvec_iter iter_in;
> +	struct bvec_iter iter_out;
> 	sector_t cc_sector;
> 	atomic_t cc_pending;
> };
> @@ -650,10 +648,12 @@ static void crypt_convert_init(struct crypt_config *cc,
> {
> 	ctx->bio_in = bio_in;
> 	ctx->bio_out = bio_out;
> -	ctx->offset_in = 0;
> -	ctx->offset_out = 0;
> -	ctx->idx_in = bio_in ? bio_in->bi_iter.bi_idx : 0;
> -	ctx->idx_out = bio_out ? bio_out->bi_iter.bi_idx : 0;
> +
> +	if (bio_in)
> +		ctx->iter_in = bio_in->bi_iter;
> +	if (bio_out)
> +		ctx->iter_out = bio_out->bi_iter;
> +
> 	ctx->cc_sector = sector + cc->iv_offset;
> 	init_completion(&ctx->restart);
> }
> @@ -681,8 +681,8 @@ static int crypt_convert_block(struct crypt_config *cc,
> 			       struct convert_context *ctx,
> 			       struct ablkcipher_request *req)
> {
> -	struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
> -	struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
> +	struct bio_vec bv_in = bio_iovec_iter(ctx->bio_in, ctx->iter_in);
> +	struct bio_vec bv_out = bio_iovec_iter(ctx->bio_out, ctx->iter_out);
> 	struct dm_crypt_request *dmreq;
> 	u8 *iv;
> 	int r;
> @@ -693,24 +693,15 @@ static int crypt_convert_block(struct crypt_config *cc,
> 	dmreq->iv_sector = ctx->cc_sector;
> 	dmreq->ctx = ctx;
> 	sg_init_table(&dmreq->sg_in, 1);
> -	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
> -		    bv_in->bv_offset + ctx->offset_in);
> +	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
> +		    bv_in.bv_offset);
> 
> 	sg_init_table(&dmreq->sg_out, 1);
> -	sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
> -		    bv_out->bv_offset + ctx->offset_out);
> +	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
> +		    bv_out.bv_offset);
> 
> -	ctx->offset_in += 1 << SECTOR_SHIFT;
> -	if (ctx->offset_in >= bv_in->bv_len) {
> -		ctx->offset_in = 0;
> -		ctx->idx_in++;
> -	}
> -
> -	ctx->offset_out += 1 << SECTOR_SHIFT;
> -	if (ctx->offset_out >= bv_out->bv_len) {
> -		ctx->offset_out = 0;
> -		ctx->idx_out++;
> -	}
> +	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
> +	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
> 
> 	if (cc->iv_gen_ops) {
> 		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
> @@ -761,8 +752,8 @@ static int crypt_convert(struct crypt_config *cc,
> 
> 	atomic_set(&ctx->cc_pending, 1);
> 
> -	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
> -	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
> +	while (ctx->iter_in.bi_size &&
> +	       ctx->iter_out.bi_size) {
> 
> 		crypt_alloc_req(cc, ctx);
> 
> @@ -1031,7 +1022,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
> 	}
> 
> 	/* crypt_convert should have filled the clone bio */
> -	BUG_ON(io->ctx.idx_out < clone->bi_vcnt);
> +	BUG_ON(io->ctx.iter_out.bi_size);
> 
> 	clone->bi_iter.bi_sector = cc->start + io->sector;
> 
> @@ -1070,7 +1061,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
> 		}
> 
> 		io->ctx.bio_out = clone;
> -		io->ctx.idx_out = 0;
> +		io->ctx.iter_out = clone->bi_iter;
> 
> 		remaining -= clone->bi_iter.bi_size;
> 		sector += bio_sectors(clone);
> @@ -1114,8 +1105,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
> 			crypt_inc_pending(new_io);
> 			crypt_convert_init(cc, &new_io->ctx, NULL,
> 					   io->base_bio, sector);
> -			new_io->ctx.idx_in = io->ctx.idx_in;
> -			new_io->ctx.offset_in = io->ctx.offset_in;
> +			new_io->ctx.iter_in = io->ctx.iter_in;
> 
> 			/*
> 			 * Fragments after the first use the base_io
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index a6de5c9..c2a6c34 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -202,26 +202,29 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
> /*
>  * Functions for getting the pages from a bvec.
>  */
> -static void bvec_get_page(struct dpages *dp,
> +static void bio_get_page(struct dpages *dp,
> 		  struct page **p, unsigned long *len, unsigned *offset)
> {
> -	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
> -	*p = bvec->bv_page;
> -	*len = bvec->bv_len;
> -	*offset = bvec->bv_offset;
> +	struct bio *bio = dp->context_ptr;
> +	struct bio_vec bvec = bio_iovec(bio);
> +	*p = bvec.bv_page;
> +	*len = bvec.bv_len;
> +	*offset = bvec.bv_offset;
> }
> 
> -static void bvec_next_page(struct dpages *dp)
> +static void bio_next_page(struct dpages *dp)
> {
> -	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
> -	dp->context_ptr = bvec + 1;
> +	struct bio *bio = dp->context_ptr;
> +	struct bio_vec bvec = bio_iovec(bio);
> +
> +	bio_advance(bio, bvec.bv_len);
> }
> 
> -static void bvec_dp_init(struct dpages *dp, struct bio_vec *bvec)
> +static void bio_dp_init(struct dpages *dp, struct bio *bio)
> {
> -	dp->get_page = bvec_get_page;
> -	dp->next_page = bvec_next_page;
> -	dp->context_ptr = bvec;
> +	dp->get_page = bio_get_page;
> +	dp->next_page = bio_next_page;
> +	dp->context_ptr = bio;
> }
> 
> /*
> @@ -459,8 +462,8 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
> 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
> 		break;
> 
> -	case DM_IO_BVEC:
> -		bvec_dp_init(dp, io_req->mem.ptr.bvec);
> +	case DM_IO_BIO:
> +		bio_dp_init(dp, io_req->mem.ptr.bio);
> 		break;
> 
> 	case DM_IO_VMA:
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index e3efb91..56e8844 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -526,8 +526,8 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
> 	struct dm_io_region io;
> 	struct dm_io_request io_req = {
> 		.bi_rw = READ,
> -		.mem.type = DM_IO_BVEC,
> -		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
> +		.mem.type = DM_IO_BIO,
> +		.mem.ptr.bio = bio,
> 		.notify.fn = read_callback,
> 		.notify.context = bio,
> 		.client = m->ms->io_client,
> @@ -629,8 +629,8 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
> 	struct mirror *m;
> 	struct dm_io_request io_req = {
> 		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
> -		.mem.type = DM_IO_BVEC,
> -		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
> +		.mem.type = DM_IO_BIO,
> +		.mem.ptr.bio = bio,
> 		.notify.fn = write_callback,
> 		.notify.context = bio,
> 		.client = ms->io_client,
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> index f3a4dcb..5e82c79 100644
> --- a/drivers/md/dm-verity.c
> +++ b/drivers/md/dm-verity.c
> @@ -73,15 +73,10 @@ struct dm_verity_io {
> 	sector_t block;
> 	unsigned n_blocks;
> 
> -	/* saved bio vector */
> -	struct bio_vec *io_vec;
> -	unsigned io_vec_size;
> +	struct bvec_iter iter;
> 
> 	struct work_struct work;
> 
> -	/* A space for short vectors; longer vectors are allocated separately. */
> -	struct bio_vec io_vec_inline[DM_VERITY_IO_VEC_INLINE];
> -
> 	/*
> 	 * Three variably-size fields follow this struct:
> 	 *
> @@ -284,9 +279,10 @@ release_ret_r:
> static int verity_verify_io(struct dm_verity_io *io)
> {
> 	struct dm_verity *v = io->v;
> +	struct bio *bio = dm_bio_from_per_bio_data(io,
> +						   v->ti->per_bio_data_size);
> 	unsigned b;
> 	int i;
> -	unsigned vector = 0, offset = 0;
> 
> 	for (b = 0; b < io->n_blocks; b++) {
> 		struct shash_desc *desc;
> @@ -336,31 +332,22 @@ test_block_hash:
> 		}
> 
> 		todo = 1 << v->data_dev_block_bits;
> -		do {
> -			struct bio_vec *bv;
> +		while (io->iter.bi_size) {
> 			u8 *page;
> -			unsigned len;
> -
> -			BUG_ON(vector >= io->io_vec_size);
> -			bv = &io->io_vec[vector];
> -			page = kmap_atomic(bv->bv_page);
> -			len = bv->bv_len - offset;
> -			if (likely(len >= todo))
> -				len = todo;
> -			r = crypto_shash_update(desc,
> -					page + bv->bv_offset + offset, len);
> +			struct bio_vec bv = bio_iovec_iter(bio, io->iter);
> +
> +			page = kmap_atomic(bv.bv_page);
> +			r = crypto_shash_update(desc, page + bv.bv_offset,
> +						bv.bv_len);
> 			kunmap_atomic(page);
> +
> 			if (r < 0) {
> 				DMERR("crypto_shash_update failed: %d", r);
> 				return r;
> 			}
> -			offset += len;
> -			if (likely(offset == bv->bv_len)) {
> -				offset = 0;
> -				vector++;
> -			}
> -			todo -= len;
> -		} while (todo);
> +
> +			bio_advance_iter(bio, &io->iter, bv.bv_len);
> +		}
> 
> 		if (!v->version) {
> 			r = crypto_shash_update(desc, v->salt, v->salt_size);
> @@ -383,8 +370,6 @@ test_block_hash:
> 			return -EIO;
> 		}
> 	}
> -	BUG_ON(vector != io->io_vec_size);
> -	BUG_ON(offset);
> 
> 	return 0;
> }
> @@ -400,9 +385,6 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
> 	bio->bi_end_io = io->orig_bi_end_io;
> 	bio->bi_private = io->orig_bi_private;
> 
> -	if (io->io_vec != io->io_vec_inline)
> -		mempool_free(io->io_vec, v->vec_mempool);
> -
> 	bio_endio(bio, error);
> }
> 
> @@ -520,13 +502,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
> 
> 	bio->bi_end_io = verity_end_io;
> 	bio->bi_private = io;
> -	io->io_vec_size = bio_segments(bio);
> -	if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
> -		io->io_vec = io->io_vec_inline;
> -	else
> -		io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
> -	memcpy(io->io_vec, __bio_iovec(bio),
> -	       io->io_vec_size * sizeof(struct bio_vec));
> +	io->iter = bio->bi_iter;
> 
> 	verity_submit_prefetch(v, io);
> 
> diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
> index f4b0aa3..6cf1f62 100644
> --- a/include/linux/dm-io.h
> +++ b/include/linux/dm-io.h
> @@ -29,7 +29,7 @@ typedef void (*io_notify_fn)(unsigned long error, void *context);
> 
> enum dm_io_mem_type {
> 	DM_IO_PAGE_LIST,/* Page list */
> -	DM_IO_BVEC,	/* Bio vector */
> +	DM_IO_BIO,
> 	DM_IO_VMA,	/* Virtual memory area */
> 	DM_IO_KMEM,	/* Kernel memory */
> };
> @@ -41,7 +41,7 @@ struct dm_io_memory {
> 
> 	union {
> 		struct page_list *pl;
> -		struct bio_vec *bvec;
> +		struct bio *bio;
> 		void *vma;
> 		void *addr;
> 	} ptr;
> -- 
> 1.8.3.rc1
> 

-- 
  Ed Cashin
  ecashin@coraid.com



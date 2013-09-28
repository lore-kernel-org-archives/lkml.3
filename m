Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3I1E7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 00:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3I1E7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 00:59:13 -0400
Date: Sat, 28 Sep 2013 00:59:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20130928045909.GA19745@redhat.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375912471-5106-17-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07 2013 at  5:54pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> We need to convert the dm code to the new bvec_iter primitives which
> respect bi_bvec_done; they also allow us to drastically simplify dm's
> bio splitting code.
> 
> Also kill bio_sector_offset(), dm was the only user and it doesn't make
> much sense anymore.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> ---
>  drivers/md/dm.c     | 170 ++++++----------------------------------------------
>  fs/bio.c            |  38 ------------
>  include/linux/bio.h |   1 -
>  3 files changed, 18 insertions(+), 191 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 5544af7..696269d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1050,7 +1050,6 @@ struct clone_info {

<snip>

>  /*
>   * Creates a bio that consists of range of complete bvecs.
>   */
>  static void clone_bio(struct dm_target_io *tio, struct bio *bio,
> -		      sector_t sector, unsigned short idx,
> -		      unsigned short bv_count, unsigned len)
> +		      sector_t sector, unsigned len)
>  {
>  	struct bio *clone = &tio->clone;
> -	unsigned trim = 0;
>  
>  	__bio_clone(clone, bio);
> -	bio_setup_sector(clone, sector, len);
> -	bio_setup_bv(clone, idx, bv_count);
>  
> -	if (idx != bio->bi_iter.bi_idx ||
> -	    clone->bi_iter.bi_size < bio->bi_iter.bi_size)
> -		trim = 1;
> -	clone_bio_integrity(bio, clone, idx, len, 0, trim);
> +	if (bio_integrity(bio))
> +		bio_integrity_clone(clone, bio, GFP_NOIO);
> +
> +	bio_advance(clone, (sector - clone->bi_iter.bi_sector) << 9);
> +	bio->bi_iter.bi_size = len << 9;
> +
> +	if (bio_integrity(bio))
> +		bio_integrity_trim(clone, 0, len);
>  }
>  
>  static struct dm_target_io *alloc_tio(struct clone_info *ci,
> @@ -1182,10 +1137,7 @@ static int __send_empty_flush(struct clone_info *ci)
>  }
>  
>  static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
> -				     sector_t sector, int nr_iovecs,
> -				     unsigned short idx, unsigned short bv_count,
> -				     unsigned offset, unsigned len,
> -				     unsigned split_bvec)
> +				     sector_t sector, unsigned len)
>  {
>  	struct bio *bio = ci->bio;
>  	struct dm_target_io *tio;
> @@ -1199,11 +1151,8 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
>  		num_target_bios = ti->num_write_bios(ti, bio);
>  
>  	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
> -		tio = alloc_tio(ci, ti, nr_iovecs, target_bio_nr);
> -		if (split_bvec)
> -			clone_split_bio(tio, bio, sector, idx, offset, len);
> -		else
> -			clone_bio(tio, bio, sector, idx, bv_count, len);
> +		tio = alloc_tio(ci, ti, 0, target_bio_nr);
> +		clone_bio(tio, bio, sector, len);
>  		__map_bio(tio);
>  	}
>  }

Hey Kent,

I haven't been able to pinpoint the issue yet, but using your for-jens
branch, if I create a dm-thin volume with this lvm command:
lvcreate -L20G -V20G -T vg/pool --name thinlv

and try to format /dev/vg/thinlv with XFS the kernel warns and then
hangs with the following:

WARNING: CPU: 0 PID: 11789 at include/linux/bio.h:202 bio_advance+0xd0/0xe0()
Attempted to advance past end of bvec iter
Modules linked in: dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio libcrc32c skd(O) ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_i
block target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe 8021q libfc garp stp llc scsi_transport_fc scsi_tgt sunrpc cpufreq_ondemand ipt_R
EJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cni
c uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan vhost tun
kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_core mdio dm_mod ses e
nclosure sg acpi_cpufreq freq_table ext4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix sd_mod crc_t10dif crct10dif_common megaraid_sas
CPU: 0 PID: 11789 Comm: mkfs.xfs Tainted: G        W  O 3.12.0-rc2.snitm+ #74
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
 00000000000000ca ffff8803313156a8 ffffffff8151e8e8 00000000000000ca
 ffff8803313156f8 ffff8803313156e8 ffffffff8104c23c ffff880300000000
 ffff8802dd524220 0000000000000400 ffff8802ddfb9680 ffff8802dd524200
Call Trace:
 [<ffffffff8151e8e8>] dump_stack+0x49/0x61
 [<ffffffff8104c23c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104c326>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff811b1e40>] bio_advance+0xd0/0xe0
 [<ffffffffa015c63e>] __clone_and_map_data_bio+0xce/0x110 [dm_mod]
 [<ffffffffa015c706>] __split_and_process_non_flush+0x86/0xd0 [dm_mod]
 [<ffffffffa015c8ff>] __split_and_process_bio+0x1af/0x200 [dm_mod]
 [<ffffffffa015ca72>] _dm_request+0x122/0x190 [dm_mod]
 [<ffffffffa015cb08>] dm_request+0x28/0x40 [dm_mod]
 [<ffffffff81247040>] generic_make_request+0xc0/0x100
 [<ffffffff81247100>] submit_bio+0x80/0x170
 [<ffffffff811b7d9a>] do_direct_IO+0x6ea/0x10f0
 [<ffffffff811b8cf6>] do_blockdev_direct_IO+0x556/0x980
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff811b9175>] __blockdev_direct_IO+0x55/0x60
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff8112a53e>] ? lru_cache_add+0xe/0x10
 [<ffffffff811b4ce6>] blkdev_direct_IO+0x56/0x60
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff8111c5f2>] generic_file_direct_write+0xc2/0x180
 [<ffffffff81195b93>] ? file_update_time+0xa3/0xe0
 [<ffffffff8111ddf0>] __generic_file_aio_write+0x2d0/0x3b0
 [<ffffffff811b42e6>] blkdev_aio_write+0x56/0xa0
 [<ffffffff8117b8af>] do_sync_write+0x5f/0xa0
 [<ffffffff8117bb4d>] ? rw_verify_area+0x5d/0xe0
 [<ffffffff8117bc98>] vfs_write+0xc8/0x170
 [<ffffffff8117c2af>] SyS_write+0x5f/0xb0
 [<ffffffff8117c24e>] ? SyS_lseek+0x7e/0x80
 [<ffffffff8152b252>] system_call_fastpath+0x16/0x1b
---[ end trace 06fd13242c0bb957 ]---

Looks to be stuck in bvec_iter_advance's while loop?

BUG: soft lockup - CPU#0 stuck for 22s! [mkfs.xfs:11641]                                                                                                               
Modules linked in: dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio libcrc32c dm_mod ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_i
block target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe libfc 8021q garp scsi_transport_fc stp scsi_tgt llc sunrpc cpufreq_ondemand ipt_R
EJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cni
c uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vend
or_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_core mdio sg ses enclosure acpi_cpufreq freq_table ext
4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix sd_mod crc_t10dif crct10dif_common megaraid_sas [last unloaded: dm_mod]                                     
CPU: 0 PID: 11641 Comm: mkfs.xfs Tainted: G        W    3.12.0-rc2.snitm+ #74                                                                                          
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011                                 
task: ffff88032c626040 ti: ffff88032418e000 task.ti: ffff88032418e000                                                                                                  
RIP: 0010:[<ffffffff811b1dd4>]  [<ffffffff811b1dd4>] bio_advance+0x64/0xe0                                                                                             
RSP: 0018:ffff88032418f768  EFLAGS: 00000206                                                                                                                           
RAX: 0000000000000e00 RBX: ffff880321cec800 RCX: 0000000000000400                                                                                                      
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009                                                                                                      
RBP: ffff88032418f788 R08: 0000000000000000 R09: 0000000000000000                                                                                                      
R10: 00000000000006bf R11: 00000000000006bf R12: ffff88032efeec60                                                                                                      
R13: ffff88032418f6e8 R14: ffffffff8104c24f R15: ffff88032418f6f8                                                                                                      
FS:  00007fdd500a2740(0000) GS:ffff88033fc00000(0000) knlGS:0000000000000000                                                                                           
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                      
CR2: 00007fdd4a210000 CR3: 0000000324296000 CR4: 00000000000007f0                                                                                                      
Stack:                                                                                                                                                                 
 0000000000000000 ffff8802cbc5c5c0 0000000000000088 0000000000001000                                                                                                   
 ffff88032418f7e8 ffffffffa036663c 0000000100000008 ffffc90006618040                                                                                                   
 ffff88032418f838 ffff88032efeec40 ffff880300000000 ffff88032418f838                                                                                                   
Call Trace:                                                                                                                                                            
 [<ffffffffa036663c>] __clone_and_map_data_bio+0xcc/0x110 [dm_mod]                                                                                                     
 [<ffffffffa0366706>] __split_and_process_non_flush+0x86/0xd0 [dm_mod]                                                                                                 
 [<ffffffffa03668ff>] __split_and_process_bio+0x1af/0x200 [dm_mod]                                                                                                     
 [<ffffffffa0366a72>] _dm_request+0x122/0x190 [dm_mod]
 [<ffffffffa0366b08>] dm_request+0x28/0x40 [dm_mod]
 [<ffffffff81247040>] generic_make_request+0xc0/0x100
 [<ffffffff81247100>] submit_bio+0x80/0x170
 [<ffffffff811b7d9a>] do_direct_IO+0x6ea/0x10f0
 [<ffffffff811b8cf6>] do_blockdev_direct_IO+0x556/0x980
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff8112b179>] ? invalidate_inode_pages2_range+0x229/0x2c0
 [<ffffffff811b9175>] __blockdev_direct_IO+0x55/0x60
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff811b4ce6>] blkdev_direct_IO+0x56/0x60
 [<ffffffff811b3d60>] ? I_BDEV+0x10/0x10
 [<ffffffff8111c5f2>] generic_file_direct_write+0xc2/0x180
 [<ffffffff8111ddf0>] __generic_file_aio_write+0x2d0/0x3b0
 [<ffffffff811b42e6>] blkdev_aio_write+0x56/0xa0
 [<ffffffff8152667c>] ? __do_page_fault+0x25c/0x4b0
 [<ffffffff8117b8af>] do_sync_write+0x5f/0xa0
 [<ffffffff8117bb4d>] ? rw_verify_area+0x5d/0xe0
 [<ffffffff8117bc98>] vfs_write+0xc8/0x170
 [<ffffffff8117c89f>] SyS_pwrite64+0x9f/0xb0
 [<ffffffff8152b252>] system_call_fastpath+0x16/0x1b
Code: 8b 6e 78 77 67 45 85 e4 74 4a 8b 53 08 eb 05 45 85 e4 74 40 8b 4b 0c 48 c1 e1 04 42 8b 44 29 08 2b 43 10 39 d0 0f 47 c2 44 39 e0 <41> 0f 47 c4 29 c2 41 29 c4 03
43 10 89 53 08 89 43 10 42 3b 44

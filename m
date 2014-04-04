Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaDDRBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:01:15 -0400
Received: from numascale.com ([213.162.240.84]:36107 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbaDDRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:01:11 -0400
Message-ID: <533EE547.3030504@numascale.com>
Date: Sat, 05 Apr 2014 01:00:55 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
CC: Steffen Persvold <sp@numascale.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: ext4 performance falloff
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a larger system 1728 cores/4.5TB memory and 3.13.9, I'm seeing very 
low 600KB/s cached write performance to a local ext4 filesystem:

# mkfs.ext4 /dev/sda5
# mount /dev/sda5 /mnt
# dd if=/dev/zero of=/mnt/test bs=1M count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 17.4307 s, 602 kB/s

Whereas eg on XFS, performance is much more reasonable:

# mkfs.xfs /dev/sda5
# mount /dev/sda5 /mnt
# dd if=/dev/zero of=/mnt/test bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 2.39329 s, 43.8 MB/s

Perf shows the time spent in bitmask iteration:

     98.77%       dd  [kernel.kallsyms]  [k] find_next_bit 

                  |
                  --- find_next_bit
                     |
                     |--99.92%-- __percpu_counter_sum
                     |          ext4_has_free_clusters
                     |          ext4_claim_free_clusters
                     |          ext4_mb_new_blocks
                     |          ext4_ext_map_blocks
                     |          ext4_map_blocks
                     |          _ext4_get_block
                     |          ext4_get_block
                     |          __block_write_begin
                     |          ext4_write_begin
                     |          ext4_da_write_begin
                     |          generic_file_buffered_write
                     |          __generic_file_aio_write
                     |          generic_file_aio_write
                     |          ext4_file_write
                     |          do_sync_write
                     |          vfs_write
                     |          sys_write
                     |          system_call_fastpath
                     |          __write_nocancel
                     |          0x0
                      --0.08%-- [...]

Analysis shows that ext4 is reading from all cores' cpu-local data (thus 
expensive off-NUMA-node access) for each block written:

if (free_clusters - (nclusters + rsv + dirty_clusters) <
				EXT4_FREECLUSTERS_WATERMARK) {
	free_clusters  = percpu_counter_sum_positive(fcc);
	dirty_clusters = percpu_counter_sum_positive(dcc);
}

This threshold is defined as:

#define EXT4_FREECLUSTERS_WATERMARK (4 * (percpu_counter_batch * 
nr_cpu_ids))

I can see why this may get overlooked for systems with commensurate 
local storage, but some filesystems reasonably don't need to scale with 
core count. The filesystem I'm testing on and the rootfs (as it has 
/tmp) are 50GB.

There must be a good rationale for this being dependent on the number of 
cores rather than just the ratio of used space, right?

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale

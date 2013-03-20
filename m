Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3CTWQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:16:30 -0400
Received: from exprod8og116.obsmtp.com ([64.18.3.32]:48537 "HELO
	exprod8og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751586Ab3CTWQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:16:29 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 18:16:28 EDT
X-AuditID: ac1c210f-b7f486d000000c69-7a-514a3134efb1
From: Chayan Biswas <Chayan.Biswas@sandisk.com>
To: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>,
        "elliott@hp.com" <elliott@hp.com>,
        Sumant Patro <Sumant.Patro@sandisk.com>
Subject: RE: Question about make_request_fn based block drivers
Thread-Topic: Question about make_request_fn based block drivers
Thread-Index: AQHOJbY+jpMRTbLTZk+zWVOZ9reTQpivISoQ
Date: Wed, 20 Mar 2013 22:01:19 +0000
Message-ID: <E821E2F372F08945977BD15EAE588D61097E8222@SACMBXIP02.sdcorp.global.sandisk.com>
References: <20130320215838.GO30284@beardog.cce.hp.com>
In-Reply-To: <20130320215838.GO30284@beardog.cce.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.181.8.64]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRobxn66JoVegwdt/ehZLVm1jtbi8aw6b
	Rd/Xz6wWj6c8Y3Zg8fjx5iWzx85Zd9k9dm3byeTxeZNcAEsUl01Kak5mWWqRvl0CV8adh18Z
	C3YoVnQs3cPawLheuouRk0NCwERi38kX7BC2mMSFe+vZQGwhgeOMEg8upXcxcgHZ5xglei8v
	BytiE9CXaLq2jg0kISLQwCix78g3dhCHWaCTUWL66UZGkCphAXuJz92/wUaJCDhIPDnxgBHC
	NpK42/wLbBKLgKpE+9XZYHFegWiJm7vPMkKsNpd49WofUC8HB6eAhcT3q34gYUag676fWsME
	YjMLiEvcejKfCeJqAYkle84zQ9iiEi8f/2MFaZUQkJe4ftoOolxHYsHuT2wQtrbEsoWvmSG2
	CkqcnPmEZQKj2CwkU2chaZmFpGUWkpYFjCyrGMWKE5OLc9NTCwyN9IoT81Iyi7P1kvNzNzGC
	40yRfwfjtinmhxgFOBiVeHg5nngGCrEmlhVX5h5ilOBgVhLhXabkFSjEm5JYWZValB9fVJqT
	WnyIkYmDU6qBMbm2YorWD4vAzGNqVcEnv6me++q9Sipx3eUNHbMFZr1yEntdp+su98eet8X7
	tPDtEy3lxUZios1MZ5Yd6+J9VH5sh77wZhabg/lNp8Tb5BwyC90d73Z83x9yeFnExm+sgft3
	mCk8Zl3QPMf/8710RuVPbvbqhU8Cy4r0jkhaRWhnR5239BNXYinOSDTUYi4qTgQAdU5SVpEC
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it! It is fixed now!!

Just one line fix, like last time. The drive capacity is 1 more than the value returned by READ_CAPACITY. Since the value we were setting was not a multiple of 4K, all the I/O were coming  in the lowest accessible size of 512 bytes.

Sumant gave me the idea to explore this angle and see what capacity we are setting. Earlier, I created a dummy block driver (ramdrive - sbull) of 1024 blocks and found it always gets 4K IO. Changing the size to 1023 made us get 512 byte I/O.

I am going to push the changes to github.

Thanks,
Chayan

> -----Original Message-----
> From: scameron@beardog.cce.hp.com
> [mailto:scameron@beardog.cce.hp.com]
> Sent: Wednesday, March 20, 2013 2:59 PM
> To: linux-kernel@vger.kernel.org
> Cc: stephenmcameron@gmail.com; scameron@beardog.cce.hp.com; Chayan
> Biswas; elliott@hp.com
> Subject: Question about make_request_fn based block drivers
>
>
> When running mke2fs against the make_request_fn based block driver
> I'm working on, I'm seeing only single-block bios.  Other such drivers
> (e.g. nvme) are getting, for example, 4k bios coming in from the same
> mke2fs command.
>
> mke2fs /dev/sop0
>
> This is on a 3.9-rc1 kernel.
>
> I've tried setting:
>
>       blk_queue_max_hw_sectors(rq, 2048);
>       blk_queue_max_segments(rq, 32);
>       blk_queue_io_opt(rq, 4096);
>       blk_queue_io_min(rq, 4096);
>       blk_queue_physical_block_size(rq, 4096);
>       blk_queue_logical_block_size(h->rq, 512);
>       blk_queue_physical_block_size(h->rq, 4096);
>
> all to no avail.
>
> If I do this:
>
>       dd if=/dev/sop0 of=/dev/null bs=4k iflag=direct
>
> with that, I can get 4k bios coming in to the make_request_fn.
>
> Driver source is here: https://github.com/HPSmartStorage/scsi-over-pcie
> (still a work in progress -- that source doesn't do all the blk_queue_*
> settings mentioned above, those are just the things I've tried.)
>
> In /sys/block/sop0/queue...
>
> [scameron@localhost queue]$ for x in *
> > do
> > echo ===== $x ======
> > cat $x
> > done
> ===== add_random ======
> 1
> ===== discard_granularity ======
> 0
> ===== discard_max_bytes ======
> 0
> ===== discard_zeroes_data ======
> 0
> ===== hw_sector_size ======
> 512
> ===== iostats ======
> 1
> ===== logical_block_size ======
> 512
> ===== max_hw_sectors_kb ======
> 1024
> ===== max_integrity_segments ======
> 0
> ===== max_sectors_kb ======
> 512
> ===== max_segments ======
> 32
> ===== max_segment_size ======
> 65536
> ===== minimum_io_size ======
> 4096
> ===== nomerges ======
> 2
> ===== nr_requests ======
> 128
> ===== optimal_io_size ======
> 4096
> ===== physical_block_size ======
> 4096
> ===== read_ahead_kb ======
> 128
> ===== rotational ======
> 0
> ===== rq_affinity ======
> 1
> ===== scheduler ======
> none
> ===== write_same_max_bytes ======
> 0
> [scameron@localhost queue]$
>
> Any ideas what I'm missing to get I/O's bigger than 1 block to come in?
>
> Thanks,
>
> -- steve


________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).


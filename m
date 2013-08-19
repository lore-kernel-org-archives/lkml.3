Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750815Ab3HSENS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:13:18 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41142 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3HSENR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:13:17 -0400
Message-ID: <52119B4E.4060409@linux.vnet.ibm.com>
Date: Mon, 19 Aug 2013 12:13:02 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, devel@driverdev.osuosl.org
Subject: Re: BUG: scheduling while atomic 3.10.7 in ZRAM Swap
References: <CAKcLGm8EMruO5e8yw+nArTjyCGSvLB5pjnGZYvz0xdF9M99iwQ@mail.gmail.com>
In-Reply-To: <CAKcLGm8EMruO5e8yw+nArTjyCGSvLB5pjnGZYvz0xdF9M99iwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-5490-0000-0000-000004015D73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mitch

On 08/17/2013 10:01 PM, Mitch Harder wrote:
> I'm encountering a BUG while using a ZRAM Swap device.
> 
> The call trace seems to involve the changes recently added to 3.10.6
> by the patch:
> zram: use zram->lock to protect zram_free_page() in swap free notify path
> 
> The hardware is a x86 single CPU AMD Athlon XP system with 1GB RAM.
> 
> I'm implementing a 352MB ZRAM swap device, and also have 1GB swap
> space on the hard disk.

IMHO, it was caused by that swap_entry_free() was invoked with page
spin-locked, thus zram_slot_free_notify() should not use rw-lock which
may goto sleep.

CC folks related.

Regards,
Michael Wang

> 
> The log include multiple messages similar to the following:
> 
> [ 3019.011511] BUG: scheduling while atomic: cc1/23223/0x00000001
> [ 3019.011517] Modules linked in: zram(C) nvidia(PO) nvidia_agp
> i2c_nforce2 xts gf128mul sha256_generic
> [ 3019.011528] CPU: 0 PID: 23223 Comm: cc1 Tainted: P         C O 3.10.7-std #1
> [ 3019.011531] Hardware name:    /MS-6570, BIOS 6.00 PG 03/29/2004
> [ 3019.011534]  f18d0c88 f18d0c88 e8673d30 c1859479 e8673d48 c1853a6d
> c1a11f18 f4f1b79c
> [ 3019.011539]  00005ab7 00000001 e8673dc8 c185e9dd e8673d60 c11130f0
> f6298e00 00000000
> [ 3019.011543]  c1b61b40 c10d8c40 f4f1b4f0 00001000 f4f1b4f0 00000001
> e8673d8c c10250ac
> [ 3019.011548] Call Trace:
> [ 3019.011561]  [<c1859479>] dump_stack+0x16/0x18
> [ 3019.011566]  [<c1853a6d>] __schedule_bug+0x4e/0x5c
> [ 3019.011573]  [<c185e9dd>] __schedule+0x4fd/0x5a0
> [ 3019.011580]  [<c11130f0>] ? bio_put+0x40/0x70
> [ 3019.011586]  [<c10d8c40>] ? end_swap_bio_read+0x30/0x80
> [ 3019.011593]  [<c10250ac>] ? kmap_atomic_prot+0x4c/0xd0
> [ 3019.011597]  [<c1025143>] ? kmap_atomic+0x13/0x20
> [ 3019.011604]  [<c10b5678>] ? get_page_from_freelist+0x278/0x500
> [ 3019.011609]  [<c185f112>] schedule+0x22/0x60
> [ 3019.011613]  [<c185f745>] rwsem_down_write_failed+0x95/0x110
> [ 3019.011618]  [<c13e4a76>] call_rwsem_down_write_failed+0x6/0x8
> [ 3019.011623]  [<f80430b0>] ? zram_free_page+0xb0/0xb0 [zram]
> [ 3019.011627]  [<c185e1d4>] ? down_write+0x24/0x30
> [ 3019.011630]  [<f80430d9>] zram_slot_free_notify+0x29/0x50 [zram]
> [ 3019.011635]  [<c10da084>] swap_entry_free+0xe4/0x140
> [ 3019.011639]  [<c10da498>] swapcache_free+0x28/0x40
> [ 3019.011643]  [<c10d95b6>] delete_from_swap_cache+0x26/0x40
> [ 3019.011646]  [<c10da55e>] reuse_swap_page+0x6e/0x80
> [ 3019.011652]  [<c10cba05>] do_wp_page.isra.84+0x225/0x5c0
> [ 3019.011656]  [<c10b9c32>] ? lru_cache_add_lru+0x22/0x40
> [ 3019.011662]  [<c10d427c>] ? page_add_new_anon_rmap+0x5c/0xa0
> [ 3019.011666]  [<c10cd34b>] handle_pte_fault+0x2db/0x5e0
> [ 3019.011669]  [<c10cd6d7>] handle_mm_fault+0x87/0xd0
> [ 3019.011674]  [<c18628e0>] ? __do_page_fault+0x480/0x480
> [ 3019.011677]  [<c18625d8>] __do_page_fault+0x178/0x480
> [ 3019.011683]  [<c1030cff>] ? __do_softirq+0x10f/0x1e0
> [ 3019.011691]  [<c1081e78>] ? handle_level_irq+0x58/0x90
> [ 3019.011695]  [<c1030ed4>] ? irq_exit+0x54/0x90
> [ 3019.011700]  [<c1866718>] ? do_IRQ+0x48/0x94
> [ 3019.011706]  [<c10e8607>] ? SyS_write+0x57/0xa0
> [ 3019.011710]  [<c18628e0>] ? __do_page_fault+0x480/0x480
> [ 3019.011713]  [<c18628ed>] do_page_fault+0xd/0x10
> [ 3019.011717]  [<c185fd21>] error_code+0x65/0x6c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


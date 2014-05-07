Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaEGHwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:52:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60532 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaEGHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:52:52 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-3e-5369e6512167
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Davidlohr Bueso'" <davidlohr@hp.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>, weijie.yang.kh@gmail.com,
        heesub.shin@samsung.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
References: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
 <20140505152014.GA8551@cerebellum.variantweb.net>
 <1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
 <20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
 <1399328550.2646.5.camel@buesod1.americas.hpqcorp.net>
In-reply-to: <1399328550.2646.5.camel@buesod1.americas.hpqcorp.net>
Subject: RE: [PATCH] zram: remove global tb_lock by using lock-free CAS
Date: Wed, 07 May 2014 15:51:35 +0800
Message-id: <000001cf69c9$5776f330$0664d990$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9osIOxyjPdmWfYRPOuS8Xb8lFzBgBEbdbw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd2gZ5nBBk+nslrMWb+GzaLr1FQW
	iyX3hS0utO1msTg4ewmTxeVdc9gs7q35z2qx7Ot7dosNLbPYLdZ+fsxu8enoIzaLJyf+szjw
	eOycdZfdY9e2nUweTyccZPLYtKqTzWPTp0nsHidm/Gbx+Pj0FotH35ZVjB7XvxV57Py0mdXj
	8ya5AO4oLpuU1JzMstQifbsEroy/J1YzF0xXrmj4eZWtgXG/dBcjJ4eEgInE5bOb2CFsMYkL
	99azdTFycQgJTGeU2Ha0gR3C+cMosXv7PxaQKjYBbYm7/RtZQWwRgXCJB/NWgRUxC/xhknjU
	38cK0bGMSWL33elsIFWcAs4SLXv3gu0QFnCXmNq2A2wSi4CqxKG+M0xdjBwcvAJ2EtfXGoGE
	eQUEJX5MvscCEmYWUJeYMiUXJMwsIC+xec1bZpCwBFD40V9diBOMJPZ17WaFKBGX2HjkFssE
	RqFZSAbNQhg0C8mgWUg6FjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjspnUjsYVzZY
	HGIU4GBU4uG1eJsRLMSaWFZcmXuIUYKDWUmEd9fFzGAh3pTEyqrUovz4otKc1OJDjNIcLEri
	vAdarQOFBNITS1KzU1MLUotgskwcnFINjDsjflbdT7zfr1LZ6DTr8ccwTtE7d2Vqau5urDDV
	lf/xXq8iJ9fxr/6nv7e1PkrNFPzMvbbkoOnLx3cP1eu8EfVriChVYrDku/+cuW5LVOnFyZuE
	d53rzIzfVPT7x2qfpSIfOSb5/k//b+jno6q3e9Is9+Dw/ddr36RUnVKeUXjFfuKHNkHpKiWW
	4oxEQy3mouJEAAc4QqnGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 6:22 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Mon, 2014-05-05 at 13:46 -0700, Andrew Morton wrote:
>> On Mon, 05 May 2014 11:00:44 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
>>
>> > > > @@ -339,12 +338,14 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>> > > >         unsigned long handle;
>> > > >         u16 size;
>> > > >
>> > > > -       read_lock(&meta->tb_lock);
>> > > > +       while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
>> > > > +               cpu_relax();
>> > > > +
>> > >
>> > > So... this might be dumb question, but this looks like a spinlock
>> > > implementation.
>> > >
>> > > What advantage does this have over a standard spinlock?
>> >
>> > I was wondering the same thing. Furthermore by doing this you'll loose
>> > the benefits of sharing the lock... your numbers do indicate that it is
>> > for the better. Also, note that hopefully rwlock_t will soon be updated
>> > to be fair and perform up to par with spinlocks, something which is long
>> > overdue. So you could reduce the critical region by implementing the
>> > same granularity, just don't implement your own locking schemes, like
>> > this.

Actually, the main reason I use a CAS rather than a standard lock here is
that I want to minimize the meta table memory overhead. A tiny reason is
my fuzzy memory that CAS is more efficient than spinlock (please correct me
if I am wrong).

Anyway, I changed the CAS to spinlock and rwlock, re-test them:

      Test       lock-free	   spinlock     rwlock
------------------------------------------------------
 Initial write   1424141.62   1426372.84   1423019.21
       Rewrite   1652504.81   1623307.14   1653682.04
          Read  11404668.35  11242885.05  10938125.00
       Re-read  11555483.75   11253906.6  10837773.50
  Reverse Read   8394478.17   8277250.34   7768057.39
   Stride read   9372229.95   9010498.53   8692871.77
   Random read   9187221.90   8988080.55   8661184.60
Mixed workload   5843370.85   5414729.54   5451055.03
  Random write   1608947.04   1572276.64   1588866.51
        Pwrite   1311055.32   1302463.04   1302001.06
         Pread   4652056.11   4555802.18   4469672.34

And I cann't say which one is the best, they have the similar performance.

Wait, iozone will create temporary files for every test thread, so there is no
possibility that these threads access the same table[index] concurrenctly.
So, I use fio to test the raw zram block device.
To enhance the possibility of access the same table[index] conflictly, I set zram
with a small disksize(10M) and let thread run with large loop count.

On the same test machine, the fio test command is:
fio --bs=32k --randrepeat=1 --randseed=100 --refill_buffers
--scramble_buffers=1 --direct=1 --loops=3000 --numjobs=4
--filename=/dev/zram0 --name=seq-write --rw=write --stonewall
--name=seq-read --rw=read --stonewall --name=seq-readwrite
--rw=rw --stonewall --name=rand-readwrite --rw=randrw --stonewall

    Test      base    lock-free   spinlock   rwlock
------------------------------------------------------
seq-write   935109.2   999580.5   998134.8   994384.6
 seq-read  5598064.6  6444011.5  6243184.6  6197514.2
   seq-rw  1403963.0  1635673.0  1633823.0  1635972.2
  rand-rw  1389864.4  1612520.4  1613403.6  1612129.8

This result(KB/s, average of 5 tests) shows the performance improvement
on base version, however, I cann't say which method is the best.

>>
>> It sounds like seqlocks will match this access pattern pretty well?
>
> Indeed. And after a closer look, except for zram_slot_free_notify(),
> that lock is always shared. So, unless fine graining it implies taking
> the lock exclusively like in this patch (if so, that needs to be
> explicitly documented in the changelog), we would ideally continue to
> share it. That _should_ provide nicer performance numbers when using the
> correct lock.
>

Andrew mentioned seqlocks, however, I think it is hard the use seqlocks here
after I recheck the codes. No matter use it as a meta global lock or a
table[index] lock. The main reason is the writer will free the handle rather than
just change some value.
If I misunderstand you, please let me know.

Now, I am in a delimma. For minimizing the memory overhead, I like to use CAS.
However, it is not a standard way.

Any complaint or suggestions are welcomed.

Regards,

>
>



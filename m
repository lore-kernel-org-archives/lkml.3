Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746Ab3E1QDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:03:53 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61469 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934639Ab3E1QDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130519175145.GC19194@moria.home.lan>
References: <20130517213223.GA2530@gmail.com>
	<20130518070515.GL19781@kernel.dk>
	<20130519175145.GC19194@moria.home.lan>
Date: Tue, 28 May 2013 12:03:49 -0400
X-Google-Sender-Auth: fAxLC2xi7rzfJZwogLaTAuqJc3s
Message-ID: <CAKb7UviiYUpatO5KtRzsD09pwf4Lz5PNmOVsqbNxVuyb2R18Rw@mail.gmail.com>
Subject: Re: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Calvin Owens <jcalvinowens@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>,
        majianpeng@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 1:51 PM, Kent Overstreet <koverstreet@google.com> wrote:
> On Sat, May 18, 2013 at 09:05:15AM +0200, Jens Axboe wrote:
>> On Fri, May 17 2013, Calvin Owens wrote:
>> > Commit 2f6db2a7 was part of a series that cleaned up mdraid code by
>> > replacing explicit re-initialization of struct bio with bio_reset().
>> >
>> > In raid5 it incorrectly assumed that a couple initializations of its
>> > members was a full reset, erasing the existing data and unconditionally
>> > triggering the following BUG when assembling arrays:
>> >
>> > [   14.653072] kernel BUG at /home/calvinow/git/linux/drivers/scsi/scsi_lib.c:1196!
>> > [   14.653074] invalid opcode: 0000 [#1] PREEMPT SMP
>> > [   14.653076] CPU: 1 PID: 40 Comm: kworker/1:0H Not tainted 3.10.0-rc1-amd-00279-g8f710dd #3
>> > [   14.653077] Hardware name: System manufacturer System Product Name/M5A88-M, BIOS 0601    09/20/2011
>> > [   14.653082] Workqueue: kblockd blk_delay_work
>> > <snip>
>> > [   14.653123] Call Trace:
>> > [   14.653126]  [<ffffffff81477248>] sd_prep_fn+0x2c8/0xb70
>> > [   14.653129]  [<ffffffff812c8b70>] ? deadline_remove_request.isra.9+0x50/0x90
>> > [   14.653132]  [<ffffffff812b8f5b>] blk_peek_request+0xdb/0x210
>> > [   14.653134]  [<ffffffff81465f15>] scsi_request_fn+0x45/0x4e0
>> > [   14.653136]  [<ffffffff812b6a51>] __blk_run_queue+0x31/0x40
>> > [   14.653138]  [<ffffffff812b6a84>] blk_delay_work+0x24/0x40
>> > [   14.653141]  [<ffffffff8105dc2a>] process_one_work+0x1da/0x490
>> > [   14.653143]  [<ffffffff8105dbcd>] ? process_one_work+0x17d/0x490
>> > [   14.653145]  [<ffffffff8105e32a>] worker_thread+0x11a/0x370
>> > [   14.653147]  [<ffffffff8105e210>] ? rescuer_thread+0x2f0/0x2f0
>> > [   14.653149]  [<ffffffff81066296>] kthread+0xd6/0xe0
>> > [   14.653151]  [<ffffffff810661c0>] ? __kthread_unpark+0x50/0x50
>> > [   14.653154]  [<ffffffff816e4d6c>] ret_from_fork+0x7c/0xb0
>> > [   14.653156]  [<ffffffff810661c0>] ? __kthread_unpark+0x50/0x50
>> > [   14.653172] Code: <snip>
>> > [   14.653174] RIP  [<ffffffff81467329>] scsi_setup_fs_cmnd+0x89/0x90
>> >
>> > Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
>>
>> Kent, there was a report on this issue yesterday as well. We need to get
>> this fixed up ASAP.
>
> Sorry for the delay - been vacationing. Reproduced the original bug,
> here's a patch that fixes it:

I saw this issue as well, and your patch fixes it for me (feel free to
add my Tested-By if necessary). It didn't appear to be in v3.10-rc3,
or any relevant git repos I could find -- just want to make sure it
didn't get lost somewhere down the line, since otherwise my system
dies.

>
>
> commit 402f5db3708b2062795a384a3d8397cf702e27bc
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Sun May 19 10:27:07 2013 -0700
>
>     raid5: Initialize bi_vcnt
>
>     The patch that converted raid5 to use bio_reset() forgot to initialize
>     bi_vcnt.
>
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
>     Cc: NeilBrown <neilb@suse.de>
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: linux-raid@vger.kernel.org
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9359828..753f318 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -664,6 +664,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>                         if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>                                 bi->bi_rw |= REQ_FLUSH;
>
> +                       bi->bi_vcnt = 1;
>                         bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
>                         bi->bi_io_vec[0].bv_offset = 0;
>                         bi->bi_size = STRIPE_SIZE;
> @@ -701,6 +702,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>                         else
>                                 rbi->bi_sector = (sh->sector
>                                                   + rrdev->data_offset);
> +                       rbi->bi_vcnt = 1;
>                         rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
>                         rbi->bi_io_vec[0].bv_offset = 0;
>                         rbi->bi_size = STRIPE_SIZE;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaLJW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:57:14 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52255 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbaLJW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:57:12 -0500
Date: Wed, 10 Dec 2014 14:57:07 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Ming Lin <mlin@minggr.net>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, linux-fsdevel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141210225707.GC31102@daterainc.com>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
 <20141208114813.GA2724@gmail.com>
 <CAF1ivSYYTO-abY32rFy2SVscPpxJaDyDZTULygXTys3rgWLONg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSYYTO-abY32rFy2SVscPpxJaDyDZTULygXTys3rgWLONg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 02:42:14PM -0800, Ming Lin wrote:
> On Mon, Dec 8, 2014 at 3:48 AM, Dongsu Park
> <dongsu.park@profitbricks.com> wrote:
> > Thanks for the reply.
> >
> > On 05.12.2014 19:02, Kent Overstreet wrote:
> >> On Thu, Dec 04, 2014 at 12:00:27PM +0100, Dongsu Park wrote:
> >> > Playing a little with your block_stuff tree based on 3.15, however,
> >> > I think there still seems to be a couple of issues.
> >> > First of all, it doesn't work with virtio-blk. A testing Qemu VM panics
> >> > at the very early stage of booting. This issue should be addressed as
> >> > the first step, so that other parts can be tested.
> >>
> >> Really? I was testing with virtio-blk, that's odd..
> >
> > The culprit seems to be the plugging commit.
> > Before that change, it works well also with virtio-blk.
> > Though that's not the only issue...
> >
> >> > Moreover, I've already tried to rebase these patches on top of current
> >> > mainline, 3.18-rc7. It's now compilable, but it seems to introduce
> >> > more bugs about direct-IO. I didn't manage to find out the reason.
> >> > I'd need to also look at the previous review comments in [1], [2].
> >> >
> >> > Don't you have other trees based on top of 3.17 or higher?
> >> > If not, can I create my own tree based on 3.18-rc7 to publish?
> >>
> >> Yeah, I'd post what you have now and I'll try and take a look.
> >
> > I've created a git tree to include what I have right now.
> > Please see <https://github.com/dongsupark/linux>.
> >
> > To be able to handle different issues one by one,
> > I got the entire tree separated out into 4 branches based on 3.18.
> >
> > * block-generic-req-for-next : the most stable branch you can test with.
> >   With this branch, you can test most of block drivers as well as file
> >   systems with less critical bugs. Though it's not 100% perfect yet,
> >   e.g. btrfs doesn't seem to work quite well. Thus more tests are needed.
> >
> > * block-mpage-bvecs-for-next : block-generic-req-for-next + multipage bvecs.
> >   This branch shows a critical issue that writing blocks to ext4 rootfs
> >   causes the whole system to crash. Need-to-investigate.
> 
> I tried block-mpage-bvecs-for-next branch on qemu-kvm with ext4 rootfs.
> Run "sync" will stuck in kernel.
> 
> [  480.751901] INFO: task sync:4424 blocked for more than 120 seconds.
> [  480.753064]       Not tainted 3.18.0-00025-g46c8231 #39
> [  480.753720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  480.754737] sync            D ffff88001fc11180     0  4424   4338 0x00000000
> [  480.755719]  ffff88001cdfbc98 0000000000000086 ffff88001cdfbba8
> ffff880014adefc0
> [  480.756810]  0000000000011180 0000000000004000 ffffffff81813460
> ffff880014adefc0
> [  480.758102]  ffff88001cdfbbc8 ffffffff812f08be ffff88001cdfbc18
> ffff880014adf028
> [  480.759454] Call Trace:
> [  480.759852]  [<ffffffff812f08be>] ? debug_smp_processor_id+0x17/0x19
> [  480.760609]  [<ffffffff8106093e>] ? __enqueue_entity+0x69/0x6b
> [  480.761318]  [<ffffffff8106017e>] ? __dequeue_entity+0x33/0x38
> [  480.762026]  [<ffffffff810601ab>] ? set_next_entity+0x28/0x7d
> [  480.762739]  [<ffffffff8105a4fb>] ? get_parent_ip+0xf/0x3f
> [  480.763425]  [<ffffffff8108562b>] ? ktime_get+0x50/0x8f
> [  480.763848]  [<ffffffff8148abdb>] ? bit_wait_timeout+0x60/0x60
> [  480.764555]  [<ffffffff8148a6be>] schedule+0x6a/0x6c
> [  480.765186]  [<ffffffff8148a74f>] io_schedule+0x8f/0xcd
> [  480.765841]  [<ffffffff8148ac19>] bit_wait_io+0x3e/0x42
> [  480.766493]  [<ffffffff8148ae80>] __wait_on_bit+0x4d/0x86
> [  480.767183]  [<ffffffff810d4302>] ? find_get_pages_tag+0x106/0x133
> [  480.767847]  [<ffffffff810d4a63>] wait_on_page_bit+0x76/0x78
> [  480.768532]  [<ffffffff8106ab59>] ? wake_atomic_t_function+0x2d/0x2d
> [  480.769262]  [<ffffffff810d511f>] filemap_fdatawait_range+0x7e/0x11d
> [  480.769992]  [<ffffffff8148a639>] ? preempt_schedule+0x36/0x51
> [  480.770677]  [<ffffffff8105a4fb>] ? get_parent_ip+0xf/0x3f
> [  480.771848]  [<ffffffff810d51df>] filemap_fdatawait+0x21/0x23
> [  480.772530]  [<ffffffff811458ce>] sync_inodes_sb+0x158/0x1aa
> [  480.773201]  [<ffffffff81480303>] ? br_mdb_dump+0x225/0x495
> [  480.773885]  [<ffffffff81149ad8>] ? fdatawrite_one_bdev+0x18/0x18
> [  480.774592]  [<ffffffff81149aec>] sync_inodes_one_sb+0x14/0x16
> [  480.775278]  [<ffffffff81125937>] iterate_supers+0x6f/0xc4
> [  480.775847]  [<ffffffff81149bf4>] sys_sync+0x35/0x83
> [  480.776460]  [<ffffffff8148da52>] system_call_fastpath+0x12/0x17
> 
> 
> Here is a quick hack.
> 
> diff --git a/block/bio.c b/block/bio.c
> index 4020ccc..fbc7108 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -829,6 +829,11 @@ int bio_add_page(struct bio *bio, struct page *page,
>                 if (bvec_to_phys(bv) + bv->bv_len ==
>                     page_to_phys(page) + offset) {
>                         bv->bv_len += len;
> +                       /*
> +                        * Page is not added to bio vec.
> +                        * Clear PG_writeback so
> filemap_fdatawait_range() won't wait for it.
> +                        */
> +                       TestClearPageWriteback(page);
>                         goto done;
>                 }
>         }
> 
> Thanks,
> Ming

Try this fix:

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b24a2541a9..3d2610b02e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -63,15 +63,15 @@ static void buffer_io_error(struct buffer_head *bh)
 
 static void ext4_finish_bio(struct bio *bio)
 {
-	int i;
 	int error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+	bio_for_each_page_all(bvec, bio, iter) {
+		struct page *page = bvec.bv_page;
 		struct buffer_head *bh, *head;
-		unsigned bio_start = bvec->bv_offset;
-		unsigned bio_end = bio_start + bvec->bv_len;
+		unsigned bio_start = bvec.bv_offset;
+		unsigned bio_end = bio_start + bvec.bv_len;
 		unsigned under_io = 0;
 		unsigned long flags;
 

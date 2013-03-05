Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3CEXad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:30:33 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:53931 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3CEXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303041711070.28666@file.rdu.redhat.com>
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
	<20130304174254.GF8913@agk.fab.redhat.com>
	<CAKwO_5GwN8PCtK6tM=KWvZMJHb357O+Bh3TpF3k3vB_0x_FtpQ@mail.gmail.com>
	<Pine.LNX.4.64.1303041711070.28666@file.rdu.redhat.com>
Date: Tue, 5 Mar 2013 15:30:29 -0800
Message-ID: <CAKwO_5EEW3Aqoua1zBOa8s3mrEDf7ncOvg6t_AAeSnk0jYcUWg@mail.gmail.com>
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
From: Paul Taysom <taysom@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Paul Taysom <taysom@chromium.org>, agk@redhat.com, dm-devel@redhat.com,
        neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seconds_kernel_to_login: 8.17s
Passed all my other tests

On Mon, Mar 4, 2013 at 2:15 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Mon, 4 Mar 2013, Paul Taysom wrote:
>
>> On Mon, Mar 4, 2013 at 9:42 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>> > On Mon, Mar 04, 2013 at 08:45:48AM -0800, Paul Taysom wrote:
>> >> @@ -449,8 +468,14 @@ static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
>> >>                               hash_block_end = v->hash_blocks - 1;
>> >>               }
>> >>  no_prefetch_cluster:
>> >> -             dm_bufio_prefetch(v->bufio, hash_block_start,
>> >> -                               hash_block_end - hash_block_start + 1);
>> >> +             vw = kmalloc(sizeof(*vw), GFP_KERNEL);
>> >
>> > kmalloc?  mempool? ...
>> >
>> > Alasdair
>> >
>> The use of mempool would be a separate patch that would have to be
>> measured for performance impact.
>> -Paul
>>
>
> You don't have to use mempool. Just avoid prefetching if there is not
> enough memory for the prefetch structure.
>
> I reworked the patch, is uses an allocation that can fail and it generates
> just one workqueue entry for one request (the original patch generated one
> workqueue entry for hash tree level).
>
> Please test the patch and if it works and performs well, let's submit it.
>
> Mikulas
>
> ---
>
> Changed the dm-verity prefetching to use a worker thread to avoid
> a deadlock in dm-bufio.
>
> If generic_make_request is called recursively, it queues the I/O
> request on the current->bio_list without making the I/O request
> and returns. The routine making the recursive call cannot wait
> for the I/O to complete.
>
> The deadlock occurred when one thread grabbed the bufio_client
> mutex and waited for an I/O to complete but the I/O was queued
> on another thread's current->bio_list and it was waiting to get
> the mutex held by the first thread.
>
> The fix allows only one I/O request from dm-verity to dm-bufio
> per thread. To do this, the prefetch requests were queued on worker
> threads.
>
> In addition to avoiding the deadlock, this fix made a slight
> improvement in performance.
>
> seconds_kernel_to_login:
>   with prefetch:    8.43s
>   without prefetch: 9.2s
>   worker prefetch:  8.28s
>
> Signed-off-by: Paul Taysom <taysom@chromium.org>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org
> ---
>  drivers/md/dm-bufio.c  |    2 ++
>  drivers/md/dm-verity.c |   37 +++++++++++++++++++++++++++++++++----
>  2 files changed, 35 insertions(+), 4 deletions(-)
>
> Index: linux-3.8-fast/drivers/md/dm-verity.c
> ===================================================================
> --- linux-3.8-fast.orig/drivers/md/dm-verity.c  2013-03-04 22:49:20.000000000 +0100
> +++ linux-3.8-fast/drivers/md/dm-verity.c       2013-03-04 23:10:45.000000000 +0100
> @@ -93,6 +93,13 @@ struct dm_verity_io {
>          */
>  };
>
> +struct dm_verity_prefetch_work {
> +       struct work_struct work;
> +       struct dm_verity *v;
> +       sector_t block;
> +       unsigned n_blocks;
> +};
> +
>  static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
>  {
>         return (struct shash_desc *)(io + 1);
> @@ -424,15 +431,18 @@ static void verity_end_io(struct bio *bi
>   * The root buffer is not prefetched, it is assumed that it will be cached
>   * all the time.
>   */
> -static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
> +static void verity_prefetch_io(struct work_struct *work)
>  {
> +       struct dm_verity_prefetch_work *pw =
> +               container_of(work, struct dm_verity_prefetch_work, work);
> +       struct dm_verity *v = pw->v;
>         int i;
>
>         for (i = v->levels - 2; i >= 0; i--) {
>                 sector_t hash_block_start;
>                 sector_t hash_block_end;
> -               verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
> -               verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
> +               verity_hash_at_level(v, pw->block, i, &hash_block_start, NULL);
> +               verity_hash_at_level(v, pw->block + pw->n_blocks - 1, i, &hash_block_end, NULL);
>                 if (!i) {
>                         unsigned cluster = ACCESS_ONCE(dm_verity_prefetch_cluster);
>
> @@ -452,6 +462,25 @@ no_prefetch_cluster:
>                 dm_bufio_prefetch(v->bufio, hash_block_start,
>                                   hash_block_end - hash_block_start + 1);
>         }
> +
> +       kfree(pw);
> +}
> +
> +static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +       struct dm_verity_prefetch_work *pw;
> +
> +       pw = kmalloc(sizeof(struct dm_verity_prefetch_work),
> +               GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +
> +       if (!pw)
> +               return;
> +
> +       INIT_WORK(&pw->work, verity_prefetch_io);
> +       pw->v = v;
> +       pw->block = io->block;
> +       pw->n_blocks = io->n_blocks;
> +       queue_work(v->verify_wq, &pw->work);
>  }
>
>  /*
> @@ -498,7 +527,7 @@ static int verity_map(struct dm_target *
>         memcpy(io->io_vec, bio_iovec(bio),
>                io->io_vec_size * sizeof(struct bio_vec));
>
> -       verity_prefetch_io(v, io);
> +       verity_submit_prefetch(v, io);
>
>         generic_make_request(bio);
>
> Index: linux-3.8-fast/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-3.8-fast.orig/drivers/md/dm-bufio.c   2013-03-04 23:03:14.000000000 +0100
> +++ linux-3.8-fast/drivers/md/dm-bufio.c        2013-03-04 23:04:19.000000000 +0100
> @@ -1026,6 +1026,8 @@ void dm_bufio_prefetch(struct dm_bufio_c
>  {
>         struct blk_plug plug;
>
> +       BUG_ON(dm_bufio_in_request());
> +
>         blk_start_plug(&plug);
>         dm_bufio_lock(c);
>

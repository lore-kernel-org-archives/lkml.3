Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3EVUs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3EVUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:23 -0400
Date: Wed, 22 May 2013 13:48:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Steve Hodgson <steve@purestorage.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 02/14] add blockconsole version 1.1
Message-Id: <20130522134822.f2f5d17beb6196bc4c4deb7e@linux-foundation.org>
In-Reply-To: <1368132193-25817-5-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-5-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:43:00 -0400 Joern Engel <joern@logfs.org> wrote:

> Console driver similar to netconsole, except it writes to a block
> device.  Can be useful in a setup where netconsole, for whatever
> reasons, is impractical.

It would be useful to provide a description of how the code works.  How
it avoids sleeping memory allocations on the disk-writing path.  What
the kernel thread does.  General overview of data flow.  How we avoid
recursion when it's called from within block/driver/etc code paths. 
What's all that special-case handling of panic() for.

>
> ...
>
>  Documentation/block/blockconsole.txt            |   94 ++++
>  Documentation/block/blockconsole/bcon_tail      |   62 +++
>  Documentation/block/blockconsole/mkblockconsole |   29 ++

We really need somewhere better to put userspace tools.

>  block/partitions/Makefile                       |    1 +
>  block/partitions/blockconsole.c                 |   22 +
>  block/partitions/check.c                        |    3 +
>  block/partitions/check.h                        |    3 +
>  drivers/block/Kconfig                           |    6 +
>  drivers/block/Makefile                          |    1 +
>  drivers/block/blockconsole.c                    |  621 +++++++++++++++++++++++
>
> ...
>
> +#define CACHE_MASK		(CACHE_SIZE - 1)
> +#define SECTOR_SHIFT		(9)
> +#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
> +#define SECTOR_MASK		(~(SECTOR_SIZE-1))
> +#define PG_SECTOR_MASK		((PAGE_SIZE >> 9) - 1)
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This normally goes before the #includes, making the undef unnecessary.

> +struct bcon_bio {
> +	struct bio bio;
> +	struct bio_vec bvec;
> +	void *sector;
> +	int in_flight;
> +};
>
> ...
>
> +static int sync_read(struct blockconsole *bc, u64 ofs)
> +{
> +	struct bio bio;
> +	struct bio_vec bio_vec;
> +	struct completion complete;
> +
> +	bio_init(&bio);
> +	bio.bi_io_vec = &bio_vec;
> +	bio_vec.bv_page = bc->pages;
> +	bio_vec.bv_len = SECTOR_SIZE;
> +	bio_vec.bv_offset = 0;
> +	bio.bi_vcnt = 1;
> +	bio.bi_idx = 0;
> +	bio.bi_size = SECTOR_SIZE;
> +	bio.bi_bdev = bc->bdev;
> +	bio.bi_sector = ofs >> SECTOR_SHIFT;
> +	init_completion(&complete);
> +	bio.bi_private = &complete;
> +	bio.bi_end_io = request_complete;
> +
> +	submit_bio(READ, &bio);
> +	wait_for_completion(&complete);
> +	return test_bit(BIO_UPTODATE, &bio.bi_flags) ? 0 : -EIO;
> +}

It wouldn't hurt to have a few explanatory comments over these functions.

>
> ...
>
> +static int bcon_convert_old_format(struct blockconsole *bc)
> +{
> +	bc->uuid = get_random_int();
> +	bc->round = 0;
> +	bc->console_bytes = bc->write_bytes = 0;
> +	bcon_advance_console_bytes(bc, 0); /* To skip the header */
> +	bcon_advance_write_bytes(bc, 0); /* To wrap around, if necessary */
> +	bcon_erase_segment(bc);
> +	pr_info("converted %s from old format\n", bc->devname);
> +	return 0;
> +}

It's strange to have an upgrade-from-old-format feature in something
which hasn't even been merged yet.  Can we just ditch all this stuff?

>
> ...
>
> +#define BCON_MAX_ERRORS	10
> +static void bcon_end_io(struct bio *bio, int err)
> +{
> +	struct bcon_bio *bcon_bio = container_of(bio, struct bcon_bio, bio);
> +	struct blockconsole *bc = bio->bi_private;
> +	unsigned long flags;
> +
> +	/*
> +	 * We want to assume the device broken and free this console if
> +	 * we accumulate too many errors.  But if errors are transient,
> +	 * we also want to forget about them once writes succeed again.
> +	 * Oh, and we only want to reset the counter if it hasn't reached
> +	 * the limit yet, so we don't bcon_put() twice from here.
> +	 */
> +	spin_lock_irqsave(&bc->end_io_lock, flags);
> +	if (err) {
> +		if (bc->error_count++ == BCON_MAX_ERRORS) {
> +			pr_info("no longer logging to %s\n", bc->devname);

pr_info() may be too low a severity level?

How does the code handle the obvious recursion concern here?

> +			schedule_work(&bc->unregister_work);
> +		}
> +	} else {
> +		if (bc->error_count && bc->error_count < BCON_MAX_ERRORS)
> +			bc->error_count = 0;
> +	}
> +	/*
> +	 * Add padding (a bunch of spaces and a newline) early so bcon_pad
> +	 * only has to advance a pointer.
> +	 */
> +	clear_sector(bcon_bio->sector);
> +	bcon_bio->in_flight = 0;
> +	spin_unlock_irqrestore(&bc->end_io_lock, flags);
> +	bcon_put(bc);
> +}
> +
> +static void bcon_writesector(struct blockconsole *bc, int index)
> +{
> +	struct bcon_bio *bcon_bio = bc->bio_array + index;
> +	struct bio *bio = &bcon_bio->bio;
> +
> +	rmb();
> +	if (bcon_bio->in_flight)
> +		return;
> +	bcon_get(bc);
> +
> +	bio_init(bio);
> +	bio->bi_io_vec = &bcon_bio->bvec;
> +	bio->bi_vcnt = 1;
> +	bio->bi_size = SECTOR_SIZE;
> +	bio->bi_bdev = bc->bdev;
> +	bio->bi_private = bc;
> +	bio->bi_end_io = bcon_end_io;
> +
> +	bio->bi_idx = 0;
> +	bio->bi_sector = bc->write_bytes >> 9;
> +	bcon_bio->in_flight = 1;
> +	wmb();
> +	submit_bio(WRITE, bio);
> +}
> +
> +static int bcon_writeback(void *_bc)

So this is actually a kernel thread service loop.  The poorly-chosen
name and absence of code comments make this unobvious.

> +{
> +	struct blockconsole *bc = _bc;
> +	struct sched_param(sp);
> +
> +	sp.sched_priority = MAX_RT_PRIO - 1; /* Highest realtime prio */
> +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule();
> +		if (kthread_should_stop())
> +			break;

This looks wrong.  The sequence should be

		set_current_state(TASK_INTERRUPTIBLE);
		if (!kthread_should_stop())
			schedule();

to avoid missed-wakeup races.

> +		while (bcon_write_sector(bc) != bcon_console_sector(bc)) {
> +			bcon_writesector(bc, bcon_write_sector(bc));
> +			bcon_advance_write_bytes(bc, SECTOR_SIZE);
> +			if (bcon_write_sector(bc) == 0)
> +				bcon_erase_segment(bc);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void bcon_pad(unsigned long data)
> +{
> +	struct blockconsole *bc = (void *)data;
> +	unsigned int n;
> +
> +	/*
> +	 * We deliberately race against bcon_write here.  If we lose the race,
> +	 * our padding is no longer where we expected it to be, i.e. it is
> +	 * no longer a bunch of spaces with a newline at the end.  There could
> +	 * not be a newline at all or it could be somewhere in the middle.
> +	 * Either way, the log corruption is fairly obvious to spot and ignore
> +	 * for human readers.
> +	 */
> +	n = SECTOR_SIZE - bcon_console_ofs(bc);
> +	if (n != SECTOR_SIZE) {
> +		bcon_advance_console_bytes(bc, n);
> +		wake_up_process(bc->writeback_thread);
> +	}
> +}

wake_up_process() from within printk is problematic - it'll deadlock if
the caller is holding certain scheduler locks.  That's why
wake_up_klogd() does weird things.

> +static void bcon_write(struct console *console, const char *msg,
> +		unsigned int len)
> +{
> +	struct blockconsole *bc = container_of(console, struct blockconsole,
> +			console);

	struct blockconsole *bc;

	bc = container_of(console, struct blockconsole, console);

> +	unsigned int n;
> +	u64 console_bytes;
> +	int i;
> +
> +	while (len) {
> +		console_bytes = bc->console_bytes;
> +		i = __bcon_console_sector(console_bytes);
> +		rmb();
> +		if (bc->bio_array[i].in_flight)
> +			break;
> +		n = min_t(int, len, SECTOR_SIZE -
> +				__bcon_console_ofs(console_bytes));

Yes, the types are a bit random in all this code.  A mix of int,
unsigned, u64 in various places, often where one would expect a size_t.

> +		memcpy(bc->bio_array[i].sector +
> +				__bcon_console_ofs(console_bytes), msg, n);
> +		len -= n;
> +		msg += n;
> +		bcon_advance_console_bytes(bc, n);
> +	}
> +	wake_up_process(bc->writeback_thread);
> +	mod_timer(&bc->pad_timer, jiffies + HZ);
> +}
> +
> +static void bcon_init_bios(struct blockconsole *bc)

This code really needs some comments :(

Oh I see.  It's BIOs, not BIOS.  Had me fooled there.

> +{
> +	int i;
> +
> +	for (i = 0; i < SECTOR_COUNT; i++) {
> +		int page_index = i >> (PAGE_SHIFT - SECTOR_SHIFT);
> +		struct page *page = bc->pages + page_index;
> +		struct bcon_bio *bcon_bio = bc->bio_array + i;
> +		struct bio_vec *bvec = &bcon_bio->bvec;
> +
> +		bcon_bio->in_flight = 0;
> +		bcon_bio->sector = page_address(bc->pages + page_index)
> +			+ SECTOR_SIZE * (i & PG_SECTOR_MASK);
> +		clear_sector(bcon_bio->sector);
> +		bvec->bv_page = page;
> +		bvec->bv_len = SECTOR_SIZE;
> +		bvec->bv_offset = SECTOR_SIZE * (i & PG_SECTOR_MASK);
> +	}
> +}
>
> ...
>
> +static int blockconsole_panic(struct notifier_block *this, unsigned long event,
> +		void *ptr)
> +{
> +	struct blockconsole *bc = container_of(this, struct blockconsole,
> +			panic_block);

ditto

> +	unsigned int n;
> +
> +	n = SECTOR_SIZE - bcon_console_ofs(bc);
> +	if (n != SECTOR_SIZE)
> +		bcon_advance_console_bytes(bc, n);
> +	bcon_writeback(bc);
> +	return NOTIFY_DONE;
> +}
> +
> +static int bcon_create(const char *devname)
> +{
> +	const fmode_t mode = FMODE_READ | FMODE_WRITE;
> +	struct blockconsole *bc;
> +	int err;
> +
> +	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
> +	if (!bc)
> +		return -ENOMEM;
> +	memset(bc->devname, ' ', sizeof(bc->devname));
> +	strlcpy(bc->devname, devname, sizeof(bc->devname));
> +	spin_lock_init(&bc->end_io_lock);
> +	strcpy(bc->console.name, "bcon");
> +	bc->console.flags = CON_PRINTBUFFER | CON_ENABLED;
> +	bc->console.write = bcon_write;
> +	bc->bdev = blkdev_get_by_path(devname, mode, NULL);
> +#ifndef MODULE
> +	if (IS_ERR(bc->bdev)) {
> +		dev_t devt = name_to_dev_t(devname);
> +		if (devt)
> +			bc->bdev = blkdev_get_by_dev(devt, mode, NULL);
> +	}
> +#endif
> +	if (IS_ERR(bc->bdev))
> +		goto out;
> +	bc->pages = alloc_pages(GFP_KERNEL, 8);
> +	if (!bc->pages)
> +		goto out;
> +	bc->zero_page = alloc_pages(GFP_KERNEL, 0);
> +	if (!bc->zero_page)
> +		goto out1;
> +	bcon_init_bios(bc);
> +	bcon_init_zero_bio(bc);
> +	setup_timer(&bc->pad_timer, bcon_pad, (unsigned long)bc);
> +	bc->max_bytes = bc->bdev->bd_inode->i_size & ~CACHE_MASK;
> +	err = bcon_find_end_of_log(bc);
> +	if (err)
> +		goto out2;
> +	kref_init(&bc->kref); /* This reference gets freed on errors */
> +	bc->writeback_thread = kthread_run(bcon_writeback, bc, "bcon_%s",
> +			devname);
> +	if (IS_ERR(bc->writeback_thread))
> +		goto out2;

Should propagate the error, not assume ENOMEM.  Minor.

> +	INIT_WORK(&bc->unregister_work, bcon_unregister);
> +	register_console(&bc->console);
> +	bc->panic_block.notifier_call = blockconsole_panic;
> +	bc->panic_block.priority = INT_MAX;
> +	atomic_notifier_chain_register(&panic_notifier_list, &bc->panic_block);
> +	pr_info("now logging to %s at %llx\n", devname, bc->console_bytes >> 20);
> +
> +	return 0;
> +
> +out2:
> +	__free_pages(bc->zero_page, 0);
> +out1:
> +	__free_pages(bc->pages, 8);
> +out:
> +	kfree(bc);
> +	/* Not strictly correct, be the caller doesn't care */
> +	return -ENOMEM;
> +}
> +
> +static void bcon_create_fuzzy(const char *name)

comments, comments, comments.  What's this do and why does it do it and
why does it make assumptions about userspace namespace configuration.

> +{
> +	char *longname;
> +	int err;
> +
> +	err = bcon_create(name);
> +	if (err) {
> +		longname = kzalloc(strlen(name) + 6, GFP_KERNEL);
> +		if (!longname)
> +			return;
> +		strcpy(longname, "/dev/");
> +		strcat(longname, name);

kasprintf()?

> +		bcon_create(longname);
> +		kfree(longname);
> +	}
> +}
> +
> +static DEFINE_SPINLOCK(device_lock);
> +static char scanned_devices[80];
> +
> +static void bcon_do_add(struct work_struct *work)
> +{
> +	char local_devices[80], *name, *remainder = local_devices;
> +
> +	spin_lock(&device_lock);
> +	memcpy(local_devices, scanned_devices, sizeof(local_devices));
> +	memset(scanned_devices, 0, sizeof(scanned_devices));
> +	spin_unlock(&device_lock);
> +
> +	while (remainder && remainder[0]) {
> +		name = strsep(&remainder, ",");
> +		bcon_create_fuzzy(name);
> +	}
> +}
> +
> +DECLARE_WORK(bcon_add_work, bcon_do_add);
> +
> +void bcon_add(const char *name)
> +{
> +	/*
> +	 * We add each name to a small static buffer and ask for a workqueue
> +	 * to go pick it up asap.  Once it is picked up, the buffer is empty
> +	 * again, so hopefully it will suffice for all sane users.
> +	 */
> +	spin_lock(&device_lock);
> +	if (scanned_devices[0])
> +		strncat(scanned_devices, ",", sizeof(scanned_devices));
> +	strncat(scanned_devices, name, sizeof(scanned_devices));
> +	spin_unlock(&device_lock);
> +	schedule_work(&bcon_add_work);
> +}

What's all this do?

>
> ...
>


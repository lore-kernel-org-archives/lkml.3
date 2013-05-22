Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3EVWcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:32:41 -0400
Received: from longford.logfs.org ([213.229.74.203]:59247 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3EVWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:32:38 -0400
Date: Wed, 22 May 2013 17:04:16 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Steve Hodgson <steve@purestorage.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 02/14] add blockconsole version 1.1
Message-ID: <20130522210416.GF7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
 <1368132193-25817-5-git-send-email-joern@logfs.org>
 <20130522134822.f2f5d17beb6196bc4c4deb7e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522134822.f2f5d17beb6196bc4c4deb7e@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 13:48:22 -0700, Andrew Morton wrote:
> On Thu,  9 May 2013 16:43:00 -0400 Joern Engel <joern@logfs.org> wrote:
> 
> > Console driver similar to netconsole, except it writes to a block
> > device.  Can be useful in a setup where netconsole, for whatever
> > reasons, is impractical.
> 
> It would be useful to provide a description of how the code works.  How
> it avoids sleeping memory allocations on the disk-writing path.  What
> the kernel thread does.  General overview of data flow.  How we avoid
> recursion when it's called from within block/driver/etc code paths. 
> What's all that special-case handling of panic() for.

Documentation/block/blockconsole.txt has some of this, but not all.
Will add more inline documentation.

> >  Documentation/block/blockconsole.txt            |   94 ++++
> >  Documentation/block/blockconsole/bcon_tail      |   62 +++
> >  Documentation/block/blockconsole/mkblockconsole |   29 ++
> 
> We really need somewhere better to put userspace tools.

Agreed.  It started as "use this horrible code as a bad example" and
turned into a repository for userspace code, which it should have
been.

Do you have an opinion on tools/ vs. a standalong git tree for the
tools?

> > +#define CACHE_MASK		(CACHE_SIZE - 1)
> > +#define SECTOR_SHIFT		(9)
> > +#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
> > +#define SECTOR_MASK		(~(SECTOR_SIZE-1))
> > +#define PG_SECTOR_MASK		((PAGE_SIZE >> 9) - 1)
> > +
> > +#undef pr_fmt
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> This normally goes before the #includes, making the undef unnecessary.

Will do.

> It wouldn't hurt to have a few explanatory comments over these functions.

Sure.

> > +static int bcon_convert_old_format(struct blockconsole *bc)
> > +{
> > +	bc->uuid = get_random_int();
> > +	bc->round = 0;
> > +	bc->console_bytes = bc->write_bytes = 0;
> > +	bcon_advance_console_bytes(bc, 0); /* To skip the header */
> > +	bcon_advance_write_bytes(bc, 0); /* To wrap around, if necessary */
> > +	bcon_erase_segment(bc);
> > +	pr_info("converted %s from old format\n", bc->devname);
> > +	return 0;
> > +}
> 
> It's strange to have an upgrade-from-old-format feature in something
> which hasn't even been merged yet.  Can we just ditch all this stuff?

Done in a later patch, as you noticed.

> > +#define BCON_MAX_ERRORS	10
> > +static void bcon_end_io(struct bio *bio, int err)
> > +{
> > +	struct bcon_bio *bcon_bio = container_of(bio, struct bcon_bio, bio);
> > +	struct blockconsole *bc = bio->bi_private;
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * We want to assume the device broken and free this console if
> > +	 * we accumulate too many errors.  But if errors are transient,
> > +	 * we also want to forget about them once writes succeed again.
> > +	 * Oh, and we only want to reset the counter if it hasn't reached
> > +	 * the limit yet, so we don't bcon_put() twice from here.
> > +	 */
> > +	spin_lock_irqsave(&bc->end_io_lock, flags);
> > +	if (err) {
> > +		if (bc->error_count++ == BCON_MAX_ERRORS) {
> > +			pr_info("no longer logging to %s\n", bc->devname);
> 
> pr_info() may be too low a severity level?

There is no distinction between "someone pulled the usb device" and
"broken cable".  Blockconsole will continue writing and retire the
device if errors accumulate.  The code is deliberately stupid, because
stupid code tends to be more robust and devoid of strange
corner-cases.

> How does the code handle the obvious recursion concern here?

I think your next comment answers that.

> > +static int bcon_writeback(void *_bc)
> 
> So this is actually a kernel thread service loop.  The poorly-chosen
> name and absence of code comments make this unobvious.
> 
> > +{
> > +	struct blockconsole *bc = _bc;
> > +	struct sched_param(sp);
> > +
> > +	sp.sched_priority = MAX_RT_PRIO - 1; /* Highest realtime prio */
> > +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> > +	for (;;) {
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		schedule();
> > +		if (kthread_should_stop())
> > +			break;
> 
> This looks wrong.  The sequence should be
> 
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		if (!kthread_should_stop())
> 			schedule();
> 
> to avoid missed-wakeup races.

Ack.  I may have copied that from somewhere else.  Will see if there
are any other bad examples in the kernel.

> > +static void bcon_pad(unsigned long data)
> > +{
> > +	struct blockconsole *bc = (void *)data;
> > +	unsigned int n;
> > +
> > +	/*
> > +	 * We deliberately race against bcon_write here.  If we lose the race,
> > +	 * our padding is no longer where we expected it to be, i.e. it is
> > +	 * no longer a bunch of spaces with a newline at the end.  There could
> > +	 * not be a newline at all or it could be somewhere in the middle.
> > +	 * Either way, the log corruption is fairly obvious to spot and ignore
> > +	 * for human readers.
> > +	 */
> > +	n = SECTOR_SIZE - bcon_console_ofs(bc);
> > +	if (n != SECTOR_SIZE) {
> > +		bcon_advance_console_bytes(bc, n);
> > +		wake_up_process(bc->writeback_thread);
> > +	}
> > +}
> 
> wake_up_process() from within printk is problematic - it'll deadlock if
> the caller is holding certain scheduler locks.  That's why
> wake_up_klogd() does weird things.

Will take a look.  My lame answer is "but I am running this on X
machines and it seems to work."  Would be nice if deadlocks were not
just rare in practice, but impossible - to the extend one can prove
anything in a codebase the size of the kernel.

> > +static void bcon_write(struct console *console, const char *msg,
> > +		unsigned int len)
> > +{
> > +	struct blockconsole *bc = container_of(console, struct blockconsole,
> > +			console);
> 
> 	struct blockconsole *bc;
> 
> 	bc = container_of(console, struct blockconsole, console);

Ack.

> > +	unsigned int n;
> > +	u64 console_bytes;
> > +	int i;
> > +
> > +	while (len) {
> > +		console_bytes = bc->console_bytes;
> > +		i = __bcon_console_sector(console_bytes);
> > +		rmb();
> > +		if (bc->bio_array[i].in_flight)
> > +			break;
> > +		n = min_t(int, len, SECTOR_SIZE -
> > +				__bcon_console_ofs(console_bytes));
> 
> Yes, the types are a bit random in all this code.  A mix of int,
> unsigned, u64 in various places, often where one would expect a size_t.

Will take a look.

> > +		memcpy(bc->bio_array[i].sector +
> > +				__bcon_console_ofs(console_bytes), msg, n);
> > +		len -= n;
> > +		msg += n;
> > +		bcon_advance_console_bytes(bc, n);
> > +	}
> > +	wake_up_process(bc->writeback_thread);
> > +	mod_timer(&bc->pad_timer, jiffies + HZ);
> > +}
> > +
> > +static void bcon_init_bios(struct blockconsole *bc)
> 
> This code really needs some comments :(
> 
> Oh I see.  It's BIOs, not BIOS.  Had me fooled there.

But, but, but isn't this obvious to someone who has just written said
function?  It has been a year now, so my own definition of obvious may
have changed as well.

> > +	if (IS_ERR(bc->writeback_thread))
> > +		goto out2;
> 
> Should propagate the error, not assume ENOMEM.  Minor.

Agreed.  The error to propagate is actually ENOMEM - until someone
changes the code in one place and fails to notice the other.

> > +static void bcon_create_fuzzy(const char *name)
> 
> comments, comments, comments.  What's this do and why does it do it and
> why does it make assumptions about userspace namespace configuration.

Ack.

> > +{
> > +	char *longname;
> > +	int err;
> > +
> > +	err = bcon_create(name);
> > +	if (err) {
> > +		longname = kzalloc(strlen(name) + 6, GFP_KERNEL);
> > +		if (!longname)
> > +			return;
> > +		strcpy(longname, "/dev/");
> > +		strcat(longname, name);
> 
> kasprintf()?

Much nicer!  Will do.

> > +void bcon_add(const char *name)
> > +{
> > +	/*
> > +	 * We add each name to a small static buffer and ask for a workqueue
> > +	 * to go pick it up asap.  Once it is picked up, the buffer is empty
> > +	 * again, so hopefully it will suffice for all sane users.
> > +	 */
> > +	spin_lock(&device_lock);
> > +	if (scanned_devices[0])
> > +		strncat(scanned_devices, ",", sizeof(scanned_devices));
> > +	strncat(scanned_devices, name, sizeof(scanned_devices));
> > +	spin_unlock(&device_lock);
> > +	schedule_work(&bcon_add_work);
> > +}
> 
> What's all this do?

Work around init ordering problems.  Quite likely there is a much
nicer way to this that I should know about and don't.

Jörn

--
Optimizations always bust things, because all optimizations are, in
the long haul, a form of cheating, and cheaters eventually get caught.
-- Larry Wall

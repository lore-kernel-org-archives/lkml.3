Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3EVWnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:43:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab3EVWnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:43:23 -0400
Date: Wed, 22 May 2013 15:43:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Steve Hodgson <steve@purestorage.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 02/14] add blockconsole version 1.1
Message-Id: <20130522154322.36d2c230bbdabb7a18979f55@linux-foundation.org>
In-Reply-To: <20130522210416.GF7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-5-git-send-email-joern@logfs.org>
	<20130522134822.f2f5d17beb6196bc4c4deb7e@linux-foundation.org>
	<20130522210416.GF7399@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 17:04:16 -0400 J__rn Engel <joern@logfs.org> wrote:

> > >  Documentation/block/blockconsole.txt            |   94 ++++
> > >  Documentation/block/blockconsole/bcon_tail      |   62 +++
> > >  Documentation/block/blockconsole/mkblockconsole |   29 ++
> > 
> > We really need somewhere better to put userspace tools.
> 
> Agreed.  It started as "use this horrible code as a bad example" and
> turned into a repository for userspace code, which it should have
> been.
> 
> Do you have an opinion on tools/ vs. a standalong git tree for the
> tools?

./tools/blockconsole/ sounds nice.  I like maintaining simple userspace
utils in the main kernel tree - it's very easy and efficient for us.

> > > +#define BCON_MAX_ERRORS	10
> > > +static void bcon_end_io(struct bio *bio, int err)
> > > +{
> > > +	struct bcon_bio *bcon_bio = container_of(bio, struct bcon_bio, bio);
> > > +	struct blockconsole *bc = bio->bi_private;
> > > +	unsigned long flags;
> > > +
> > > +	/*
> > > +	 * We want to assume the device broken and free this console if
> > > +	 * we accumulate too many errors.  But if errors are transient,
> > > +	 * we also want to forget about them once writes succeed again.
> > > +	 * Oh, and we only want to reset the counter if it hasn't reached
> > > +	 * the limit yet, so we don't bcon_put() twice from here.
> > > +	 */
> > > +	spin_lock_irqsave(&bc->end_io_lock, flags);
> > > +	if (err) {
> > > +		if (bc->error_count++ == BCON_MAX_ERRORS) {
> > > +			pr_info("no longer logging to %s\n", bc->devname);
> > 
> > pr_info() may be too low a severity level?
> 
> There is no distinction between "someone pulled the usb device" and
> "broken cable".  Blockconsole will continue writing and retire the
> device if errors accumulate.  The code is deliberately stupid, because
> stupid code tends to be more robust and devoid of strange
> corner-cases.

I meant should we use pr_err() or pr_emerg() rather than pr_info(). 
Chances are that pr_info() is being hidden.

> > How does the code handle the obvious recursion concern here?
> 
> I think your next comment answers that.

hm, that was clever of me.  I meant more generally, if we do a printk()
from within this code how do we prevent arbitrarily deep recursion?

> > > +		memcpy(bc->bio_array[i].sector +
> > > +				__bcon_console_ofs(console_bytes), msg, n);
> > > +		len -= n;
> > > +		msg += n;
> > > +		bcon_advance_console_bytes(bc, n);
> > > +	}
> > > +	wake_up_process(bc->writeback_thread);
> > > +	mod_timer(&bc->pad_timer, jiffies + HZ);
> > > +}
> > > +
> > > +static void bcon_init_bios(struct blockconsole *bc)
> > 
> > This code really needs some comments :(
> > 
> > Oh I see.  It's BIOs, not BIOS.  Had me fooled there.
> 
> But, but, but isn't this obvious to someone who has just written said
> function?  It has been a year now, so my own definition of obvious may
> have changed as well.

heh.  I blame Jens for calling it a "bio".

> > > +void bcon_add(const char *name)
> > > +{
> > > +	/*
> > > +	 * We add each name to a small static buffer and ask for a workqueue
> > > +	 * to go pick it up asap.  Once it is picked up, the buffer is empty
> > > +	 * again, so hopefully it will suffice for all sane users.
> > > +	 */
> > > +	spin_lock(&device_lock);
> > > +	if (scanned_devices[0])
> > > +		strncat(scanned_devices, ",", sizeof(scanned_devices));
> > > +	strncat(scanned_devices, name, sizeof(scanned_devices));
> > > +	spin_unlock(&device_lock);
> > > +	schedule_work(&bcon_add_work);
> > > +}
> > 
> > What's all this do?
> 
> Work around init ordering problems.  Quite likely there is a much
> nicer way to this that I should know about and don't.

Well, without adequate description of the problem, nobody can help
solve it!

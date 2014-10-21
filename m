Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaJUKg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:36:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33866 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaJUKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:36:25 -0400
Date: Tue, 21 Oct 2014 12:36:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141021103622.GB23161@amd>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
 <20141016231221.GA13592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016231221.GA13592@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-17 01:12:21, Greg Kroah-Hartman wrote:
> On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> > On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> > Are the Android guys comfortable with the ABI stability rules they'll
> > now face?
> 
> Just because something is in staging, doesn't mean you don't have to
> follow the same ABI stability rules as the rest of the kernel.  If a
> change had happened to this code that broke userspace in the past, I
> would have reverted it.  So this should not be anything different from
> what has been happening inthe past.

Actually, there's big difference.

If Al Viro changes core filesystem in a way that breaks
staging/binder, binder is broken, and if it can't be fixed... well it
can't be fixed.

If Al Viro changes core filesystem in a way that breaks
drivers/binder, Al's change is going to be reverted.

It is really hard to review without API documentation. Normally, API
documentation is required for stuff like this.

For example: does it add new files in /proc?

Given that it is stable, can we get rid of binder_debug() and
especially BINDER_DEBUG_ENTRY stuff?

Checkpatch warns about 98 too long lines. Some of them could be fixed
easily.

This looks scary:

                        trace_binder_transaction_fd(t, fp->handle,
                        target_fd);
			                binder_debug(BINDER_DEBUG_TRANSACTION,
                                     "        fd %d -> %d\n",
                        fp->handle, target_fd);
                        /* TODO: fput? */
                        fp->handle = target_fd;
			        } break;

Could binder_transcation() be split to smaller functions according to
CodingStyle? 17 goto targets at the end of function are not exactly
easy to read.

ginder_thread_read/write also needs splitting.

binder_ioctl_write_read: just use direct return, no need to goto out
if it just returns.

   proc->user_buffer_offset = vma->vm_start - (uintptr_t)proc->buffer;
        mutex_unlock(&binder_mmap_lock);

#ifdef CONFIG_CPU_CACHE_VIPT
        if (cache_is_vipt_aliasing()) {
                while (CACHE_COLOUR((vma->vm_start ^
        (uint32_t)proc->buffer))) {

Should this be (uintptr_t)?

        /*pr_info("binder_mmap: %d %lx-%lx maps %p\n",                                   

Delete the code, don't comment it out. It is on more than one place.

static void print_binder_thread(struct seq_file *m,
                                struct binder_thread *thread,
                                int print_always)
{
        struct binder_transaction *t;
	struct binder_work *w;
        size_t start_pos = m->count;
	size_t header_pos;

        seq_printf(m, "  thread %d: l %02x\n", thread->pid,
        thread->looper);
        header_pos = m->count;
        t = thread->transaction_stack;
	while (t) {
 	        if (t->from == thread) {
                        print_binder_transaction(m,
				                                 "
        outgoing transaction", t);
                        t = t->from_parent;

Is anyone depending on the debugfs files? Can it be deleted?

Code indentation is "interesting" in binder_thread_read(). See the "}
break;" lines. {}s should not be needed...?

I don't think this code would get merged if it was submitted for
normal inclusion in kernel. I don't think it is good idea to push it
through the back door, without documenting what it does and without
patches even going to the lists.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

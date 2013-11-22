Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3KVX1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:27:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3KVX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:27:12 -0500
Date: Fri, 22 Nov 2013 15:27:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-Id: <20131122152711.c644e5acf02b61668c63b59c@linux-foundation.org>
In-Reply-To: <20131108102113.GB6343@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-4-git-send-email-jack@suse.cz>
	<CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
	<20131107225733.GE2054@quack.suse.cz>
	<20131107232148.GE28130@localhost.localdomain>
	<20131107183717.0fc9eb6e@gandalf.local.home>
	<20131107234647.GG28130@localhost.localdomain>
	<20131108102113.GB6343@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013 11:21:13 +0100 Jan Kara <jack@suse.cz> wrote:

> On Fri 08-11-13 00:46:49, Frederic Weisbecker wrote:
> > On Thu, Nov 07, 2013 at 06:37:17PM -0500, Steven Rostedt wrote:
> > > On Fri, 8 Nov 2013 00:21:51 +0100
> > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > 
> > > > Offloading to a workqueue would be perhaps better, and writing to the serial
> > > > console could then be done with interrupts enabled, preemptible context, etc...
> > > 
> > > Oh God no ;-)  Adding workqueue logic into printk just spells a
> > > nightmare of much more complexity for a critical kernel infrastructure.
> > 
> > But yeah that's scary, that means workqueues itself can't printk that safely.
> > So, you're right after all.
>   Yeah, we've been there (that was actually my initial proposal). But
> Andrew and Steven (rightfully) objected and suggested irq_work should be
> used instead.

I still hate the patchset and so does everyone else, including you ;)
There must be something smarter we can do.  Let's start by restating
the problem:

CPU A is in printk, emitting log_buf characters to a slow device. 
Meanwhile other CPUs come into printk(), see that the system is busy,
dump their load into log_buf then scram, leaving CPU A to do even more
work.

Correct so far?

If so, what is the role of local_irq_disabled() in this?  Did CPU A
call printk() with local interrupts disabled, or is printk (or the
console driver) causing the irqs-off condition?  Where and why is this
IRQ disablement happening?


Could we fix this problem by not permitting CPUs B, C and D to DoS CPU
A?  When CPU B comes into printk() and sees that printk is busy, make
CPU A hand over to CPU B and let CPU A get out of there?



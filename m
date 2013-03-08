Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3CHVUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:20:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3CHVUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:20:47 -0500
Date: Fri, 8 Mar 2013 13:20:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] coredump: introduce dump_interrupted()
Message-Id: <20130308132046.02e2e6ac44a9fc4e63ed6604@linux-foundation.org>
In-Reply-To: <20130308175915.GA26322@redhat.com>
References: <20130308175852.GA26300@redhat.com>
	<20130308175915.GA26322@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013 18:59:15 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> Change dump_write(), dump_seek() and do_coredump() to check
> signal_pending() and abort if it is true.

hm, why.

I think we're missing some context here - this is to support freezing,
yes?  There's some undescribed interaction between the freezer and the
core-dumper which is being fixed?

IOW, can we please have the high-level overview of what this patchset
is trying to achieve?



An example of why this is needed: the dump_interrupted() check which
was added to dump_seek() is just weird.  An lseek is instantaneous, so
why do we need to bother checking for signals there if the caller will
be checking one microsecond later anyway??

And if the file doesn't support lseek (do such files exist?  should we
be returning 0 instead of -ENOMEM?), we just sit there in a loop
extending the file with write().  This can take *ages*, but this part
of dump_seek() *didn't* get the signal check!

So it makes no sense at all.  If we had that what-Oleg-is-trying-to-do
text then perhaps others could understand all of this?

> We add the new trivial helper, dump_interrupted(), to document that
> this probably needs more work and to simplify the potential freezer
> changes. Perhaps it will have more callers.
> 
> Ideally it should do try_to_freeze() but then we need the unpleasant
> changes in dump_write() and wait_for_dump_helpers(). So far we simply
> accept the fact that the freezer can truncate a core-dump but at least
> you can reliably suspend.

OK, so there is some connection between this and suspending.  Details,
please...


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaAUWHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:07:39 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:44830 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaAUWHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:07:32 -0500
Message-ID: <1390342178.5567.770.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>
Date: Tue, 21 Jan 2014 14:09:38 -0800
In-Reply-To: <20140120113415.GE30183@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
	 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
	 <20140120113415.GE30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 12:34 +0100, Peter Zijlstra wrote:
> On Mon, Jan 20, 2014 at 03:44:44AM +0000, Nicholas A. Bellinger wrote:
> > From: Kent Overstreet <kmo@daterainc.com>
> > 
> > This patch changes percpu_ida_alloc() + callers to accept task state
> > bitmask for prepare_to_wait() for code like target/iscsi that needs
> > it for interruptible sleep, that is provided in a subsequent patch.
> > 
> > It now expects TASK_UNINTERRUPTIBLE when the caller is able to sleep
> > waiting for a new tag, or TASK_RUNNING when the caller cannot sleep,
> > and is forced to return a negative value when no tags are available.
> > 
> > v2 changes:
> >   - Include blk-mq + tcm_fc + vhost/scsi + target/iscsi changes
> >   - Drop signal_pending_state() call
> 
> Urgh, you made me look at percpu_ida... steal_tags() does a
> for_each_cpus() with IRQs disabled. This mean you'll disable IRQs for
> multiple ticks on SGI class hardware. That is a _very_ long time indeed.
> 

So given the performance penalties involved in the steal tag slow path,
consumers should typically be pre-allocating a larger number of
percpu_ida tags than necessary to (ideally) avoid this logic completely.

> Then there's alloc_global_tags() vs alloc_local_tags(), one gets an
> actual tag, while the other only moves tags about -- semantic mismatch.
> 

How about just in-lining alloc_global_tags() into percpu_ida_alloc()..?

> I do not get the comment near prepare to wait -- why does it matter if
> percpu_ida_free() flips a cpus_have_tags bit?
> 

Mmm, not sure on that one.

> Given I don't understand this comment, its hard for me to properly
> review the proposed patch series.
> 

Kent..?

--nab


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaATLel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:34:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54177 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaATLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:34:39 -0500
Date: Mon, 20 Jan 2014 12:34:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140120113415.GE30183@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:44:44AM +0000, Nicholas A. Bellinger wrote:
> From: Kent Overstreet <kmo@daterainc.com>
> 
> This patch changes percpu_ida_alloc() + callers to accept task state
> bitmask for prepare_to_wait() for code like target/iscsi that needs
> it for interruptible sleep, that is provided in a subsequent patch.
> 
> It now expects TASK_UNINTERRUPTIBLE when the caller is able to sleep
> waiting for a new tag, or TASK_RUNNING when the caller cannot sleep,
> and is forced to return a negative value when no tags are available.
> 
> v2 changes:
>   - Include blk-mq + tcm_fc + vhost/scsi + target/iscsi changes
>   - Drop signal_pending_state() call

Urgh, you made me look at percpu_ida... steal_tags() does a
for_each_cpus() with IRQs disabled. This mean you'll disable IRQs for
multiple ticks on SGI class hardware. That is a _very_ long time indeed.

Then there's alloc_global_tags() vs alloc_local_tags(), one gets an
actual tag, while the other only moves tags about -- semantic mismatch.

I do not get the comment near prepare to wait -- why does it matter if
percpu_ida_free() flips a cpus_have_tags bit?

Given I don't understand this comment, its hard for me to properly
review the proposed patch series.

Help?

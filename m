Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3JKL5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:57:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49918 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206Ab3JKL5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:57:42 -0400
Date: Fri, 11 Oct 2013 12:57:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: Kernel warning triggered with trinity on 3.12-rc4
Message-ID: <20131011115732.GJ14732@mudshark.cambridge.arm.com>
References: <20131008145217.GB21189@mudshark.cambridge.arm.com>
 <20131009133741.GA16003@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009133741.GA16003@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:37:41PM +0100, Benjamin LaHaise wrote:
> On Tue, Oct 08, 2013 at 03:52:17PM +0100, Will Deacon wrote:
> > Hi guys,
> > 
> > I've been running trinity on my ARMv7 Cortex-A15 system and managed to
> > trigger the following kernel warning:
> 
> Adding Kent to the list of recipients since this is in code he wrote.  I'd 
> like to try to track down a test case to add to the libaio tests if we can 
> figure it out.


FWIW, I just saw this issue again on a different board running a separate
instance of trinity:

[183036.699436] WARNING: CPU: 1 PID: 7279 at fs/aio.c:474 free_ioctx+0x13b/0x154()
[183036.700450] Modules linked in:
[183036.701028] CPU: 1 PID: 7279 Comm: kworker/1:1 Not tainted 3.12.0-rc4+ #1844
[183036.703447] Workqueue: events free_ioctx
[183036.704863] [<c001ca11>] (unwind_backtrace+0x1/0x9c) from [<c001a575>] (show_stack+0x11/0x14)
[183036.710360] [<c001a575>] (show_stack+0x11/0x14) from [<c02dbe8d>] (dump_stack+0x55/0x88)
[183036.713109] [<c02dbe8d>] (dump_stack+0x55/0x88) from [<c0025275>] (warn_slowpath_common+0x51/0x70)
[183036.714885] [<c0025275>] (warn_slowpath_common+0x51/0x70) from [<c00252ab>] (warn_slowpath_null+0x17/0x1c)
[183036.715896] [<c00252ab>] (warn_slowpath_null+0x17/0x1c) from [<c00de2f7>] (free_ioctx+0x13b/0x154)
[183036.716816] [<c00de2f7>] (free_ioctx+0x13b/0x154) from [<c0035b8f>] (process_one_work+0xd3/0x2dc)
[183036.717752] [<c0035b8f>] (process_one_work+0xd3/0x2dc) from [<c003606f>] (worker_thread+0xe7/0x270)
[183036.718662] [<c003606f>] (worker_thread+0xe7/0x270) from [<c0039d5d>] (kthread+0x71/0x7c)
[183036.719446] [<c0039d5d>] (kthread+0x71/0x7c) from [<c0017c3d>] (ret_from_fork+0x11/0x20)
[183036.724930] ---[ end trace 7524c2e7acad0b28 ]---

Will

> > [15333.257972] ------------[ cut here ]------------
> > [15333.259328] WARNING: CPU: 1 PID: 18717 at fs/aio.c:474 free_ioctx+0x1d0/0x1d4()
> > [15333.259894] Modules linked in:
> > [15333.260643] CPU: 1 PID: 18717 Comm: kworker/1:0 Not tainted 3.12.0-rc4 #3
> > [15333.261580] Workqueue: events free_ioctx
> > [15333.261978] [<c00213f8>] (unwind_backtrace+0x0/0xf4) from [<c001e034>] (show_stack+0x10/0x14)
> > [15333.263231] [<c001e034>] (show_stack+0x10/0x14) from [<c03c350c>] (dump_stack+0x98/0xd4)
> > [15333.264106] [<c03c350c>] (dump_stack+0x98/0xd4) from [<c002c5ac>] (warn_slowpath_common+0x6c/0x88)
> > [15333.265132] [<c002c5ac>] (warn_slowpath_common+0x6c/0x88) from [<c002c664>] (warn_slowpath_null+0x1c/0x24)
> > [15333.266053] [<c002c664>] (warn_slowpath_null+0x1c/0x24) from [<c01269a0>] (free_ioctx+0x1d0/0x1d4)
> > [15333.267097] [<c01269a0>] (free_ioctx+0x1d0/0x1d4) from [<c0041c30>] (process_one_work+0xf4/0x35c)
> > [15333.267822] [<c0041c30>] (process_one_work+0xf4/0x35c) from [<c004288c>] (worker_thread+0x138/0x3d4)
> > [15333.268766] [<c004288c>] (worker_thread+0x138/0x3d4) from [<c0048058>] (kthread+0xb4/0xb8)
> > [15333.269746] [<c0048058>] (kthread+0xb4/0xb8) from [<c001ae78>] (ret_from_fork+0x14/0x3c)
> > [15333.270455] ---[ end trace d2466d8d496fd5c9 ]---
> > 
> > --->8
> > 
> > So this looks like either somebody else is messing with ctx->reqs_available
> > on the ctx freeing path, or we're inadvertently incrementing the
> > reqs_available count beyond the queue size. I'm really not familiar with
> > this code, but the conditional assignment to avail looks pretty scary given
> > that I don't think we hold the ctx->completion_lock and potentially read the
> > tail pointer more than once.
> > 
> > Any ideas? I've not been able to reproduce the problem again with further
> > fuzzing (yet).

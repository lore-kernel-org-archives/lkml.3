Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3JHOwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:52:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39908 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343Ab3JHOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:52:27 -0400
Date: Tue, 8 Oct 2013 15:52:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: linux-aio@kvack.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, bcrl@kvack.org
Subject: Kernel warning triggered with trinity on 3.12-rc4
Message-ID: <20131008145217.GB21189@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've been running trinity on my ARMv7 Cortex-A15 system and managed to
trigger the following kernel warning:

8<---

[15333.257972] ------------[ cut here ]------------
[15333.259328] WARNING: CPU: 1 PID: 18717 at fs/aio.c:474 free_ioctx+0x1d0/0x1d4()
[15333.259894] Modules linked in:
[15333.260643] CPU: 1 PID: 18717 Comm: kworker/1:0 Not tainted 3.12.0-rc4 #3
[15333.261580] Workqueue: events free_ioctx
[15333.261978] [<c00213f8>] (unwind_backtrace+0x0/0xf4) from [<c001e034>] (show_stack+0x10/0x14)
[15333.263231] [<c001e034>] (show_stack+0x10/0x14) from [<c03c350c>] (dump_stack+0x98/0xd4)
[15333.264106] [<c03c350c>] (dump_stack+0x98/0xd4) from [<c002c5ac>] (warn_slowpath_common+0x6c/0x88)
[15333.265132] [<c002c5ac>] (warn_slowpath_common+0x6c/0x88) from [<c002c664>] (warn_slowpath_null+0x1c/0x24)
[15333.266053] [<c002c664>] (warn_slowpath_null+0x1c/0x24) from [<c01269a0>] (free_ioctx+0x1d0/0x1d4)
[15333.267097] [<c01269a0>] (free_ioctx+0x1d0/0x1d4) from [<c0041c30>] (process_one_work+0xf4/0x35c)
[15333.267822] [<c0041c30>] (process_one_work+0xf4/0x35c) from [<c004288c>] (worker_thread+0x138/0x3d4)
[15333.268766] [<c004288c>] (worker_thread+0x138/0x3d4) from [<c0048058>] (kthread+0xb4/0xb8)
[15333.269746] [<c0048058>] (kthread+0xb4/0xb8) from [<c001ae78>] (ret_from_fork+0x14/0x3c)
[15333.270455] ---[ end trace d2466d8d496fd5c9 ]---

--->8

So this looks like either somebody else is messing with ctx->reqs_available
on the ctx freeing path, or we're inadvertently incrementing the
reqs_available count beyond the queue size. I'm really not familiar with
this code, but the conditional assignment to avail looks pretty scary given
that I don't think we hold the ctx->completion_lock and potentially read the
tail pointer more than once.

Any ideas? I've not been able to reproduce the problem again with further
fuzzing (yet).

Cheers,

Will

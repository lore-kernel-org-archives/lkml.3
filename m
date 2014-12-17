Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaLQRR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:17:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaLQRRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:17:54 -0500
Date: Wed, 17 Dec 2014 12:17:49 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Marc Dionne <marc.dionne@your-file-system.com>, agk@redhat.com
Subject: Re: dm thin: Initialize refcount and completion earlier
Message-ID: <20141217171749.GB27737@redhat.com>
References: <1418821199-6890-1-git-send-email-marc.dionne@your-file-system.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418821199-6890-1-git-send-email-marc.dionne@your-file-system.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17 2014 at  7:59am -0500,
Marc Dionne <marc.c.dionne@gmail.com> wrote:

> The commit 80e96c5484be (dm thin: do not allow thin device activation
> while pool is suspended) delayed the initialization of the completion
> and setting the initial refcount to 1 until after the new thin is
> added to the pool's active thins list and the pool lock is released.
> This opens a race with a worker thread that walks the list and calls
> thin_get/put, noticing that the refcount goes to 0 and calling
> complete, freezing up the system and giving the oops below:
> 
>  kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
>  kernel: IP: [<ffffffff810d360b>] __wake_up_common+0x2b/0x90
> 
>  kernel: Call Trace:
>  kernel: [<ffffffff810d3683>] __wake_up_locked+0x13/0x20
>  kernel: [<ffffffff810d3dc7>] complete+0x37/0x50
>  kernel: [<ffffffffa0595c50>] thin_put+0x20/0x30 [dm_thin_pool]
>  kernel: [<ffffffffa059aab7>] do_worker+0x667/0x870 [dm_thin_pool]
>  kernel: [<ffffffff816a8a4c>] ? __schedule+0x3ac/0x9a0
>  kernel: [<ffffffff810b1aef>] process_one_work+0x14f/0x400
>  kernel: [<ffffffff810b206b>] worker_thread+0x6b/0x490
>  kernel: [<ffffffff810b2000>] ? rescuer_thread+0x260/0x260
>  kernel: [<ffffffff810b6a7b>] kthread+0xdb/0x100
>  kernel: [<ffffffff810b69a0>] ? kthread_create_on_node+0x170/0x170
>  kernel: [<ffffffff816ad7ec>] ret_from_fork+0x7c/0xb0
>  kernel: [<ffffffff810b69a0>] ? kthread_create_on_node+0x170/0x170
> 
> Set the initial refcount and initialize the completion
> before dropping the pool lock.
> 
> Signed-off-by: Marc Dionne <marc.dionne@your-file-system.com>

Thanks, applied for 3.19, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=2b94e8960cc3f225dec058f27570505351f4bc13

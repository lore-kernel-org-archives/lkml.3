Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3APDav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:30:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab3APDat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130116025251.GM2668@htj.dyndns.org>
References: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
	<CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
	<CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
	<CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
	<CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
	<20130115183204.GE2668@htj.dyndns.org>
	<CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
	<20130115235043.GJ2668@htj.dyndns.org>
	<CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
	<CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
	<20130116025251.GM2668@htj.dyndns.org>
Date: Wed, 16 Jan 2013 11:30:46 +0800
Message-ID: <CACVXFVM5Nr9YdN80TkotAcKff3=cZVG-R2sCiwXMJPv1gx38dg@mail.gmail.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
From: Ming Lei <ming.lei@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:52 AM, Tejun Heo <tj@kernel.org> wrote:
> If the default iosched is built as module, the kernel may deadlock
> while trying to load the iosched module on device probe if the probing
> was running off async.  This is because async_synchronize_full() at
> the end of module init ends up waiting for the async job which
> initiated the module loading.
>
>  async A                                modprobe
>
>  1. finds a device
>  2. registers the block device
>  3. request_module(default iosched)
>                                         4. modprobe in userland
>                                         5. load and init module
>                                         6. async_synchronize_full()
>
> Async A waits for modprobe to finish in request_module() and modprobe
> waits for async A to finish in async_synchronize_full().
>
> Because there's no easy to track dependency once control goes out to
> userland, implementing properly nested flushing is difficult.  For
> now, make module init perform async_synchronize_full() iff module init
> has queued async jobs as suggested by Linus.
>
> This avoids the described deadlock because iosched module doesn't use
> async and thus wouldn't invoke async_synchronize_full().  This is
> hacky and incomplete.  It will deadlock if async module loading nests;
> however, this works around the known problem case and seems to be the
> best of bad options.
>
> For more details, please refer to the following thread.
>
>   http://thread.gmane.org/gmane.linux.kernel/1420814
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Alex Riesen <raa.lkml@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---

Looks it does fix the deadlock problem on my Pandaboard,
also the scsi disk device node(/dev/sdX) comes just
after loading module of 'sd_mod'.

Tested-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei

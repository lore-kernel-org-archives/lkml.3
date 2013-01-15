Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3AOScM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:32:12 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41301 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab3AOScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:32:09 -0500
Date: Tue, 15 Jan 2013 10:32:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
Message-ID: <20130115183204.GE2668@htj.dyndns.org>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, Jan 15, 2013 at 09:36:57AM -0800, Linus Torvalds wrote:
> Tejun, comments? You can see the whole thread on lkml, but the basic
> problem is that the module loading doing the unconditional
> async_synchronize_full() has caused problems, because we have
> 
>  - load module A
>    - module A does per-controller async discovery of its devices (eg
> scsi or ata probing)
>    - in the async thread, it initializes somethign that needs another
> module B (in this case the default IO scheduler module)
>       - modprobe for B loads the IO scheduler module successfully
>           at the end of the module load, it does
> async_synchronize_full() to make sure load_module won't return before
> the module is ready
>           *DEADLOCK*, because the async_synchronize_full() thing
> actually waits for not the module B async code (it didn't have any),
> but for the module *A* async code, which is waiting for module B to
> finish.

I think the root problem here, apart from request_module() from block
- which is a bit nasty but making that part completely async would too
be quite nasty albeit in a different way - is that
async_synchronize_full() is way too indescriminate.  It's something
only suitable for things like the end of system init.

I'm wondering whether what we need is a rudimentray nesting like the
following.

finished_loading()
{
	blah blah;

	cookie = async_current_cookie();

	do init calls;

	async_synchronize_upto(cookie);

	blah blah;
}

The nesting here would be an approximation as the dependency recorded
here is chronological.  I *suspect* this should be safe unless the
module is doing something weird.  Need to think more about it.  One
way or the other, I think what we need is some form of scoping for
flushing async ops.

BTW, the current synchronization is broken - cookie isn't transferred
to running->domain in queueing order but __lowest_in_progress()
assumes that.  I think I broke that while converting it to workqueue.

Anyways, working on it.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3AOSVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:21:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45410 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756861Ab3AOSU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:20:59 -0500
Date: Tue, 15 Jan 2013 13:20:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ming Lei <ming.lei@canonical.com>, Tejun Heo <tj@kernel.org>,
        Alex Riesen <raa.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301151300200.11786-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Linus Torvalds wrote:

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
> 
> Now, I'll happily argue that we shouldn't have this kind of "load
> modules from random context" behavior in the kernel, and I think the
> block layer is to blame for doing the IO scheduler load at an insane
> time. So "don't do that then" would be the best solution.

It may not be so easy.  When the SCSI async thread probes the new disk, 
it has to do I/O.  So it needs to use a scheduler.

But maybe it could use a built-in trivial scheduler until the proper 
one is loaded.  Then the loading could be asynchronous.

Alan Stern


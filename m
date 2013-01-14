Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab3ANSfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:35:20 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:58148 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3ANSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301141302380.1782-100000@iolanthe.rowland.org>
References: <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301141302380.1782-100000@iolanthe.rowland.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Jan 2013 10:34:57 -0800
X-Google-Sender-Auth: 55RrdvTGcVPgTqM8m7bkLbwuOqY
Message-ID: <CA+55aFz1T8t57zTiEKYJKS9crNS99gpp+SxQ41A9TKj2hoq72w@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:04 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> How about skipping that call if the current thread is one of the async
> helpers?  Is it possible to detect when that happens?
>
> Or maybe such a check should go inside async_synchronize_full() itself.

Do we have some idea of exactly what is waiting for what? Which async
context is causing the module load to happen in the first place?

I think *that* is what we should avoid - it sounds like the block
layer is loading the IO scheduler at the wrong point. I realize that
people like (for testing purposes) to change the IO scheduler at
random, but if that means that any IO can basically result in a
request_module(), then that sounds like a problem.

It seems to be "elevator_get()", and I presume the chain is something
like "load block driver async, the block driver does
blk_init_allocated_queue, that does request_module() to find the
elevator, the request_module() succeeds, but ends up waiting for async
work, which is the block driver load, which is waiting for the
request_module to finish".

And my gut feel is that blk_init_allocated_queue() probably shouldn't
do that request_module() at all. We migth want to do it when we *open*
the device, but not while loading the module for the device.

So my _feeling_ is that this is just a bug in the block layer, and
that it shouldn't set up block device drivers for this kind of crazy
"need to load the elevator module while in the middle of scanning
devices". I think *that* is what we should aim to change.

Hmm?

That said, I think it might indeed be a good idea to make this problem
much easier to see, and that "detect when it happens" would be a good
thing (and then we should WARN_ON_ONCE() on people trying to do
request_module() calls from async context).

               Linus

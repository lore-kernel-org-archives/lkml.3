Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3APAfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:35:39 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:46064 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3APAfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:35:36 -0500
Date: Tue, 15 Jan 2013 16:35:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
Message-ID: <20130116003530.GK2668@htj.dyndns.org>
References: <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <50F5F392.7010709@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5F392.7010709@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On Tue, Jan 15, 2013 at 04:25:54PM -0800, Arjan van de Ven wrote:
> async fundamentally had the concept of a monotonic increasing number,
> and that you could always wait for "everyone before me".
> then people (like me) wanted exceptions to what "everyone" means ;-(
> I'm ok with going back to a single space and simplify the world.

If we want (or need) finer grained operation, we'll probably have to
head the other direction, so that we can definitively tell that an
async operation belongs to domains system, module load A and B, so
that each waiter knows what to wait for.

The current domain implementation is somewhere inbetween.  It's not
completely simplistic system and at the same time not developed enough
to do properly stacked flushing.

> the module wait case is tricky, and I wonder if there's deadlocks
> lurking even without async.

I don't think so.  It's really an async job waiting for itself.
Working around just this case is mostly trivial (working on patches
now) but it really is putting kludges on top of shaky foundation.
Maybe this is the extent of complexity that we need to go given the
rather limited use cases of async.  Let's hope so.  I think we'll have
to reimplement synchronization scheme if we have to go further.

> at some point in the past we had the concept of "request a module
> but don't wait for it", and I wonder if that is what should have
> been used here.

We actually want to wait for it as it creates a userland visible
behavior difference otherwise.  It's just that async's way of waiting
is too ham-fisted to be used properly in more complex scenarios.

Thanks.

-- 
tejun

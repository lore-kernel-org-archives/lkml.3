Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3AOXuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:50:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65390 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab3AOXus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:50:48 -0500
Date: Tue, 15 Jan 2013 15:50:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
Message-ID: <20130115235043.GJ2668@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Arjan.  Arjan, the original thread can be read from

  http://thread.gmane.org/gmane.linux.kernel/1420814

Hello, again.

On Tue, Jan 15, 2013 at 12:18:01PM -0800, Linus Torvalds wrote:
> I think that is a good solution if it works, but look out: we need to
> synchronize across *all* domains, not just the default one.  The sd.c
> code, for example, uses its own "scsi_sd_probe_domain" for example,
> and we *do* want to synchronize with it.
> 
> Can you do that with your suggested interface (ie it would have to be
> a *global* sequence number).

So, I've been thinking about it for a while now and it looks like
async is cutting too many corners to implement any sane stackable
flushing scheme on top.  There simply isn't much information to
determine who should wait for what.

I've thought of two workarounds.  Both suck.

A. Try to detect deadlock conditions from synchronize().  If deadlock
   condition involving other async jobs are detected, whine about it
   and then skip.  Ignore deadlock condition on self (should solve
   this particular case).

   Detecting deadlock condition isn't difficult if there are only
   global synchronizations; unfortunately, fragmented dependencies via
   domain-local synchronization makes this non-trivial.

   We can still do ignore-self thing mostly trivially tho.  This will
   at least work around the problem at hand.

B. The ranged synchronization I first suggested.  The problem with
   this is that it's a common practice for a given async job to try to
   flush anything which comes before it.  This can introduce spurious
   synchronization dependencies which can then lead to deadlocks.

   These conditions can be detected and ignored, at least only
   considering global synchronizations.  The problem here is that
   those deadlock conditions will occur under normal usage and thus
   should be ignored silently, which basically makes synchronization
   silently ignore and finish successfully even if there are
   legitimate deadlocks which should be investigated.

For now, I'm gonna implement simple "I'm not gonna wait for myself"
self-deadlock avoidance.  If this needs any more sophistication, I
think we better reimplement it so that we can explicitly match up and
track who's gonna wait for what instead of throwing everything into a
single cookie space and then try to work back from there.

Thanks.

-- 
tejun

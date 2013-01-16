Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3APA1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:27:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:20732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181Ab3APAZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,475,1355126400"; 
   d="scan'208";a="244371278"
Message-ID: <50F5F392.7010709@linux.intel.com>
Date: Tue, 15 Jan 2013 16:25:54 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
References: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org> <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com> <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com> <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com> <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com> <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com> <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com> <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com> <20130115235043.GJ2668@htj.dyndns.org>
In-Reply-To: <20130115235043.GJ2668@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For now, I'm gonna implement simple "I'm not gonna wait for myself"
> self-deadlock avoidance.  If this needs any more sophistication, I
> think we better reimplement it so that we can explicitly match up and
> track who's gonna wait for what instead of throwing everything into a
> single cookie space and then try to work back from there.

async fundamentally had the concept of a monotonic increasing number,
and that you could always wait for "everyone before me".
then people (like me) wanted exceptions to what "everyone" means ;-(
I'm ok with going back to a single space and simplify the world.

the case with (usb) module loading is "fun"...
people expect the device to be there (since frankly, it's hard to do otherwise)..
... but it's also really hard due to the nature of USB.. USB is async in nature,
even independent of the kernel async stuff.
Example: Load ehci.ko ... the actual use devices don't show up for some time.


the module wait case is tricky, and I wonder if there's deadlocks lurking even without async.
(btw there is a similar situation at the end of the normal kernel boot versus things like asynchronous
driver initializing... but we "skip" that in the case of an initrd is used to bypass a very similar deadlock.
this is even without "async" in use.. typical hard case is the PS/2 mouse probing)

at some point in the past we had the concept of "request a module but don't wait for it",
and I wonder if that is what should have been used here.

Doing a "range wait", with the start of the range being taken at the start of module loading
is a bit of a hack, but it'll work for the userspace expected semantics of all async stuff of
the *loaded module* be done, independent of all other modules/async stuff.
It's not as deadlocky as one might think, but it's not going to be efficient to implement.

not self-deadlocking likely solves most practical cases though





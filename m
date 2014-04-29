Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbaD2S0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:26:14 -0400
Received: from imap.thunk.org ([74.207.234.97]:40139 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaD2S0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:26:13 -0400
Date: Tue, 29 Apr 2014 14:26:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: Add "initialized" variable to proc
Message-ID: <20140429182610.GA19325@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
 <20140428214112.GC7857@thunk.org>
 <535FE68C.8060002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FE68C.8060002@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:51:08PM +0200, Florian Weimer wrote:
> 
> I've got a (physical) machine where it happens after ten seconds, or much
> longer if there is no activity.
> 
> I've seen cases where on the first boot of virtual machines, the SSH key was
> generated before the printk with the initialization message.  It's not a
> problem if you install the OS first and then generate the keys, but for
> booting from pre-provisioned images, it could be.  (I have no evidence that
> this hurts the quality of the generated key material, this is just based on
> what's reported by the kernel.)

Yes, fair enough, just because it works for me for my laptops doesn't
mean that there aren't systems for which it was a problem.  :-)

I will say that for virtual machines, we *really* need virtio-rng.
And I wonder if the right answer is that initially we have some other
process listening on the ssh port, which can generate the ssh host
keys when someone actually first connects to the ssh port (since at
that point, networking will have come up and we'll get some entropy
just from the networking interupts if nothing else), and then exec the
real ssh daemon to handle the incoming connection, as well as execing
a the real ssh daemon to take over listening on the ssh port.

> I'm not sure if I want to bet an increasingly crucial part of the boot
> design on the continuing availability of the current entropy levels (which
> could go down as the result of environmental changes or a reassessment of
> the entropy that actually comes into the system).

It doesn't matter of entropy levels go down; what's important is that
at least at one point, the entropy estimate goes above the threshold
level.  Once that happens, someone can only break the RNG if (a) we
were wrong about the entropy estimate --- and we've made the entropy
estimator extremely conservative for that reason; the academic papers
which have studied /dev/random have not found fault with the
estimator, or (b) someone has broken the underlying crypto algorithm.

> Or a new /dev/?random device that blocks until initialized, but behaves just
> like /dev/urandom after that.   The question is how useful it would be
> because of the deadlock scenario.

It's like any other technology; it depends on how you use it.  If you
don't block the whole boot, but just those services which depend on
the entropy generation (for example, ssh), and there's enough services
up so that the machine has activity so that eventually the initialized
flag is set, it won't be a deadlock.  Maybe it will take five minutes
before the machine is answering ssh queries, and that could be a
support nightmare, sure.  At some level, it's up to use to generate a
system that can generate enough entropy in a reasonable time, which is
why I added the printk in the first place -- to assist in that effort.

So if you're not going to block on the urandom generator being
"initialized" (where the definition, like the entropy estimator, is
somewhat arbitrary), how were you thinking the information from
/proc/sys/kernel/random/intialized would be used?

							- Ted

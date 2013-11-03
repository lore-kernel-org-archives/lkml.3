Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3KCXKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 18:10:10 -0500
Received: from imap.thunk.org ([74.207.234.97]:53860 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3KCXKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 18:10:07 -0500
Date: Sun, 3 Nov 2013 18:10:04 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] random: use device attach events for entropy
Message-ID: <20131103231004.GD7376@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
 <1383485595-2020-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383485595-2020-2-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 08:33:12AM -0500, Theodore Ts'o wrote:
> Some investigation from FreeBSD shows that there is entropy available
> from measuring the device attach times:
> 
> http://lists.randombit.net/pipermail/cryptography/2013-October/005689.html
> 
> This will hopefully help us more quickly initialize the entropy pools
> while the system is booting (which is one of the times when we really
> badly need more entropy, especially in the case of the first boot
> after an consumer electronics device is taken out of the box).
> 
> Measurements indicate this makes a huge improvement in the security of
> /dev/urandom during the boot sequence, so I'm cc'ing this to the
> stable kernel series.  Especially for embedded systems, which use
> flash and which don't necessarily have the network enabled when they
> first generate ssh or x.509 keys (sigh), this can be a big deal.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Self-NAK.  After doing some more measurements, I'm not convinced the
entropy estimator is working well given how we are collecting the
device attach times.  Instead, we need to measure the delta between
the start and the end of the device probe, which in turn will only
work if we have a valid cycle counter.  (random_get_entropy() is not
going to cut it.)

So with some changes, this approach will improve things on x86, but on
architectures like ARM, which generally don't have a cycle counter,
the jiffies counter is not going to have enough resolution to do
something useful --- and it was on platforms such as ARM and MIPS
where I was hoping this would be most useful.   Grumble.

Why can't ARM and MIPS have decent cycle counters?   <Shakes fist>

						- Ted

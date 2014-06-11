Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaFKCIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:08:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:60846 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaFKCIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:08:40 -0400
Date: Tue, 10 Jun 2014 22:08:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140611020835.GA23110@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140610212032.GG12104@thunk.org>
 <20140611001003.12979.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611001003.12979.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:10:03PM -0400, George Spelvin wrote:
> What I wanted to do was eliminate that huge tmp buffer from
> _xfer_secondary_pool.  There's no good reason why it needs to be there.
> and several reasons for getting rid of it.

So have you actually instrumented the kernel to demonstrate that in
fact we have super deep stack call paths where the 128 bytes worth of
stack actually matters?

Premature optimization being the root of all evil (not to mention
wasting a lot of time of kernel developers) and all that....

> I hadn't tested the patch when I mailed it to you (I prepared it in
> order to reply to your e-mail, and it's annoying to reboot the machine
> I'm composing an e-mail on), but I have since.  It works.

As an aside, I'd strongly suggest that you use kvm to do your kernel
testing.  It means you can do a lot more testing which is always a
good thing....

> The *fundamental* race, as I see it, is the one between modifying pools
> and crediting entropy.
> 
> As I noted, you can't safely do the credit either before *or* after modifying
> the pool; you will always end up with the wrong answer in some situation.

Actually, it's **fine**.  That's because RNDADDENTROPY adds the
entropy to the input pool, which is has the limit flag set.  So we
will never pull more entropy than the pool is credited as having.
This means that race can't happen.  It ***is*** safe.

1)  Assume the entropy count starts at 10 bytes.

2)  Random writer mixes in 20 bytes of entropy into the entropy pool.

3)  Random extractor tries to extract 32 bytes of entropy.  Since the
entropy count is still is 10, it will only get 10 bytes.  (And if we
started with the entropy count started at zero, we wouldn't extract
any entropy at all.)

4) Random writer credit the entropy counter with the 20 bytes mixed in
step #2.

See? no problems!

					- Ted

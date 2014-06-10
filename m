Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936247AbaFJIhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:37:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267AbaFJIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:37:39 -0400
Date: Tue, 10 Jun 2014 10:37:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610083726.GY3213@twins.programming.kicks-ass.net>
References: <20140603130233.658a6a3c@gandalf.local.home>
 <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ELMKpCVvjiB+uwRu"
Content-Disposition: inline
In-Reply-To: <20140609162613.GE4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ELMKpCVvjiB+uwRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 09:26:13AM -0700, Paul E. McKenney wrote:
> That would indeed be a bad thing, as it could potentially lead to
> use-after-free bugs.  Though one could argue that any code that resulted
> in use-after-free would be quite aggressive.  But still...

Let me hijack this thread for yet another issue... So I had an RCU
related use-after-free the other day, and while Sasha was able to
trigger it quite easily, I had a multi-day struggle to reproduce.

Once I figured out what the exact problem was it was also clear to me
why it was so hard for me to reproduce.

So normally its easier to trigger races on bigger machines, more cpus,
more concurrency, more races, all good.

_However_ with RCU the grace period machinery is slower the bigger the
machine, so bigger machine, slower grace period, slower RCU free, less
likely to hit use-after-free.

So I was thinking, and I know you all will go kick me for this because
the very last thing we need is what I'm about to propose: more RCU
flavours :-).

How about an rcu_read_unlock() reference counted RCU variant that's
ultra aggressive in doing the callbacks in order to better trigger such
issues?

--ELMKpCVvjiB+uwRu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlsPGAAoJEHZH4aRLwOS6oDgQAKRpErHVpmoJrpOurClgfQrW
xpYYupyKk8B4TNg9FfYfrlf4oafAFc+IxzwjxQriFtw1UPCAb8ju/GmscMXAfKJY
z4uNFemZ8IxNszqkGj89wdQyfMWQf2lsli1SqjoXylSA6C+et51bI2Kk1Ib4MOqR
zTX+cZcnxDLsQfXpT1u/re05/4WS0Mz35CcJZ4Xvlr6YnUrLozo7fy87XzGzqfGw
1YcwduQ2n9X/e2CBiYuEtzT75p5x0gWcZkXWncKxEhOFR7V474uAveMzJE88gcdn
/zeuvW1ipiYbGZ31pojK2RFrRX7AFF1sIb1q0djmahqhEua8k617fhUdfNSdTXJ0
oSvfJ7scYZi2eHwJtlfTPr+zUxtPU7ZC0XSBsls6kCCyuIMLALqKye5gLFX7BjgB
J1Ih0d+xHdEoYNTZd60AlgWeUB4JitJWZ3TQP4ZwY72mG09fy7hj6NBPOWzpU1Be
g1cuqtpMji9qoFCfa1OqPFkN0dcbxEaQX686OM5BlWAK50uUjXXK+G8U29nXyFPa
8JXJZTpLb5klUBwYBrypM7j2RWpHToi9gfUq1pd9ftvBZSHQQChKhbJX4O5+h6AH
2m8HTyE9JzUKcaAFGWeun1PBNLX4//14zyNfglODMhlLmgdCqL/nDs7xYxSuM2VJ
2WkhgGrdAepFYN7osQkr
=xcbP
-----END PGP SIGNATURE-----

--ELMKpCVvjiB+uwRu--

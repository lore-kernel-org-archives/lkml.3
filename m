Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaFNDG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 23:06:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:38590 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbaFNDG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 23:06:27 -0400
Date: Fri, 13 Jun 2014 23:06:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140614030621.GB6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140613155241.GA4265@thunk.org>
 <20140614021014.1863.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614021014.1863.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:10:14PM -0400, George Spelvin wrote:
> > Unrolling doesn't make much difference; which isn't surprising given
> > that almost all of the differences go away when I commented out the
> > udelay().  Basically, at this point what we're primarily measuring is
> > how good various CPU's caches work, especially across context switches
> > where other code gets to run in between.
> 
> Huh.  As I was referring to when I talked about the branch
> predictor, I was hoping the removing *conditional* branches would
> help.

At least for Intel, between its branch predictor and speculative
execution engine, it doesn't make a difference.  

> Are you trying for an XOR to memory, or is the idea to remain in
> registers for the entire operation?
>
> I'm not sure an XOR to memory is that much better; it's 2 pool loads
> and 1 pool store either way.  Currently, the store is first (to
> input[]) and then both it and the fast_pool are fetched in fast_mix.
> 
> With an XOR to memory, it's load-store-load, but is that really better?

The second load can be optimized away.  If the compiler isn't smart
enough, the store means that the data is almost certainly still in the
D-cache.  But with a smart compiler (and gcc should be smart enough),
if fast_mix is a static function, gcc will inline fast_mix, and then
it should be able to optimize out the load.  In fact, it might be
smart enough to optimize out the first store, since it should be able
to realize that first store to the pool[] array will get overwritten
by the final store to the pool[] array.

So hopefully, it will remain in registers for the entire operation,
and the compilers will hopefully be smart enough to make the right
hting happy without the code having to be really ugly.

> In case it's useful, below is a small patch I made to
> add_interrupt_randomness to take advantage of 64-bit processors and make
> it a bit clearer what it's doing.  Not submitted officially because:
> 1) I haven't examined the consequences on 32-bit processors carefully yet.

When I did a quick comparison of your 64-bit fast_mix2 variant, it's
much slower than either the 32-bit fast_mix2, or the original fast_mix
alrogithm.  So given that 32-bit processors tend to be slower, I'm
pretty sure if we want to add a 64-bit optimization, we'll have to
conditionalize it on BITS_PER_LONG == 64 and include both the original
code and the 64-bit optimized code.

						- Ted

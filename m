Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3JAMod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:44:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:40710 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3JAMoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:44:32 -0400
Date: Tue, 1 Oct 2013 08:44:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20131001124424.GA2097@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:51:43PM +0000, Luck, Tony wrote:
> > In this case fast_mix would use two uninitialized ints from the stack
> > and mix it into the pool.
> 
> Is the concern here is that an attacker might know (or be able to control) what is on
> the stack - and so get knowledge of what is being mixed into the pool?

Yes, this is a bogus complaint.

> > In this case set the input to 0.
> 
> And the fix is to guarantee that everyone knows what is being mixed in? (!)
> 
> Wouldn't it be better to adjust the "nbytes" parameter to
> 
> 	fast_mix(..., ..., sizeof (input));
> 
> to only mix in the part of input[] that we successfully initialized?

The changes queued for the next merge window in the random tree solve
this problem slightly differently:

	...
	input[0] = cycles ^ j_high ^ irq;
	input[1] = now ^ c_high;
	ip = regs ? instruction_pointer(regs) : _RET_IP_;
	input[2] = ip;
	input[3] = ip >> 32;

	fast_mix(fast_pool, input);
	...

(Note the lack of nbytes parameter in fast_mix --- there are some
optimizations so that we mix in the changes by 32-bit words, instead
of bytes, and the number of 32-bit words is fixed to 4, since it's the
only way fast_mix is called).

_RET_IP_ isn't that much better than 0, but it's at least kernel
specific, and I figured it was better to shut up bogus warnings, as
opposed to trying to depend on stack garbage (which would likely be
kernel specific anyway).

Cheers,

						- Ted

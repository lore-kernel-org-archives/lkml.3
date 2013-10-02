Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3JBTki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:40:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:41389 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3JBTkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:40:36 -0400
Date: Wed, 2 Oct 2013 15:40:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Dumazet <eric.dumazet@gmail.com>, Tom Herbert <therbert@google.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] random: introduce
 get_random_bytes_busy_wait_initialized
Message-ID: <20131002194029.GC31579@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Tom Herbert <therbert@google.com>, davem@davemloft.net,
	netdev@vger.kernel.org, jesse.brandeburg@intel.com,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.2.02.1309231535030.23896@tomh.mtv.corp.google.com>
 <1379980991.3165.37.camel@edumazet-glaptop>
 <20130924023038.GA22393@order.stressinduktion.org>
 <20130924033505.GB22393@order.stressinduktion.org>
 <1380001118.3165.41.camel@edumazet-glaptop>
 <20130924054532.GA24446@order.stressinduktion.org>
 <1380028797.3165.65.camel@edumazet-glaptop>
 <20130925090034.GC4904@order.stressinduktion.org>
 <20131002151018.GA31579@thunk.org>
 <20131002171839.GQ10771@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002171839.GQ10771@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 07:18:40PM +0200, Hannes Frederic Sowa wrote:
> 
> I agree. I will look if this is easily possible for secure_seq and
> syncookies but depending on the data structure and its size it is a much
> harder thing to do. I wanted to try the low-hanging fruits first. ;)

To use syncookies as an example, you shouldn't need to store all of
the old syncookies.  Instead, if every 10 minutes or so, you rekey,
and you keep both the old and the new secrets around, you could just
simply check an incoming TCP packet using first the new key, and then
the old key.  During the transition window it would take a wee bit
more CPU time, but most of the time, it wouldn't cost anything extra
in CPU time, and the only extra cost is the space for the old key.

>From a security perspective it would be much better if we tried to
make all of the places where we draw randomness and somehow try to
rekey on a periodic basis.  That way, even if the initial value isn't
super-secure, that situation will heal itself fairly rapidly.  And it
also means that even if an adversary can brute-force break a 32-bit
secret, they would have to do so within 5 or 10 minutes in order for
it to be useful, and even if they could, it would only be useful for a
short window of time.

I know it won't always be possible, but to the extent that we can do
this, it would be a big improvement from a security perspective.

Cheers,

							- Ted

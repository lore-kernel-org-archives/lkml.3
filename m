Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaFLURQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:17:16 -0400
Received: from imap.thunk.org ([74.207.234.97]:36101 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaFLURP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:17:15 -0400
Date: Thu, 12 Jun 2014 16:17:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140612201710.GA3112@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140612041318.11805.qmail@ns.horizon.com>
 <20140612111850.26176.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612111850.26176.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the reasons for the timing instability is because of the
usleep() calls.  This allows some other process to schedule, and thus
disrupts the I-cache and uop caches.  With the usleep() calls:

i7-4900MQ# schedtool -R -p 1 -e /tmp/fast_mix2_49
fast_mix: 213	     fast_mix2: 280
fast_mix: 336	     fast_mix2: 356
fast_mix: 174	     fast_mix2: 392
fast_mix: 202	     fast_mix2: 403
fast_mix: 152	     fast_mix2: 280
fast_mix: 212	     fast_mix2: 403
fast_mix: 213	     fast_mix2: 403
fast_mix: 213	     fast_mix2: 392
fast_mix: 202	     fast_mix2: 403
fast_mix: 191	     fast_mix2: 392

... and without the usleep calls:

i7-4900MQ# schedtool -R -p 1 -e /tmp/fast_mix2_49
fast_mix: 146  fast_mix2: 347
fast_mix: 157  fast_mix2: 90
fast_mix: 78   fast_mix2: 90
fast_mix: 78   fast_mix2: 89
fast_mix: 78   fast_mix2: 90
fast_mix: 78   fast_mix2: 90
fast_mix: 90   fast_mix2: 90
fast_mix: 79   fast_mix2: 90
fast_mix: 90   fast_mix2: 89
fast_mix: 79   fast_mix2: 90

I had originally added the usleep calls() in my test infrastructure to
more accurately disable the uop cache effects, since we are going to
be called from an interrupt handler, not in a loop.  But anyway, this
is one of the reasons for the differences that you were seeing with
your benchmarking framework and mine, and why micro-benchmarking can
be so hard to get right.  :-)

(BTW, this is your original mixer; I haven't tried playing with your
modified Skein-like core round yet.)

					- Ted



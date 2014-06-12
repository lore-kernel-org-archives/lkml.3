Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaFLUqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:46:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:36173 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaFLUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:46:26 -0400
Date: Thu, 12 Jun 2014 16:46:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140612204622.GB3112@thunk.org>
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

So I just tried your modified 32-bit mixing function where you the
rotation to the middle step instead of the last step.  With the
usleep(), it doesn't make any difference:

# schedtool -R -p 1 -e /tmp/fast_mix2_48
fast_mix: 212  fast_mix2: 400	fast_mix3: 400
fast_mix: 208  fast_mix2: 408	fast_mix3: 388
fast_mix: 208  fast_mix2: 396	fast_mix3: 404
fast_mix: 224  fast_mix2: 408	fast_mix3: 392
fast_mix: 200  fast_mix2: 404	fast_mix3: 404
fast_mix: 208  fast_mix2: 412	fast_mix3: 396
fast_mix: 208  fast_mix2: 392	fast_mix3: 392
fast_mix: 212  fast_mix2: 408	fast_mix3: 388
fast_mix: 200  fast_mix2: 716	fast_mix3: 773
fast_mix: 426  fast_mix2: 717	fast_mix3: 728

without the usleep() I get:

692# schedtool -R -p 1 -e /tmp/fast_mix2_48
fast_mix: 104  fast_mix2: 224	fast_mix3: 176	
fast_mix: 56   fast_mix2: 112	fast_mix3: 56	
fast_mix: 56   fast_mix2: 64	fast_mix3: 64	
fast_mix: 64   fast_mix2: 64	fast_mix3: 48	
fast_mix: 56   fast_mix2: 64	fast_mix3: 56	
fast_mix: 56   fast_mix2: 64	fast_mix3: 64	
fast_mix: 56   fast_mix2: 64	fast_mix3: 64	
fast_mix: 56   fast_mix2: 72	fast_mix3: 56	
fast_mix: 56   fast_mix2: 64	fast_mix3: 56	
fast_mix: 64   fast_mix2: 64	fast_mix3: 56	

I'm beginning to suspect that some of the differences between your
measurements and mine might be that in addition to having a smaller
cache (8M instead of 12M), I suspect there are some other caches,
perhaps the uop cache, which are also smaller on the mobile processor,
and that is explaining why you are seeing some different results.

> 
> Of course, using wider words works fantastically.
> These constants give 76 bits if avalanche after 2 rounds,
> essentially full after 3....

And here is my testing using your 64-bit variant:

# schedtool -R -p 1 -e /tmp/fast_mix2_49
fast_mix: 294  fast_mix2: 476	fast_mix4: 442
fast_mix: 286  fast_mix2: 1058	fast_mix4: 448
fast_mix: 958  fast_mix2: 460	fast_mix4: 1002
fast_mix: 940  fast_mix2: 1176	fast_mix4: 826
fast_mix: 476  fast_mix2: 840	fast_mix4: 826
fast_mix: 462  fast_mix2: 840	fast_mix4: 826
fast_mix: 462  fast_mix2: 826	fast_mix4: 826
fast_mix: 462  fast_mix2: 826	fast_mix4: 826
fast_mix: 462  fast_mix2: 826	fast_mix4: 826
fast_mix: 462  fast_mix2: 840	fast_mix4: 826

... and without usleep()

690# schedtool -R -p 1 -e /tmp/fast_mix2_48
fast_mix: 52   fast_mix2: 116	fast_mix4: 96	
fast_mix: 32   fast_mix2: 32	fast_mix4: 24	
fast_mix: 28   fast_mix2: 36	fast_mix4: 24	
fast_mix: 32   fast_mix2: 32	fast_mix4: 24	
fast_mix: 32   fast_mix2: 36	fast_mix4: 24	
fast_mix: 36   fast_mix2: 32	fast_mix4: 24	
fast_mix: 32   fast_mix2: 36	fast_mix4: 28	
fast_mix: 28   fast_mix2: 28	fast_mix4: 24	
fast_mix: 32   fast_mix2: 36	fast_mix4: 28	
fast_mix: 32   fast_mix2: 32	fast_mix4: 24	

The bottom line is that what we are primarily measuring here is all
different cache effects.  And these are going to be quite different on
different microarchitectures.

That being said, I wouldn't be at all surprised if there are some
CPU's where the extract memory dereference to the twist_table[] would
definitely hurt, since Intel's amazing cache architecture(tm) is no
doubt covering a lot of sins.  I wouldn't be at all surprised if some
of these new mixing functions would fare much better if we tried
benchmarking them on an 32-bit ARM processor, for example....

	     	     	       	   	      - Ted


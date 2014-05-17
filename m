Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbaEQCTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 22:19:45 -0400
Received: from imap.thunk.org ([74.207.234.97]:46208 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbaEQCTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 22:19:44 -0400
Date: Fri, 16 May 2014 22:18:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        price@mit.edu
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
Message-ID: <20140517021840.GA5513@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
	price@mit.edu
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
 <20140516162117.GY11096@twins.programming.kicks-ass.net>
 <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:46:22PM -0700, Hannes Frederic Sowa wrote:
> This should do the trick:
> dd if=/dev/urandom of=/dev/zero bs=67108707
> 
> I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
> culprit.

Yep, that it's it.  Thanks for noticing this so quickly!  I'll push
the following patch to Linus.

    	      	    			- Ted

commit 29fb0ca5b3922288fba3f4c975a55032a51df0f0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri May 16 21:40:41 2014 -0400

    random: fix BUG_ON caused by accounting simplification
    
    Commit ee1de406ba6eb1 ("random: simplify accounting logic") simplified
    things too much, in that it allows the following to trigger an
    overflow that results in a BUG_ON crash:
    
    dd if=/dev/urandom of=/dev/zero bs=67108707
    
    Thanks to Peter Zihlstra for discovering the crash, and Hannes
    Frederic for analyizing the root cause.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reported-by: Peter Zijlstra <peterz@infradead.org>
    Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Cc: Greg Price <price@mit.edu>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..102c50d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -995,8 +995,11 @@ retry:
 		ibytes = min_t(size_t, ibytes, have_bytes - reserved);
 	if (ibytes < min)
 		ibytes = 0;
-	entropy_count = max_t(int, 0,
-			      entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
+	if (have_bytes >= ibytes + reserved)
+		entropy_count -= ibytes << (ENTROPY_SHIFT + 3);
+	else
+		entropy_count = reserved << (ENTROPY_SHIFT + 3);
+
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 

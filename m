Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbaGOUiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:38:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36936 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509AbaGOUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:38:08 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 16:38:08 EDT
X-Sasl-enc: 1Bd/5zCTSs9mLGQcpB3AwbtCLs9nRk/WVEVEZN4Ob22w 1405456153
Message-ID: <1405456150.25863.16.camel@localhost>
Subject: Re: BUG_ON drivers/char/random.c:986
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        price@mit.edu
Date: Tue, 15 Jul 2014 22:29:10 +0200
In-Reply-To: <20140715043613.GA18575@redhat.com>
References: <5370EBE9.6@oracle.com>
	 <20140516153455.GV11096@twins.programming.kicks-ass.net>
	 <53763775.3040602@linux.intel.com>
	 <20140516162117.GY11096@twins.programming.kicks-ass.net>
	 <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
	 <20140517021840.GA5513@thunk.org> <20140715043613.GA18575@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 2014-07-15 at 00:36 -0400, Dave Jones wrote:
> On Fri, May 16, 2014 at 10:18:40PM -0400, Theodore Ts'o wrote:
>  > On Fri, May 16, 2014 at 05:46:22PM -0700, Hannes Frederic Sowa wrote:
>  > > This should do the trick:
>  > > dd if=/dev/urandom of=/dev/zero bs=67108707
>  > > 
>  > > I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
>  > > culprit.
>  > 
>  > Yep, that it's it.  Thanks for noticing this so quickly!  I'll push
>  > the following patch to Linus.
>  > 
>  >     	      	    			- Ted
>  > 
>  > commit 29fb0ca5b3922288fba3f4c975a55032a51df0f0
>  > Author: Theodore Ts'o <tytso@mit.edu>
>  > Date:   Fri May 16 21:40:41 2014 -0400
>  > 
>  >     random: fix BUG_ON caused by accounting simplification
> 
> I just hit this bug again on 3.16rc5, which has this patch, so
> there's still some corner case that isn't happy..
> 
> (old thread is here for reference: https://lkml.org/lkml/2014/5/16/724)

Looks like an overflow introduced by e33ba5fa7afce1a ("random: fix nasty
entropy accounting bug"). Ted, what do you think about the following
fix?

Bye,
Hannes

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..72511e8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -999,7 +999,9 @@ retry:
 	}
 	if (ibytes < min)
 		ibytes = 0;
-	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+
+	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0 ||
+	    entropy_count > orig)
 		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)



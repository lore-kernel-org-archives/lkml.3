Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbaD3Jds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:33:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaD3Jdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:33:47 -0400
Date: Wed, 30 Apr 2014 11:33:45 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] timer: prevent overflow in apply_slack
Message-ID: <20140430093345.GA18623@midget.suse.cz>
References: <20140417194215.GA10494@midget.suse.cz>
 <alpine.DEB.2.02.1404172344420.22697@ionos.tec.linutronix.de>
 <20140418152310.GA13654@midget.suse.cz>
 <20140429111356.GA23888@midget.suse.cz>
 <alpine.DEB.2.02.1404291921490.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404291921490.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:22:25PM +0200, Thomas Gleixner wrote:
> > > +	mask = (1LL << bit) - 1;
> 
> This should be 1UL, shouldn't it?

yes, good catch, thanks!




On architectures with sizeof(int) < sizeof (long), the
computation of mask inside apply_slack() can be undefined if the
computed bit is > 32.

E.g. with: expires = 0xffffe6f5 and slack = 25, we get:

expires_limit = 0x20000000e
bit = 33
mask = (1 << 33) - 1  /* undefined */

On x86, mask becomes 1 and and the slack is not applied properly.
On s390, mask is -1, expires is set to 0 and the timer fires immediately.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Suggested-by: Deborah Townsend <dstownse@us.ibm.com>

diff --git a/kernel/timer.c b/kernel/timer.c
index 87bd529..4c36c91 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -838,7 +838,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ


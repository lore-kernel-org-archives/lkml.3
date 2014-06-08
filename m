Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaFHLaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 07:30:04 -0400
Received: from ns.horizon.com ([71.41.210.147]:43953 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753496AbaFHLaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 07:30:02 -0400
Date: 8 Jun 2014 07:30:00 -0400
Message-ID: <20140608113000.5423.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond, not the second
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <53943E34.7030502@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine by me this cleanup, although not strictly needed.

Agreed.  The timer slack is set to HZ (1 second) anyway.

It just dawned on me that a simpler and more efficient way to do this
(which I'll do in v2 of this) would be:

   	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
-	expires = 40 + (prandom_u32() % 40);
-	seed_timer.expires = jiffies + msecs_to_jiffies(expires * MSEC_PER_SEC);
+	expires = 40*HZ + prandom_u32_max(40*HZ);
+	seed_timer.expires = jiffies + expires;

That avoids calling msecs_to_jiffies entirely.

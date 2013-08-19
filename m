Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab3HSIA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:00:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:50182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3HSIAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:00:25 -0400
Message-ID: <1376899214.14734.6.camel@jlt4.sipsolutions.net>
Subject: Re: 3.11-rc6 genetlink locking fix offends lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>, Thomas Graf <tgraf@suug.ch>
Date: Mon, 19 Aug 2013 10:00:14 +0200
In-Reply-To: <alpine.LNX.2.00.1308182143370.906@eggly.anvils>
References: <alpine.LNX.2.00.1308182143370.906@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 3.11-rc6's commit 58ad436fcf49 ("genetlink: fix family dump race")
> gives me the lockdep trace below at startup.

Hmm. Yes, I see now how this happens, not sure why I didn't run into it.

The problem is that genl_family_rcv_msg() is called with the genl_lock
held, and then calls netlink_dump_start() with it held, creating a
genl_lock->cb_mutex dependency, but obviously the dump continuation is
the other way around.

We could use the semaphore instead, I believe, but I don't really
understand the mutex vs. semaphore well enough to be sure that's
correct.

johannes


diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index f85f8a2..6cfa646 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -792,7 +792,7 @@ static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
 	bool need_locking = chains_to_skip || fams_to_skip;
 
 	if (need_locking)
-		genl_lock();
+		down_read(&cb_lock);
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -815,7 +815,7 @@ errout:
 	cb->args[1] = n;
 
 	if (need_locking)
-		genl_unlock();
+		up_read(&cb_lock);
 
 	return skb->len;
 }



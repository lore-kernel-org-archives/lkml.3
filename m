Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3EERgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 13:36:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3EERgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 13:36:46 -0400
Date: Sun, 05 May 2013 13:36:42 -0400 (EDT)
Message-Id: <20130505.133642.523571665638952150.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: netdev@vger.kernel.org, edumazet@google.com, fw@strlen.de,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH] net: frag, fix race conditions in LRU list maintenance
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130505145622.9351.86587.stgit@zurg>
References: <20130505145622.9351.86587.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 05 May 2013 10:36:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Sun, 05 May 2013 18:56:22 +0400

> This patch fixes race between inet_frag_lru_move() and inet_frag_lru_add()
> which was introduced in commit 3ef0eb0db4bf92c6d2510fe5c4dc51852746f206
> ("net: frag, move LRU list maintenance outside of rwlock")
> 
> One cpu already added new fragment queue into hash but not into LRU.
> Other cpu found it in hash and tries to move it to the end of LRU.
> This leads to NULL pointer dereference inside of list_move_tail().
> 
> Another possible race condition is between inet_frag_lru_move() and
> inet_frag_lru_del(): move can happens after deletion.
> 
> This patch initializes LRU list head before adding fragment into hash and
> inet_frag_lru_move() doesn't touches it if it's empty.
> 
> I saw this kernel oops two times in a couple of days.
 ...
> Oops happened on this path:
> ip_defrag() -> ip_frag_queue() -> inet_frag_lru_move() -> list_move_tail() -> __list_del_entry()
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

This looks good to me, Jesper and co. please review.

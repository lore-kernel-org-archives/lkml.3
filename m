Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LJB3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:29:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3LJB3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:29:02 -0500
Date: Mon, 09 Dec 2013 20:29:00 -0500 (EST)
Message-Id: <20131209.202900.593427287326860030.davem@davemloft.net>
To: nyushchenko@dev.rtsoft.ru
Cc: claudiu.manoil@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dkrivoschokov@dev.rtsoft.ru,
        kbaidarov@dev.rtsoft.ru
Subject: Re: [PATCH] net: gainfar: fix race between issuing and completing
 Tx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386333359-18854-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1386333359-18854-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 09 Dec 2013 17:29:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Date: Fri,  6 Dec 2013 16:35:59 +0400

> gfar_poll() checked Tx queue status without locking, thus allowing
> gfar_start_xmit() to alter it in parallel, which caused hang on every
> other nfsroot boot with RT enabled.
> 
> This patch raises locking from gfar_clean_tx_ring() up to gfar_poll().
> With this change applied, hangs are no longer reproduced.
> 
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This is not sufficient.

You've left a huge comment in gfar_start_xmit() which explains that
the current locking is correct.

Whoever wrote that comment thought there were no problems with the
current arrangement.

If you want to change it, you have to adjust this comment, and also
explain exactly what races without your proposed change.

If you are going to take this lock, you might want to consider using
netif_tx_lock() since that is held across the entirety of any
netdev_ops->ndo_start_xmit() invocation.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaHEXHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:07:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaHEXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:07:49 -0400
Date: Tue, 05 Aug 2014 16:07:48 -0700 (PDT)
Message-Id: <20140805.160748.1185917042908283028.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 16:07:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Mon, 4 Aug 2014 16:20:56 +0100

> This series starts using carrier off as a way to purge packets when the guest is
> not able (or willing) to receive them. It is a much faster way to get rid of
> packets waiting for an overwhelmed guest.
> The first patch changes current netback code where it relies currently on
> netif_carrier_ok.
> The second turns off the carrier if the guest times out on a queue, and only
> turn it on again if that queue (or queues) resurrects.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Applied, but I have some reservations:

1) This is starting to bleed what is normally qdisc type policy into the
   driver.

2) There are other drivers that could run into this kind of situation and
   have similar concerns, therefore we should make sure we have a consistent
   approach that such entities use to handle this problem.

Part of the problem is that netif_carrier_off() only partially mimicks
the situation.  It expresses the "transmitter is down so packets
aren't going onto the wire" part, which keeps the watchdog from
spitting out log messages ever time it fires.  But it doesn't deal
with packet freeing policy meanwhile, which I guess is the part that
this patch series is largely trying to address.

Thanks.


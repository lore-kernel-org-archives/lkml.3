Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3K2Vmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:42:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54956 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K2Vmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:42:31 -0500
Date: Fri, 29 Nov 2013 16:42:29 -0500 (EST)
Message-Id: <20131129.164229.2292905485668904870.davem@davemloft.net>
To: puzman@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pch_gbe: Fix transmit queue management
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385631882-12827-2-git-send-email-puzman@gmail.com>
References: <20131127.203929.1379316258754767343.davem@davemloft.net>
	<1385631882-12827-2-git-send-email-puzman@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Nov 2013 13:42:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Puzman <puzman@gmail.com>
Date: Thu, 28 Nov 2013 10:44:39 +0100

> According to Documentation/networking/driver.txt the ndo_start_xmit method should not return NETDEV_TX_BUSY under normal circumstances.
> Stop the transmit queue when tx_ring is full.

Please format your commit message text to 80 columns.

> 
> Signed-off-by: Ondrej Puzman <puzman@gmail.com>

You should be instead preventing the transmit method from being invoked
when it might be possible that a request cannot be satisfied.

This means that at the end of a transmit request, you must stop the
queue if a packet with the maximum number of possible descriptors
cannot be satisfied.  Then it is impossible for the transmit function
to be invoked in a situation where it would need to fail for lack of
available transmit descriptors.

This is why drivers decided whether to stop their TX queues based upon
calculations involving MAX_SKB_FRAGS.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3H2AIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:08:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52201 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3H2AId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:08:33 -0400
Date: Wed, 28 Aug 2013 20:08:31 -0400 (EDT)
Message-Id: <20130828.200831.289304393401193657.davem@davemloft.net>
To: linus.luessing@web.de
Cc: bridge@lists.linux-foundation.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, amwang@redhat.com,
        linux@baker-net.org.uk
Subject: Re: [PATCH] bridge: separate querier and query timer into
 IGMP/IPv4 and MLD/IPv6 ones
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377511266-14530-1-git-send-email-linus.luessing@web.de>
References: <1377511266-14530-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 28 Aug 2013 17:08:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon, 26 Aug 2013 12:01:06 +0200

> Currently we would still potentially suffer multicast packet loss if there
> is just either an IGMP or an MLD querier: For the former case, we would
> possibly drop IPv6 multicast packets, for the latter IPv4 ones. This is
> because we are currently assuming that if either an IGMP or MLD querier
> is present that the other one is present, too.
> 
> This patch makes the behaviour and fix added in
> "bridge: disable snooping if there is no querier" (b00589af3b04)
> to also work if there is either just an IGMP or an MLD querier on the
> link: It refines the deactivation of the snooping to be protocol
> specific by using separate timers for the snooped IGMP and MLD queries
> as well as separate timers for our internal IGMP and MLD queriers.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

I think the logic of the fix is fine, but theres a lot of duplication
here.

Why not make a:

struct bridge_mcast_timer {
	struct	timer_list	timer;
	u32			queries_sent;
	u32			startup_queries_sent;

};

Then in the port structure you have:

	struct bridge_mcast_timer	ip4;
	struct bridge_mcast_timer	ip6;

And pass a reference to the right one into generic helper functions.

That sounds a lot better right?

Please make this improvement and resubmit, thanks.

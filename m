Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaIFADf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:03:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47120 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIFADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:03:31 -0400
Message-ID: <1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Prashant Sreedharan <prashant@broadcom.com>
Cc: Benjamin Poirier <bpoirier@suse.de>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 17:03:30 -0700
In-Reply-To: <1409960135.18724.33.camel@prashant>
References: <1409880647-14887-1-git-send-email-bpoirier@suse.de>
	 <1409880647-14887-5-git-send-email-bpoirier@suse.de>
	 <1409960135.18724.33.camel@prashant>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 16:35 -0700, Prashant Sreedharan wrote:

> fyi.. Initially the driver was doing a skb_copy()
> (tigon3_dma_hwbug_workaround()) for LSO skb that met HW bug conditions
> but users started reporting page allocation failures due to copying of
> large LSO skbs. To avoid this Commit 4caab52eb102f1 (tg3: Prevent page
> allocation failure during TSO workaround) changed the driver logic to do
> skb_gso_segment() for LSO skbs that met the HW bug conditions. With
> skb_linearize() we might end up again with memory allocation failures
> for large LSO skbs though at a much less frequent level (ie when TX
> queue is almost full). 

Note that TCP stack has one skb collapse feature, currently limited in
allocation of linear skbs fitting a whole page.

Instead of this private helper (and pretty limited one btw), we could
add a core function, that would build skbs with order-0 fragments.

Instead of skb_linearize(), I guess many call sites could instead use
this new helper.

Because as you said, skb_linearize() of one 64KB GSO packet can ask
order-5 allocations, and this generally does not work reliably.



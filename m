Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaHVEZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:25:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46071 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHVEZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:25:17 -0400
Date: Thu, 21 Aug 2014 21:25:14 -0700 (PDT)
Message-Id: <20140821.212514.4787122329921320.davem@davemloft.net>
To: bpoirier@suse.de
Cc: mchan@broadcom.com, prashant@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] tg3: Fix tx_pending checks for tg3_tso_bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140821215911.GA7117@f1.synalogic.ca>
References: <20140821012303.GA15440@f1.synalogic.ca>
	<1408614683.7644.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<20140821215911.GA7117@f1.synalogic.ca>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 21:25:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Thu, 21 Aug 2014 14:59:11 -0700

> Ah, now I understand the reason for the * 3 in
> 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
> 
> 	/* Estimate the number of fragments in the worst case */
> but that is not really the "worst case". It's not forbidden to have more than
> two frags per skb output from skb_gso_segment(). I've kept this estimation
> approach but I've added code to validate the estimation or else linearize the
> skb.

This is a common situation drivers run into, and there have been a few
notable situations in virtualization drivers recently.  Although in
those cases the problems arise from the fact that if an SKB fragment
is a compound page, this can evaluate to requiring multiple
descriptors, one for each 4K segment within that fragment.

Anyways, the point I wanted to make is that you shouldn't do anything
too complicated to handle all of this.  And I think your conclusion
to linearize if the estimation fails is a good one.

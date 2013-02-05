Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3BEIMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:12:38 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:50474 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3BEIMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:12:35 -0500
Date: Tue, 5 Feb 2013 09:12:32 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Romain KUNTZ <r.kuntz@ipflavors.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        herbert@gondor.hengli.com.au,
        Emmanuel THIERRY <emmanuel.thierry@telecom-bretagne.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Subject: Re: [RFC PATCH] xfrm: fix handling of XFRM policies mark and mask.
Message-ID: <20130205081232.GF23291@secunet.com>
References: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Feb 2013 08:12:32.0662 (UTC) FILETIME=[8C639B60:01CE0378]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Jamal, he introduced the xfrm_mark framework and knows it
probably the best.

On Sat, Feb 02, 2013 at 06:27:03PM +0100, Romain KUNTZ wrote:
> The current algorithm to insert XFRM policies with a mark and a mask
> allows the insertion of more generic policies, but fails when trying
> to install more specific policies.
> 

Hm, I think we will not match always the right policy if we allow both
orders. Lets take your example and assume we have a flow with mark 1.
The policy lookup is a linear search, so we use the first matching
policy. xfrm_policy_match() does the following check on the mark:

if (... || (fl->flowi_mark & pol->mark.m) != pol->mark.v || ...)
	return -ESRCH

> For example, executing the below commands in that order succeed:
>  ip -6 xfrm policy flush
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 1 mask 0xffffffff
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out

The policy with mark 1 is the first we find. The policy passes the
mark check and if the flow matches the selectors, we use this policy.

> 
> But it fails in the reverse order:
>  ip -6 xfrm policy flush
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 1 mask 0xffffffff
>  RTNETLINK answers: File exists

With this scenario, we would find the policy with mark and mask 0 first.
This policy passes the mark check too. So we would use this policy if the
flow matches the selectors, but the flow asked for a policy with mark 1.

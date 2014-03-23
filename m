Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaCWEuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 00:50:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaCWEuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 00:50:12 -0400
Date: Sun, 23 Mar 2014 00:50:10 -0400 (EDT)
Message-Id: <20140323.005010.1898428719601246326.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com
Subject: Re: [PATCH] netlink: have netlink per-protocol bind function
 return an error code.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1239812af16a5c746772913ef68d3570383f2e50.1395419169.git.rgb@redhat.com>
References: <1239812af16a5c746772913ef68d3570383f2e50.1395419169.git.rgb@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Mar 2014 21:50:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Fri, 21 Mar 2014 12:39:11 -0400

> @@ -1441,6 +1441,17 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
>  	if (!nladdr->nl_groups && (nlk->groups == NULL || !(u32)nlk->groups[0]))
>  		return 0;
>  
> +	if (nlk->netlink_bind && nladdr->nl_groups) {
> +		int i;
> +
> +		for (i = 0; i < nlk->ngroups; i++)
> +			if (test_bit(i, (long unsigned int *)&nladdr->nl_groups)) {
> +				err = nlk->netlink_bind(i);
> +				if (err)
> +					return err;
> +			}
> +	}
> +

You can't just leave a partially set of completed bindings in place.

It's not valid to leave half-baked state like this.

If you return an error, all of the binding state changes must be
completely undone.

If you can't find a way to do this cleanly, you'll need to find
a way for the audit code to not return an error.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaHVEbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:31:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46128 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHVEa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:30:59 -0400
Date: Thu, 21 Aug 2014 21:30:57 -0700 (PDT)
Message-Id: <20140821.213057.1438247518790500739.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add handling of IP header with option
 field in netvsc_set_hash()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408481635-29639-1-git-send-email-haiyangz@microsoft.com>
References: <1408481635-29639-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 21:30:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 19 Aug 2014 20:53:55 +0000

> @@ -200,12 +202,18 @@ static bool netvsc_set_hash(u32 *hash, struct sk_buff *skb)
>  	iphdr = ip_hdr(skb);
>  
>  	if (iphdr->version == 4) {
> -		if (iphdr->protocol == IPPROTO_TCP)
> +		data = (u8 *)&iphdr->saddr;
> +		if (iphdr->protocol == IPPROTO_TCP) {
>  			data_len = 12;
> -		else
> +			if (iphdr->ihl > 5) {
> +				memcpy(dbuf, &iphdr->saddr, 8);
> +				memcpy(&dbuf[8], &tcp_hdr(skb)->source, 4);

This is rediculous.

Make hash_comp() take a void pointer for the buffer.

Then your code is simply:

	be32 dbuf[2];

	dbuf[1] = iph->saddr;
	dbuf[2] = iph->daddr;
	dbuf[3] = *(be32 *)tcph->source;

	*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN, dbuf, 12);

No special cases for IP options or any garbage like that.

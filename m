Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaGVHot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:44:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGVHoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:44:46 -0400
Date: Tue, 22 Jul 2014 10:42:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, dcb314@hotmail.com,
        David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
        Patrick McHardy <kaber@trash.net>, pablo@netfilter.org,
        Simon Horman <horms@verge.net.au>, wensong@linux-vs.org
Subject: Re: [PATCH 3/5] net/netfilter/ipvs/ip_vs_ctl.c: drop argument range
 check just before the check for equality
Message-ID: <20140722074214.GL25880@mwanda>
References: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
 <alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
 <CANZNk83dJCXAWrQ+i5rh=sdUuiiD5ZhzDua-rjJpBZCzzNGDJA@mail.gmail.com>
 <alpine.LFD.2.11.1407212253100.2358@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407212253100.2358@ja.home.ssi.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:01:56PM +0300, Julian Anastasov wrote:
> @@ -2333,13 +2339,12 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
>  	struct ip_vs_dest_user_kern udest;
>  	struct netns_ipvs *ipvs = net_ipvs(net);
>  
> +	BUILD_BUG_ON(sizeof(arg) > 256);

256 is off-by-one because u8 ranges from 0-255 so we are never able to
copy 256 bytes into the "arg" buffer.

> -	if (copylen > 128)
> +	if (*len < (int) copylen || *len < 0) {
> +		pr_err("get_ctl: len %d < %u\n", *len, copylen);

Don't let users flood dmesg.  Just return an error.  (This can be
triggered by non-root as well).

>  		return -EINVAL;
> +	}

regards,
dan carpenter

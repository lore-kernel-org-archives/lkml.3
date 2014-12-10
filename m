Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaLJCBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:01:14 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:54937 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754081AbaLJCBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:01:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3871:3872:4321:4605:5007:6117:6261:7903:10004:10400:10481:10848:11026:11232:11658:11914:12043:12517:12519:12740:13019:13069:13161:13229:13311:13357:19900:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: duck06_7e14c58976520
X-Filterd-Recvd-Size: 2485
Message-ID: <1418176864.1047.6.camel@perches.com>
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
From: Joe Perches <joe@perches.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 09 Dec 2014 18:01:04 -0800
In-Reply-To: <5487A455.1090907@cn.fujitsu.com>
References: <5487A455.1090907@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 09:39 +0800, Gu Zheng wrote:
> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
> cmsghdr from msghdr, just cleanup. 

Does this even compile?

So which is it?

	for_each_cmsghdr
or
	for_each_cmsg_hdr?

The .h #defines for_each_cmsg_hdr
but all the uses are for_each_cmsghdr

> diff --git a/Documentation/networking/timestamping/timestamping.c b/Documentation/networking/timestamping/timestamping.c
[]
> @@ -169,9 +169,7 @@ static void printpacket(struct msghdr *msg, int res,
>  	       res,
>  	       inet_ntoa(from_addr->sin_addr),
>  	       msg->msg_controllen);
> -	for (cmsg = CMSG_FIRSTHDR(msg);
> -	     cmsg;
> -	     cmsg = CMSG_NXTHDR(msg, cmsg)) {
> +	for_each_cmsghdr(cmsg, msg) {
>  		printf("   cmsg len %zu: ", cmsg->cmsg_len);
>  		switch (cmsg->cmsg_level) {
>  		case SOL_SOCKET:
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
[]
> @@ -399,7 +399,7 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
>  {
>  	struct cmsghdr *cmsg;
>  
> -	for (cmsg = CMSG_FIRSTHDR(msg); cmsg; cmsg = CMSG_NXTHDR(msg, cmsg)) {
> +	for_each_cmsghdr(cmsg, msg) {
>  		if (!CMSG_OK(msg, cmsg))
>  			return -EINVAL;
>  		if (cmsg->cmsg_level != SOL_ALG)
> diff --git a/include/linux/socket.h b/include/linux/socket.h
[]
> @@ -94,6 +94,10 @@ struct cmsghdr {
>  			     (cmsg)->cmsg_len <= (unsigned long) \
>  			     ((mhdr)->msg_controllen - \
>  			      ((char *)(cmsg) - (char *)(mhdr)->msg_control)))
> +#define for_each_cmsg_hdr(cmsg, msg)  \
> +	for (cmsg = CMSG_FIRSTHDR(msg); \
> +	     cmsg; \
> +	     cmsg = CMSG_NXTHDR(msg, cmsg))




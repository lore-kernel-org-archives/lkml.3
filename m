Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaCHB4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:56:55 -0500
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:40356 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbaCHB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:56:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4250:4321:4559:4605:5007:7576:7652:10011:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357:13869:13894,0,RBL:none,CacheIP:none,Bay
X-HE-Tag: birth41_75ff541d93329
X-Filterd-Recvd-Size: 2145
Message-ID: <1394243809.6972.4.camel@joe-AO722>
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: Joe Perches <joe@perches.com>
To: behanw@converseincode.com
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Date: Fri, 07 Mar 2014 17:56:49 -0800
In-Reply-To: <1394241960-1764-1-git-send-email-behanw@converseincode.com>
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>
	 <1394241960-1764-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 17:26 -0800, behanw@converseincode.com wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
[]
> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
[]
> @@ -23,12 +23,14 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>  			       u8 *data, size_t data_len, u8 *mic)
>  {
>  	struct scatterlist assoc, pt, ct[2];
> -	struct {
> -		struct aead_request	req;
> -		u8			priv[crypto_aead_reqsize(tfm)];
> -	} aead_req;
>  
> -	memset(&aead_req, 0, sizeof(aead_req));
> +	char aead_req_data[sizeof(struct aead_request) +
> +				crypto_aead_reqsize(tfm) +
> +				CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;

Can this be a too large amount of stack?

Is crypto_aead_reqsize() limited to < ~1k?

Perhaps it'd be better to use kzalloc for this
or another reserved pool



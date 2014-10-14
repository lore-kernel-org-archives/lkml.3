Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaJNKGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:06:04 -0400
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:11887
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932066AbaJNKGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:06:01 -0400
X-Greylist: delayed 5638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 06:06:01 EDT
Message-ID: <543CDF7C.4080209@freescale.com>
Date: Tue, 14 Oct 2014 11:31:56 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.14 36/37] crypto: caam - fix addressing of struct member
References: <20141013022400.286360067@linuxfoundation.org>
 <20141013022401.796709337@linuxfoundation.org>
In-Reply-To: <20141013022401.796709337@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(479174003)(24454002)(51704005)(199003)(95666004)(65956001)(59896002)(36756003)(46102003)(64126003)(85306004)(65806001)(104016003)(106466001)(107046002)(105606002)(76176999)(4396001)(92726001)(65816999)(83506001)(102836001)(54356999)(50986999)(84676001)(92566001)(23676002)(21056001)(50466002)(33656002)(575784001)(64706001)(26826002)(20776003)(97736003)(120916001)(80022003)(87266999)(47776003)(76482002)(6806004)(80316001)(99396003)(19580405001)(44976005)(31966008)(19580395003)(87936001)(85852003)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

You can cherry-pick 307fd543f3d23f8f56850eca1b27b1be2fe71017 on stable
3.13+ as well. The original 'cc stable 3.13+' line was deleted by
mistake during commit.

Thank you,
Cristian S.





On 10/13/2014 05:24 AM, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Cristian Stoica <cristian.stoica@freescale.com>
> 
> commit 4451d494b1910bf7b7f8381a637d0fe6d2142467 upstream.
> 
> buf_0 and buf_1 in caam_hash_state are not next to each other.
> Accessing buf_1 is incorrect from &buf_0 with an offset of only
> size_of(buf_0). The same issue is also with buflen_0 and buflen_1
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/crypto/caam/caamhash.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -1348,9 +1348,9 @@ static int ahash_update_first(struct aha
>  	struct device *jrdev = ctx->jrdev;
>  	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
>  		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
> -	u8 *next_buf = state->buf_0 + state->current_buf *
> -		       CAAM_MAX_HASH_BLOCK_SIZE;
> -	int *next_buflen = &state->buflen_0 + state->current_buf;
> +	u8 *next_buf = state->current_buf ? state->buf_1 : state->buf_0;
> +	int *next_buflen = state->current_buf ?
> +		&state->buflen_1 : &state->buflen_0;
>  	int to_hash;
>  	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
>  	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
> 
> 

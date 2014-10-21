Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaJUIRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:17:51 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:57719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750964AbaJUIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:17:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:421:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:4321:5007:6261:10004:10400:10450:10455:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13095:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ocean46_43ff12f035617
X-Filterd-Recvd-Size: 2574
Message-ID: <1413879465.12828.1.camel@perches.com>
Subject: Re: [PATCH 2/2] jffs2: fix buffer dump debug output
From: Joe Perches <joe@perches.com>
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 01:17:45 -0700
In-Reply-To: <21ad981db8c65d3f00be3d9a254cae78cf40b96d.1413878259.git.cyrille.pitchen@atmel.com>
References: <cover.1413878259.git.cyrille.pitchen@atmel.com>
	 <21ad981db8c65d3f00be3d9a254cae78cf40b96d.1413878259.git.cyrille.pitchen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 10:05 +0200, Cyrille Pitchen wrote:
> This patch fixes __jffs2_dbg_dump_buffer(): this function prints a message
> claiming to dump len bytes. However, depending on the start offset, the former
> code drops up to 31 (JFFS2_BUFDUMP_BYTES_PER_LINE - 1) bytes.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> ---
>  fs/jffs2/debug.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
> index 07bd5bc..1b515b2 100644
> --- a/fs/jffs2/debug.c
> +++ b/fs/jffs2/debug.c
> @@ -736,30 +736,25 @@ void
>  __jffs2_dbg_dump_buffer(unsigned char *buf, int len, uint32_t offs)
>  {
>  	int skip;
> -	int i;
> +	int i, pos;
>  
>  	printk(JFFS2_DBG_MSG_PREFIX " dump from offset %#08x to offset %#08x (%x bytes).\n",
>  		offs, offs + len, len);
> -	i = skip = offs % JFFS2_BUFDUMP_BYTES_PER_LINE;
> +	i = skip = offs & (JFFS2_BUFDUMP_BYTES_PER_LINE - 1);
>  	offs = offs & ~(JFFS2_BUFDUMP_BYTES_PER_LINE - 1);
>  
> -	if (skip != 0)
> -		printk(JFFS2_DBG "%#08x: ", offs);
> -
> +	printk(JFFS2_DBG "%#08x: ", offs);
>  	while (skip--)
>  		printk("   ");
>  
> -	while (i < len) {
> -		if ((i % JFFS2_BUFDUMP_BYTES_PER_LINE) == 0 && i != len -1) {
> -			if (i != 0)
> -				printk("\n");
> +	for (pos = 0; pos < len; ++pos, ++i) {
> +		if (i == JFFS2_BUFDUMP_BYTES_PER_LINE) {
>  			offs += JFFS2_BUFDUMP_BYTES_PER_LINE;
> -			printk(JFFS2_DBG "%0#8x: ", offs);
> +			printk(JFFS2_DBG "\n%0#8x: ", offs);
> +			i = 0;

print_hex_dump would be better



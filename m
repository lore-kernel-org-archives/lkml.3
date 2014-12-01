Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaLAVED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:04:03 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40096 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaLAVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:03:59 -0500
Message-ID: <547CD7B9.5030000@gmail.com>
Date: Mon, 01 Dec 2014 22:03:53 +0100
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Alasdair Kergon <agk@redhat.com>,
        kernel-janitors@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8 v2] dm: replace memset by memzero_explicit
References: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr> <1417367029-32762-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1417367029-32762-6-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 06:03 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Memset on a local variable may be removed when it is called just before the
> variable goes out of scope.  Using memzero_explicit defeats this
> optimization.  A simplified version of the semantic patch that makes this
> change is as follows: (http://coccinelle.lip6.fr/)

Ack, but I submitted the same patch a week ago....

https://www.redhat.com/archives/dm-devel/2014-November/msg00084.html

Mike, please could you add this to linux-next tree or you want this
to go through Herbert's tree?
(I do not think it is good idea for DM patches.)

Thanks,
Milan

> 
> // <smpl>
> @@
> identifier x;
> type T;
> @@
> 
> {
> ... when any
> T x[...];
> ... when any
>     when exists
> - memset
> + memzero_explicit
>   (x,
> -0,
>   ...)
> ... when != x
>     when strict
> }
> // </smpl>
> 
> This change was suggested by Daniel Borkmann <dborkman@redhat.com>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Daniel Borkmann suggested that these patches could go through Herbert Xu's
> cryptodev tree.
> 
> v2: fixed email address
> 
>  drivers/md/dm-crypt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index fc93b93..08981be 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -705,7 +705,7 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
>  	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
>  		crypto_xor(data + i * 8, buf, 8);
>  out:
> -	memset(buf, 0, sizeof(buf));
> +	memzero_explicit(buf, sizeof(buf));
>  	return r;
>  }
>  
> 


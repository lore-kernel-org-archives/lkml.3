Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3IEGMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:12:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755393Ab3IEGMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:12:37 -0400
Message-ID: <1378361546.1944.8.camel@joe-AO722>
Subject: Re: [PATCH] ALSA: emu10k1: casting (void *) value returned by
 kcalloc is useless
From: Joe Perches <joe@perches.com>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: perex@perex.cz, linux-kernel@vger.kernel.org
Date: Wed, 04 Sep 2013 23:12:26 -0700
In-Reply-To: <52281D37.40808@cn.fujitsu.com>
References: <52281D37.40808@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 13:57 +0800, Duan Jiong wrote:
> From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> 
> Casting (void *) value returned by kcalloc is useless
> as mentioned in Documentation/CodingStyle, Chap 14.

__user is an important marker that is lost here.

> diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
[]
> @@ -1183,9 +1183,8 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
>  	mm_segment_t seg;
>  
>  	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
> -	    (icode->gpr_map = (u_int32_t __user *)
> -	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
> -		     GFP_KERNEL)) == NULL ||
> +	    (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024,
> +				sizeof(u_int32_t), GFP_KERNEL)) == NULL ||
>  	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
>  				sizeof(*controls), GFP_KERNEL)) == NULL) {
>  		err = -ENOMEM;

I think this would be clearer as

	err = -ENOMEM;
	icode = kzalloc(sizeof(*icode), GFP_KERNEL)
	if (!icode)
		goto err;
	icode->gpr_map = (__user)kcalloc(512 + 256 + 256 + 2 * 1024,
					 sizeof(u_int32_t), GFP_KERNEL);
	if (!icode->gpr_map)
		goto err;
	controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
			    sizeof(*controls), GFP_KERNEL);
	if (!controls)
		goto err;




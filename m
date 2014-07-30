Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaG3IKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:10:34 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:40186 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaG3IKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:10:30 -0400
Message-ID: <1406707812.22788.3.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH] s390: net: claw.c:  Fix a define larger than in a
 sizeof in conjunction with strncpy
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 10:10:12 +0200
In-Reply-To: <1406461822-11249-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406461822-11249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1406461822-11249-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073008-5024-0000-0000-000000D6152D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 13:50 +0200, Rickard Strandqvist wrote:
> The MAX_NAME_LEN is larger than sizeof, which could potentially
> giving lots of error here.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/net/claw.c |   31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
> index d837c3c..0172ce8 100644
> --- a/drivers/s390/net/claw.c
> +++ b/drivers/s390/net/claw.c
> @@ -3068,12 +3068,15 @@ claw_hname_write(struct device *dev, struct device_attribute *attr,
>  	if (!priv)
>  		return -ENODEV;
>  	p_env = priv->p_env;
> -	if (count > MAX_NAME_LEN+1)
> +	if (count >= sizeof(p_env->host_name) && count > 0)
>  		return -EINVAL;
> -	memset(p_env->host_name, 0x20, MAX_NAME_LEN);
> +
>  	strncpy(p_env->host_name,buf, count);
> -	p_env->host_name[count-1] = 0x20;  /* clear extra 0x0a */
> -	p_env->host_name[MAX_NAME_LEN] = 0x00;
> +	/* clear extra 0x0a */
> +	memset(&p_env->host_name[count - 1],
> +			' ', sizeof(p_env->host_name) - count);
> +	p_env->host_name[sizeof(p_env->host_name) - 1] = '\0';
> +
>  	CLAW_DBF_TEXT(2, setup, "HstnSet");
>  	CLAW_DBF_TEXT_(2, setup, "%s", p_env->host_name);
> 
> @@ -3106,12 +3109,14 @@ claw_adname_write(struct device *dev, struct device_attribute *attr,
>  	if (!priv)
>  		return -ENODEV;
>  	p_env = priv->p_env;
> -	if (count > MAX_NAME_LEN+1)
> +	if (count >= sizeof(p_env->adapter_name) && count > 0)
>  		return -EINVAL;
> -	memset(p_env->adapter_name, 0x20, MAX_NAME_LEN);
> +
>  	strncpy(p_env->adapter_name,buf, count);
> -	p_env->adapter_name[count-1] = 0x20; /* clear extra 0x0a */
> -	p_env->adapter_name[MAX_NAME_LEN] = 0x00;
> +	/* clear extra 0x0a */
> +	memset(&p_env->adapter_name[count - 1],
> +			' ', sizeof(p_env->adapter_name) - count);
> +	p_env->adapter_name[sizeof(p_env->adapter_name) - 1] = '\0';
>  	CLAW_DBF_TEXT(2, setup, "AdnSet");
>  	CLAW_DBF_TEXT_(2, setup, "%s", p_env->adapter_name);
> 
> @@ -3145,12 +3150,14 @@ claw_apname_write(struct device *dev, struct device_attribute *attr,
>  	if (!priv)
>  		return -ENODEV;
>  	p_env = priv->p_env;
> -	if (count > MAX_NAME_LEN+1)
> +	if (count >= sizeof(p_env->api_type) && count > 0)
>  		return -EINVAL;
> -	memset(p_env->api_type, 0x20, MAX_NAME_LEN);
> +
>  	strncpy(p_env->api_type,buf, count);
> -	p_env->api_type[count-1] = 0x20;  /* we get a loose 0x0a */
> -	p_env->api_type[MAX_NAME_LEN] = 0x00;
> +	/* we get a loose 0x0a */
> +	memset(&p_env->api_type[count - 1],
> +			' ', sizeof(p_env->api_type) - count);
> +	p_env->api_type[sizeof(p_env->api_type) - 1] = '\0';
>  	if(strncmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
>  		p_env->read_size=DEF_PACK_BUFSIZE;
>  		p_env->write_size=DEF_PACK_BUFSIZE;

Why do you say "MAX_NAME_LEN is larger than sizeof"? MAX_NAME_LEN is 8,
and claw_env has defined its char arrays as ...[9]?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaGaHhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:37:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:57942 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbaGaHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:37:07 -0400
Message-ID: <1406792212.26163.4.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH] s390: net: claw.c:  Cleaning up possible error if
 incorrect in parameter
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 31 Jul 2014 09:36:52 +0200
In-Reply-To: <1406752372-19743-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406752372-19743-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073107-8372-0000-0000-000000B3DA93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 22:32 +0200, Rickard Strandqvist wrote:
> Possible error if incorrect in parameter, count = 0.
> And clarified what the code actually does significantly.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/net/claw.c |   24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
> index d837c3c..8d5b7b6 100644
> --- a/drivers/s390/net/claw.c
> +++ b/drivers/s390/net/claw.c
> @@ -3070,10 +3070,10 @@ claw_hname_write(struct device *dev, struct device_attribute *attr,
>  	p_env = priv->p_env;
>  	if (count > MAX_NAME_LEN+1)
>  		return -EINVAL;
> -	memset(p_env->host_name, 0x20, MAX_NAME_LEN);
> -	strncpy(p_env->host_name,buf, count);
> -	p_env->host_name[count-1] = 0x20;  /* clear extra 0x0a */
> -	p_env->host_name[MAX_NAME_LEN] = 0x00;
> +	strlcpy(p_env->host_name, buf,
> +			sizeof(p_env->host_name));
> +	strlcat(p_env->host_name, "        ",
> +			sizeof(p_env->host_name));
>  	CLAW_DBF_TEXT(2, setup, "HstnSet");
>  	CLAW_DBF_TEXT_(2, setup, "%s", p_env->host_name);
> 
> @@ -3108,10 +3108,10 @@ claw_adname_write(struct device *dev, struct device_attribute *attr,
>  	p_env = priv->p_env;
>  	if (count > MAX_NAME_LEN+1)
>  		return -EINVAL;
> -	memset(p_env->adapter_name, 0x20, MAX_NAME_LEN);
> -	strncpy(p_env->adapter_name,buf, count);
> -	p_env->adapter_name[count-1] = 0x20; /* clear extra 0x0a */
> -	p_env->adapter_name[MAX_NAME_LEN] = 0x00;
> +	strlcpy(p_env->adapter_name, buf,
> +			sizeof(p_env->adapter_name));
> +	strlcat(p_env->adapter_name, "        ",
> +			sizeof(p_env->adapter_name));
>  	CLAW_DBF_TEXT(2, setup, "AdnSet");
>  	CLAW_DBF_TEXT_(2, setup, "%s", p_env->adapter_name);
> 
> @@ -3147,10 +3147,10 @@ claw_apname_write(struct device *dev, struct device_attribute *attr,
>  	p_env = priv->p_env;
>  	if (count > MAX_NAME_LEN+1)
>  		return -EINVAL;
> -	memset(p_env->api_type, 0x20, MAX_NAME_LEN);
> -	strncpy(p_env->api_type,buf, count);
> -	p_env->api_type[count-1] = 0x20;  /* we get a loose 0x0a */
> -	p_env->api_type[MAX_NAME_LEN] = 0x00;
> +	strlcpy(p_env->api_type, buf,
> +			sizeof(p_env->api_type));
> +	strlcat(p_env->api_type, "        ",
> +			sizeof(p_env->api_type));
>  	if(strncmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
>  		p_env->read_size=DEF_PACK_BUFSIZE;
>  		p_env->write_size=DEF_PACK_BUFSIZE;

These functions are invoked when echoing something into a sysfs
attribute. The smallest count value possible here is 1, i.e. just a
linefeed.


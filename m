Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaD1Lfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:35:30 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:12063 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526AbaD1Lf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:35:28 -0400
Message-ID: <535E3CF7.9030609@bfs.de>
Date: Mon, 28 Apr 2014 13:35:19 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2 v2] staging: lustre: integer overflow in obd_ioctl_is_invalid()
References: <20140428105858.GA31925@mwanda>
In-Reply-To: <20140428105858.GA31925@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 28.04.2014 12:58, schrieb Dan Carpenter:
> The obd_ioctl_getdata() function caps "data->ioc_len" at
> OBD_MAX_IOCTL_BUFFER and then calls this obd_ioctl_is_invalid() to check
> that the other values inside data are valid.
> 
> There are several lengths inside data but when they are added together
> they must not be larger than "data->ioc_len".  The checks against
> "(data->ioc_inllen1 > (1<<30))" are supposed to ensure that the addition
> does not have an integer overflow.  But "(1<<30) * 4" actually can
> overflow 32 bits, so the checks are insufficient.
> 
> I have changed it to "> OBD_MAX_IOCTL_BUFFER" instead.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Updated the error messages as Walter Harms pointed out.
> 
> diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
> index bdc9812..3c26bbd 100644
> --- a/drivers/staging/lustre/lustre/include/lustre_lib.h
> +++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
> @@ -179,24 +179,25 @@ static inline int obd_ioctl_packlen(struct obd_ioctl_data *data)
>  
>  static inline int obd_ioctl_is_invalid(struct obd_ioctl_data *data)
>  {
> -	if (data->ioc_len > (1<<30)) {
> -		CERROR("OBD ioctl: ioc_len larger than 1<<30\n");
> +	if (data->ioc_len > OBD_MAX_IOCTL_BUFFER) {
> +		CERROR("OBD ioctl: ioc_len larger than %d\n",
> +		       OBD_MAX_IOCTL_BUFFER);
>  		return 1;
>  	}
> -	if (data->ioc_inllen1 > (1<<30)) {
> -		CERROR("OBD ioctl: ioc_inllen1 larger than 1<<30\n");
> +	if (data->ioc_inllen1 > OBD_MAX_IOCTL_BUFFER) {
> +		CERROR("OBD ioctl: ioc_inllen1 larger than ioc_len\n");
>  		return 1;
>  	}

The error mention ioc_len the compare is OBD_MAX_IOCTL_BUFFER ?
Is that intentional ?

re,
 wh

> -	if (data->ioc_inllen2 > (1<<30)) {
> -		CERROR("OBD ioctl: ioc_inllen2 larger than 1<<30\n");
> +	if (data->ioc_inllen2 > OBD_MAX_IOCTL_BUFFER) {
> +		CERROR("OBD ioctl: ioc_inllen2 larger than ioc_len\n");
>  		return 1;
>  	}
> -	if (data->ioc_inllen3 > (1<<30)) {
> -		CERROR("OBD ioctl: ioc_inllen3 larger than 1<<30\n");
> +	if (data->ioc_inllen3 > OBD_MAX_IOCTL_BUFFER) {
> +		CERROR("OBD ioctl: ioc_inllen3 larger than ioc_len\n");
>  		return 1;
>  	}
> -	if (data->ioc_inllen4 > (1<<30)) {
> -		CERROR("OBD ioctl: ioc_inllen4 larger than 1<<30\n");
> +	if (data->ioc_inllen4 > OBD_MAX_IOCTL_BUFFER) {
> +		CERROR("OBD ioctl: ioc_inllen4 larger than ioc_len\n");
>  		return 1;
>  	}
>  	if (data->ioc_inlbuf1 && !data->ioc_inllen1) {
> 

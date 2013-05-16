Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3EPRrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:47:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37939 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3EPRrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:47:01 -0400
Message-ID: <51951B92.1040102@acm.org>
Date: Thu, 16 May 2013 12:46:58 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: openipmi-developer@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipmi: ipmi_devintf: compat_ioctl method failes to take
 ipmi_mutex
References: <20130513193934.GA17394@kvack.org>
In-Reply-To: <20130513193934.GA17394@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right.  I've pulled this in to my tree.  Looking at this, 
ipmi_mutex really should go away and be replaced bu something that 
scales better, but I guess it's not that critical for IPMI.

-corey

On 05/13/2013 02:39 PM, Benjamin LaHaise wrote:
> When a 32 bit version of ipmitool is used on a 64 bit kernel, the
> ipmi_devintf code fails to correctly acquire ipmi_mutex.  This results in
> incomplete data being retrieved in some cases, or other possible failures.
> Add a wrapper around compat_ipmi_ioctl() to take ipmi_mutex to fix this.
> This is probably a candidate for -stable as well.
>
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> ---
>   drivers/char/ipmi/ipmi_devintf.c |   14 +++++++++++++-
>   1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index 9eb360f..d5a5f02 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -837,13 +837,25 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
>   		return ipmi_ioctl(filep, cmd, arg);
>   	}
>   }
> +
> +static long unlocked_compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
> +				       unsigned long arg)
> +{
> +	int ret;
> +
> +	mutex_lock(&ipmi_mutex);
> +	ret = compat_ipmi_ioctl(filep, cmd, arg);
> +	mutex_unlock(&ipmi_mutex);
> +
> +	return ret;
> +}
>   #endif
>   
>   static const struct file_operations ipmi_fops = {
>   	.owner		= THIS_MODULE,
>   	.unlocked_ioctl	= ipmi_unlocked_ioctl,
>   #ifdef CONFIG_COMPAT
> -	.compat_ioctl   = compat_ipmi_ioctl,
> +	.compat_ioctl   = unlocked_compat_ipmi_ioctl,
>   #endif
>   	.open		= ipmi_open,
>   	.release	= ipmi_release,


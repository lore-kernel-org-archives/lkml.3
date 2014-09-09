Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaIISVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:21:23 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54038 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaIISVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:21:22 -0400
Message-ID: <540F4520.9090308@mvista.com>
Date: Tue, 09 Sep 2014 13:21:20 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ipmi: work around gcc-4.9 build warning
References: <58708252.p9ogO3naVQ@wuerfel>
In-Reply-To: <58708252.p9ogO3naVQ@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd prefer to fix gcc, but I understand.  This change is probably better
in general, anyway.

Queued for 3.18.  Thanks.

-corey

On 08/23/2014 02:04 PM, Arnd Bergmann wrote:
> Building ipmi on arm with gcc-4.9 results in this warning
> for an allmodconfig build:
>
> drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_thread':
> include/linux/time.h:28:5: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   if (lhs->tv_sec > rhs->tv_sec)
>      ^
> drivers/char/ipmi/ipmi_si_intf.c:1007:18: note: 'busy_until.tv_sec' was declared here
>   struct timespec busy_until;
>                   ^
>
> The warning is bogus and this case can not occur. Apparently
> this is a false positive resulting from gcc getting a little
> smarter about tracking assignments but not smart enough. Marking
> the ipmi_thread_busy_wait function as inline gives the gcc
> optimization logic enough information to figure out for itself
> that the case cannot happen, which gets rid of the warning
> without adding any fake initialization.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 5d665680ae33..539ff0db52fc 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -965,9 +965,9 @@ static inline int ipmi_si_is_busy(struct timespec *ts)
>  	return ts->tv_nsec != -1;
>  }
>  
> -static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
> -				 const struct smi_info *smi_info,
> -				 struct timespec *busy_until)
> +static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
> +					const struct smi_info *smi_info,
> +					struct timespec *busy_until)
>  {
>  	unsigned int max_busy_us = 0;
>  
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


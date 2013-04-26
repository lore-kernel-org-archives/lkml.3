Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3DZIKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:10:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:8680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab3DZIKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,556,1363158000"; 
   d="scan'208";a="327786898"
Message-ID: <1366963839.2189.1.camel@rzhang1-mobl4>
Subject: Re: [PATCH 15/21] thermal: cooling: avoid uninitialied used gcc
 warning
From: Zhang Rui <rui.zhang@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Amit Daniel kachhap <amit.daniel@samsung.com>,
        eduardo <eduardo.valentin@ti.com>
Date: Fri, 26 Apr 2013 16:10:39 +0800
In-Reply-To: <1366910944-3033663-16-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	 <1366910944-3033663-16-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 19:28 +0200, Arnd Bergmann wrote:
> The newly rewritten get_property() function causes a bogus warning
> from gcc-3.8, which cannot figure out that "level" is always
> initialized at the point where it gets evaluated:
> 
> drivers/thermal/cpu_cooling.c: In function 'get_property':
> drivers/thermal/cpu_cooling.c:189:37: warning: 'level' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    if (property == GET_FREQ && level == j) {
>                                      ^
> 
> Slightly rearranging the code makes this more obvious and
> avoids the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Amit Daniel kachhap <amit.daniel@samsung.com>

we already have a fix for this.
please refer to
https://patchwork.kernel.org/patch/2454891/

thanks for your patch, Arnd!

-rui
> ---
>  drivers/thermal/cpu_cooling.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 768b508..34878e6 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -165,10 +165,6 @@ static int get_property(unsigned int cpu, unsigned long input,
>  		return 0;
>  	}
>  
> -	if (property == GET_FREQ)
> -		level = descend ? input : (max_level - input -1);
> -
> -
>  	for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>  		/* ignore invalid entry */
>  		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> @@ -186,10 +182,15 @@ static int get_property(unsigned int cpu, unsigned long input,
>  			*output = descend ? j : (max_level - j - 1);
>  			return 0;
>  		}
> -		if (property == GET_FREQ && level == j) {
> -			/* get frequency by level */
> -			*output = freq;
> -			return 0;
> +
> +		if (property == GET_FREQ) {
> +			level = descend ? input : (max_level - input -1);
> +
> +			if (level == j) {
> +				/* get frequency by level */
> +				*output = freq;
> +				return 0;
> +			}
>  		}
>  		j++;
>  	}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3DYUH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:07:58 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40650 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3DYUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <1366910944-3033663-16-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	<1366910944-3033663-16-git-send-email-arnd@arndb.de>
Date: Thu, 25 Apr 2013 16:07:56 -0400
Message-ID: <CAC-25o_bmrZZ9n10cBE=ewO7Yr+FmgP2JTYJNr1y=V_9BgcyXQ@mail.gmail.com>
Subject: Re: [PATCH 15/21] thermal: cooling: avoid uninitialied used gcc warning
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, Apr 25, 2013 at 1:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
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

Rui has merged a patch that removes this bogus compiler warning:
http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=4469b99743d296e24aefc5f8ed7df1bc9cfbbac8

Though, as not as elegant as your patch, it does the trick. :-)

> ---
>  drivers/thermal/cpu_cooling.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 768b508..34878e6 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -165,10 +165,6 @@ static int get_property(unsigned int cpu, unsigned long input,
>                 return 0;
>         }
>
> -       if (property == GET_FREQ)
> -               level = descend ? input : (max_level - input -1);
> -
> -
>         for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>                 /* ignore invalid entry */
>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> @@ -186,10 +182,15 @@ static int get_property(unsigned int cpu, unsigned long input,
>                         *output = descend ? j : (max_level - j - 1);
>                         return 0;
>                 }
> -               if (property == GET_FREQ && level == j) {
> -                       /* get frequency by level */
> -                       *output = freq;
> -                       return 0;
> +
> +               if (property == GET_FREQ) {
> +                       level = descend ? input : (max_level - input -1);
> +
> +                       if (level == j) {
> +                               /* get frequency by level */
> +                               *output = freq;
> +                               return 0;
> +                       }
>                 }
>                 j++;
>         }
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Eduardo Bezerra Valentin

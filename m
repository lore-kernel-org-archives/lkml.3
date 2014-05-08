Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaEHBzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:55:46 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34494 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaEHBzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <001501cf6a5c$07bc2520$17346f60$@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
	<CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
	<CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
	<CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
	<003e01cf6984$fb950280$f2bf0780$@samsung.com>
	<CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
	<CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
	<001501cf6a5c$07bc2520$17346f60$@samsung.com>
Date: Wed, 7 May 2014 20:55:41 -0500
X-Google-Sender-Auth: DijhU0DCEoBKo5fz4j9IG39TMEs
Message-ID: <CAGo_u6rAY1Cqh6_1RPsjGMwqNSVr=yW+VgyXfEjA6V+LT-SMcQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Nishanth Menon <nm@ti.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 8:22 PM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
>> @Jonghwan: Please consider doing this:
>> - Don't play with the order of frequencies in table.
>> - Instead initialize .driver_data filed with values that you need to write
>> in the registers for all frequencies. i.e. 0 for highest frequency and
>> FREQ_COUNT-1 for lowest one.
>
> -> For that, I changed like this.
> For initializing .driver_data, I changed dev_pm_opp_init_cpufreq_table function().
>
>
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -622,12 +622,12 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
>   * or in contexts where mutex locking cannot be used.
>   */
>  int dev_pm_opp_init_cpufreq_table(struct device *dev,
> -                           struct cpufreq_frequency_table **table)
> +               struct cpufreq_frequency_table **table, int order)
>  {
>         struct device_opp *dev_opp;
>         struct dev_pm_opp *opp;
>         struct cpufreq_frequency_table *freq_table;
> -       int i = 0;
> +       int i = 0, index = 0;
>
>         /* Pretend as if I am an updater */
>         mutex_lock(&dev_opp_list_lock);
> @@ -649,16 +649,22 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
>                 return -ENOMEM;
>         }
>
> +       if (OPP_TABLE_ORDER_DESCENDING == order)
> +               index = dev_pm_opp_get_opp_count(dev) - 1;
> +
>         list_for_each_entry(opp, &dev_opp->opp_list, node) {
>                 if (opp->available) {
> -                       freq_table[i].driver_data = i;
> +                       if (OPP_TABLE_ORDER_DESCENDING == order)
> +                               freq_table[i].driver_data = index--;
> +                       else
> +                               freq_table[i].driver_data = index++;
>                         freq_table[i].frequency = opp->rate / 1000;
>                         i++;
>                 }
>         }
>         mutex_unlock(&dev_opp_list_lock);
>
> -       freq_table[i].driver_data = i;
> +       freq_table[i].driver_data = index;
>         freq_table[i].frequency = CPUFREQ_TABLE_END;
>
>         *table = &freq_table[0];
>
>
> Is it acceptiable?

Personally, I feel that filling up driver_data should be left to the
driver(caller of dev_pm_opp_init_cpufreq_table). for example providing
a function pointer which decides what that value should be (be it
index or some magical register value).. Viresh might have better
opinions.

Regards,
Nishanth Menon

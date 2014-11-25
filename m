Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaKYIsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:48:36 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:52597 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaKYIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqE_qhrRs3X9s9juyPH_Zcq8vdE_amqKM3VUnMjHtL2Rg@mail.gmail.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-7-git-send-email-amit.daniel@samsung.com>
	<CAPDyKFqE_qhrRs3X9s9juyPH_Zcq8vdE_amqKM3VUnMjHtL2Rg@mail.gmail.com>
Date: Tue, 25 Nov 2014 14:18:33 +0530
X-Google-Sender-Auth: FgSx7LKmMaWH7RiEDqY5NjTQhE0
Message-ID: <CADGdYn6fAScrpz4Va=THtC1ZgT+rYN_gQuE6NnRaCiN4NErg5g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 07/12] PM / Domains: export pm_genpd_lookup_name
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 1:05 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 24 November 2014 at 14:04, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> This API may be needed to set the power domain parent/child relationship
>> in the power domain platform driver. The parent relationship is
>> generally set after the child power domain is registered with the power
>> domain subsystem. In this case, pm_genpd_lookup_name API might be
>> useful.
>
> I think this is a step in the wrong direction. Instead we should be
> working on removing the "name" based APIs from genpd.
>
> The proper way should be to pass the PM domain as a parameter to the
> APIs instead.
Yes i understand but i had a special requirement for using this API
during pd probe.
 I cannot use hierarchy to represent parent/child pd nodes as it will
break the existing SoC's. In my case all the PD nodes are linear. The
parent/child relationship are established in the second pass after all
the PD entries are registered with the help of this API.
Although there a way that i can always keep parent PD's before the
child PD's in DT in linear order. Will check this approach.

Regards,
Amit
>
> Kind regards
> Uffe
>
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/base/power/domain.c |    3 ++-
>>  include/linux/pm_domain.h   |    7 +++++++
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
>> index fb83d4a..b0e1c2f 100644
>> --- a/drivers/base/power/domain.c
>> +++ b/drivers/base/power/domain.c
>> @@ -49,7 +49,7 @@
>>  static LIST_HEAD(gpd_list);
>>  static DEFINE_MUTEX(gpd_list_lock);
>>
>> -static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
>> +struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
>>  {
>>         struct generic_pm_domain *genpd = NULL, *gpd;
>>
>> @@ -66,6 +66,7 @@ static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
>>         mutex_unlock(&gpd_list_lock);
>>         return genpd;
>>  }
>> +EXPORT_SYMBOL_GPL(pm_genpd_lookup_name);
>>
>>  struct generic_pm_domain *dev_to_genpd(struct device *dev)
>>  {
>> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
>> index 2e0e06d..aedcec3 100644
>> --- a/include/linux/pm_domain.h
>> +++ b/include/linux/pm_domain.h
>> @@ -150,6 +150,8 @@ extern int pm_genpd_name_poweron(const char *domain_name);
>>
>>  extern struct dev_power_governor simple_qos_governor;
>>  extern struct dev_power_governor pm_domain_always_on_gov;
>> +
>> +extern struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name);
>>  #else
>>
>>  static inline struct generic_pm_domain_data *dev_gpd_data(struct device *dev)
>> @@ -221,6 +223,11 @@ static inline int pm_genpd_name_poweron(const char *domain_name)
>>  {
>>         return -ENOSYS;
>>  }
>> +static inline
>> +struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
>> +{
>> +       return NULL;
>> +}
>>  #define simple_qos_governor NULL
>>  #define pm_domain_always_on_gov NULL
>>  #endif
>> --
>> 1.7.9.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

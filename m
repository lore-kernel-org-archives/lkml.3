Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDOF4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:56:09 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40224 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaDOF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <534C4EC2.5080008@semaphore.gr>
References: <534C4EC2.5080008@semaphore.gr>
Date: Tue, 15 Apr 2014 11:26:06 +0530
Message-ID: <CAKohpon0twCA1gNdOQ1FyUO3wmtxZsddv+Y3Xmo9Me07PXEa-A@mail.gmail.com>
Subject: Re: [PATCH 14/20] thermal: cpu_cooling: Use cpufreq_for_each_valid_entry
 macro for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:40, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> The cpufreq core supports the cpufreq_for_each_valid_entry macro
> helper for iteration over the cpufreq_frequency_table, so use it.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/thermal/cpu_cooling.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 4246262..3040629 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -144,11 +144,11 @@ static int get_property(unsigned int cpu, unsigned long input,
>                         unsigned int *output,
>                         enum cpufreq_cooling_property property)
>  {
> -       int i, j;
> +       int i;
>         unsigned long max_level = 0, level = 0;
>         unsigned int freq = CPUFREQ_ENTRY_INVALID;
>         int descend = -1;
> -       struct cpufreq_frequency_table *table =
> +       struct cpufreq_frequency_table *pos, *table =
>                                         cpufreq_frequency_get_table(cpu);
>
>         if (!output)
> @@ -157,20 +157,16 @@ static int get_property(unsigned int cpu, unsigned long input,
>         if (!table)
>                 return -EINVAL;
>
> -       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
> -               /* ignore invalid entries */
> -               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> -                       continue;
> -
> +       cpufreq_for_each_valid_entry(pos, table) {
>                 /* ignore duplicate entry */
> -               if (freq == table[i].frequency)
> +               if (freq == pos->frequency)
>                         continue;
>
>                 /* get the frequency order */
>                 if (freq != CPUFREQ_ENTRY_INVALID && descend == -1)
> -                       descend = !!(freq > table[i].frequency);
> +                       descend = !!(freq > pos->frequency);

drop !! as well, its not required here. Mention that in log.

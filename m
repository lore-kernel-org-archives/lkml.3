Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaHYNlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:41:42 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51768 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaHYNli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <53F589C3.4050504@huawei.com>
References: <53F589C3.4050504@huawei.com>
Date: Mon, 25 Aug 2014 19:11:37 +0530
Message-ID: <CAKohpo=HbdDo1RsYt4brs9VVj3g61FVwOT2F-e37M6hu=vqfaQ@mail.gmail.com>
Subject: Re: [RESEND PATCH] acpi-cpufreq: get the cur_freq from
 acpi_processor_performance states
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wang Weidong <wangweidong1@huawei.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> linux-kernel@vger.kernel.org" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 11:25, Wang Weidong <wangweidong1@huawei.com> wrote:
> As the initialized freq_tables maybe different from the p-states
> values, so the array index is different as well.
>
> p-states value: [2400 2400 2000 ...], while the freq_tables:
> [2400 2000 ... CPUFREQ_TABLE_END]. After setted the freqs 2000,
> the perf->state is 3 while the freqs_table's index should be 2.
> So when call the get_cur_freq_on_cpu, the freqs value we get
> is 2400.
>
> So, fix the problem with the correct tables.
>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>  drivers/cpufreq/acpi-cpufreq.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index b0c18ed..ac93885 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -365,6 +365,7 @@ static u32 get_cur_val(const struct cpumask *mask)
>  static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
>  {
>         struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
> +       struct acpi_processor_performance *perf;
>         unsigned int freq;
>         unsigned int cached_freq;
>
> @@ -375,7 +376,8 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
>                 return 0;
>         }
>
> -       cached_freq = data->freq_table[data->acpi_data->state].frequency;
> +       perf = data->acpi_data;
> +       cached_freq = perf->states[perf->state].core_frequency * 1000;
>         freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
>         if (freq != cached_freq) {
>                 /*

The problem looks real but I am not very well aware of this driver and
so it would
be more appropriate if Rafael replies/Applies..

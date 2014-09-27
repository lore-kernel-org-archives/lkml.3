Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaI0Tlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:41:55 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55987 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751828AbaI0Tlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:41:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wang Weidong <wangweidong1@huawei.com>
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] acpi-cpufreq: get the cur_freq from acpi_processor_performance states
Date: Sat, 27 Sep 2014 22:01:46 +0200
Message-ID: <2361937.mQR3H5xj3F@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54264C0B.1000607@huawei.com>
References: <53F589C3.4050504@huawei.com> <2075276.PKjjuvNeys@vostro.rjw.lan> <54264C0B.1000607@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2014 01:32:59 PM Wang Weidong wrote:
> On 2014/9/27 7:21, Rafael J. Wysocki wrote:
> > On Thursday, August 21, 2014 01:55:15 PM Wang Weidong wrote:
> >> As the initialized freq_tables maybe different from the p-states
> >> values, so the array index is different as well.
> >>
> >> p-states value: [2400 2400 2000 ...], while the freq_tables:
> >> [2400 2000 ... CPUFREQ_TABLE_END]. After setted the freqs 2000,
> >> the perf->state is 3 while the freqs_table's index should be 2.
> >> So when call the get_cur_freq_on_cpu, the freqs value we get
> >> is 2400.
> >>
> >> So, fix the problem with the correct tables.
> > 
> > What you're saying is basically that freq_table and perf->states
> > diverge at one point.  Shouldn't we re-generate freq_table in that
> > case instead of fixing up get_cur_freq_on_cpu() only in a quite
> > indirect way? 
> > 
> Hi Rafael,
> 
> Thanks for your reply.
> 
> You mean that we should re-generate the freq_table in that case?
> Could we fix the table init like this:
> 
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -779,7 +779,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
> 
>         /* table init */
>         for (i = 0; i < perf->state_count; i++) {
> -               if (i > 0 && perf->states[i].core_frequency >=
> +               if (i > 0 && perf->states[i].core_frequency >
>                     data->freq_table[valid_states-1].frequency / 1000)
>                         continue;
> 
> when the value is same, we just keep the value into the freq_table.

That would only be OK if it is guaranteed that the set of available
states hasn't changed, which I'm not sure is the case.

Rafael


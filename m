Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaDUVuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:50:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53175 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754455AbaDUVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:50:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/8] cpufreq: Introduce macros for cpufreq_frequency_table iteration
Date: Tue, 22 Apr 2014 00:06:39 +0200
Message-ID: <26900651.DzFuLa6PAS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <534E2B44.7090008@semaphore.gr>
References: <534E2B44.7090008@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 10:03:32 AM Stratos Karafotis wrote:
> Many cpufreq drivers need to iterate over the cpufreq_frequency_table
> for various tasks.
> 
> This patch introduces two macros which can be used for iteration over
> cpufreq_frequency_table keeping a common coding style across drivers:
> 
> - cpufreq_for_each_entry: iterate over each entry of the table
> - cpufreq_for_each_valid_entry: iterate over each entry that contains
> a valid frequency.
> 
> It should have no functional changes.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Can you please resend the entire series as v4 so that it is clear which version
of each patch is the current one?

> ---
> 
> Changes v2 -> v3
> 	- Better formatting in Documentation
> 	- Fix spell error in comments
> 
>  Documentation/cpu-freq/cpu-drivers.txt | 19 +++++++++++++++++++
>  drivers/cpufreq/cpufreq.c              | 11 +++++++++++
>  include/linux/cpufreq.h                | 21 +++++++++++++++++++++
>  3 files changed, 51 insertions(+)
> 
> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
> index 48da5fd..b045fe5 100644
> --- a/Documentation/cpu-freq/cpu-drivers.txt
> +++ b/Documentation/cpu-freq/cpu-drivers.txt
> @@ -228,3 +228,22 @@ is the corresponding frequency table helper for the ->target
>  stage. Just pass the values to this function, and the unsigned int
>  index returns the number of the frequency table entry which contains
>  the frequency the CPU shall be set to.
> +
> +The following macros can be used as iterators over cpufreq_frequency_table:
> +
> +cpufreq_for_each_entry(pos, table) - iterates over all entries of frequency
> +table.
> +
> +cpufreq-for_each_valid_entry(pos, table) - iterates over all entries,
> +excluding CPUFREQ_ENTRY_INVALID frequencies.
> +Use arguments "pos" - a cpufreq_frequency_table * as a loop cursor and
> +"table" - the cpufreq_frequency_table * you want to iterate over.
> +
> +For example:
> +
> +	struct cpufreq_frequency_table *pos, *driver_freq_table;
> +
> +	cpufreq_for_each_entry(pos, driver_freq_table) {
> +		/* Do something with pos */
> +		pos->frequency = ...
> +	}
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index abda660..a517da9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -237,6 +237,17 @@ void cpufreq_cpu_put(struct cpufreq_policy *policy)
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
>  
> +bool cpufreq_next_valid(struct cpufreq_frequency_table **pos)
> +{
> +	while ((*pos)->frequency != CPUFREQ_TABLE_END)
> +		if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
> +			return true;
> +		else
> +			(*pos)++;
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_next_valid);
> +
>  /*********************************************************************
>   *            EXTERNALLY AFFECTING FREQUENCY CHANGES                 *
>   *********************************************************************/
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 5ae5100..77a5fa1 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -468,6 +468,27 @@ struct cpufreq_frequency_table {
>  				    * order */
>  };
>  
> +bool cpufreq_next_valid(struct cpufreq_frequency_table **pos);
> +
> +/*
> + * cpufreq_for_each_entry -	iterate over a cpufreq_frequency_table
> + * @pos:	the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:	the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_entry(pos, table)	\
> +	for (pos = table; pos->frequency != CPUFREQ_TABLE_END; pos++)
> +
> +/*
> + * cpufreq_for_each_valid_entry -     iterate over a cpufreq_frequency_table
> + *	excluding CPUFREQ_ENTRY_INVALID frequencies.
> + * @pos:        the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:      the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_valid_entry(pos, table)	\
> +	for (pos = table; cpufreq_next_valid(&pos); pos++)
> +
>  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>  				    struct cpufreq_frequency_table *table);
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

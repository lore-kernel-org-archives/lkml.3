Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3GOCrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:47:07 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49198 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3GOCrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:47:04 -0400
Message-ID: <51E3629D.1070807@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 10:46:53 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com> <1575632.O15l1yqZOt@vostro.rjw.lan>
In-Reply-To: <1575632.O15l1yqZOt@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071502-4790-0000-0000-00000942E067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 11:56 PM, Rafael J. Wysocki wrote:
[snip]
>> +
>> +	/*
>> +	 * Since there is no lock to prvent re-queue the
>> +	 * cancelled work, some early cancelled work might
>> +	 * have been queued again by later cancelled work.
>> +	 *
>> +	 * Flush the work again with dbs_data->queue_stop
>> +	 * enabled, this time there will be no survivors.
>> +	 */
>> +	if (round)
>> +		goto redo;
> 
> Well, what about doing:
> 
> 	for (round = 2; round; round--)
> 	  	for_each_cpu(i, policy->cpus) {
> 	  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
> 	  		cancel_delayed_work_sync(&cdbs->work);
> 	  	}
> 
> instead?
> 

It could works, while I was a little dislike to use nested 'for' logical...

Anyway, seems like we have not solved the issue yet, so let's put these
down and focus on the fix firstly ;-)

Regards,
Michael Wang

>> +	dbs_data->queue_stop = 0;
>>  }
>>  
>>  /* Will return if we need to evaluate cpu load again or not */
>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
>> index e16a961..9116135 100644
>> --- a/drivers/cpufreq/cpufreq_governor.h
>> +++ b/drivers/cpufreq/cpufreq_governor.h
>> @@ -213,6 +213,7 @@ struct dbs_data {
>>  	unsigned int min_sampling_rate;
>>  	int usage_count;
>>  	void *tuners;
>> +	int queue_stop;
>>  
>>  	/* dbs_mutex protects dbs_enable in governor start/stop */
>>  	struct mutex mutex;
>>
> 
> 


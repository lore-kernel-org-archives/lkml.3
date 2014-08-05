Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbaHEJbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:31:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:17604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbaHEJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:31:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="553896436"
Message-ID: <53E0A3D4.7020100@intel.com>
Date: Tue, 05 Aug 2014 17:28:52 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, jan.kiszka@siemens.com,
        mingo@kernel.org, huawei.libin@huawei.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com> <20140805084135.GB18234@pd.tnic>
In-Reply-To: <20140805084135.GB18234@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月05日 16:41, Borislav Petkov wrote:
> On Mon, Aug 04, 2014 at 04:59:02PM +0800, Lan Tianyu wrote:
>> Some test result shows cpu offline consumes more than 100ms during S3.
>> After some researchs, found native_cpu_die() would fall into 100ms
>> sleep if cpu idle loop thread marked cpu state slower. What native_cpu_die()
>> does is that poll cpu state and wait for 100ms if cpu state hasn't been marked
>> to DEAD. The 100ms sleep doesn't make sense. To avoid such long sleep, this
>> patch is to add struct completion to each cpu, wait for the completion
>> in the native_cpu_die() and wakeup the completion when the cpu state is
>> marked to DEAD.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  arch/x86/kernel/smpboot.c | 26 ++++++++++++++------------
>>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> ...
> 
>> @@ -1339,18 +1342,16 @@ int native_cpu_disable(void)
>>  void native_cpu_die(unsigned int cpu)
>>  {
>>  	/* We don't do anything here: idle task is faking death itself. */
>> -	unsigned int i;
>> +	wait_for_completion_timeout(&per_cpu(die_complete, cpu),
>> +			msecs_to_jiffies(1000));
> 
> One more thing peterz suggested. Just do:
> 
> 	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
> 
> because HZ is the number of jiffies in a second. Which is what you want
> here.
> 

Yes, that looks better. I will update.


-- 
Best regards
Tianyu Lan

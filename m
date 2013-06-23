Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3FWS7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 14:59:10 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39184 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3FWS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 14:59:06 -0400
Message-ID: <51C744A9.8000406@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 00:25:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, ddaney@caviumnetworks.com
Subject: Re: [PATCH 25/45] staging/octeon: Use get/put_online_cpus_atomic()
 to prevent CPU offline
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623134331.19094.80396.stgit@srivatsabhat.in.ibm.com> <20130623181740.GB24256@kroah.com>
In-Reply-To: <20130623181740.GB24256@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062318-0260-0000-0000-000003342980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 11:47 PM, Greg Kroah-Hartman wrote:
> On Sun, Jun 23, 2013 at 07:13:33PM +0530, Srivatsa S. Bhat wrote:
>> Once stop_machine() is gone from the CPU offline path, we won't be able
>> to depend on disabling preemption to prevent CPUs from going offline
>> from under us.
>>
>> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
>> offline, while invoking from atomic context.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: devel@driverdev.osuosl.org
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/staging/octeon/ethernet-rx.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
>> index 34afc16..8588b4d 100644
>> --- a/drivers/staging/octeon/ethernet-rx.c
>> +++ b/drivers/staging/octeon/ethernet-rx.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/prefetch.h>
>>  #include <linux/ratelimit.h>
>>  #include <linux/smp.h>
>> +#include <linux/cpu.h>
>>  #include <linux/interrupt.h>
>>  #include <net/dst.h>
>>  #ifdef CONFIG_XFRM
>> @@ -97,6 +98,7 @@ static void cvm_oct_enable_one_cpu(void)
>>  		return;
>>  
>>  	/* ... if a CPU is available, Turn on NAPI polling for that CPU.  */
>> +	get_online_cpus_atomic();
>>  	for_each_online_cpu(cpu) {
>>  		if (!cpu_test_and_set(cpu, core_state.cpu_state)) {
>>  			v = smp_call_function_single(cpu, cvm_oct_enable_napi,
>> @@ -106,6 +108,7 @@ static void cvm_oct_enable_one_cpu(void)
>>  			break;
>>  		}
>>  	}
>> +	put_online_cpus_atomic();
> 
> Does this driver really need to be doing this in the first place?  If
> so, why?  The majority of network drivers don't, why is this one
> "special"?
> 

Honestly, I don't know. Let's CC the author of that code (David Daney).
I wonder why get_maintainer.pl didn't generate his name for this file,
even though the entire file is almost made up of his commits alone!

Regards,
Srivatsa S. Bhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3GIAdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:33:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7749 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIAda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:33:30 -0400
X-Spam-Score: -100.8
Message-ID: <51DB5A22.9080307@asianux.com>
Date: Tue, 09 Jul 2013 08:32:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/smp.c: free related resources when failure occurs
 in hotplug_cfd()
References: <51DA7D50.8010209@asianux.com> <20130709002830.GA2071@udknight>
In-Reply-To: <20130709002830.GA2071@udknight>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 08:28 AM, Wang YanQing wrote:
> On Mon, Jul 08, 2013 at 04:50:24PM +0800, Chen Gang wrote:
>> > When failure occurs in hotplug_cfd(), need release related resources,
>> > or will cause memory leak.
>> > 
>> > Also beautify the related code.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/smp.c |   13 +++++++++----
>> >  1 files changed, 9 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/kernel/smp.c b/kernel/smp.c
>> > index 02a885d..c264623 100644
>> > --- a/kernel/smp.c
>> > +++ b/kernel/smp.c
>> > @@ -45,15 +45,20 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>> >  	switch (action) {
>> >  	case CPU_UP_PREPARE:
>> >  	case CPU_UP_PREPARE_FROZEN:
>> > -		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
>> > -				cpu_to_node(cpu)))
>> > +		if (!zalloc_cpumask_var_node(&cfd->cpumask,
>> > +						GFP_KERNEL, cpu_to_node(cpu)))
>> >  			return notifier_from_errno(-ENOMEM);
> What did you fixed here? code style?
> You can drop this part.
> 

Yes, I should drop.

>> > -		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
>> > -				cpu_to_node(cpu)))
>> > +
>> > +		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi,
>> > +						GFP_KERNEL, cpu_to_node(cpu))) {
>> > +			free_cpumask_var(cfd->cpumask);
>> >  			return notifier_from_errno(-ENOMEM);
>> > +		}
>> > +
>> >  		cfd->csd = alloc_percpu(struct call_single_data);
>> >  		if (!cfd->csd) {
>> >  			free_cpumask_var(cfd->cpumask);
>> > +			free_cpumask_var(cfd->cpumask_ipi);
>> >  			return notifier_from_errno(-ENOMEM);
>> >  		}
>> >  		break;
> Yes, we need this fix.
> 
> If you resend the v2, I will give acked-by :)

Thanks.
-- 
Chen Gang

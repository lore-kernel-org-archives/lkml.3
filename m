Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3EQTx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:53:26 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59167 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab3EQTxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:53:24 -0400
Message-ID: <519689F2.5070207@linux.vnet.ibm.com>
Date: Sat, 18 May 2013 01:20:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Olivier Doucet <webmaster@ajeux.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: Performance issue since 3.2.6
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <18379918.sbmR7uiKVn@vostro.rjw.lan> <CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com> <2048745.M7CAe2g1gj@vostro.rjw.lan> <CAPPqfY2hrd54viFHKErWk_8uRLHP9WK54G0inJtyUFJKKunDOg@mail.gmail.com> <CAPPqfY3+e3tVQA_RKn0DhwModLienrgtFzsUrCCsUndbJfnHOg@mail.gmail.com> <CAPPqfY2ba5M27omZBwe0h26Eutyd+2KkLXht6uLN5VdjEKT_Ug@mail.gmail.com>
In-Reply-To: <CAPPqfY2ba5M27omZBwe0h26Eutyd+2KkLXht6uLN5VdjEKT_Ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051719-0260-0000-0000-0000030478D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 11:47 PM, Olivier Doucet wrote:
> Hello,
> 
> This performance penalty is still present in kernel 3.9.2. And
> CONFIG_PM cannot be deactivated anymore.
> 
> I was able to make a working 3.9.2 (meaning with no penalty)  with
> following config and patch :
> CONFIG_PM=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_CPU_IDLE=y
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCESSOR=y
> 
> Patch : https://gist.github.com/odoucet/5600630
> 
> I know this patch is not perfect because it is just equivalent to
> rollback commit f51d67a64f32cd81ea8b67ca964fb7cf7e783b2e ;
> 
> I really want this to be fixed in kernel, so I would be glad to test
> any patch / config file you want.
>

I went through your previous mails and here is what I think:
I think this is not a regression that needs to be fixed. Instead it
occurs to me that you started depending on the _flaw_ introduced by
commit e8db0be124 (PM QoS: Move and rename the implementation files).

Your requirement is very simple: you don't want CPUs to go to deep
idle states, since your benchmark is very performance critical.

Commit e8db0be124 made the mistake of returning 0 in pm_qos_request()
when CONFIG_PM was unset. And that has the effect of disabling deeper
idle states, which is exactly what you wanted.

But, as noted by commit d020283d (PM / QoS: CPU C-state breakage with
PM Qos change), this is quite a bit wrong, because it makes the system
consume a *lot* of CPU power, because the CPUs never go to idle states
and instead keep polling.

Now, you might ask why is it wrong to set the default value to 0
(IOW, disable deep idle states) when CONFIG_PM is unset? Again, commit
d020283d answers that indirectly - not every power-management
configuration falls under CONFIG_PM, like CONFIG_CPU_IDLE,
CONFIG_INTEL_IDLE etc. So we need a sane default for pm_qos_request()
when CONFIG_PM is unset, to prevent the power usage from shooting
through the roof and surprising the user.

You started your comparisons with 3.2.0 which had commit e8db0be124
included. If you had tried any previous kernel, I'm pretty sure that
you would have found "performance penalties" too.

So, to summarize my thoughts:
 - IMHO there is no regression here, you just depended on a bug included
   in 3.2.0 (which made it behave like idle=poll with CONFIG_PM=n) and
   started your comparisons from there. The later kernels (3.2.6+) got
   that bug fixed which is why you saw "performance drops".

 - As much as we would like to do it, we can't set the value of
   PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE to 0 when CONFIG_PM=n, because
   CONFIG_PM doesn't encompass all power-management features (which is
   a pity). Doing that would need a big overhaul of all the relevant
   Kconfigs, which might or might not be worth the effort. (Because, who
   says that CONFIG_PM=n kernels are supposed to eat power like crazy??)

So here is my suggestion - use the interfaces provided by the kernel to
fix your problem:
   - you can give idle=poll in the kernel command line,
   - OR you can echo 0 > /dev/cpu_dma_latency

Irrespective of your kernel configuration options (CONFIG_PM=y/n), the
CPUs will not enter deep idle states, giving you the performance
improvement that you are looking for.

Regards,
Srivatsa S. Bhat

> 
> 2013/2/12 Olivier Doucet <webmaster@ajeux.com>
>>
>> Hello,
>>
>> A quick update on my latest tests :
>> I was able to compile a working 3.7.1 kernel (by 'working', I mean
>> with no performance penalty). I'm sure 3.7.7 will be OK also (do you
>> want me to test latest RC of 3.8 ?)
>>
>> I had to disable CONFIG_ACPI_PROCESSOR to disable power management.
>> So now these two options are unset :
>> CONFIG_CPU_IDLE
>> CONFIG_ACPI_PROCESSOR
>>
>> I've posted the whole .config file here :
>> https://gist.github.com/odoucet/4773390
>>
>> I'll be glad to test any patch that may help reactivate PM on my
>> system (CPU Intel Xeon L5630)
>>
>> Olivier


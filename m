Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBYH7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:59:12 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51942 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaBYH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:59:09 -0500
Message-ID: <530C4D57.1030905@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 13:29:19 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Olof Johansson <olof@lixom.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: warn users of smt-snooze-delay that the API
 isn't there anymore
References: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022507-0260-0000-0000-0000046B3C48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 05:44 AM, Cody P Schafer wrote:
> /sys/devices/system/cpu/cpu*/smt-snooze-delay was converted into a NOP
> in commit 3fa8cad82b94d0bed002571bd246f2299ffc876b, and now does
> nothing. Add a pr_warn() to convince any users that they should stop
> using it.
> 
> The commit message from the removing commit notes that this
> functionality should move into the cpuidle driver, essentially by
> adjusting target_residency to the specified value. At the moment,
> target_residency is not exposed by cpuidle's sysfs, so there isn't a
> drop in replacement for this.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>



smt-snooze-delay was used to delay an entry into NAP state
or disable NAP state completely. This was before we adopted cpuidle
framework for idle state management on powerpc. This is per-cpu based
tunable, where we could have cores with  different target residencies
and idle states.

Now that we have moved towards cpuidle framework, which provides a
better way of idle state management and this framework expects a single
target residency for all the cpus. We can no longer honour
smt-snooze-delay functionality of providing per-cpu target residency.
This was badly broken in the kernel before the patch to clean it up.
By removing this we would honour cpuidle framework through which we
carry out idle state management.

And generic cpuidle framework does not provide the flexibility to change
target residency on the go as there are multiple idle states supported
and trying to change target residency of one state (incorrectly) may
result in undefined behavior.

Also, the second functionality to disable/enable states can be done
using the cpuidle sysfs files. So this is functionality is preserved.

We currently do not use smt-snooze-delay in the kernel.
The sysfs entries needs to  be retained until we do a clean up ppc64_cpu
util that uses these entries to determine SMT,
clean up patch for this has already been posted out by Prerna.
Once, we have the ppc64_cpu changes in, we can look to clean up these
parts from the kernel.

Regards,
Deepthi





> ---
>  arch/powerpc/kernel/sysfs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> index 97e1dc9..84097b4 100644
> --- a/arch/powerpc/kernel/sysfs.c
> +++ b/arch/powerpc/kernel/sysfs.c
> @@ -50,6 +50,9 @@ static ssize_t store_smt_snooze_delay(struct device *dev,
>  	if (ret != 1)
>  		return -EINVAL;
>  
> +	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
> +		  current->comm, task_pid_nr(current), cpu->dev.id);
> +
>  	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
>  	return count;
>  }
> @@ -60,6 +63,9 @@ static ssize_t show_smt_snooze_delay(struct device *dev,
>  {
>  	struct cpu *cpu = container_of(dev, struct cpu, dev);
>  
> +	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
> +		  current->comm, task_pid_nr(current), cpu->dev.id);
> +
>  	return sprintf(buf, "%ld\n", per_cpu(smt_snooze_delay, cpu->dev.id));
>  }
>  
> 


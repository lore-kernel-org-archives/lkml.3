Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaGKK7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:59:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60530 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaGKK7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:59:30 -0400
Date: Fri, 11 Jul 2014 12:59:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Igor Mammedov <imammedo@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, toshi.kani@hp.com,
        huawei.libin@huawei.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        umgwanakikbuti@gmail.com, peterz@infradead.org
Subject: Re: [PATCH] x86,cpu-hotplug: assign same CPU number to readded CPU
Message-ID: <20140711105920.GC17083@pd.tnic>
References: <53BE51CE.40208@jp.fujitsu.com>
 <20140710112609.0b0eb294@nial.usersys.redhat.com>
 <53BF345B.8000107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53BF345B.8000107@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 09:48:27AM +0900, Yasuaki Ishimatsu wrote:
> >>+static int get_cpuid(int apicid)

Btw this "cpuid" is misleading. Call it "cpu_num" or so.

> >>+{
> >>+	int cpuid;
> >>+
> >>+	cpuid = apicid_to_cpuid[apicid];
> >>+	if (cpuid < 0)
> >>+		cpuid = cpumask_next_zero(-1, cpu_used_mask);
> >Why do you need additional cpu bitmask?
> 
> To assing new CPU number, I prepared new cpu bitmask.
> 
> The following two steps are necessary to assign CPU number to APIC ID.
>  1. Check whether APIC ID has been assigned CPU number
>  2. Assign new CPU number if ACPI ID has not been assigned CPU number (it
>     means apicid_to_cpuid[] returns -1)
> 
> Step 1. is checked by apicid_to_cpuid[]. And step 2. assigns new CPU
> number by using cpu_used_mask.
> 
> To keep cpu number, cpumask must not be cleared by hot removing CPU.
> If cpumask is cleared by hot removing CPU, the cpumask cannot be used
> to keep CPU number.
> 
> Currently, cpu_present_map is used to assign CPU number. But the cpumask
> is cleared by hot removing CPU since the mask is prepared to remember
> existed CPUs in the system. So the cpu_present_map must be cleared
> at CPU hot remove.
> 
> I confirmed whether present cpumasks (cpu_possible_map, cpu_online_map
> et al) is usable or not for this purpose. But there is no cpumask that
> can be used to keep CPU number. So I prepared new cpu bitmask.
> 
> >How about just finding the first apicid_to_cpuid[apicid] < 0
> >and dropping not needed anymore bitmask.
> 
> When apicid_to_cpuid[] return -1, kernel assigns new CPU number. For
> this, the cpu_used_mask is necessary.

And we can't have that - we cannot have cores which had number X get
number Y after hotplug.

Can you send a full dmesg after you've done a physical node hotplug on a
machine? Privately is fine too.

Boot with

	"ignore_loglevel log_buf_len=10M debug apic=debug show_lapic=all"

please.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

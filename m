Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3KHQJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:09:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3KHQJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:09:15 -0500
Date: Fri, 8 Nov 2013 11:08:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 1/3] x86, apic: Don't count the CPU with BP flag from
 MP table as booting-up CPU
Message-ID: <20131108160830.GB13068@redhat.com>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022150124.24240.20741.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022150124.24240.20741.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:01:24AM +0900, HATAYAMA Daisuke wrote:
> If crash occurs on some AP, then kdump 2nd kernel is booted up on the
> AP. Therefore, it is not always correct that the CPU that is currently
> booting up the kernel is BSP. It's wrong to reflect BSP information in
> MP table as for the current booting up CPU.
> 
> Also, boot_cpu_physical_apicid has already been initialized before
> reaching here, for example, in register_lapic_address().
> 
> This is a preparation for next patch that will introduce a new kernel
> parameter to disabls specified CPU where boot_cpu_physical_apicid
> needs to have apicid for the currently booting up CPU to identify it
> to avoid falsely disabling it.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/kernel/mpparse.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index d2b5648..969bb9f 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -64,7 +64,6 @@ static void __init MP_processor_info(struct mpc_cpu *m)
>  
>  	if (m->cpuflag & CPU_BOOTPROCESSOR) {
>  		bootup_cpu = " (Bootup-CPU)";
> -		boot_cpu_physical_apicid = m->apicid;
>  	}
>  
>  	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);

Hi Hatayama,

Looks like different pieces of code are assuming different meaning of
boot_cpu_physical_apicid.

MP table parsing code seems to assume that this is boot cpu as reported
by MP tables.

        if (m->cpuflag & CPU_BOOTPROCESSOR) {
                bootup_cpu = " (Bootup-CPU)";
                boot_cpu_physical_apicid = m->apicid;
        }

And based on that it also tries to determine whether boot cpu has been
detected yet or not. If it was always the cpu we are booting on, then
MP table parsing code did not have to worry about whether boot cpu
has been detected yet or not.

void generic_processor_info(int apicid, int version)
{
        int cpu, max = nr_cpu_ids;
        bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
                                phys_cpu_present_map);

        /*
         * If boot cpu has not been detected yet, then only allow upto
         * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
         */
        if (!boot_cpu_detected && num_processors >= nr_cpu_ids - 1 &&
            apicid != boot_cpu_physical_apicid) {
                int thiscpu = max + disabled_cpus - 1;

                pr_warning(
                        "ACPI: NR_CPUS/possible_cpus limit of %i almost"
                        " reached. Keeping one slot for boot cpu."
                        "  Processor %d/0x%x ignored.\n", max, thiscpu,
apicid);

                disabled_cpus++;
                return;
        }

I am not the code expert here but looks like there is some confusion
here w.r.t what's the meaning of boot_cpu_physical_apicid and we might
have to fix it.

Thanks
Vivek

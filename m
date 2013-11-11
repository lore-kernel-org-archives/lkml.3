Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3KKCzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:55:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34356 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3KKCzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:55:24 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5280466E.9090504@jp.fujitsu.com>
Date: Mon, 11 Nov 2013 11:52:30 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 1/3] x86, apic: Don't count the CPU with BP flag from
 MP table as booting-up CPU
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131022150124.24240.20741.stgit@localhost6.localdomain6> <20131108160830.GB13068@redhat.com>
In-Reply-To: <20131108160830.GB13068@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/09 1:08), Vivek Goyal wrote:
> On Wed, Oct 23, 2013 at 12:01:24AM +0900, HATAYAMA Daisuke wrote:
>> If crash occurs on some AP, then kdump 2nd kernel is booted up on the
>> AP. Therefore, it is not always correct that the CPU that is currently
>> booting up the kernel is BSP. It's wrong to reflect BSP information in
>> MP table as for the current booting up CPU.
>>
>> Also, boot_cpu_physical_apicid has already been initialized before
>> reaching here, for example, in register_lapic_address().
>>
>> This is a preparation for next patch that will introduce a new kernel
>> parameter to disabls specified CPU where boot_cpu_physical_apicid
>> needs to have apicid for the currently booting up CPU to identify it
>> to avoid falsely disabling it.
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>   arch/x86/kernel/mpparse.c |    1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
>> index d2b5648..969bb9f 100644
>> --- a/arch/x86/kernel/mpparse.c
>> +++ b/arch/x86/kernel/mpparse.c
>> @@ -64,7 +64,6 @@ static void __init MP_processor_info(struct mpc_cpu *m)
>>
>>   	if (m->cpuflag & CPU_BOOTPROCESSOR) {
>>   		bootup_cpu = " (Bootup-CPU)";
>> -		boot_cpu_physical_apicid = m->apicid;
>>   	}
>>
>>   	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
>
> Hi Hatayama,
>
> Looks like different pieces of code are assuming different meaning of
> boot_cpu_physical_apicid.
>
> MP table parsing code seems to assume that this is boot cpu as reported
> by MP tables.
>
>          if (m->cpuflag & CPU_BOOTPROCESSOR) {
>                  bootup_cpu = " (Bootup-CPU)";
>                  boot_cpu_physical_apicid = m->apicid;
>          }
>
> And based on that it also tries to determine whether boot cpu has been
> detected yet or not. If it was always the cpu we are booting on, then
> MP table parsing code did not have to worry about whether boot cpu
> has been detected yet or not.
>
> void generic_processor_info(int apicid, int version)
> {
>          int cpu, max = nr_cpu_ids;
>          bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>                                  phys_cpu_present_map);
>
>          /*
>           * If boot cpu has not been detected yet, then only allow upto
>           * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
>           */
>          if (!boot_cpu_detected && num_processors >= nr_cpu_ids - 1 &&
>              apicid != boot_cpu_physical_apicid) {
>                  int thiscpu = max + disabled_cpus - 1;
>
>                  pr_warning(
>                          "ACPI: NR_CPUS/possible_cpus limit of %i almost"
>                          " reached. Keeping one slot for boot cpu."
>                          "  Processor %d/0x%x ignored.\n", max, thiscpu,
> apicid);
>
>                  disabled_cpus++;
>                  return;
>          }
>
> I am not the code expert here but looks like there is some confusion
> here w.r.t what's the meaning of boot_cpu_physical_apicid and we might
> have to fix it.
>
> Thanks
> Vivek
>

Looking at my past investigation, kernel/mpparse.c, mm/amdtopology.c and
platform/visws/visws_quirks.c assumes that boot_cpu_physical_apicid
has initial apicid of the BSP, not the current actual booting-up cpu.

These three are called in get_smp_config() below. If either of them is
called actually, boot_cpu_physical_apicid has the apicid different from
the current actual booting-up cpu temporarily. But init_apic_mappings()
soon modifies back the value to the one obtained by read_apic_id().

         /*
          * Read APIC and some other early information from ACPI tables.
          */
         acpi_boot_init();
         sfi_init();
         x86_dtb_init();

         /*
          * get boot-time SMP configuration:
          */
         if (smp_found_config)
                 get_smp_config();

         prefill_possible_map();

         init_cpu_to_node();

         init_apic_mappings();

So, thanks to init_apic_mappings(), the patch set would work without the
first patch... This is a careless point in this patch set.

Also, in case of UP kernel, there is the following code in
APIC_init_uniprocessor():

             /*
              * Hack: In case of kdump, after a crash, kernel might be booting
              * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
              * might be zero if read from MP tables. Get it from LAPIC.
              */
     # ifdef CONFIG_CRASH_DUMP
             boot_cpu_physical_apicid = read_apic_id();
     # endif

So, it seems reasonable for boot_cpu_physical_apicid to have the apicid for
the actually booting-up cpu.

Next, let's consider whether or not to fix here. To be honest, the above
lastly called init_apic_mappings() part looks to me a kind of workaround
and should be cleaned up, by introducing bsp_apicid variable separately
to boot_cpu_physical_apicid.

However, I don't know mm/amdtopology.c and platform/visws/visws_quirks.c very
well, in particular for the former. I would think it really needs the real BSP's
apicid in the next patch, but more reviewing by each maintainers might be needed
here.

BTW, there are other confusions except for boot_cpu_physical_apicid. For example,
there's currently the assumption that cpu0 is always the one with BSP flag, for
example, in hibernation, suspend, reboot and cpu0 hot-plugging code. The current
version of this patch set doesn't deal with any of them because the first two
are never used in the kdump 2nd kernel, reboot has so far worked well even if
cpu0 is AP. Lastly, cpu0 hot-plugging code is never used in the 2nd kernel; even
if it is used, NMI logic would be applicable to AP without special handling.

So, I'll post a patch like this. Do you agree?

- introduce bsp_apicid variable in apic.c and use it to have the initial apicid
   of the real BSP.
- replace boot_cpu_physical_apicid in mm/amdtopology.c, mpparse.c and
   platform/visws/visws_quirks.c by newly introduced bsp_apicid. The change needs
   to be reviewed by each maintainers.

Also, by the way, currently read_apic_id() is used to get the apicid of the
current actually booting-up cpu. However, this is compared with the initial apicid
exported from MP table or MADT. So, rigorously, read_apic_id() is wrong, this
returns the apicid possibly different from initial apicid. Instead, cpuid value
should be used. However, there's no bug report about this and if fixing this,
patch set would become bigger, which I want to avoid. So, I don't do this.

-- 
Thanks.
HATAYAMA, Daisuke


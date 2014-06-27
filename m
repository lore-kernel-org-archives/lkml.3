Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaF0FfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:35:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64322 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0FfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:35:05 -0400
Message-ID: <53AD0275.7020003@huawei.com>
Date: Fri, 27 Jun 2014 13:34:45 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "Chen, Gong" <gong.chen@linux.intel.com>, <tony.luck@intel.com>,
        <bp@alien8.de>, <joe@perches.com>, <m.chehab@samsung.com>,
        <arozansk@redhat.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86 platform
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com> <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com> <52612BA4.2060906@linux.vnet.ibm.com>
In-Reply-To: <52612BA4.2060906@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/18 20:37, Naveen N. Rao wrote:
> On 10/18/2013 01:53 PM, Chen, Gong wrote:
>> This H/W error log driver (a.k.a eMCA driver) is implemented based on
>> http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html
>>
>> After errors are captured, more valuable information can be
>> got via this new enhanced H/W error log driver.
>>
>> v3 -> v2: fix a MACRO definition error and some cleanup
>> v2 -> v1: eliminate spin_lock & minor fixes suggested by Boris
>>
>> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
>> ---
>>   arch/x86/include/asm/mce.h       |   5 +
>>   arch/x86/kernel/cpu/mcheck/mce.c |  20 +++
>>   drivers/acpi/Kconfig             |  20 +++
>>   drivers/acpi/Makefile            |   2 +

[...]

>> +}
>> +EXPORT_SYMBOL_GPL(unregister_elog_handler);
>> +
>>   /*
>>    * Poll for corrected events or events that happened before reset.
>>    * Those are just logged through /dev/mcelog.
>> @@ -624,6 +641,9 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>>               (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
>>               continue;
>>
>> +        if (mce_ext_err_print)
>> +            mce_ext_err_print(NULL, m.extcpu, i);
>> +
> 
> Can we use the notifier chain we already have: mce_register_decode_chain()? EDAC uses this and I'm wondering if it is a good fit here. As an added bonus, it seems to honor dont_log_ce option as well.

Hi everyone,

I have a question here, is it safe when we use printk in MCE context?

The call graph is like this,
do_machine_check
 -> mce_log
  -> atomic_notifier_call_chain(&x86_mce_decoder_chain ...)
   -> ...
    -> extlog_print
     -> print_extlog_rcd
      -> __print_extlog_rcd
       -> printk

There's a logbuf_lock in printk. If logbuf_lock is held by other cpu,
it'll lead to an infinity spin here. Isn't it?

--
Thanks,
	XiuQi

> 
>>           mce_read_aux(&m, i);
>>
>>           if (!(flags & MCP_TIMESTAMP))
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index 22327e6..c67ec61 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -372,4 +372,24 @@ config ACPI_BGRT
>>
>>   source "drivers/acpi/apei/Kconfig"
>>
>> +config ACPI_EXTLOG
>> +    tristate "Extended Error Log support"
>> +    depends on X86_MCE
...



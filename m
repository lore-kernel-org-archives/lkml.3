Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3HSCgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:36:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3HSCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:36:03 -0400
Message-ID: <5211851E.4010903@oracle.com>
Date: Mon, 19 Aug 2013 10:38:22 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: jeremy@goop.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: initialize xen panic handler for PVHVM
References: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com> <20130816124327.GC10190@konrad-lan.dumpdata.com>
In-Reply-To: <20130816124327.GC10190@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 08:43 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 16, 2013 at 04:10:56PM +0800, Vaughan Cao wrote:
>> kernel use callback linked in panic_notifier_list to notice others when panic
>> happens.
>> NORET_TYPE void panic(const char * fmt, ...){
>>     ...
>>     atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>> }
>> When xen aware this, it will call xen_reboot(SHUTDOWN_crash) to send out an
>   ^^^^^^^^^^^^^^^^^^^-> "When Xen becomes aware of this"
>
>> event with reason code - SHUTDOWN_crash.
>> xen_panic_handler_init() is defined to register on panic_notifier_list but
>> we only call it in xen_arch_setup which only be called by pvm, this patch is
>                                           ^^^^^^^-> "is only"
>>  necessary for pvhvm.
> Could you tell me what has been happening without this patch?
Setting 'on_crash=coredump-restart' in PVHVM guest config file can't
lead a vmcore to be generate when the guest panics. It can be reproduced
with 'echo c > /proc/sysrq-trigger'.
>From the xend.log, we find the reason code gotten by dominfo is not as
expected:
  [2013-07-29 08:55:37 19378] INFO (XendDomainInfo:2148) Domain has
shutdown: name=oakDom1 id=15 reason=reboot.
While log from a guest who can capture the crash is as below:   
  [2013-07-29 08:13:42 19378] WARNING (XendDomainInfo:2131) Domain has
crashed: name=oakDom1 id=14.

Thanks,
Vaughan
>
> Thank you.
>
>> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
>> ---
>>  arch/x86/xen/enlighten.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index 4aec5ed..53e5726 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -1713,6 +1713,8 @@ static void __init xen_hvm_guest_init(void)
>>  
>>  	xen_hvm_init_shared_info();
>>  
>> +	xen_panic_handler_init();
>> +
>>  	if (xen_feature(XENFEAT_hvm_callback_vector))
>>  		xen_have_vector_callback = 1;
>>  	xen_hvm_smp_init();
>> -- 
>> 1.7.11.7
>>


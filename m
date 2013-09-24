Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3IXTuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:50:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3IXTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:50:22 -0400
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402
 Thunderbird/17.0.5
MIME-Version: 1.0
Message-ID: <5241ED15.7090003@oracle.com>
Date: Tue, 24 Sep 2013 12:50:45 -0700 (PDT)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: hpa@linux.intel.com
Cc: Steven Rostedt <rostedt@goodmis.org>, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org, Stefano.Stabellini@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen: Do not enable spinlocks before jump_label_init() has
 executed
References: <1379039384-1568-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130912224719.5a4a81da@gandalf.local.home>
In-Reply-To: <20130912224719.5a4a81da@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:47 PM, Steven Rostedt wrote:
> On Thu, 12 Sep 2013 22:29:44 -0400
> Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:
>
>> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>
>> xen_init_spinlocks() currently calls static_key_slow_inc() before
>> jump_label_init() is invoked. When CONFIG_JUMP_LABEL is set (which usually is
>> the case) the effect of this static_key_slow_inc() is deferred until after
>> jump_label_init(). This is different from when CONFIG_JUMP_LABEL is not set, in
>> which case the key is set immediately. Thus, depending on the value of config
>> option, we may observe different behavior.
>>
>> In addition, when we come to __jump_label_transform() from jump_label_init(),
>> the key (paravirt_ticketlocks_enabled) is already enabled. On processors where
>> ideal_nop is not the same as default_nop this will cause a BUG() since it is
>> expected that before a key is enabled the latter is replaced by the former
>> during initialization.
>>
>> To address this problem we need to move
>> static_key_slow_inc(&paravirt_ticketlocks_enabled) so that it is called
>> after jump_label_init(). We also need to make sure that this is done before
>> other cpus start to boot. early_initcall appears to be  a good place to do so.
>> (Note that we cannot move whole xen_init_spinlocks() there since pv_lock_ops
>> need to be set before alternative_instructions() runs.)
>>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
>
> Peter,
>
> This fixes a regression in 3.12 against xen. Please pull and push to
> Linus sometime soon.

Peter,

Are you planning on taking this patch?

Thanks.
-boris


>
> Thanks,
>
> -- Steve
>
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>>   arch/x86/xen/spinlock.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
>> index 253f63f..d90628d 100644
>> --- a/arch/x86/xen/spinlock.c
>> +++ b/arch/x86/xen/spinlock.c
>> @@ -267,11 +267,18 @@ void __init xen_init_spinlocks(void)
>>   		return;
>>   	}
>>   
>> -	static_key_slow_inc(&paravirt_ticketlocks_enabled);
>> -
>>   	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
>>   	pv_lock_ops.unlock_kick = xen_unlock_kick;
>>   }
>> +static __init int xen_init_spinlocks_jump(void)
>> +{
>> +	if (!xen_pvspin)
>> +		return 0;
>> +
>> +	static_key_slow_inc(&paravirt_ticketlocks_enabled);
>> +	return 0;
>> +}
>> +early_initcall(xen_init_spinlocks_jump);
>>   
>>   static __init int xen_parse_nopvspin(char *arg)
>>   {


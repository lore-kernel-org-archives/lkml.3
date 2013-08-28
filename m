Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3H1SD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:03:29 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:40832 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3H1SD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <521E2635.4070800@linaro.org>
References: <1377706794-8481-1-git-send-email-robherring2@gmail.com>
	<521E2635.4070800@linaro.org>
Date: Wed, 28 Aug 2013 13:03:27 -0500
Message-ID: <CAL_JsqKx0NBeC6kDjpZEwO1Liu44Uztuq9n-gNNcoV0CH4KGMQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] ARM: xen: only set pm function ptrs for Xen guests
From: Rob Herring <robherring2@gmail.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: xen-devel@lists.xensource.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:32 AM, Julien Grall <julien.grall@linaro.org> wrote:
> On 08/28/2013 05:19 PM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
>> function pointers. This breaks multi-platform kernels. Move this
>> initialization into xen_guest_init, so it is conditional on running as a
>> Xen guest.
>>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>> This breaks reset and poweroff for Midway when Xen is enabled. This
>> should go into 3.11 or stable.
>> Rob
>>
>>  arch/arm/xen/enlighten.c | 12 +++---------
>>  1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
>> index 8a6295c..fa86452 100644
>> --- a/arch/arm/xen/enlighten.c
>> +++ b/arch/arm/xen/enlighten.c
>> @@ -263,6 +263,9 @@ static int __init xen_guest_init(void)
>>       if (xen_vcpu_info == NULL)
>>               return -ENOMEM;
>>
>> +     pm_power_off = xen_power_off;
>> +     arm_pm_restart = xen_restart;
>> +
>
> I think it's too early to set pm callbacks. If Linux is running as dom0,
> xen needs to overwrite the power management callback. Otherwise, dom0
> could shutdown/restart the whole platform, that is annoying.
> For instance, on the versatile express, the power management callback
> are set very late (ie during driver initialization).
>
> pm callbacks should be updated by a late initcall and check if xen is
> enabled.
>
>>       gnttab_init();
>>       if (!xen_initial_domain())
>>               xenbus_probe(NULL);
>> @@ -271,15 +274,6 @@ static int __init xen_guest_init(void)
>>  }
>>  core_initcall(xen_guest_init);
>>
>> -static int __init xen_pm_init(void)
>> -{
>> -     pm_power_off = xen_power_off;
>> -     arm_pm_restart = xen_restart;
>> -
>> -     return 0;
>> -}
>> -subsys_initcall(xen_pm_init);
>> -
>>  static irqreturn_t xen_arm_callback(int irq, void *arg)
>>  {
>>       xen_hvm_evtchn_do_upcall();
>>
>
>
> --
> Julien Grall

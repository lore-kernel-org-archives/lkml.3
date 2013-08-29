Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3H2SUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:20:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40161 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab3H2SUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:20:53 -0400
Message-ID: <521F9100.4070107@gmail.com>
Date: Thu, 29 Aug 2013 20:20:48 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-17-git-send-email-sebastian.hesselbarth@gmail.com> <201308291537.54608.arnd@arndb.de>
In-Reply-To: <201308291537.54608.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 15:37, Arnd Bergmann wrote:
> On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
>> @@ -58,10 +57,10 @@ static void __init zynq_init_machine(void)
>>          of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
>>   }
>>
>> -static void __init zynq_timer_init(void)
>> +static void __init zynq_init_irq(void)
>>   {
>> +       irqchip_init();
>>          zynq_slcr_init();
>> -       clocksource_of_init();
>>   }
>>
>>   static struct map_desc zynq_cortex_a9_scu_map __initdata = {
>> @@ -104,8 +103,8 @@ static const char * const zynq_dt_match[] = {
>>   DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>>          .smp            = smp_ops(zynq_smp_ops),
>>          .map_io         = zynq_map_io,
>> +       .init_irq       = zynq_init_irq,
>>          .init_machine   = zynq_init_machine,
>> -       .init_time      = zynq_timer_init,
>>          .dt_compat      = zynq_dt_match,
>>          .restart        = zynq_system_reset,
>>   MACHINE_END
>
> It looks like we are not getting any closer to removing all callbacks here,
> since you add one in order to remove another, and after the patch we do
> more things "early", which we try to avoid. I think we're better off without
> this particular patch.

Right.

Have you seen Soeren requesting to move of_clk_init(NULL) under the
else branch of arch-wide .init_time? In the proposed patch it is called
unconditionally before any mach specific callback.

Moving it to what gets called if no mach specific callback is set,
would allow zynq (and others) to still have their own callback where
they can probe clocks whenever they want to.

Sebastian


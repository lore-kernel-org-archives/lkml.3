Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbaJ2Mzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:55:53 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:39525 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaJ2Mzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141029123418.GB2265@localhost>
References: <20141024192948.GE11455@saruman>
	<20141024193655.GD19377@localhost>
	<20141024194442.GG11455@saruman>
	<20141024195532.GF19377@localhost>
	<20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
	<20141028002552.GX12379@n2100.arm.linux.org.uk>
	<20141028081616.GL2006@localhost>
	<20141028084745.GY12379@n2100.arm.linux.org.uk>
	<20141028131257.GS2006@localhost>
	<20141028151610.GA12379@n2100.arm.linux.org.uk>
	<20141029123418.GB2265@localhost>
Date: Wed, 29 Oct 2014 13:55:49 +0100
Message-ID: <CABgxDo+ewxNwb3RrBVZA7kqYMvSujLb9U6A6FCvnHQH1W8V0kg@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        devicetree <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, j-keerthy@ti.com, nsekhar@ti.com,
        Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        t-kristo@ti.com, Lokesh Vutla <lokeshvutla@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan:. do you really plan to use this "poweroff-source" property ? As
you proposed a renaming few days ago...
I don't really want to waste time to propose patches to fix things
incrementally and rename it if the old one is used...

Romain

2014-10-29 13:34 GMT+01:00 Johan Hovold <johan@kernel.org>:
> On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
>> On Tue, Oct 28, 2014 at 02:12:57PM +0100, Johan Hovold wrote:
>> > That's not what I was trying to refer to. But the patch set explicitly
>> > allows for multiple, prioritised power-off handlers, which can power
>> > off a board in different ways and with various degrees of success.
>> > Specifically, it allows for fallback handlers in case one or more
>> > power-off handlers fail.
>> >
>> > So if we allow for that, what is to prevent the final power-off handler
>> > from failing? And should this not be logged by arch code in the same way
>> > as failure to restart is?
>>
>> And how is that different from having a set of power-off handlers, and
>> reporting when each individual one fails?  Don't you want to know if
>> your primary high priority reboot handler fails, just as much as you
>> want to know if your final last-resort power-off handler fails?
>
> Good point. Failed power-off should probably be logged by the power-off
> call chain implementation (which seems to makes notifier chains a bad
> fit).
>
> And what about any power-off latencies? Should this always be dealt with
> in the power-off handler?
>
> Again, if it's predictable and high, as in the OMAP RTC case, it should
> go in the handler. But what if it's just normal bus latencies
> (peripheral busses, i2c, or whatever people may come up with)?
>
> Should there always be a short delay before calling the next handler?
>
>> Or different from having no power-off handlers.
>
> That is actually quite different, as in that case we call machine_halt
> instead (via kernel_halt).
>
>> Here's the x86 code:
>>
>> void machine_power_off(void)
>> {
>>         machine_ops.power_off();
>> }
>>
>> struct machine_ops machine_ops = {
>>         .power_off = native_machine_power_off,
>> ...
>>
>> static void native_machine_power_off(void)
>> {
>>         if (pm_power_off) {
>>                 if (!reboot_force)
>>                         machine_shutdown();
>>                 pm_power_off();
>>         }
>>         /* A fallback in case there is no PM info available */
>>         tboot_shutdown(TB_SHUTDOWN_HALT);
>> }
>>
>> void tboot_shutdown(u32 shutdown_type)
>> {
>>         void (*shutdown)(void);
>>
>>         if (!tboot_enabled())
>>                 return;
>>
>> See - x86 can very well just fall straight back out of machine_power_off()
>> if there's no pm_power_off() hook and tboot is not enabled.
>
> I never doubted that, but is the right thing to do? Not all arches do it
> that way.
>
> And what about the killing of init? Shall we simply consider that a
> systemd bug?
>
>         case LINUX_REBOOT_CMD_POWER_OFF:
>                 kernel_power_off();
>                 do_exit(0);
>                 break;
>
> If power-off fails (for whatever reason), do_exit(0) will trigger a
> panic when called from PID 1.
>
> Johan
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

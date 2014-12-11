Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246AbaLKRCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:02:25 -0500
Received: from v032797.home.net.pl ([89.161.177.31]:60060 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965195AbaLKRCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:02:20 -0500
Message-ID: <5489CE19.8080108@elproma.com.pl>
Date: Thu, 11 Dec 2014 18:02:17 +0100
From: =?UTF-8?B?SmFudXN6IFXFvHlja2k=?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v3] clk: Add PWM clock driver
References: <1418138392-17081-1-git-send-email-p.zabel@pengutronix.de>	 <54872810.7000700@elproma.com.pl> <1418223593.3258.10.camel@pengutronix.de> <5489C385.9090305@elproma.com.pl>
In-Reply-To: <5489C385.9090305@elproma.com.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Part of my .config:
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y

However the patch does not help against the bug:
--- a/linux-3.14.17/drivers/clk/clk-pwm.c
+++ b/linux-3.14.17/drivers/clk/clk-pwm.c
@@ -25,15 +25,22 @@ struct clk_pwm {
  static int clk_pwm_enable(struct clk_hw *hw)
  {
         struct clk_pwm *clk_pwm = to_clk_pwm(hw);
+       int ret;
+
+       preempt_disable();
+       ret = pwm_enable(clk_pwm->pwm);
+       preempt_enable();

-       return pwm_enable(clk_pwm->pwm);
+       return ret;
  }

  static void clk_pwm_disable(struct clk_hw *hw)
  {
         struct clk_pwm *clk_pwm = to_clk_pwm(hw);

+       preempt_disable();
         pwm_disable(clk_pwm->pwm);
+       preempt_enable();
  }

The problem is rather clk_enable_lock/clk_enable_unlock
called twice. Once for the pwm-clock and the second for
pwm's clock (clk_prepare_enable/clk_disable_unprepare).
Any idea? How does it work for you?

thanks,
Janusz

W dniu 2014-12-11 o 17:17, Janusz Użycki pisze:
> Hi Philipp,
>
> W dniu 2014-12-10 o 15:59, Philipp Zabel pisze:
>> Hi Janusz,
>>
>> thank you for the comments.
>>
>> Am Dienstag, den 09.12.2014, 17:49 +0100 schrieb Janusz Użycki:
>> [...]
>>>> [...]
>>>> +    pwm = devm_pwm_get(&pdev->dev, NULL);
>>> NULL or clk_name ?
>> There's only one pwm input to the pwm-clock, so I see no need to use a
>> con_id here and require the pwm-names device tree property to be set.
>
> OK
>
>>
>>>> [...]
>>>> +    if (of_property_read_u32(node, "clock-frequency", 
>>>> &clk_pwm->fixed_rate))
>>>> +        clk_pwm->fixed_rate = 1000000000 / pwm->period;
>>> You can use NSEC_PER_SEC instead of the hardcoded value.
>> Thanks, I'll fix that.
>>
>>>> +
>>>> +    if (pwm->period != 1000000000 / clk_pwm->fixed_rate &&
>>>> +        pwm->period != DIV_ROUND_UP(1000000000, 
>>>> clk_pwm->fixed_rate)) {
>>>> +        dev_err(&pdev->dev,
>>>> +            "clock-frequency does not match pwm period\n");
>>>> +        return -EINVAL;
>>>> +    }
>>> This can't prevent against buggy pwm driver (bad frequency)
>>> because there is not function to read the period back, ie.
>>> .pwm_config callback does not modify duty_ns and period_ns to real
>>> values indeed.
>> Of course, this is only to make sure that the clock-frequency and pwm
>> duty cycle are roughly the same.
>
> OK, it looks good and simple.
>
>>> There is the way to set directly
>>>           pwm->period = NSEC_PER_SEC / clk_pwm>fixed_rate;
>>> instead of third argument (period_ns) of pwms. Although the argument is
>>> required
>>> (#pwm-cells >= 2 and *_xlate_* functions) it could be set to 0 in pwms.
>>> Such calculation should be right for most PWMs if they are clocked not
>>> faster
>>> than eg. 40MHz. Above div-round issue can appear but it also appears 
>>> due
>>> to ns resolution.
>>> I can't point if this is the best solution for the future.
>>>
>>>> +
>>>> +    ret = pwm_config(pwm, (pwm->period + 1) >> 1, pwm->period);
>>>> +    if (ret < 0)
>>>> +        return ret;
>>>> +
>>>> +    clk_name = node->name;
>>>> +    of_property_read_string(node, "clock-output-names", &clk_name);
>>>> +
>>>> +    init.name = clk_name;
>>>> +    init.ops = &clk_pwm_ops;
>>>> +    init.flags = CLK_IS_ROOT;
>>> and what about CLK_IS_BASIC?
>> Yes, I'll add that.
>>
>>>> +    init.num_parents = 0;
>>> Is it proof against suspend/resume race of pwm driver vs pwm-clock's
>>> customer?
>>> Otherwise chain of clocks can be broken.
>> Are there pwm drivers that disable pwm output in their suspend callback?
>> I don't think system wide suspend/resume ordering can protect against
>> that at all, since the two devices may be on completely different buses.
>> In that case it'd probably be best to use runtime pm to keep the pwm
>> activated until clk_disable/pwm_disable is called by the consumer.
>>
>> [...]
>>>> +static struct platform_driver clk_pwm_driver = {
>>>> +    .probe = clk_pwm_probe,
>>> missing
>>>                   .remove = clk_pwm_remove,
>>>
>>>> +    .driver = {
>>>> +        .name = "pwm-clock",
>>>> +        .owner = THIS_MODULE,
>>> .owner could be removed (not a problem now)
>> Will add and remove those, respectively.
>>
>>>> +        .of_match_table = of_match_ptr(clk_pwm_dt_ids),
>>>> +    },
>>> Why doesn't mcp251x trigger probe of pwm-clock driver?
>>> The fixed-clock uses CLK_OF_DECLARE which defines .data
>>> of of_device_id instead of .probe. Unfortunately I'm not so much
>>> familiar with DT.
>>> Any idea?
>> Did you add "simple-bus" to the clocks node compatible? The pwm-clock
>> device tree node needs to be placed somewhere where of_platform_populate
>> will consider it.
>
> Yeah, I've added simple-bus but then I also removed from the driver 
> .of_match_table and
> added node = of_find_compatible_node(NULL, NULL, "pwm-clock") and 
> of_node_put(node)
> in the probe. The probe wasn't called. still Your suggestion helped me 
> a lot to undo
> the wrong experiment, thanks!
> Expressing somewhere meaning of "simple-bus" could be a nice step.
>
> "fixed-clock" was probed without "simple-bus" as it uses 
> CLK_OF_DECLARE (init section).
> Now the pwm-clk [v3 + .remove + CLK_IS_BASIC + debug messages] driver 
> is probed.
> My debug messages on system start (the driver is built-in, not a module):
> clk_pwm_probe: node c7efb9dc
> clk_pwm_recalc_rate: freq 12000000
>
> On "modprobe mcp251x" with the pwm-clock configured I get
> "BUG: scheduling while atomic: modprobe/1374/0x00000002"
> and the back-trace below. It doesn't appear if fixed-clock used.
> On "rmmod" I get similar issue below.
>
> Do you investigate tags like MODULE_LICENSE("GPL v2"), author etc. for 
> the driver?
>
> thanks,
> Janusz
>
>
> # modprobe mcp251x
> CAN device driver interface
> ------------[ cut here ]------------
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1374 at drivers/clk/clk.c:77 
> clk_enable_lock+0x4c/0xc4()
> CPU: 0 PID: 1374 Comm: modprobe Not tainted 3.14.17 #276
> Backtrace:
> [<c000c700>] (dump_backtrace) from [<c000c828>] (show_stack+0x18/0x1c)
>  r6:c053be98 r5:c0338e94 r4:0000004d
> [<c000c810>] (show_stack) from [<c0212c28>] (dump_stack+0x20/0x28)
> [<c0212c08>] (dump_stack) from [<c0016ae0>] 
> (warn_slowpath_common+0x6c/0x8c)
> [<c0016a74>] (warn_slowpath_common) from [<c0016b24>] 
> (warn_slowpath_null+0x24/0x2c)
>  r8:c7166000 r7:c05f8308 r6:00000025 r5:60000093 r4:c05f3f48
> [<c0016b00>] (warn_slowpath_null) from [<c0338e94>] 
> (clk_enable_lock+0x4c/0xc4)
> [<c0338e48>] (clk_enable_lock) from [<c033900c>] (clk_enable+0x14/0x34)
>  r5:00000025 r4:c780b120
> [<c0338ff8>] (clk_enable) from [<c0266664>] 
> (auart_console_write+0x38/0xec)
>  r5:00000025 r4:c7ae6c00
> [<c026662c>] (auart_console_write) from [<c004dbf0>] 
> (call_console_drivers+0x124/0x148)
>  r8:c7166000 r7:c05f8308 r6:00000025 r5:c05f8af8 r4:c05de0b8
> [<c004dacc>] (call_console_drivers) from [<c004dfbc>] 
> (console_unlock+0x3a8/0x4c8)
>  r7:c0603780 r6:00000086 r5:00000004 r4:00000025
> [<c004dc14>] (console_unlock) from [<c004eb30>] 
> (vprintk_emit+0x448/0x498)
>  r10:00000000 r9:60000093 r8:c05f870a r7:00000004 r6:00000024 r5:00000001
>  r4:00000000
> [<c004e6e8>] (vprintk_emit) from [<c004ebb8>] (printk+0x38/0x40)
>  r10:c7ba4240 r9:bf02eb9c r8:00000009 r7:00000000 r6:c053be98 r5:c0338e94
>  r4:0000004d
> [<c004eb84>] (printk) from [<c0016aa4>] (warn_slowpath_common+0x30/0x8c)
>  r3:00000000 r2:c0338e94 r1:0000004d r0:c04f57ac
> [<c0016a74>] (warn_slowpath_common) from [<c0016b24>] 
> (warn_slowpath_null+0x24/0x2c)
>  r8:c7135000 r7:c79fdc6c r6:c796de10 r5:60000093 r4:c05f3f48
> [<c0016b00>] (warn_slowpath_null) from [<c0338e94>] 
> (clk_enable_lock+0x4c/0xc4)
> [<c0338e48>] (clk_enable_lock) from [<c033900c>] (clk_enable+0x14/0x34)
>  r5:00000000 r4:c780b0c0
> [<c0338ff8>] (clk_enable) from [<c023a08c>] (mxs_pwm_enable+0x30/0x60)
>  r5:00000000 r4:c780b0c0
> [<c023a05c>] (mxs_pwm_enable) from [<c0238df0>] (pwm_enable+0x54/0x60)
>  r7:bf02ef1c r6:c7b7fc00 r5:00000000 r4:c7ba4240
> [<c0238d9c>] (pwm_enable) from [<c033c3cc>] (clk_pwm_enable+0x14/0x18)
> [<c033c3b8>] (clk_pwm_enable) from [<c0338894>] (__clk_enable+0x6c/0xa0)
> [<c0338828>] (__clk_enable) from [<c0339018>] (clk_enable+0x20/0x34)
>  r5:60000013 r4:c7ba4240
> [<c0338ff8>] (clk_enable) from [<bf02e574>] 
> (mcp251x_can_probe+0xc0/0x3e8 [mcp251x])
>  r5:00b71b00 r4:00000000
> [<bf02e4b4>] (mcp251x_can_probe [mcp251x]) from [<c02cfb34>] 
> (spi_drv_probe+0x20/0x24)
>  r10:c064387c r9:c7167efc r8:00000004 r7:bf02ef1c r6:bf02ef1c r5:00000000
>  r4:c7b7fc00
> [<c02cfb14>] (spi_drv_probe) from [<c0270a0c>] 
> (driver_probe_device+0xd4/0x224)
> [<c0270938>] (driver_probe_device) from [<c0270de4>] 
> (__driver_attach+0x6c/0x90)
>  r10:00000000 r8:c7167f48 r7:bf02ef1c r6:bf02ef1c r5:c7b7fc34 r4:c7b7fc00
> [<c0270d78>] (__driver_attach) from [<c026f3e8>] 
> (bus_for_each_dev+0x5c/0x98)
>  r6:c0270d78 r5:c7167d80 r4:00000000
> [<c026f38c>] (bus_for_each_dev) from [<c0270818>] 
> (driver_attach+0x20/0x28)
>  r7:00000000 r6:c05e454c r5:c7ba3300 r4:bf02ef1c
> [<c02707f8>] (driver_attach) from [<c026fea0>] 
> (bus_add_driver+0xbc/0x1c8)
> [<c026fde4>] (bus_add_driver) from [<c02713d0>] 
> (driver_register+0xa8/0xec)
>  r7:bf031000 r6:00000018 r5:bf02ef58 r4:bf02ef1c
> [<c0271328>] (driver_register) from [<c02cf948>] 
> (spi_register_driver+0x4c/0x60)
>  r5:bf02ef58 r4:00000000
> [<c02cf8fc>] (spi_register_driver) from [<bf031014>] 
> (mcp251x_can_driver_init+0x14/0x1c [mcp251x])
> [<bf031000>] (mcp251x_can_driver_init [mcp251x]) from [<c0008900>] 
> (do_one_initcall+0x98/0x140)
> [<c0008868>] (do_one_initcall) from [<c006df20>] 
> (load_module+0xb30/0xe74)
>  r10:00000000 r8:c7167f48 r7:00000000 r6:00000018 r5:bf02ef58 r4:00000000
> [<c006d3f0>] (load_module) from [<c006e488>] (SyS_init_module+0xcc/0xd4)
>  r10:00000000 r9:c7166000 r8:c0009664 r7:00000080 r6:000a9628 r5:000a9a58
>  r4:00004e96
> [<c006e3bc>] (SyS_init_module) from [<c0009500>] 
> (ret_fast_syscall+0x0/0x2c)
>  r6:000a9628 r5:000a9a58 r4:000a97e0
> ---[ end trace 3f34e0dc194f915a ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1374 at drivers/clk/clk.c:78 
> clk_enable_lock+0x80/0xc4()
>
>
> # rmmod mcp251x
> BUG: scheduling while atomic: rmmod/1387/0x00000002
> Backtrace:
> [<c000c700>] (dump_backtrace) from [<c000c828>] (show_stack+0x18/0x1c)
>  r6:c712ed80 r5:00000000 r4:00000000
> [<c000c810>] (show_stack) from [<c0212c28>] (dump_stack+0x20/0x28)
> [<c0212c08>] (dump_stack) from [<c003e998>] (__schedule_bug+0x48/0x60)
> [<c003e950>] (__schedule_bug) from [<c0410998>] (__schedule+0x68/0x4e8)
>  r4:00000000
> [<c0410930>] (__schedule) from [<c04110fc>] (schedule+0x78/0x7c)
>  r10:00000002 r9:c78ba000 r8:c7863df4 r7:7fffffff r6:c7862000 r5:00000000
>  r4:7fffffff
> [<c0411084>] (schedule) from [<c0410330>] (schedule_timeout+0x20/0x218)
> [<c0410310>] (schedule_timeout) from [<c04119c0>] 
> (wait_for_common+0x104/0x1d4)
>  r8:c7863df4 r7:7fffffff r6:c7862000 r5:00000000 r4:00000000
> [<c04118bc>] (wait_for_common) from [<c0411b38>] 
> (wait_for_completion+0x18/0x1c)
>  r10:c05d9470 r8:c7ba3300 r7:c7863df4 r6:00000001 r5:00000000 r4:c711e1c0
> [<c0411b20>] (wait_for_completion) from [<c002bff8>] 
> (call_usermodehelper_exec+0x108/0x174)
> [<c002bef0>] (call_usermodehelper_exec) from [<c002c14c>] 
> (call_usermodehelper+0x48/0x50)
>  r7:c7b97000 r6:00000000 r5:00000000 r4:00000001
> [<c002c104>] (call_usermodehelper) from [<c0216364>] 
> (kobject_uevent_env+0x3b4/0x434)
>  r4:00000000
> [<c0215fb0>] (kobject_uevent_env) from [<c02163f8>] 
> (kobject_uevent+0x14/0x18)
>  r10:00000000 r9:c7862000 r8:c0009664 r7:c7863f3c r6:c715f280 r5:c05deb28
>  r4:c7ba3300
> [<c02163e4>] (kobject_uevent) from [<c021537c>] 
> (kobject_release+0x38/0x7c)
> [<c0215344>] (kobject_release) from [<c0214eb8>] (kobject_put+0x68/0x7c)
>  r6:00000000 r5:bf02ef58 r4:c7ba3300
> [<c0214e50>] (kobject_put) from [<c026f86c>] 
> (bus_remove_driver+0x80/0x98)
>  r4:bf02ef1c
> [<c026f7ec>] (bus_remove_driver) from [<c0271304>] 
> (driver_unregister+0x48/0x54)
>  r4:bf02ef1c
> [<c02712bc>] (driver_unregister) from [<bf02e8b0>] 
> (mcp251x_can_driver_exit+0x14/0x1c [mcp251x])
>  r4:a0000013
> [<bf02e89c>] (mcp251x_can_driver_exit [mcp251x]) from [<c006e5fc>] 
> (SyS_delete_module+0x12c/0x194)
> [<c006e4d0>] (SyS_delete_module) from [<c0009500>] 
> (ret_fast_syscall+0x0/0x2c)
>  r7:00000081 r6:0000009a r5:beb47b9c r4:b6f1c490
> BUG: scheduling while atomic: rmmod/1387/0x00000002
> Unable to handle kernel paging request at virtual address 00081f84
> pgd = c719c000
> [00081f84] *pgd=47197831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 80000005 [#1] PREEMPT ARM
> Process rmmod (pid: 1387, stack limit = 0xc78621c0)
> ---[ end trace 3f34e0dc194f9160 ]---
> note: rmmod[1387] exited with preempt_count 1
> Segmentation fault
>
>>
>> regards
>> Philipp
>>
>


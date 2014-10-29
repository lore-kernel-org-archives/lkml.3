Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaJ2NVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:21:33 -0400
Received: from [208.91.199.152] ([208.91.199.152]:49757 "EHLO
	bh-25.webhostbox.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaJ2NVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:21:31 -0400
Message-ID: <5450E9A8.1060506@roeck-us.net>
Date: Wed, 29 Oct 2014 06:20:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
References: <20141024192948.GE11455@saruman> <20141024193655.GD19377@localhost> <20141024194442.GG11455@saruman> <20141024195532.GF19377@localhost> <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org> <20141028002552.GX12379@n2100.arm.linux.org.uk> <20141028081616.GL2006@localhost> <20141028084745.GY12379@n2100.arm.linux.org.uk> <20141028131257.GS2006@localhost> <20141028151610.GA12379@n2100.arm.linux.org.uk> <20141029123418.GB2265@localhost>
In-Reply-To: <20141029123418.GB2265@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5450E9AD.0242,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 05:34 AM, Johan Hovold wrote:
> On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
>> On Tue, Oct 28, 2014 at 02:12:57PM +0100, Johan Hovold wrote:
>>> That's not what I was trying to refer to. But the patch set explicitly
>>> allows for multiple, prioritised power-off handlers, which can power
>>> off a board in different ways and with various degrees of success.
>>> Specifically, it allows for fallback handlers in case one or more
>>> power-off handlers fail.
>>>
>>> So if we allow for that, what is to prevent the final power-off handler
>>> from failing? And should this not be logged by arch code in the same way
>>> as failure to restart is?
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
Good that I just replaced notifier chain with an open coded implementation.
Sure, that is possible, but I would prefer to do that as a follow-up commit,
and it should be discussed in the context of the power-off handler patch set.

> And what about any power-off latencies? Should this always be dealt with
> in the power-off handler?
>
> Again, if it's predictable and high, as in the OMAP RTC case, it should
> go in the handler. But what if it's just normal bus latencies
> (peripheral busses, i2c, or whatever people may come up with)?
>
> Should there always be a short delay before calling the next handler?
>
That delay would depend on the individual power-off handler, so I think
the current implementation works just fine (where power-off handlers
implement the delay).

We could move the delay into the infrastructure, but it would have
to be configurable. I would prefer to consider that as a follow-up patch
to not overload the power-off handler patch set with too many changes
at the same time.

>> Or different from having no power-off handlers.
>
> That is actually quite different, as in that case we call machine_halt
> instead (via kernel_halt).
>
>> Here's the x86 code:
>>
>> void machine_power_off(void)
>> {
>>          machine_ops.power_off();
>> }
>>
>> struct machine_ops machine_ops = {
>>          .power_off = native_machine_power_off,
>> ...
>>
>> static void native_machine_power_off(void)
>> {
>>          if (pm_power_off) {
>>                  if (!reboot_force)
>>                          machine_shutdown();
>>                  pm_power_off();
>>          }
>>          /* A fallback in case there is no PM info available */
>>          tboot_shutdown(TB_SHUTDOWN_HALT);
>> }
>>
>> void tboot_shutdown(u32 shutdown_type)
>> {
>>          void (*shutdown)(void);
>>
>>          if (!tboot_enabled())
>>                  return;
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
> 	case LINUX_REBOOT_CMD_POWER_OFF:
> 		kernel_power_off();
> 		do_exit(0);
> 		break;
>
> If power-off fails (for whatever reason), do_exit(0) will trigger a
> panic when called from PID 1.
>
Common handling of that condition - eg to call machine_halt() - might be
an option. Separate patch, though.

Guenter


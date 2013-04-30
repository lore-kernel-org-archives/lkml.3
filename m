Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab3D3CVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:21:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35998 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3D3CVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:21:22 -0400
Message-ID: <517F2A9E.9040209@amacapital.net>
Date: Mon, 29 Apr 2013 19:21:18 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        dirk.j.brandewie@intel.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, dirk.brandewie@gmail.com
Subject: Re: CONFIG_X86_INTEL_PSTATE disables CPU frequency transition stats,
 many governors and other standard features
References: <475427035.74642.1367038733183.JavaMail.mail@webmail08> <1843018.F0kGJi5K1v@vostro.rjw.lan>
In-Reply-To: <1843018.F0kGJi5K1v@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 07:35 AM, Rafael J. Wysocki wrote:
> On Saturday, April 27, 2013 04:58:53 AM Artem S. Tashkinov wrote:
>> Hello,
>>
>> Just wanted to let everyone know that CONFIG_X86_INTEL_PSTATE wreaks
>> havoc with the CPU frequency subsystem in the Linux kernel.
>>
>> With this option enabled:
>>
>> 1) All governors except performance and powersave are gone, ondemand
>> userspace, conservative
>>
>> 2) scaling_cur_freq is gone, thus user space utilities monitoring the CPU
>> frequency have stopped working
>>
>> 3) CPU frequency transition stats are gone, there's no "stats" directory
>> anywhere
>>
>> 4) scaling_available_frequencies is gone, so I cannot set the desired constant
>> CPU frequency (the userspace governor is not available anyway)
>>
>> Is this an intended behavior? I shrivel to think that's the case.
>>
>> The bug report is filed here: https://bugzilla.kernel.org/show_bug.cgi?id=57141
> 
> intel_pstate is not a usual cpufreq driver and from the cpufreq's perspective
> it contains its own governor.  That's the reason why the other scaling governors
> aren't available with it.
> 
> The sysfs attributes mentioned above are missing simply because they don't make
> sense with intel_pstate.
> 
> I'm only wondering which user space doesn't work correctly with intel_pstate as
> you said in the bug entry above.
> 
> If you don't want to use intel_pstate (in which case the ACPI driver will be
> used instead), please append intel_pstate=disable to the kernel command line.

Out of curiosity, what is this driver doing?

It uses aperf/mperf magic to (I think) estimate how busy the CPU has
been recently.  (This is clearly somewhat Intel-specific, but a similar
estimate could be made using knowledge of the programmed frequency and
the scheduler's idle time on any CPU.)

It samples that estimate every 10 ms (why is this even remotely
acceptable in a driver that's supposed to save power?).

Using that sample, it updates one of two PID controllers to bring the
busy or idle fraction (which one depends on the choice of controller) to
a target value of 109/256 or 75/256.  In practice, it seems like once it
starts using the busy controller, it never goes back unless XPERF_FIX is
#defined, which it isn't.

It then adjusts the pstate as decreed by the PID controller.

At least this has the property that, the busier the CPU, the higher the
pstate.




Not to sidetrack the discussion, but (wearing my HFT hat for a moment)
has anyone else noticed that C1E is an absolute disaster for
performance?  IMO the kernel should turn off C1E in case the BIOS is
malicious enough to turn it on, and then the kernel should treat
all-cores-idle as an extra, kind of strange idle state with very high
exit latency and use it (and adjust frequency) accordingly?

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaJUM7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:59:19 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49367 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbaJUM7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <5445CB94.1090302@jp.fujitsu.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
 <20141020064826.GA4064@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
 <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com> <5445CB94.1090302@jp.fujitsu.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 21 Oct 2014 08:58:54 -0400
X-Google-Sender-Auth: 8tjxucZ9vwa181T3Zay5Tsrq4Mo
Message-ID: <CALZtONCPLoCXXqC9M3v0WUxhFyCJV2P82gRw3A_Z9KyVe3My5A@mail.gmail.com>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Neil Zhang <zhangwm@marvell.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:57 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> Hi Neil and Dan,
>
>
> (2014/10/21 2:02), Dan Streetman wrote:
>>
>> On Mon, Oct 20, 2014 at 3:40 AM, Neil Zhang <zhangwm@marvell.com> wrote:
>>>
>>> Greg,
>>>
>>>
>>> -----Original Message-----
>>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>>> Sent: 2014年10月20日 14:48
>>> To: Neil Zhang
>>> Cc: linux-kernel@vger.kernel.org
>>> Subject: Re: [PATCH] drivers: base: update cpu offline info when do
>>> hotplug
>>>
>>> On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
>>>>>
>>>>> How much noise is this going to cause on a big/little system that
>>>>> constantly hot unplug/plugs processors all of the time?
>>>>
>>>>
>>>> Can you explain more what kind of noise will be introduced on a
>>>> big/little system?
>>>
>>>
>>> Have you tested this on such a machine?
>>>
>>> I didn't have such kind of machine on hand.
>>> Can anyone has such machine to verify it?
>>> Thanks!
>>
>>
>> I tested this on a ppc PowerVM system, using dlpar operations to
>> remove/add cpus.
>>
>> Without this patch the cpu online nodes get out of sync with the main
>> online node (and the actual state of the cpus), because they aren't
>> updated as the cpus are brought up/down:
>>
>
>> [root@br10p02 cpu]$ pwd
>> /sys/devices/system/cpu
>> [root@br10p02 cpu]$ cat online
>> 0-39
>> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
>> -eq 1 && echo -n "$n " ; done ; echo ""
>> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
>> 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
>
>
> How is the issue reproduced.
>
> Here is a result on my x86 box with linux-3.18-rc1.

This is not an issue when using the sysfs interface to bring cpus up
or down.  This is only an issue when using any other method to bring
cpus up or down.  I used dlpar operations, which invoke the
arch/powerpc/platforms/pseries/dlpar.c code, which brings cpus up and
down.  The dlpar operations are invoked by a hypervisor on a "LPAR"
(virtualized guest) system to tell it some of the (virtualized) cpus
are being added/removed.

>
> - before offline CPU
> # cd /sys/devices/system/cpu/
> # cat online
> 0-59
> # for n in {0..59} ; do test $( cat cpu$n/online ) -eq 1 && echo -n "$n " ;
> done ; echo ""
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
> 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53
> 54 55
> 56 57 58 59
>
> - after offline CPU{1..59}
> # for n in {1..59} ; do echo 0 > cpu$n/online; done
> # cat online
> 0
> # for n in {0..59} ; do test $( cat cpu$n/online ) -eq 1 && echo -n "$n " ;
> done ; echo ""
> 0
>
> It seems that dev->offline is set to correct valute.
>
> Thanks,
> Yasuaki Ishimatsu
>
>>
>>
>> While with the patch, the cpu online nodes are kept up to date as the
>> cpus are brought up/down:
>>
>> [root@br10p02 cpu]$ pwd
>> /sys/devices/system/cpu
>> [root@br10p02 cpu]$ cat online
>> 0-39
>> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
>> -eq 1 && echo -n "$n " ; done ; echo ""
>> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
>> 27 28 29 30 31 32 33 34 35 36 37 38 39
>>
>>
>> Feel free to add
>>
>> Tested-by: Dan Streetman <ddstreet@ieee.org>
>>
>>>
>>>> As I know IKS on arm will use cpu_suspend way to power down a core.
>>>
>>>
>>> Are you sure that it also doesn't use that same functionality to drop a
>>> processor to save power?
>>>
>>> As I know it use cpu_suspend to switch out a processor in IKS and there
>>> is no cpu hotplug notifier in this procedure.
>>>
>>>
>>> Why do you need/want this notification?  What are you going to do with
>>> this information that you don't already have?
>>>
>>> The offline won't be updated if an in kernel hotplug governor plug in /
>>> out a core which cause the sysfs interface report a wrong status.
>>>
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>>
>>> Best Regards,
>>> Neil Zhang
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>

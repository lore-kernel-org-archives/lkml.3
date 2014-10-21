Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaJUD1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:27:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47496 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJUD1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:27:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5445D27D.1080505@jp.fujitsu.com>
Date: Tue, 21 Oct 2014 12:26:53 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, Dan Streetman <ddstreet@ieee.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com> <20141020044340.GA9589@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com> <20141020064826.GA4064@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com> <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com> <5445CB94.1090302@jp.fujitsu.com> <9034CBD80F070943B59700D7F8149ED9024EB81D55@SC-VEXCH4.marvell.com>
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024EB81D55@SC-VEXCH4.marvell.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 12:18), Neil Zhang wrote:
> Yasuaki,
>
>> -----Original Message-----
>> From: Yasuaki Ishimatsu [mailto:isimatu.yasuaki@jp.fujitsu.com]
>> Sent: 2014年10月21日 10:57
>> To: Dan Streetman; Neil Zhang
>> Cc: Greg KH; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
>>
>> Hi Neil and Dan,
>>
>> (2014/10/21 2:02), Dan Streetman wrote:
>>> On Mon, Oct 20, 2014 at 3:40 AM, Neil Zhang <zhangwm@marvell.com> wrote:
>>>> Greg,
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>>>> Sent: 2014年10月20日 14:48
>>>> To: Neil Zhang
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Subject: Re: [PATCH] drivers: base: update cpu offline info when do
>>>> hotplug
>>>>
>>>> On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
>>>>>> How much noise is this going to cause on a big/little system that
>>>>>> constantly hot unplug/plugs processors all of the time?
>>>>>
>>>>> Can you explain more what kind of noise will be introduced on a big/little
>> system?
>>>>
>>>> Have you tested this on such a machine?
>>>>
>>>> I didn't have such kind of machine on hand.
>>>> Can anyone has such machine to verify it?
>>>> Thanks!
>>>
>>> I tested this on a ppc PowerVM system, using dlpar operations to
>>> remove/add cpus.
>>>
>>> Without this patch the cpu online nodes get out of sync with the main
>>> online node (and the actual state of the cpus), because they aren't
>>> updated as the cpus are brought up/down:
>>>
>>
>>> [root@br10p02 cpu]$ pwd
>>> /sys/devices/system/cpu
>>> [root@br10p02 cpu]$ cat online
>>> 0-39
>>> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
>>> -eq 1 && echo -n "$n " ; done ; echo ""
>>> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
>>> 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
>>
>> How is the issue reproduced.
>>
>> Here is a result on my x86 box with linux-3.18-rc1.
>>
>> - before offline CPU
>> # cd /sys/devices/system/cpu/
>> # cat online
>> 0-59
>> # for n in {0..59} ; do test $( cat cpu$n/online ) -eq 1 && echo -n "$n " ;
>> done ; echo ""
>> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
>> 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54
>> 55
>> 56 57 58 59
>>
>> - after offline CPU{1..59}
>> # for n in {1..59} ; do echo 0 > cpu$n/online; done # cat online
>> 0
>> # for n in {0..59} ; do test $( cat cpu$n/online ) -eq 1 && echo -n "$n " ;
>> done ; echo ""
>> 0
>>
>> It seems that dev->offline is set to correct valute.
>>
>

> Please use an in kernel governor to up / down a core instead of sysfs interface.

Thank you for the information. But I don't know the in kernel governor?
Could you point a documentation of it?

Thanks,
Yasuaki Ishimatsu

>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>>>
>>>
>>> While with the patch, the cpu online nodes are kept up to date as the
>>> cpus are brought up/down:
>>>
>>> [root@br10p02 cpu]$ pwd
>>> /sys/devices/system/cpu
>>> [root@br10p02 cpu]$ cat online
>>> 0-39
>>> [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
>>> -eq 1 && echo -n "$n " ; done ; echo ""
>>> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
>>> 27 28 29 30 31 32 33 34 35 36 37 38 39
>>>
>>>
>>> Feel free to add
>>>
>>> Tested-by: Dan Streetman <ddstreet@ieee.org>
>>>
>>>>
>>>>> As I know IKS on arm will use cpu_suspend way to power down a core.
>>>>
>>>> Are you sure that it also doesn't use that same functionality to drop a
>> processor to save power?
>>>>
>>>> As I know it use cpu_suspend to switch out a processor in IKS and there is
>> no cpu hotplug notifier in this procedure.
>>>>
>>>>
>>>> Why do you need/want this notification?  What are you going to do with this
>> information that you don't already have?
>>>>
>>>> The offline won't be updated if an in kernel hotplug governor plug in / out
>> a core which cause the sysfs interface report a wrong status.
>>>>
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>>
>>>> Best Regards,
>>>> Neil Zhang
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>
>
> Best Regards,
> Neil Zhang
> �{.n�+�������+%��lzwm��b�맲��r��zX���w��{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!�iO��z��v�^�m����nƊ��Y&�
>



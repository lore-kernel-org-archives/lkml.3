Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3CHKGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411Ab3CHKGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:06:50 -0500
Message-ID: <5139B82A.5030602@redhat.com>
Date: Fri, 08 Mar 2013 11:06:34 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130222 Thunderbird/17.0.3
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: LKML <linux-kernel@vger.kernel.org>, hmh@hmh.eng.br, joe@perches.com,
        isimatu.yasuaki@jp.fujitsu.com, rafael.j.wysocki@intel.com
Subject: Re: ACPI undocking on 3.8-rc5 no longer works with Lenovo T61
References: <5107A899.9080109@redhat.com> <51390B2B.6070500@redhat.com> <1362695426.12845.144.camel@misato.fc.hp.com>
In-Reply-To: <1362695426.12845.144.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 7.3.2013 23:30, Toshi Kani napsal(a):
> On Thu, 2013-03-07 at 22:48 +0100, Zdenek Kabelac wrote:
>> Dne 29.1.2013 11:46, Zdenek Kabelac napsal(a):
>>> Hi
>>>
>>> No exactly sure which patch did it - but when I'm now checking 3.8-rc5 kernel,
>>> I cannot use anymore this 'undock' command:
>>>
>>> echo 1 >/sys/devices/platform/dock.0/undock
>>>
>>> which works ok with 3.7 kernel - to properly undock my T61 before suspend.
>>>
>>>
>>> Dmesg shows this:
>>>
>>> [ 2657.087414] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: undocking
>>> [ 2658.613494] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>> [ 2658.613508] ata4.00: ST_FIRST: !(DRQ|ERR|DF)
>>> [ 2658.613522] sr 3:0:0:0: CDB:
>>> [ 2658.613530] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
>>> [ 2658.613583] ata4.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio
>>> 16392 in
>>>            res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
>>> [ 2658.613670] ata4: soft resetting link
>>> [ 2658.766888] ata4.00: NODEV after polling detection
>>> [ 2658.766900] ata4.00: revalidation failed (errno=-2)
>>>
>>>
>>> Here is boot log attached, my HW is Lenovo T61, C2D
>>>
>>
>>
>> I've run 'bisect'  and found out commit which has broken  'undock' support on
>> my Lenovo:
>>
>> commit 8ab0ab2570cfc48303e545944f53690a6983a898
>> Author: Toshi Kani <toshi.kani@hp.com>
>> Date:   Tue Oct 23 01:30:26 2012 +0200
>>
>>       ACPI: dock: Remove redundant ACPI NS walk
>>
>>       Combined two ACPI namespace walks, which look for dock stations
>>       and then bays separately, into a single walk.
>>
>>       Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>>       Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>       Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>>
>> After doin plain revert of this commit undock 'support' is back -
>> I've tested this with 3.9-rc1  (though on this kernel it seems wifi is
>> again horribly broken for now)
>>
>> Any idea about proper fix here ?
>
> Sorry for the trouble.  I suspect that your Lenovo has both doc station
> and battery bay.  Since the above patch combined HW scans for doc
> station and battery bay into a single scan, it may have changed
> instance# of the sysfs "dock.%d" files on your Lenovo.  You can verify
> the type by doing:
>
>    cat /sys/devices/platform/dock*/type
>
> dock.0 on your Lenovo likely shows as "battery_bay", which I think you
> cannot undock regardless of this patch.  Can you try to undock the one
> with "dock_station"?


Thanks - you are correct here - and I've not had though about that
before I've started bisect.

So while before this patch  dock.0 had type dock_station, it's now battery_bay 
and dock_station becomes dock.2 and I need to update my undocking script.

Zdenek


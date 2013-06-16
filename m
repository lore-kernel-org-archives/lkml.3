Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3FPQ1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 12:27:23 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52330 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3FPQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 12:27:20 -0400
Message-ID: <51BDE761.9080801@gmail.com>
Date: Mon, 17 Jun 2013 00:27:13 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <8220093.o4hXWiX0st@vostro.rjw.lan> <51BBC6FC.2020002@gmail.com> <8974656.5GmDyxHW7F@vostro.rjw.lan>
In-Reply-To: <8974656.5GmDyxHW7F@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 04:17 AM, Rafael J. Wysocki wrote:
> On Saturday, June 15, 2013 09:44:28 AM Jiang Liu wrote:
>> On Sat 15 Jun 2013 06:21:02 AM CST, Rafael J. Wysocki wrote:
[...]
>>> Can we please relax a bit and possibly take a step back?
>>>
>>> So since your last reply to me wasn't particularly helpful, I went through the
>>> code in dock.c and acpiphp_glue.c and I simply think that the whole
>>> hotplug_list thing is simply redundant.
>>>
>>> It looks like instead of using it (or the klist in this patch), we can add a
>>> "hotlpug_device" flag to dock_dependent_device and set that flag instead of
>>> adding dd to hotplug_devices or clear it instead of removing dd from that list.
>>>
>>> That would allow us to avoid the deadlock, because we wouldn't need the hp_lock
>>> any more and perhaps we could make the code simpler instead of making it more
>>> complex.
>>>
>>> How does that sound?
>>>
>>> Rafael
>> Hi Rafael,
>>        Thanks for comments! It would be great if we could kill the 
>> hotplug_devices
>> list so thing gets simple. But there are still some special cases:(
>>
>> As you have mentioned,  ds->hp_lock is used to make both addition and 
>> removal
>> of hotplug devices wait for us to complete walking ds->hotplug_devices.
>> So it acts as two roles:
>> 1) protect the hotplug_devices list,
>> 2) serialize unregister_hotplug_dock_device() and 
>> hotplug_dock_devices() so
>> the dock driver doesn't access registered handler and associated data 
>> structure
>> once returing from unregister_hotplug_dock_device().
> 
> When it returns from unregister_hotplug_dock_device(), nothing prevents it
> from accessing whatever it wants, because ds->hp_lock is not used outside
> of the add/del and hotplug_dock_devices().  So, the actual role of
> ds->hp_lock (not the one that it is supposed to play, but the real one)
> is to prevent addition/deletion from happening when hotplug_dock_devices()
> is running.  [Yes, it does protect the list, but since the list is in fact
> unnecessary, that doesn't matter.]
Hi Rafael,
With current implementation function dock_add_hotplug_device(),
dock_del_hotplug_device(), hotplug_dock_devices() and dock_event()
access hotplug_devices list, registered callback(ops) and associated
data(context).

Caller may free the associated data(context) once returned from function
unregister_hotplug_dock_device(), so the dock core shouldn't access the
data(context) any more after returning from
unregister_hotplug_dock_device(). With current implementation, this is
guaranteed by acquiring ds->hp_lock in function
dock_del_hotplug_device(). But there's another issue with current
implementation here, we should use ds->hp_lock to protect dock_event() too.

> 
>> If we simply use a flag to mark presence of registered callback, we 
>> can't achieve the second goal.
> 
> I don't mean using the flag *alone*.
> 
>> Take the sony laptop as an example. It has several PCI 
>> hotplug
>> slot associated with the dock station:
>> [   28.829316] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB
>> [   30.174964] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM0
>> [   30.174973] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM1
>> [   30.174979] acpiphp_glue: _handle_hotplug_event_func: Btus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2
>> [   30.174985] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GFXA
>> [   30.175020] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GHDA
>> [   30.175040] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC0.DLAN
>> [   30.175050] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC1.DODD
>> [   30.175060] acpiphp_glue: _handle_hotplug_event_func: Bus check 
>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC2.DUSB
>>
>> So it still has some race windows if we undock the station while 
>> repeatedly rescanning/removing
>> the PCI bus for \_SB_.PCI0.RP07.LPMB.LPM0 through sysfs interfaces. For 
>> example, thread 1 is
>> handling undocking event, walking the dependent device list and 
>> invoking registered callback
>> handler with associated data. While that, thread 2 may step in to 
>> unregister the callback for
>>  \_SB_.PCI0.RP07.LPMB.LPM0. Then thread 1 may cause access-after-free 
>> issue.
> 
> That should be handled in acpiphp_glue instead of dock.  What you're trying to
> do is to make dock work around synchronization issues in the acpiphp driver.
I'm not sure whether we could solve this issue from acpiphp_glue side.
If dock driver can't guarantee that it doesn't access registered
handler(ops) and associated data(context) after returning from
unregister_hotplug_dock_device(), it will be hard for acpiphp_glue to
manage the data structure(context). So I introduced a "put" method into
the acpi_dock_ops to help manage lifecycle of "context".

> 
>> The klist patch solves this issue by adding a "put" callback method to 
>> explicitly notify
>> dock client that the dock core has done with previously registered 
>> handler and associated
>> data.
> 
> Honestly, don't you think this is overly compilcated?
Yeah, I must admire that it's really a little over complicated, but I
can't find a simpler solution here:(

> 
> Rafael
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3AaHF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:05:27 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63942 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3AaHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:05:25 -0500
Message-ID: <510A17AF.6030906@openvz.org>
Date: Thu, 31 Jan 2013 11:05:19 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/5] e1000e: fix resuming from runtime-suspend
References: <20130118113019.6698.25941.stgit@zurg> <12263202.uQHxo0zU24@vostro.rjw.lan> <51076CEE.8050706@openvz.org> <1546399.qHCL89Xptv@vostro.rjw.lan>
In-Reply-To: <1546399.qHCL89Xptv@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, January 29, 2013 10:32:14 AM Konstantin Khlebnikov wrote:
>> Rafael J. Wysocki wrote:
>>> On Monday, January 28, 2013 04:05:33 PM Bjorn Helgaas wrote:
>>>> [+cc Rafael, author of patch you cited]
>>>>
>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
>>>> <khlebnikov@openvz.org>   wrote:
>>>>> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
>>>>> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
>>>>>
>>>>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>>>> Cc: e1000-devel@lists.sourceforge.net
>>>>> Cc: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
>>>>> Cc: Bruce Allan<bruce.w.allan@intel.com>
>>>>> ---
>>>>>    drivers/net/ethernet/intel/e1000e/netdev.c |   13 ++++++++-----
>>>>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> index fbf75fd..2853c11 100644
>>>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> @@ -5691,14 +5691,17 @@ static int e1000_runtime_suspend(struct device *dev)
>>>>>           struct pci_dev *pdev = to_pci_dev(dev);
>>>>>           struct net_device *netdev = pci_get_drvdata(pdev);
>>>>>           struct e1000_adapter *adapter = netdev_priv(netdev);
>>>>> +       int retval;
>>>>> +       bool wake;
>>>>>
>>>>> -       if (e1000e_pm_ready(adapter)) {
>>>>> -               bool wake;
>>>>> +       if (!e1000e_pm_ready(adapter))
>>>>> +               return 0;
>>>>>
>>>>> -               __e1000_shutdown(pdev,&wake, true);
>>>>> -       }
>>>>> +       retval = __e1000_shutdown(pdev,&wake, true);
>>>>> +       if (!retval)
>>>>> +               e1000_power_off(pdev, true, wake);
>>>>>
>>>>> -       return 0;
>>>>> +       return retval;
>>>>>    }
>>>>>
>>>>>    static int e1000_idle(struct device *dev)
>>>>>
>>>
>>> I'd like the changelog to say what the bug is and how it is being fixed in
>>> general terms.
>>
>> Ok, my bad.
>>
>> Problem: ethernet device does not work (no carrier signal).
>> Right after boot it goes to runtime-suspend and never wake up.
>>
>> Original code (before your commit) calls pci_prepare_to_sleep() and it
>> calls pci_enable_wake() and switches device to one of D3 state.
>
> The original code in what function?

Oh, I screwed up again. That commit adds support of runtime-pm,
so there is no original code. But runtime-pm in 'igb' works in this way:
igb_runtime_suspend() -> pci_prepare_to_sleep() -> pci_enable_wake()

>
>> It seems redundant, because pci_pm_runtime_suspend() do the same thing
>> after calling ->runtime_suspend callback. Or rather it did it before commit
>> 42eca2302146fed51335b95128e949ee6f54478f ("PCI: Don't touch card regs after
>> runtime suspend D3") and third patch aimed fix this damage.
>>
>> More over seems like calling pci_enable_wake() from e1000e isn't enough for my case,
>> because my enthernet cannot wakeup from runtime-suspend without third patch.
>
> Which third patch?

third patch in this patchset:
"[PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization"

>
>> Seems like it's because pci_enable_wake() and pci_finish_runtime_suspend()
>> calls different pratform-pm callbacks -- platform_pci_run_wake() /
>> platform_pci_sleep_wake().
>
> That's correct, for historical reasons.  We'll need to merge these things, but
> for now the are separate (because of the way ACPI handles system suspend and
> runtime PM).

Ok, I have not read yet all code and documentation. But it seems runtime-pm
engine needs some sort of runtime debug-mode which would warn about strange or
ineffective actions in drivers, probably just script for parsing kernel-log
and tracking states for all devices and buses.

>
> Thanks,
> Rafael
>
>


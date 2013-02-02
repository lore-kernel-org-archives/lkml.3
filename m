Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3BBMML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:12:11 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:47513 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3BBMMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:12:09 -0500
Message-ID: <510D0293.8030509@openvz.org>
Date: Sat, 02 Feb 2013 16:12:03 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend
 finalization
References: <20130118113019.6698.25941.stgit@zurg> <51077499.90602@openvz.org> <7488961.Q6GFlfgakd@vostro.rjw.lan> <2547462.dZlJyWsOdA@vostro.rjw.lan>
In-Reply-To: <2547462.dZlJyWsOdA@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, January 29, 2013 12:55:15 PM Rafael J. Wysocki wrote:
>> On Tuesday, January 29, 2013 11:04:57 AM Konstantin Khlebnikov wrote:
>>> Rafael J. Wysocki wrote:
>>>> On Monday, January 28, 2013 04:17:42 PM Bjorn Helgaas wrote:
>>>>> [+cc Rafael]
>>>>>
>>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
>>>>> <khlebnikov@openvz.org>   wrote:
>>>>>> This patch effectively reverts commit 42eca2302146fed51335b95128e949ee6f54478f
>>>>>> ("PCI: Don't touch card regs after runtime suspend D3")
>>>>>>
>>>>>> | This patch checks whether the pci state is saved and doesn't attempt to hit
>>>>>> | any registers after that point if it is.
>>>>>>
>>>>>> This seems completely wrong. Yes, PCI configuration space has been saved by
>>>>>> driver, but this doesn't means that all job is done and device has been
>>>>>> suspended and ready for waking up in the future.
>>>>>>
>>>>>> For example driver e1000e for ethernet in my thinkpad x220 saves pci-state
>>>>>> but device cannot wakeup after that, because it needs some ACPI callbacks
>>>>>> which usually called from pci_finish_runtime_suspend().
>>>>>>
>>>>>> | Optimus (dual-gpu) laptops seem to have their own form of D3cold, but
>>>>>> | unfortunately enter it on normal D3 transitions via the ACPI callback.
>>>>>>
>>>>>> Hardware which disappears from the bus unexpectedly is exception, so let's
>>>>>> handle it as an exception. Its driver should set device state to D3cold and
>>>>>> the rest code will handle it properly.
>>>>>
>>>>> Functions in D3cold don't have power, so it's completely expected that
>>>>> they would disappear from the bus and not respond to config accesses.
>>>>> Maybe Dave was referring to D3hot, where functions *should* respond to
>>>>> config accesses.  I dunno.
>>>>>
>>>>> Just to be clear, it sounds like 42eca230 caused a regression on your
>>>>> e1000e device?  If so, I guess we should revert it unless you and Dave
>>>>> can figure out a better patch that fixes both your e1000e device and
>>>>> the Optimus issue.
>>>>
>>>> Yes, if there's a regression, let's revert it, but I'd like the regression
>>>> to be described clearly.
>>>
>>> Yep, this is regression.
>>>
>>> commit 42eca2302146fed51335b95128e949ee6f54478f ("PCI: Don't touch
>>> card regs after runtime suspend D3") changes state convention during
>>> runtime-suspend transaction too much. If PCI configuration space
>>> has been saved by driver that does not means that all job is done
>>> and device has been suspended and ready for waking up in the future.
>>>
>>> e1000e saves pci-config space itself, but it requires operations which
>>> pci_finish_runtime_suspend() does: preparing for wake (calling particular
>>> platform pm-callbacks) and switching to proper sleep state.
>>
>> Well, I'd argue this is a bug in e1000e.  Why does it need to save the PCI
>> config space even though pci_pm_runtime_suspend() will do that anyway?
>
> I honestly don't think we should revert 42eca2302146 because of this.
>
> Yes, there is a requirement that drivers not save the PCI config space by
> themselves unless they want to do the whole power management by themselves too
> and e1000e is not following that.  So either we need to drop the
> pci_save_state() from __e1000_shutdown() which I would prefer (I'm not really
> sure why it is there), or e1000_runtime_suspend() needs to call
> pci_finish_runtime_suspend() by itself.

Yet another problem: some drivers calls pci_save_state() from ->probe() callback
to use this saved state in pci_error_handlers->slot_reset().
As result pdev->state_saved is true mostly all time.
At least e1000e and drivers/pci/pcie/portdrv_pci.c are doing this.

I think it will be safer to revert 42eca2302146 in v3.8

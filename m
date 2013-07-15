Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3GOIZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:25:18 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:64926 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3GOIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:25:15 -0400
Message-ID: <51E3B1E7.2080004@suse.cz>
Date: Mon, 15 Jul 2013 10:25:11 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Jiri Slaby <jirislaby@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e + suspend, 3.9-rc2
References: <20130311191936.GD5000@pd.tnic> <513E355C.4000204@gmail.com> <20130311202537.GF5000@pd.tnic> <20130312171745.GE5370@pd.tnic> <51483B1A.9090704@suse.cz> <51483DAA.7060806@openvz.org> <5148589E.8030509@suse.cz> <804857E1F29AAC47BF68C404FC60A1844D9F3062@ORSMSX103.amr.corp.intel.com> <516C1CE5.1080803@suse.cz> <51B8C8A8.9040900@suse.cz> <51B8E854.9040101@openvz.org> <51D72B7C.3040700@suse.cz>
In-Reply-To: <51D72B7C.3040700@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any ideas on this?

On 07/05/2013 10:24 PM, Jiri Slaby wrote:
> On 06/12/2013 11:29 PM, Konstantin Khlebnikov wrote:
>> Jiri Slaby wrote:
>>> On 04/15/2013 05:29 PM, Jiri Slaby wrote:
>>>> On 03/29/2013 07:04 PM, Allan, Bruce W wrote:
>>>>>> -----Original Message-----
>>>>>> From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
>>>>>> Sent: Tuesday, March 19, 2013 5:23 AM
>>>>>> To: Konstantin Khlebnikov
>>>>>> Cc: Borislav Petkov; Kirsher, Jeffrey T; Rafael J. Wysocki; Bjorn
>>>>>> Helgaas;
>>>>>> x86@kernel.org; lkml; e1000-devel@lists.sourceforge.net; Allan,
>>>>>> Bruce W
>>>>>> Subject: Re: e1000e + suspend, 3.9-rc2
>>>>>>
>>>>>>>>> Ok, I can still see the hardware error message when suspending:
>>>>>>>>
>>>>>>>> And with 3.8 plus these:
>>>>>>>>       PCI/PM: Clear state_saved during suspend
>>>>>>>>       e1000e: fix pci-device enable-counter balance
>>>>>>>>       e1000e: fix runtime power management transitions
>>>>>>>>       e1000e: fix accessing to suspended device
>>>>>>>>
>>>>>>>> I sometimes see this:
>>>>>>>> pci_pm_suspend():e1000_suspend +0x0/0x10 [e1000e] returns -2
>>>>>>>> dpm_run_callback(): pci_pm_suspend+0x0/0x140 returns -2
>>>>>>>> PM: Device 0000:00:19.0 failed to suspend async: error -2
>>>>>>>>
>>>>>>>> Any ideas? Am I missing some patch still?
>>>>>>>
>>>>>>> Try this:
>>>>>>> "PCI: Don't try to disable Bus Master on disconnected PCI devices"
>>>>>>> https://patchwork.kernel.org/patch/2271641/
>>>>>>>
>>>>>>> But I'm not sure, probably it is unrelated because this code works
>>>>>>> only (?)
>>>>>>> during shutdown/kexec sequences.
>>>>>>
>>>>>> I don't think it will help either. -2 here is -E1000_ERR_PHY from
>>>>>> e1000e_write_phy_reg_mdic if I'm looking correctly. I.e. MDIC not
>>>>>> ready
>>>>>> or unlike MDIC_ERROR.
>>>>>>
>>>>>> I think this happened after I put the link down and tried to suspend.
>>>>>>
>>>>>> -- 
>>>>>> js
>>>>>> suse labs
>>>>>
>>>>> Sorry for not replying sooner, for some reason some of this thread
>>>>> was filtered
>>>>> to my junk folder and I didn’t see it until now.
>>>>>
>>>>> Jiri, can you provide the output of 'lspci -s 00:19.0 -n -vv' and
>>>>> confirm the scenario
>>>>> in which the problem occurs?  Is this easily reproduced?
>>>>
>>>> Sorry about the late reply, I totally forgot about this. lspci output is
>>>> attached below. The scenario is not rigid as I'm not sure when exactly
>>>> this happens. It looks like I have to use power saving on that device.
>>>> And I don't need to use that device at all. Here is an excerpt from one
>>>> kernel boot modulo e1000e where the error occurred.
>>>>
>>>> e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic
>>>> conservative mode
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1)
>>>> 3c:97:0e:35:3d:dd
>>>> e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
>>>> e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>>> e1000e 0000:00:19.0: setting latency timer to 64
>>>> e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>>
>>> This still happens with 3.9.5 ...
>>>
>>> I don't use wired net at all. This usually happens after I enable power
>>> saving.
>>
>> I guess that '-2' is one of 'return -E1000_ERR_PHY',
>> but all that debug messages are omitted by default.
>>
>> Please enable CONFIG_DYNAMIC_DEBUG=y and mount debugfs, after that:
>> # echo module e1000e +p > /sys/kernel/debug/dynamic_debug/control
>> If it would be too verbose you can enable these messages more selective.\
> 
> Here we go at last:
> 
> e1000e 0000:00:19.0 eth0: Setting page 0x6020
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: Setting page 0x6020
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: failed to enable jumbo frame workaround mode
> e1000e 0000:00:19.0 eth0: Setting page 0x0
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: Setting page 0x0
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: Setting page 0x6020
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: Could not set Port Control page
> e1000e 0000:00:19.0 eth0: Setting page 0x6020
> e1000e 0000:00:19.0 eth0: MDI Write did not complete
> e1000e 0000:00:19.0 eth0: Could not set Port Control page
> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
> dpm_run_callback(): pci_pm_suspend+0x0/0x140 returns -2
> PM: Device 0000:00:19.0 failed to suspend async: error -2
> PM: Some devices failed to suspend
> 
>>>> 00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit
>>>> Network Connection [8086:1502] (rev 04)
>>>>          Subsystem: Lenovo Device [17aa:21f3]
>>>>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-
>>>> <TAbort-<MAbort->SERR-<PERR- INTx-
>>>>          Latency: 0
>>>>          Interrupt: pin A routed to IRQ 46
>>>>          Region 0: Memory at f2500000 (32-bit, non-prefetchable)
>>>> [size=128K]
>>>>          Region 1: Memory at f253b000 (32-bit, non-prefetchable)
>>>> [size=4K]
>>>>          Region 2: I/O ports at 5080 [size=32]
>>>>          Capabilities: [c8] Power Management version 2
>>>>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
>>>>          Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>>                  Address: 00000000fee00398  Data: 0000
>>>>          Capabilities: [e0] PCI Advanced Features
>>>>                  AFCap: TP+ FLR+
>>>>                  AFCtrl: FLR-
>>>>                  AFStatus: TP-
>>>>          Kernel driver in use: e1000e
>>>>
>>>>
>>>> thanks,
>>>>
>>>
>>>
>>
> 
> 


-- 
js
suse labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3HWMpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:45:52 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:51183 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3HWMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:45:50 -0400
Message-ID: <5217599C.3080707@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 14:46:20 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [sched_delayed] sched: RT throttling activated
References: <521722EE.70209@fold.natur.cuni.cz> <20130823100913.GQ31370@twins.programming.kicks-ass.net> <52173BBD.3050803@fold.natur.cuni.cz> <20130823110254.GU31370@twins.programming.kicks-ass.net> <521748FC.10809@fold.natur.cuni.cz> <20130823121004.GW31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130823121004.GW31370@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Fri, Aug 23, 2013 at 01:35:24PM +0200, Martin Mokrejs wrote:
> 
>> # ps -deo pid,cls,cmd | grep -e 'RR \[' -e 'FF \['
> 
> This explicitly only lists kernel threads; from your other comment:
> 
>> The shell/python tasks have 'TS' in place of the FF value in the second column
>> so I guess they are not requiring realtime responsiveness.
> 
> I'll assume you actually inspected the other tasks and found none.

Yes, the other (false) matches were in the third or latter columns so I wanted to match
just those true matches and cut&paste it. I admit, this is not a general-purpose
REGEXP and is misleading.

> 
>>     7  FF [migration/0]
>>    10  FF [watchdog/0]
>>    11  FF [watchdog/1]
>>    12  FF [migration/1]
>>    17  FF [migration/2]
>>    22  FF [migration/3]
> 
> The 'migration' threads only look like FIFO threads but they're secretly
> not and don't count to the limit. The watchdog threads shouldn't run
> much either.
> 
>>  2161  FF [irq/50-iwlwifi]
> 
> Oh a threaded interrupt, I presume you're not using "threadiqrs" since

Is that what you talk about?

CONFIG_IRQ_FORCED_THREADING=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y

> this is the only interrupt thread around and I see a
> 'request_threaded_irq()' call in
> drivers/net/wireless/iwlwifi/pcie/trans.c
> 
> And wow, why would that thing consume that much cpu. 
> 
> Johill, ever seen the iwlwifi interrupt go 'funny' and consume gobs of
> cpu-time?

I am not sure if I understand you but in case it helps somebody

Current values:

# cat /proc/interrupts 
           CPU0       CPU1       
  0:         23          0   IO-APIC-edge      timer
  1:         42          0   IO-APIC-edge      i8042
  8:         36          0   IO-APIC-edge      rtc0
  9:          3          0   IO-APIC-fasteoi   acpi
 12:     404650          0   IO-APIC-edge      i8042
 16:        109          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:     583646          0   IO-APIC-fasteoi   ehci_hcd:usb2
 40:          0          0   PCI-MSI-edge      pciehp
 41:      54319          0   PCI-MSI-edge      i915
 42:     553802          0   PCI-MSI-edge      ahci
 43:          0          0   PCI-MSI-edge      enp5s0
 44:     257268          0   PCI-MSI-edge      xhci_hcd
 45:          0          0   PCI-MSI-edge      xhci_hcd
 46:          0          0   PCI-MSI-edge      xhci_hcd
 47:          0          0   PCI-MSI-edge      xhci_hcd
 48:          0          0   PCI-MSI-edge      xhci_hcd
 49:     465462          0   PCI-MSI-edge      snd_hda_intel
 50:    3895788          0   PCI-MSI-edge      iwlwifi
NMI:       8687       9483   Non-maskable interrupts
LOC:   17531664   16978131   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:       8687       9483   Performance monitoring interrupts
IWI:     213009     205171   IRQ work interrupts
RTR:          3          0   APIC ICR read retries
RES:    1922651    4491695   Rescheduling interrupts
CAL:      73741     348678   Function call interrupts
TLB:      98634     111173   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:        286        286   Machine check polls
ERR:          0
MIS:          0

# ifconfig wlp9s0
wlp9s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.0.24  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::4e80:93ff:fe15:e6c7  prefixlen 64  scopeid 0x20<link>
        ether 4c:80:93:15:e6:c7  txqueuelen 1000  (Ethernet)
        RX packets 811806  bytes 992611146 (946.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 490006  bytes 71390887 (68.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# dmesg
...
[   11.789302] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   11.789310] Copyright(c) 2003-2013 Intel Corporation
[   11.791626] iwlwifi 0000:09:00.0: irq 50 for MSI/MSI-X
[   12.044905] iwlwifi 0000:09:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
[   13.896033] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   13.896041] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   13.896044] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   13.896047] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   13.896049] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_P2P disabled
[   13.896054] iwlwifi 0000:09:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
[   13.896173] iwlwifi 0000:09:00.0: L1 Disabled; Enabling L0S
[   13.917705] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'


> 
> 
>>> Nope, you get that message once to tell you that we throttle RT tasks.
>>
>> I think the message could improved to explain this is a warn ONCE message and
>> that there is no "[sched_delayed] sched: RT throttling deactivated" counterpart
>> message to be anticipated.
> 
> Would something like: 
> 
>   sched: [ONCE] RT throttle hit -- inspect system configuration.
> 
> Be a better message?

Not really. I would prefer something like:

[sched_delayed] sched: stopped running $cmd on CPU%d in favor of RR/FIFO task $psname

where the "$cmd" would be something like what "ps -deo pid,cls,cmd | grep -e RR -e FF" gives?

Still, I think when the interrupted task is ran again, a "counterpart" message should be logged.
Especially to see the timing between them could be helpful?

> 
> Also, could you clarify what exact kernel version you're running? I
> couldn't find it in your previous messages.


Vanilla 3.10.9, I thought it was in the very first message ...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3CROJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:09:04 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44183 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3CROJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:09:02 -0400
Message-ID: <51471FFB.6090005@acm.org>
Date: Mon, 18 Mar 2013 09:08:59 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux IPMI subsystem hang
References: <87ip4w2g2e.fsf@alice.fifthhorseman.net> <87vc8s7ap4.fsf@alice.fifthhorseman.net>
In-Reply-To: <87vc8s7ap4.fsf@alice.fifthhorseman.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 01:57 PM, Daniel Kahn Gillmor wrote:
> On Tue 2013-03-12 22:23:37 -0400, Daniel Kahn Gillmor wrote:
>
>> I am working with a Lenovo ThinkCentre M78, model 4865-A14, and it seems
>> to have trouble with the IPMI subsystem.
>>
>> udev seems to hang for about 3 minutes at startup, ultimately failing
>> with the following messages:
>>
>> udevd[416]: worker [495] unexpectedly returned with status 0x0100
>> udevd[416]: worker [495] failed while handling '/devices/pci0000:00/0000:00:15.2/0000:03:00.3'
>>
>> This hang happens whether i'm running linux kernel 3.2 or 3.8, using
>> either x86 or x86_64 kernels.
> trying with udev 175-7.1 (from debian unstable) and kernel 3.2, i see
> that the failure message is:
>
> udevd[548]: timeout: killing '/sbin/modprobe -b pci:v000010ECd0000816Csv000017AAsd00003089bc0Csc07i01' [623]
>
> and:
>
> [    5.650931] ipmi message handler version 39.2
> [    5.916958] IPMI System Interface driver.
> [    5.921153] ipmi_si 0000:03:00.3: probing via PCI
> [    5.925851] ipmi_si 0000:03:00.3: [io  0xe000-0xe0ff] regsize 1 spacing 1 irq 17
> [    5.933727] ipmi_si: Adding PCI-specified kcs state machine
> [    5.939554] ipmi_si: Trying PCI-specified kcs state machine at i/o address 0xe000, slave address 0x0, irq 17
> [  406.916061] ipmi_si: There appears to be no BMC at this location
>
> with kernel 3.8, the last line ("There appears to be no BMC at this
> location") isn't emitted, but the delay/hang with modprobe still
> happens.
>
> I think the first alias in ipmi_si.ko is what is causing this to be triggered:
>
> 0 krazy:~# modinfo ipmi_si | grep ^alias
> alias:          pci:v*d*sv*sd*bc0Csc07i*
> alias:          pci:v0000103Cd0000121Asv*sd*bc*sc*i*
> 0 krazy:~#
>
> since the bc0Csc07 matches the [0c07] identifier from lspci:
>
>> 03:00.3 IPMI SMIC interface [0c07]: Realtek Semiconductor Co., Ltd. Device [10ec:816c] (rev 01) (prog-if 01)
> It seems like there are four plausible cases:
>
>   0) this is actually an IPMI device, but the hardware is broken.
>
>   1) this is an IPMI device, but it does not implement some part of the
>      IPMI spec that ipmi_si.ko expects to be implemented, and ipmi_si.ko
>      cannot detect this cleanly.
>
>   2) this device is not an IPMI device at all, and is mislabeled in its
>      PCI identifiers somehow.
>
>   3) this device is not an IPMI device at all, it is properly labeled,
>      and the module's internal aliasing (and lspci's index?) is
>      overgeneral and misidentifies the device.
>
> How can i distinguish between these cases?

I would guess that the register spacing is wrong.  The spec has a 
protocol for determining register spacing, but according to the spec it 
only works for KCS interfaces.  Since this is a SMIC interface, it's not 
implemented.

You can hardcode values in ipmi_pci_probe_regspacing() in 
drivers/char/ipmi/ipmi_si_intf.c to see if that makes a difference. I'd 
guess 4, but it might be 16.  I can think about trying the protocol on 
SMIC, perhaps it will work there, too.

-corey

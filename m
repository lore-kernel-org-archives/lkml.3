Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3EQJWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:22:21 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:55885 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3EQJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:22:19 -0400
Message-ID: <5195F6C9.5050200@fold.natur.cuni.cz>
Date: Fri, 17 May 2013 11:22:17 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>, Robert Norris <robn@opera.com>,
        Daniel Kurtz <djkurtz@chromium.org>
CC: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com> <20130514231626.GA12961@pyro.melbourne.osa> <20130515112044.753bb7bb@endymion.delvare> <20130515112741.GA23766@pyro.melbourne.osa> <20130515214923.036dabdb@endymion.delvare> <20130516034455.GA19452@pyro.melbourne.osa> <20130517103622.5000d277@endymion.delvare>
In-Reply-To: <20130517103622.5000d277@endymion.delvare>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  while you are chasing some problem with i2c_801 I would like to mention
that I never got an answer on the thread https://lkml.org/lkml/2013/1/23/405
about a kmemleak reported by kernel . Maybe this could give you a hint?
If these do not overlap I would be anyways glad to receive an answer via
the original thread I have started.
Thank you,
Martin

Jean Delvare wrote:
> Hi Robert,
> 
> On Thu, 16 May 2013 13:44:55 +1000, Robert Norris wrote:
>> On Wed, May 15, 2013 at 09:49:23PM +0200, Jean Delvare wrote:
>>>>     Interrupt: pin B routed to IRQ 0
>>>
>>> Hmm, this "IRQ 0" is quite odd. I'm wondering if this could be the
>>> reason for this hang. Was it with the i2c-i801 driver loaded, or
>>> blacklisted? Please check if it makes a difference.
>>
>> That was without the driver loaded (blacklisted). After loading (with
>> interrupts enabled) we get:
>>
>>     Interrupt: pin B routed to IRQ 20
> 
> For the record, I also see the IRQ value change after loading the
> i2c-i801 driver on my system (with an ICH10 south bridge.) From 14 to
> 22 in my case. So it's a bit different (no IRQ 0) but not still
> somewhat similar, so I'm still not sure if this has anything to do with
> your issue.
> 
>>
>>> Do you see the same (and more generally, this issue) on one, some or
>>> all of your x3550 servers?
>>
>> The issue has occured on at least three x3550s (we have 11). I haven't
>> tested more, because knowingly crashing production machines sucks.
> 
> Yes of course, I understand, I did not expect you to do that ;) 
> 
>> This appears to be the case on other machines. With the module
>> blacklisted (never loaded), lspci shows IRQ 0. After load, IRQ 20.
>> (tested on 3.4 and 3.9).
> 
> OK.
> 
>>> Are you using IPMI on these machines?
>>
>> Yes, but only for monitoring/sensors, if that makes a difference.
> 
> IPMI is still likely to access the SMBus controller. If there's a BMC
> in the machine, it can also access the SMBus slave with its own
> controller. It would be good to rule this out by disabling IPMI
> completely, removing the BMC from the machine if it has one, and
> checking if it makes the issue go away or not.
> 
>>> I would appreciate if you could test the following:
>>> * Blacklist i2c-i801 and ics932s401 so that none of them get
>>>   auto-loaded.
>>
>> Done.
>>
>>> * Manually load i2c-i801 with interrupts enabled, and see what
>>>   happens.
>>
>> Returned immediately:
>>
>> [   60.527140] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> 
> This confirms that the i2c-i801 driver loading itself isn't the problem.
> 
>>> * If no hang happens, load i2c-dev, find the i801 bus number with
>>>   i2cdetect -l (from the i2c-tools package - it should be 4 according
>>>   to what you reported so far but there is no guarantee that it won't
>>>   change across reboots.)
>>
>> $ i2cdetect -l
>> i2c-0   i2c         Radeon i2c bit bus DVI_DDC          I2C adapter
>> i2c-1   i2c         Radeon i2c bit bus VGA_DDC          I2C adapter
>> i2c-2   i2c         Radeon i2c bit bus MONID            I2C adapter
>> i2c-3   i2c         Radeon i2c bit bus CRT2_DDC         I2C adapter
>> i2c-4   smbus       SMBus I801 adapter at 0440          SMBus adapter
>>
>>> Then do a simple read from a random address
>>>   with:
>>>   # i2cget 4 0x50 0x00
>>>   (Adjust the bus number as needed.)
>>>   I am curious if this will hang as well or only when accessing the
>>>   clock chip at address 0x69.
>>
>> Yep, that one hangs. The hung task handler picked it up after a few
>> minutes.
> 
> OK, this means that any transaction request to the SMBus controller
> causes the hang.
> 
> The i2c-i801 driver is optimistically using wait_event() when waiting
> for an interrupt to arrive. I suppose that the interrupt is never
> delivered in your case (all 0 in /proc/interrupts.)
> 
> Daniel, shouldn't we use wait_event_timeout() instead to catch issues
> like this and fail cleanly? Maybe even fallback to polling
> automatically?
> 

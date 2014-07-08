Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaGHM2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:28:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbaGHM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:28:31 -0400
Message-ID: <53BBE3D6.40307@ti.com>
Date: Tue, 8 Jul 2014 17:58:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <53BA82A4.5070104@ti.com> <53BA86AB.8050603@itdev.co.uk>
In-Reply-To: <53BA86AB.8050603@itdev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2014 05:08 PM, Nick Dyer wrote:
> On 07/07/14 12:21, Sekhar Nori wrote:
>> I was unable to get the touchscreen working on my board after applying 
>> just these patches. It does work correctly with your for-next branch so 
>> I guess I need to wait for you to post the rest of your patches too.
>>
>> Here are the relevant messages at boot. Full boot log is available here 
>> (in case you want to have a look): http://paste.ubuntu.com/7759703/
>>
>> [    2.315717] atmel_mxt_ts 0-004a: Direct firmware load failed with error -2
>> [    2.322949] atmel_mxt_ts 0-004a: Falling back to user helper
>> [    5.934924] atmel_mxt_ts 0-004a: Wait for completion timed out.
>> [    5.941237] atmel_mxt_ts 0-004a: Warning: Info CRC error - device=0x000000 file=0x8EE45C
>> [    7.294769] atmel_mxt_ts 0-004a: Wait for completion timed out.
>> [    7.300976] atmel_mxt_ts 0-004a: Resetting chip
>> [   10.574729] atmel_mxt_ts 0-004a: Wait for completion timed out.
>> [   10.581010] atmel_mxt_ts 0-004a: Error -110 updating config
>> [   10.626788] atmel_mxt_ts 0-004a: Family: 128 Variant: 1 Firmware V1.6.AB Objects: 17
>>
>> One key difference is that these patches try to load the config at 
>> probe where as with your -next branch that is avoided in the DT case. 
>> This is also missing the new update_cfg sysfs interface (which I guess 
>> you will post as follow-on patches).
>>
>> The wait_for_completion() times out because the interrupt never 
>> arrives. Even later when testing using evtest, I do not see interrupts 
>> coming. There are only two interrupts that arrive during boot and it 
>> stays that way. There is something going on with the way interrupts are 
>> handled. I havent debugged further yet. This problem is not there with 
>> your for-next branch.
> 
> Thanks for trying this, apologies that it didn't work.
> 
> Looking at it, I've a feeling that this is the solution for the issue you see:
> https://github.com/ndyer/linux/commit/4e8f8d56361b09a2a

Okay, I rebased that patch onto this series, but it did not solve the 
problem.

> 
> Although, the fact that it says the device is reporting the Info CRC to be
> 0x000000 is rather odd, as well.

Thats because the device was not configured at factory (I was using the
board for the first time). Once I run the kernel from your for-next branch,
this messages disappear since I guess the configuration is successfully
flashed by that kernel.

> It would be useful if you could turn on all the debug in the driver and
> re-test (#define DEBUG 1 at the top). However, if you don't have time, I
> will try and reproduce on my test system.

Here are the messages I see:

[    2.257611] atmel_mxt_ts 0-004a: T5 Start:242 Size:9 Instances:1 Report IDs:0-0
[    2.265261] atmel_mxt_ts 0-004a: T6 Start:251 Size:6 Instances:1 Report IDs:1-1
[    2.272966] atmel_mxt_ts 0-004a: T38 Start:257 Size:8 Instances:1 Report IDs:0-0
[    2.280726] atmel_mxt_ts 0-004a: T7 Start:265 Size:3 Instances:1 Report IDs:0-0
[    2.288389] atmel_mxt_ts 0-004a: T8 Start:268 Size:8 Instances:1 Report IDs:0-0
[    2.296045] atmel_mxt_ts 0-004a: T9 Start:276 Size:31 Instances:1 Report IDs:2-11
[    2.303905] atmel_mxt_ts 0-004a: T15 Start:307 Size:11 Instances:1 Report IDs:12-12
[    2.311935] atmel_mxt_ts 0-004a: T18 Start:318 Size:2 Instances:1 Report IDs:0-0
[    2.319695] atmel_mxt_ts 0-004a: T19 Start:320 Size:16 Instances:1 Report IDs:13-13
[    2.327723] atmel_mxt_ts 0-004a: T20 Start:336 Size:12 Instances:1 Report IDs:14-14
[    2.335732] atmel_mxt_ts 0-004a: T22 Start:348 Size:17 Instances:1 Report IDs:15-15
[    2.343761] atmel_mxt_ts 0-004a: T23 Start:365 Size:15 Instances:1 Report IDs:16-16
[    2.351789] atmel_mxt_ts 0-004a: T24 Start:380 Size:19 Instances:1 Report IDs:17-20
[    2.359812] atmel_mxt_ts 0-004a: T25 Start:399 Size:14 Instances:1 Report IDs:21-21
[    2.367844] atmel_mxt_ts 0-004a: T27 Start:413 Size:7 Instances:1 Report IDs:22-22
[    2.375763] atmel_mxt_ts 0-004a: T28 Start:420 Size:6 Instances:1 Report IDs:23-23
[    2.383705] atmel_mxt_ts 0-004a: T37 Start:112 Size:130 Instances:1 Report IDs:0-0
[    2.401277] atmel_mxt_ts 0-004a: T6 Config Checksum: 0x6BC1AB
[    2.407301] atmel_mxt_ts 0-004a: T6 Status 0x90 RESET CAL
[    2.413026] atmel_mxt_ts 0-004a: T6 Status 0x00 OK
[    2.424854] atmel_mxt_ts 0-004a: Direct firmware load failed with error -2
[    2.462113] atmel_mxt_ts 0-004a: Falling back to user helper
[    5.698524] atmel_mxt_ts 0-004a: Initialized power cfg: ACTV 255, IDLE 32
[    5.712014] atmel_mxt_ts 0-004a: Touchscreen size X799Y479
[    5.742180] atmel_mxt_ts 0-004a: Family: 128 Variant: 1 Firmware V1.6.AB Objects: 17

Full testing log here: http://paste.ubuntu.com/7765352/

Thanks,
Sekhar


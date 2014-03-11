Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaCKG7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:59:24 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:52168 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbaCKG7W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:59:22 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -4.4
X-Spam-Languages: en
Message-ID: <531EB444.4090406@topic.nl>
Date: Tue, 11 Mar 2014 07:59:16 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Suneel Garapati <suneel.garapati@xilinx.com>,
        Soren Brinkmann <sorenb@xilinx.com>, Michal Simek <michals@xilinx.com>
CC: git <git@xilinx.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
References: <1394449954-10797-1-git-send-email-mike.looijmans@topic.nl> <20140310215952.GF13293@xsjandreislx> <b6f0755f-cfc9-4962-851f-5eeac767e93e@AM1EHSMHS008.ehs.local>
In-Reply-To: <b6f0755f-cfc9-4962-851f-5eeac767e93e@AM1EHSMHS008.ehs.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 03/11/2014 05:49 AM, Suneel Garapati wrote:
> Hi Mike/Soren,
>
>> 

Met vriendelijke groet / kind regards,

Mike Looijmans

TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

-----Original Message-----
>> From: Sören Brinkmann [mailto:soren.brinkmann@xilinx.com]
>> Sent: Tuesday, March 11, 2014 03:30
>> To: Mike Looijmans; Michal Simek
>> Cc: git; wsa@the-dreams.de; linux-i2c@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
>>
>> Hi Mike,
>>
>> The cadence driver is not in mainline yet. I think for our vendor tree we can
>> pretty much take it this way.
>> Regarding getting this into mainline, I'll send another iteration of the change
>> set and include these changes.
>>
>> On Mon, 2014-03-10 at 12:12PM +0100, Mike Looijmans wrote:
>>> Pressing CTRL-C while communicating with an I2C device leads to
>>> erratic behaviour. The cause is that the controller will interrupt the
>>> I2C transfer in progress, and leave the client device in an undefined
>>> state. Many drivers do not handle error return codes on I2C transfers.
>>> The calling driver has no way of telling how much of the transfer has
>>> actually completed, so it cannot reliably determine the device's state.
>>>
>>> The best solution here is to not handle signals in the I2C bus driver
>>> at all, but always complete a transaction before returning control.
>>>
>>> See for a related patch and discussion on this topic:
>>> http://lkml.org/lkml/2014/1/9/246
>>
>> Can we get your Signed-off-by, please?

Sure, I forgot the -s, will add it in the next version.

>>
>>> ---
>>>   drivers/i2c/busses/i2c-cadence.c |   12 ++++--------
>>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-cadence.c
>>> b/drivers/i2c/busses/i2c-cadence.c
>>> index 86713d6..32ce2ee 100644
>>> --- a/drivers/i2c/busses/i2c-cadence.c
>>> +++ b/drivers/i2c/busses/i2c-cadence.c
>>> @@ -452,16 +452,12 @@ static int cdns_i2c_process_msg(struct cdns_i2c
>> *id, struct i2c_msg *msg,
>>>                      cdns_i2c_msend(id);
>>>
>>>              /* Wait for the signal of completion */
>>> -           ret = wait_for_completion_interruptible_timeout(
>>> -                                                   &id->xfer_done, HZ);
>>> -           if (ret < 1) {
>>> +           ret = wait_for_completion_timeout(&id->xfer_done, HZ);
>>> +           if (ret == 0) {
>>
>> To match the style used throughout the file this should just be
>>        if (!ret) {

Will do.

> Instead of discarding Ctrl+C, Can we wait until the current msg transfer completes
> [to avoid client undefined state or re-init the host to a known state]
>
> I see da-vinci driver handling in a similar way.

My patch for the davinci should have completely ignored the signals too. I 
haven't come across a driver that actually calls the xfer function with more 
than one item anyway. If drivers check the result of the xfer at all, they 
usually don't have a clue how to handle partial transfers. Many drivers just 
ignore the return code completely and don't even report failure.

The gain is a stable I2C system. The loss here is something like <1ms more 
latency to interrupt a process in the case it was just transferring I2C data. 
 From experience I can tell that the gain far outweighs that loss.

Mike.



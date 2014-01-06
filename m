Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaAFVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:44:25 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59852 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaAFVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:44:24 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-f2-52cb23b55375
Message-id: <52CB23B2.6070506@samsung.com>
Date: Mon, 06 Jan 2014 14:44:18 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rjw@rjwysocki.net, shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2 1/3] drivers/bus: Add Legacy PM OPS usage check and
 warning to bus_register()
References: <cover.1389034060.git.shuah.kh@samsung.com>
 <1b1d24cd7140784f96b9d1fee9cace9da04a88f5.1389034060.git.shuah.kh@samsung.com>
 <20140106201755.GA7339@kroah.com> <52CB1267.1000502@samsung.com>
 <20140106212954.GA4580@kroah.com>
In-reply-to: <20140106212954.GA4580@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9hP92tyqeDDE6sE7VoXryezeLyrjls
	FmdOX2K1+PrTwYHFY+esu+we++euYffYcrWdxePzJrkAligum5TUnMyy1CJ9uwSujF9rJAoW
	iFW8fv2UqYHxtWAXIyeHhICJRM/+JjYIW0ziwr31QDYXh5DAMkaJqaevskI4vUwSOyauh3I2
	Mkp037/HCNLCK6Al0f9pIVg7i4CqxIvWPmYQm01AXeLz6x3sILaQgJxE05LVYHFRgQiJV2cn
	skD0Ckr8mHwPzBYR0JB4efQWmM0skCvx5HUT2HxhgTSJT1NWQp30nlHi654PTF2MHBycAnoS
	7z4zQ9RbS6yctI0RwpaX2LzmLTPEXmWJP5dPgZVLCChKbF9tNYFRZBaSzbOQdM9C0r2AkXkV
	o1hpcXJBcVJ6aoWhXnFibnFpXrpecn7uJkZIdFTtYLzz1eYQowAHoxIP74u9p4KEWBPLiitz
	DzFKcDArifCKKJ0OEuJNSaysSi3Kjy8qzUktPsTIxMEp1cAofTvjT+SbL9LK7Ac259h91NB7
	6zi5u6jjdFoDz17OH1dMZ98SEX+Wq642cQ4j3359i6n5zA0sp1YtCjK6sb19R+uDY5bsZtNf
	3bFsSbDjVcuPMV1QJWBzVvJ5S2Do37PNrE/sJy2N+SB9J5X35lm/5VdFk33eiEaKHK0JPsz2
	71XdsqXN6w4osRRnJBpqMRcVJwIAgBjHYGwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 02:29 PM, Greg KH wrote:
> On Mon, Jan 06, 2014 at 01:30:31PM -0700, Shuah Khan wrote:
>> On 01/06/2014 01:17 PM, Greg KH wrote:
>>> On Mon, Jan 06, 2014 at 01:03:21PM -0700, Shuah Khan wrote:
>>>> Add Legacy PM OPS usage checks to bus_register() function. If Legacy PM OPS
>>>> usage is found, print warning message to indicate that the driver code needs
>>>> updating to use Dev PM OPS interfaces. This will help serve as a way to track
>>>> drivers that still use Legacy PM OPS and fix them.
>>>>
>>>> The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
>>>> resume(struct device *) bus level interfaces.
>>>>
>>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>>> ---
>>>>   drivers/base/bus.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
>>>> index 73f6c29..e8753a7 100644
>>>> --- a/drivers/base/bus.c
>>>> +++ b/drivers/base/bus.c
>>>> @@ -916,6 +916,9 @@ int bus_register(struct bus_type *bus)
>>>>   		goto bus_groups_fail;
>>>>
>>>>   	pr_debug("bus: '%s': registered\n", bus->name);
>>>> +	if (bus->suspend || bus->resume)
>>>> +		pr_warn("bus '%s' needs updating - use pm pointer.\n",
>>>> +			bus->name);
>>>
>>> Why can't we just sweep the tree for all of these now, fix them up, and
>>> then delete these fields and be done with it?
>>>
>>> Same for the other ones, putting warnings in the kernel log files
>>> doesn't work at all for getting people to fix up their code (see
>>> examples of scsi log messages being there for _years_ about obsolete
>>> driver interfaces being used.)
>>
>> This change is not a simple case of replacing legacy with pm ops. I have
>> been working on changing drivers that use legacy, in some cases it is an
>> easy change, however in some cases it requires adding new interfaces to port
>> over from legacy to pm ops. Legacy suspend/resume is more course grain and
>> pm ops offer fine grain control over suspend, hibernate etc. Also it has
>> been a challenge without the hardware to test.
>>
>> My thinking is adding warning might get the attention of individual driver
>> owners.
>
> If it's not a trivial change, and takes a lot of work by someone who
> knows this type of thing (i.e. you), then I wouldn't start making kernel
> log warnings about this, it's just going to annoy a bunch of people :)

ok I will continue fixing the drivers. :)

>
> Again, see the SCSI log warnings for examples of this, people just tune
> them out, assuming someone else is going to fix the issue, someday.  And
> that someday never comes...
>

Yeah. Warnings could just get ignored.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

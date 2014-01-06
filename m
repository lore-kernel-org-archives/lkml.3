Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaAFUai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:30:38 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:47547 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaAFUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:30:35 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-ed-52cb1269fa4e
Message-id: <52CB1267.1000502@samsung.com>
Date: Mon, 06 Jan 2014 13:30:31 -0700
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
 <20140106201755.GA7339@kroah.com>
In-reply-to: <20140106201755.GA7339@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9hX90sodNBBi+CLZoXr2ezuLxrDpvF
	mdOXWC2+/nRwYPHYOesuu8f+uWvYPbZcbWfx+LxJLoAlissmJTUnsyy1SN8ugSvjxsdNrAUv
	BCqWdU9jbGDcw9vFyMkhIWAisWflW3YIW0ziwr31bCC2kMAyRomXDfxdjFxAdi+TxOEjMxgh
	EhsZJS780AGxeQW0JKYfecYMYrMIqEq0bOhgAbHZBNQlPr/ewQ5RLyfRtGQ1WI2oQITEq7MT
	WSB6BSV+TL4HZosIaEi8PHoLzGYWyJV48roJbJewQJrEpykr2SCOWMMo0bH7LStIglNAT6J5
	4RVmiAZriZWTtjFC2PISm9e8ZYZYrCzx5/Ippi5GDqDPFCW2r7aawCgyC8nqWUi6ZyHpXsDI
	vIpRrLQ4uaA4KT21wlivODG3uDQvXS85P3cTIyQ2anYw3vtqc4hRgINRiYf3xd5TQUKsiWXF
	lbmHGCU4mJVEeGdwnQ4S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGhg6c1Q3OD7f6VZkfnSm84z
	F6eKLlWbnl1Xn+r7PpX/yePclVO3m+WwH3z3/4Sg5V3zCjv2H4eWXD3fP+sqB3vJBfbYGrPK
	0ujo/w92c1tLbDV2OhnOIWA7Q3wBtzK/44uqaqdVy7WDSoIdjsWXRekK5YaYGFXHdXyOuds5
	e0f4LJOiTW8PKbEUZyQaajEXFScCAB/mD8RrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 01:17 PM, Greg KH wrote:
> On Mon, Jan 06, 2014 at 01:03:21PM -0700, Shuah Khan wrote:
>> Add Legacy PM OPS usage checks to bus_register() function. If Legacy PM OPS
>> usage is found, print warning message to indicate that the driver code needs
>> updating to use Dev PM OPS interfaces. This will help serve as a way to track
>> drivers that still use Legacy PM OPS and fix them.
>>
>> The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
>> resume(struct device *) bus level interfaces.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/base/bus.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
>> index 73f6c29..e8753a7 100644
>> --- a/drivers/base/bus.c
>> +++ b/drivers/base/bus.c
>> @@ -916,6 +916,9 @@ int bus_register(struct bus_type *bus)
>>   		goto bus_groups_fail;
>>
>>   	pr_debug("bus: '%s': registered\n", bus->name);
>> +	if (bus->suspend || bus->resume)
>> +		pr_warn("bus '%s' needs updating - use pm pointer.\n",
>> +			bus->name);
>
> Why can't we just sweep the tree for all of these now, fix them up, and
> then delete these fields and be done with it?
>
> Same for the other ones, putting warnings in the kernel log files
> doesn't work at all for getting people to fix up their code (see
> examples of scsi log messages being there for _years_ about obsolete
> driver interfaces being used.)

This change is not a simple case of replacing legacy with pm ops. I have 
been working on changing drivers that use legacy, in some cases it is an 
easy change, however in some cases it requires adding new interfaces to 
port over from legacy to pm ops. Legacy suspend/resume is more course 
grain and pm ops offer fine grain control over suspend, hibernate etc. 
Also it has been a challenge without the hardware to test.

My thinking is adding warning might get the attention of individual 
driver owners.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

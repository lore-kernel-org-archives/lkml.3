Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbbASJbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:31:40 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38713 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbASJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:31:37 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ea-54bccef65dd3
Date: Mon, 19 Jan 2015 10:31:22 +0100 (CET)
From: Paul Osmialowski <p.osmialowsk@samsung.com>
X-X-Sender: p.osmialowsk@AMDC1262.digital.local
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, p.osmialowsk@samsung.com
Subject: Re: [RFC 2/3] regmap: Use the enhancement of i2c API to address
 circular dependency problem
In-reply-to: <20150116183635.GH3856@sirena.org.uk>
Message-id: <alpine.DEB.2.10.1501191031080.13777@AMDC1262.digital.local>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
 <20150116162314.GB3856@sirena.org.uk>
 <alpine.DEB.2.10.1501161811280.21618@AMDC1262.digital.local>
 <20150116183635.GH3856@sirena.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xy7rfzu0JMXiwWMVi6sMnbBZPDrQz
	WjQvXs9m0f/4NbPFwrYlLBYdf78wWlzeNYfNYsb5fUwWE94cYLZYeWIWswOXx6ZVnWwe++eu
	YfdY3DeZ1aNvyypGj5OnnrB4fN4kF8AWxWWTkpqTWZZapG+XwJVx/NhuloKrchWbt59namB8
	L9HFyMkhIWAicfn/FUYIW0ziwr31bF2MXBxCAksZJe4t/ckO4XxklLjw9A0TSBWLgLbEroZ2
	sA42AUOJm/8PQ3XrS/z89ZAdxBYRUJa4+n0vC0gzs8B6JomDc94CORwcwgJpEs+OG4PUcAoY
	Sbw+eIgNxOYV8JB4d6ORCWLZFCaJRR//gy0TFdCVOPTvD1SRoMSPyfdYQGxmAUuJnjMrmCYw
	CsxCkpqFJLWAkWkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkjgf9nBuPiY1SFGAQ5GJR5e
	jZw9IUKsiWXFlbmHGCU4mJVEePnWA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw9vVlZX5kYFbZ
	O3OOVZmBXa3TLNnUrntz48vnKpZP/aDyKKhJ9nHqk6ndIX/OfFctjp75QVu77O2560ppfK8d
	BL7bfLy2zPUqU0ok/7LGRXutNyxdIXPdbva6Kl7HOHnFyV1z/+R9t+No/n0l/ptlxZe2e+c4
	3m5ltlJVinHRf1mq/CbI8maxEktxRqKhFnNRcSIAutB/eVoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Jan 2015, Mark Brown wrote:

> On Fri, Jan 16, 2015 at 06:36:14PM +0100, Paul Osmialowski wrote:
>> On Fri, 16 Jan 2015, Mark Brown wrote:
>
>>> I don't know what this means, sorry.  I'm also very worried about the
>>> fact that this is being discussed purely in terms of I2C - why would
>>> this not affect other buses?
>
>> I tried to open some gate for further extension to any bus that is used for
>> regmap communications. Currently it goes down to regmap-i2c.c since I
>> enhanced i2c API for this. Anyone who feels it is useful or saves oneself
>> from locking troubles can voluntarily adapt other regmap-i2c.* places (as
>> needed?).
>
>> My whole point is that I proposed a way to solve nasty deadlock which is
>> better to fix than just leave as it is. I got a feeling that situation I
>> adressed here may occur others too, so I proposed this extension that allows
>> future adaptations. I don't expect it to be accepted easily (i.e. I'm new
>> here and have mixed feelins about proposing changes that go so far),
>> therefore I prepared other solution for this particular deadlock that occurs
>> on this particular device.
>
> What I'm saying is that I want to understand this change from a point of
> view that isn't tied to I2C - at the regmap level what is this doing,

>From the regmap point of view, it allows its functions to have a chance to 
prepare transfer medium for (synchronous) transfer (no matter what bus 
handles it) before it actually start to happen (then unprepare it when 
it's done) and crucially before any lock is obtained in functions like 
regmap_write(), regmap_read() or regmap_update_bits.

Maybe adding a pair of callbacks (map->reg_write_sync_prepared(), 
map->reg_read_sync_prepared()) would make situation clearer.

> I2C is a bus that has some properties which you're saying needs some
> changes, what are those properties and those changes?

I'm not saying I2C as a bus requires changes. What I'm saying is that I2C 
API can be extended to allow more detailed control on what happens with 
the transfer.

>
>>>> +	void (*reg_unprepare_sync_io)(void *context);
>
>>> The first question here is why this only affects synchronous I/O or
>>> alternatively why these operations have _sync in the name if they aren't
>>> for synchronous I/O.
>
>> IMHO this whole idea is against asynchronous I/O.
>
> Can you be more specific please?  If something needs preparing it seems
> like it'd need preparing over an async transaction just as much as over
> a synchronous one.
>

Even with those preparation and unpreparation stages, this transfer is 
still synchronous. For example, it starts when regmap_read() starts and 
ends when regmap_read() ends. Nothing is queued or deferred. Namely, when 
max_gen_clk_unprepare() function calls regmap_update_bits() it expects 
that when regmap_update_bits() returned, no outstanding transfer are 
happening nor waiting to proceed. Everything must be completed before 
returning to max_gen_clk_unprepare().

>>>> +	if (bus) {
>>>> +		map->reg_prepare_sync_io = regmap_bus_prepare_sync_io;
>>>> +		map->reg_unprepare_sync_io = regmap_bus_unprepare_sync_io;
>>>> +	}
>
>>> Why are we using these indirections instead of assigning the operation
>>> directly?  They...
>
>> I followed the pattern used throughout this file.
>
> Not in this pattern where the caller needs to check too.
>

I don't persist on that. Apparently, you're the author of this file, 
though regmap_init() function was later expanded by other guys. They never 
assigned bus callback function pointers directly to map operation 
callbacks. It is possible to replace 'map->reg_prepare_sync_io = 
regmap_bus_prepare_sync_io' with 'map->reg_prepare_sync_io = 
map->bus->prepare_sync_io' - this will compile and this will work 
properly. But IMHO it wouldn't match with what the others did.

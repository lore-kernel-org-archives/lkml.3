Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbbATLOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:14:52 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32437 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbbATLOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:14:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-11-54be38a75459
Date: Tue, 20 Jan 2015 12:14:31 +0100 (CET)
From: Paul Osmialowski <p.osmialowsk@samsung.com>
X-X-Sender: p.osmialowsk@AMDC1262.digital.local
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC 2/3] regmap: Use the enhancement of i2c API to address
 circular dependency problem
In-reply-to: <20150119192557.GI2809@sirena.org.uk>
Message-id: <alpine.DEB.2.10.1501201214200.8428@AMDC1262.digital.local>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
 <20150116162314.GB3856@sirena.org.uk>
 <alpine.DEB.2.10.1501161811280.21618@AMDC1262.digital.local>
 <20150116183635.GH3856@sirena.org.uk>
 <alpine.DEB.2.10.1501191031080.13777@AMDC1262.digital.local>
 <20150119192557.GI2809@sirena.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7rLLfaFGBw8Imgx9eETNosnB9oZ
	LZoXr2ez6H/8mtliYdsSFouOv18YLS7vmsNmMeP8PiaLlSdmMTtwemxa1cnmsX/uGnaPxX2T
	WT1OnnrC4vF5k1wAaxSXTUpqTmZZapG+XQJXxuIPW9gLGlQrLj/8x9LAOFOui5GTQ0LARGJD
	33cmCFtM4sK99WxdjFwcQgJLGSVevr3DAuF8ZJR4+mouaxcjBweLgLbE1J0OIA1sAoYSN/8f
	ZoRo1pf4+eshO4gtIqAscfX7XrBeZoGpTBKNf5exg/QKC6RJPDtuDFLDKWAkMaNvM1gvr4C7
	xIPeu8wQu34zSazd9QJskKiArsShf3/YIIoEJX5MvscCYjMLWEr0nFnBNIFRYBaS1CwkqQWM
	TKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQkL86w7GpcesDjEKcDAq8fCecN4bIsSaWFZc
	mXuIUYKDWUmEt0diX4gQb0piZVVqUX58UWlOavEhRiYOTqkGxjkFL1vD/1yKz3ru/9vSoTSl
	8PKdzxe6S88LnX/sl6b65NuXx9JKxvtl/+jbBTRE5l3SZxKpEngRm2bCGqk+c0Znd8V1xy/N
	i88HKsZ/cDpYfM/plHobH0esRC3Xqs8LJXY15+vnTNH+NGNj+809JZx+hbyzNnIuP9e8uyJ4
	2+5Xil/+FAj9UmIpzkg01GIuKk4EAH5wS4pPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Jan 2015, Mark Brown wrote:

> On Mon, Jan 19, 2015 at 10:31:22AM +0100, Paul Osmialowski wrote:
>> On Fri, 16 Jan 2015, Mark Brown wrote:
>
>>> What I'm saying is that I want to understand this change from a point of
>>> view that isn't tied to I2C - at the regmap level what is this doing,
>
>> From the regmap point of view, it allows its functions to have a chance to
>> prepare transfer medium for (synchronous) transfer (no matter what bus
>> handles it) before it actually start to happen (then unprepare it when it's
>> done) and crucially before any lock is obtained in functions like
>> regmap_write(), regmap_read() or regmap_update_bits.
>
> OK, so that's what should go in the changelog (along with an explanation
> of why this preparation is required at all) - but I still don't see the
> async bit of this I'm afraid.
>

I don't think preparation stage should be exposed for asynchronous 
transfer. Due to its nature, it shouldn't cause circular lock dependency 
as we can observe for synchronous io. Since i2c does not support async 
transfer anyway (so (map->async && map->bus->async_write) will be always 
false for i2c transfers), let's use spi as an example.

With spi we have curious situation where both sync and async are handled 
by the same __spi_async() function, though for sync transfer 
wait_for_completion() is called soon after __spi_async() in order to 
ensure that transfer is completed.

Actual transfer is handled by spi_transfer_one_message() called from 
spi_pump_messages(). Note that spi_pump_message() before it calls 
spi_transfer_one_message() also calls prepare_message() callback (if 
provided):

 	if (master->prepare_message) {
 		ret = master->prepare_message(master, master->cur_msg);

So we have some candidate to expose if we would like to modify 
regmap-spi.c similarly to regmap-i2c.c. Thing is, we don't need to expose 
it for asynchronous transfer. If master->prepare_message() callback 
obtains some lock, which is unfortunately held by other task that waits 
for a lock already obtained by regmap_write_async() it will not wait 
forever since call path started in regmap_write_async() is not blocked by 
things like wait_for_completion() and should soon end calling 
map->unlock(map->lock_arg).

>> Maybe adding a pair of callbacks (map->reg_write_sync_prepared(),
>> map->reg_read_sync_prepared()) would make situation clearer.
>
> No, I don't think so - it'd just complicate the callers.
>
>>> I2C is a bus that has some properties which you're saying needs some
>>> changes, what are those properties and those changes?
>
>> I'm not saying I2C as a bus requires changes. What I'm saying is that I2C
>> API can be extended to allow more detailed control on what happens with the
>> transfer.
>
> My point here is that your explanation is in terms of I2C specifics and
> not really at a generic regmap level.
>
>>> Can you be more specific please?  If something needs preparing it seems
>>> like it'd need preparing over an async transaction just as much as over
>>> a synchronous one.
>
>> Even with those preparation and unpreparation stages, this transfer is still
>> synchronous. For example, it starts when regmap_read() starts and ends when
>> regmap_read() ends. Nothing is queued or deferred. Namely, when
>> max_gen_clk_unprepare() function calls regmap_update_bits() it expects that
>> when regmap_update_bits() returned, no outstanding transfer are happening
>> nor waiting to proceed. Everything must be completed before returning to
>> max_gen_clk_unprepare().
>
> That doesn't address my question - all you're saying is that in a
> synchronous call path things are synchronous which is fine but obviously
> regmap supports async I/O too.
>
>>> Not in this pattern where the caller needs to check too.
>
>> I don't persist on that. Apparently, you're the author of this file, though
>> regmap_init() function was later expanded by other guys. They never assigned
>> bus callback function pointers directly to map operation callbacks. It is
>> possible to replace 'map->reg_prepare_sync_io = regmap_bus_prepare_sync_io'
>> with 'map->reg_prepare_sync_io = map->bus->prepare_sync_io' - this will
>> compile and this will work properly. But IMHO it wouldn't match with what
>> the others did.
>
> If you look at the other callbacks they're doing other things beyond
> simply forwarding the functions on.  That's the problem here, the
> functions just add a layer of indirection and nothing else.
>

Yes, I added layer of indirection just because the others added layer of 
indirection - there is no functional requirement behind that. It can be 
easily removed.

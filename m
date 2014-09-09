Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbaIIOwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:52:04 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34532 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbaIIOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:51:05 -0400
Message-ID: <540F13DB.2070205@linaro.org>
Date: Tue, 09 Sep 2014 15:51:07 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] asm-generic/io.h: Implement read[bwlq]_relaxed()
References: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org> <20140909122818.GI1754@arm.com> <540EFA94.1010905@linaro.org> <540EFD4E.50804@linaro.org> <20140909141513.GW4790@arm.com>
In-Reply-To: <20140909141513.GW4790@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 15:15, Will Deacon wrote:
> On Tue, Sep 09, 2014 at 02:14:54PM +0100, Daniel Thompson wrote:
>> On 09/09/14 14:03, Daniel Thompson wrote:
>>> On 09/09/14 13:28, Will Deacon wrote:
>>>> I have a larger series adding these (and the write equivalents) to all
>>>> architectures that I periodically post and then fail to get on top of.
>>>
>>> That's why you're on Cc:...
> 
> Ok, so why not just pick the asm-generic patch out of my series?

Only really that your patch introducing the writeX_relaxed() family at
the same time.

However it would be fine to subset your patch rather than use mine. You
did post it first...


>>>> The key part you're missing is defining some generic semantics for these
>>>> accessors. Without those, I don't think it makes sense to put them into
>>>> asm-generic, because drivers can't safely infer any meaning from the relaxed
>>>> definition.
>>>
>>> Currently the semantics are described as:
>>> --- cut here ---
>>> PCI ordering rules also guarantee that PIO read responses arrive after
>>> any outstanding DMA writes from that bus, since for some devices the
>>> result of a readb call may signal to the driver that a DMA transaction
>>> is complete. In many cases, however, the driver may want to indicate
>>> that the next readb call has no relation to any previous DMA writes
>>> performed by the device. The driver can use readb_relaxed for these
>>> cases, although only some platforms will honor the relaxed semantics.
>>> Using the relaxed read functions will provide significant performance
>>> benefits on platforms that support it. The qla2xxx driver provides
>>> examples of how to use readX_relaxed . In many cases, a majority of the
>>> driver’s readX calls can safely be converted to readX_relaxed calls,
>>> since only a few will indicate or depend on DMA completion.
>>> --- cut here ---
>>>
>>> The implementation provided in the patch trivially meets this definition
>>> (by not honouring the relaxedness).
> 
> I still think we need to mention ordering of relaxed reads against each
> other and also against spinlocks.

I don't disagree.

I just think the documentation being sub-optimal is not a good reason to
avoid implementing the read functions.


>>>> Ben and I agreed on something back in May:
>>>>
>>>>   https://lkml.org/lkml/2014/5/22/468
>>>
>>> ... and didn't you also conclude with hpa that the very relaxed x86
>>> implementation of readl_relaxed() already meets this definition (as do
>>> these changes to asm-generic/io.h).
>>
>> Sorry. "very relaxed" is always a very stupid thing to say about x86
>> (especially to an arm guy).
>>
>> More exactly I was referring to the absence of memory clobber in x86
>> readl_relaxed().
> 
> Yeah, my series just adds the relaxed write accessors for x86.
> 
>>> Thus allowing its use to perculate more widely really shouldn't do an harm.
>>>
>>>
>>>> but I need to send a new version including:
>>>>
>>>>   - ioreadX_relaxed and iowriteX_relaxed
>>>>   - Strengthening non-relaxed I/O accessors on architectures with non-empty
>>>>     mmiowb()
>>>>
>>>> I'll bump it up the list. In the meantime, you can have a look at my io
>>>> branch on kernel.org
>>>
>>> I'd really like to see your work included (which I spotted after I wrote
>>> the patch and when it occured to me to visit
>>> https://www.google.com/search?q=asm-generic+readl_relaxed to see if
>>> there was a well known reason not to make this change).
>>>
>>> However... I really can't see why we should delay introducing an already
>>> documented function to the remaining architectures.
> 
> I'd just rather fix the interface once instead of churning it about

Churn? 12 lines of code where two people independently produce the same
thing (apart from ordering within the file)?


> How about I dust off the series again?

Dusting off the series again would be great.

Would you consider putting readX_relaxed() and its documentation at the
front of the patchset? That way if the writel_relaxed() side log jams
again we can still get some of it delivered.


Daniel.

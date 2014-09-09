Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaIINOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:14:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54543 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaIINOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:14:52 -0400
Message-ID: <540EFD4E.50804@linaro.org>
Date: Tue, 09 Sep 2014 14:14:54 +0100
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
References: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org> <20140909122818.GI1754@arm.com> <540EFA94.1010905@linaro.org>
In-Reply-To: <540EFA94.1010905@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 14:03, Daniel Thompson wrote:
> On 09/09/14 13:28, Will Deacon wrote:
>> Hi Daniel,
>>
>> On Tue, Sep 09, 2014 at 01:12:40PM +0100, Daniel Thompson wrote:
>>> Currently the read[bwlq]_relaxed() family are implemented on every
>>> architecture except blackfin, m68k[1], metag, openrisc, s390[2] and
>>> score. Increasingly drivers are being optimized to exploit relaxed
>>> reads putting these architectures at risk of compilation failures for
>>> shared drivers.
>>>
>>> This patch addresses this by providing implementations of
>>> read[bwlq]_relaxed() that are identical to the equivalent read[bwlq]().
>>> All the above architectures include asm-generic/io.h .
>>>
>>> Note that currently only eight architectures (alpha, arm, arm64, avr32,
>>> hexagon, microblaze, mips and sh) implement write[bwlq]_relaxed() meaning
>>> these functions are deliberately not included in this patch.
>>>
>>> [1] m68k includes the relaxed family only when configured *without* MMU.
>>> [2] s390 requires CONFIG_PCI to include the relaxed family.
>>>
>>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: linux-arch@vger.kernel.org
>>> ---
>>>  include/asm-generic/io.h | 14 ++++++++++++++
>>>  1 file changed, 14 insertions(+)
>>
>> I have a larger series adding these (and the write equivalents) to all
>> architectures that I periodically post and then fail to get on top of.
> 
> That's why you're on Cc:...
> 
> 
>> The key part you're missing is defining some generic semantics for these
>> accessors. Without those, I don't think it makes sense to put them into
>> asm-generic, because drivers can't safely infer any meaning from the relaxed
>> definition.
> 
> Currently the semantics are described as:
> --- cut here ---
> PCI ordering rules also guarantee that PIO read responses arrive after
> any outstanding DMA writes from that bus, since for some devices the
> result of a readb call may signal to the driver that a DMA transaction
> is complete. In many cases, however, the driver may want to indicate
> that the next readb call has no relation to any previous DMA writes
> performed by the device. The driver can use readb_relaxed for these
> cases, although only some platforms will honor the relaxed semantics.
> Using the relaxed read functions will provide significant performance
> benefits on platforms that support it. The qla2xxx driver provides
> examples of how to use readX_relaxed . In many cases, a majority of the
> driver’s readX calls can safely be converted to readX_relaxed calls,
> since only a few will indicate or depend on DMA completion.
> --- cut here ---
> 
> The implementation provided in the patch trivially meets this definition
> (by not honouring the relaxedness).
> 
> 
>> Ben and I agreed on something back in May:
>>
>>   https://lkml.org/lkml/2014/5/22/468
> 
> ... and didn't you also conclude with hpa that the very relaxed x86
> implementation of readl_relaxed() already meets this definition (as do
> these changes to asm-generic/io.h).

Sorry. "very relaxed" is always a very stupid thing to say about x86
(especially to an arm guy).

More exactly I was referring to the absence of memory clobber in x86
readl_relaxed().


> 
> Thus allowing its use to perculate more widely really shouldn't do an harm.
> 
> 
>> but I need to send a new version including:
>>
>>   - ioreadX_relaxed and iowriteX_relaxed
>>   - Strengthening non-relaxed I/O accessors on architectures with non-empty
>>     mmiowb()
>>
>> I'll bump it up the list. In the meantime, you can have a look at my io
>> branch on kernel.org
> 
> I'd really like to see your work included (which I spotted after I wrote
> the patch and when it occured to me to visit
> https://www.google.com/search?q=asm-generic+readl_relaxed to see if
> there was a well known reason not to make this change).
> 
> However... I really can't see why we should delay introducing an already
> documented function to the remaining architectures.
> 
> 
> Daniel.
> 


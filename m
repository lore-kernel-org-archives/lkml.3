Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbbAXTwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:52:19 -0500
Received: from outbound-smtp06.blacknight.com ([81.17.249.39]:32920 "EHLO
	outbound-smtp06.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbbAXTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:52:17 -0500
Message-ID: <54C3F7E7.6090306@nexus-software.ie>
Date: Sat, 24 Jan 2015 19:52:07 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie> <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 01:48, Ong, Boon Leong wrote:

Skipping stuff I agree with.

>  From V1 comment:
> Suggest to add a statement on 3 different types of IMR: General IMR, Host Memory
> I/O Boundary IMR & System Management Mode IMR. Then, call out that this patch
> is meant to support general IMR type only.

Hmm - There's no mention of grouping like that in the documentation, nor 
in released silicon - to my knowledge.

Also why do you want a statement added saying that it supports CPU only 
mode ?

This patch will support adding IMRs for SMM mode - if calling code wants 
do do that - it's just imr_add_range(base, size, SMM, SMM);

Same thing with virtual-channels, RMU, etc.


>> +	ret = imr_check_range(base, size);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (size < IMR_ALIGN)
>> +		return -EINVAL;
> I believe this is redundant because imr_check_range() has test for (size & IMR_MASK)
> which means if the size is indeed smaller than 0x400, the test will caught it anyway.

Nope.

(0 & 0x3FF) == 0

We need to bounds check for a zero size.

I'll change it to

if (size == 0)
	return -EINVAL;

to avoid confusion.

>> +
>> +	/* Tweak the size value */
>> +	size = imr_fixup_size(size);
>> +	pr_debug("IMR %d phys 0x%08lx-0x%08lx rmask 0x%08x wmask
>> 0x%08x\n",
>> +		reg, base, end, rmask, wmask);
> Do we want to account for the 'size fixup' above on 'end'
>> +
>> +	/* Allocate IMR */
>> +	imr.addr_lo = phys_to_imr(base);
>> +	imr.addr_hi = phys_to_imr(end);
>
> The fix-up size above is never factored here ...
> 'end-size' should be the correct one

hmmm.

The correct fix is

size = imr_fixup_size(size);
end = base + size;

>> +	} else {
>> +		/* Search for match based on address range */
>> +		for (i = 0; i < imr_dev.max_imr; i++) {
>> +			ret = imr_read(reg, &imr);
> A serious bug here.... 'reg' should be 'i' . We enter this branch if reg=-1
> Is there a miss in your test case?

Hmm you're right.

Turns out there's only the one test case for imr_del_range();

Good catch.

--
BOD


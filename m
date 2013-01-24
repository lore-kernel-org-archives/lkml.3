Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3AXIOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:14:10 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41716 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3AXIOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <1359014483.12502.94.camel@smile>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358955452-20960-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=mx8n53pU42Xx+J3VgMg+ZAWnSNyuDB-2nm5K67MnMTyQ@mail.gmail.com>
	<1359014483.12502.94.camel@smile>
Date: Thu, 24 Jan 2013 13:44:01 +0530
Message-ID: <CAKohpomsR-0hp8bZr=eDNzHc20D0dGYKzCY+brN2csmhnxTzBg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 January 2013 13:31, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, 2013-01-24 at 10:37 +0530, Viresh Kumar wrote:

>> Is there a point updating residue here? I don't have a very good knowledge of
>> nollp transfers but this is what i know...
>>
>> The above "if" will pass if we are still doing transfers and fail if
>> all transfers are done.
>> After the end of each LLI we receive an interrupt, where we queue next
>> LLI. Better
>> would be to initialize dwc->residue at dwc_dostart() with total
>> length, start decrementing
>> it with desc->len for every lli interrupt we get
>
> It's mostly okay, but we have to handle few cases:
> - we have only first (master) descriptor
> - we have a chain of the descriptors: master + children
> - we have finished last transfer
>
> From my point of view we can't fully get rid of dwc_update_residue(),
> but modify it a bit (drop away for loop).

I feel the residue mechanism for all three cases can be handled by the code
i asked you to try. Lets see how it goes, after we see first level of
draft from you.

>> and if call for
>> getting residue comes in
>> middle of transfer, simple return residue - dwc_get_sent(desc) without
>> updating residue
>> field...
>
> Where? In the tx_status to call something which returns dwc->residue -
> dwc_get_sent() ?

Yes. My point was not to update dwc->residue with whatever data we get out of
dwc_get_sent().

>> > +       spin_lock_irqsave(&dwc->lock, flags);
>> > +
>>
>> why do you need locking here?
>
> What about the case when one CPU is getting an interrupt and runs
> scan_descriptors when the other, for example, in the middle of
> tx_status? So, I'm afraid the dma_set_residue(txstate, dwc->residue) is
> not atomic and we might end up with random numbers here.

I am not against the lock, but want both of us to know why it is there :)
So, i don't think that we need to protect dma_set_residue() at all. That's
not our job.

What we need to make sure is value read from dwc->residue is consistent.
And so, i believe we need a lock to protect read and write to dwc->residue.

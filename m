Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935139AbaKNExY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:53:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934226AbaKNExX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:53:23 -0500
Message-ID: <54658ABF.5050708@suse.com>
Date: Fri, 14 Nov 2014 05:53:19 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-3-git-send-email-jgross@suse.com> <20141112214506.GA5922@laptop.dumpdata.com> <54644E48.3040506@suse.com> <20141113195605.GA13039@laptop.dumpdata.com>
In-Reply-To: <20141113195605.GA13039@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 08:56 PM, Konrad Rzeszutek Wilk wrote:
>>>> +	mfn_save = virt_to_mfn(buf);
>>>> +
>>>> +	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
>>>
>>> So the 'list' is constructed by going forward - that is from low-numbered
>>> PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
>>> other way - from the highest PFN to the lowest PFN.
>>>
>>> Won't that mean we will restore the chunks of memory in the wrong
>>> order? That is we will still restore them in chunks size, but the
>>> chunks will be in descending order instead of ascending?
>>
>> No, the information where to put each chunk is contained in the chunk
>> data. I can add a comment explaining this.
>
> Right, the MFNs in a "chunks" are going to be restored in the right order.
>
> I was thinking that the "chunks" (so a set of MFNs) will be restored in
> the opposite order that they are written to.
>
> And oddly enough the "chunks" are done in 512-3 = 509 MFNs at once?

More don't fit on a single page due to the other info needed. So: yes.

>
>>
>>>
>>>> +		/* Map the remap information */
>>>> +		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
>>>> +
>>>> +		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
>>>> +
>>>> +		free = 0;
>>>> +		pfn = xen_remap_buf.target_pfn;
>>>> +		for (i = 0; i < xen_remap_buf.size; i++) {
>>>> +			mfn = xen_remap_buf.mfns[i];
>>>> +			if (!released && xen_update_mem_tables(pfn, mfn)) {
>>>> +				remapped++;
>>>
>>> If we fail 'xen_update_mem_tables' we will on the next chunk (so i+1) keep on
>>> freeing pages instead of trying to remap. Is that intentional? Could we
>>> try to remap?
>>
>> Hmm, I'm not sure this is worth the effort. What could lead to failure
>> here? I suspect we could even just BUG() on failure. What do you think?
>
> I was hoping that this question would lead to making this loop a bit
> simpler as you would have to spread some of the code in the loop
> into functions.
>
> And keep 'remmaped' and 'released' reset every loop.
>
> However, if it makes the code more complex - then please
> forget my question.

Using BUG() instead would make the code less complex. Do you really
think xen_update_mem_tables() would ever fail in a sane system?

- set_phys_to_machine() would fail only on a memory shortage. Just
   going on without adding more memory wouldn't lead to a healthy system,
   I think.
- The hypervisor calls would fail only in case of parameter errors.
   This should never happen, so dying seems to be the correct reaction.

David, what do you think?


Juergen

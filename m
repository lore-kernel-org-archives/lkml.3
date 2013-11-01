Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3KAQJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:09:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49556 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3KAQJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:09:28 -0400
X-IronPort-AV: E=Sophos;i="4.93,618,1378857600"; 
   d="scan'208";a="69775428"
Message-ID: <5273D235.3060100@citrix.com>
Date: Fri, 1 Nov 2013 16:09:25 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Davies <Jonathan.Davies@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH net-next RFC 2/5] xen-netback: Change TX path
 from grant copy to mapping
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <1383094220-14775-3-git-send-email-zoltan.kiss@citrix.com> <9AAE0902D5BC7E449B7C8E4E778ABCD015717A@AMSPEX01CL01.citrite.net> <527175DB.8070400@citrix.com>
In-Reply-To: <527175DB.8070400@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 21:10, Zoltan Kiss wrote:
> On 30/10/13 09:11, Paul Durrant wrote:
>>> +    err = alloc_xenballooned_pages(MAX_PENDING_REQS,
>>> +        vif->mmap_pages,
>>> +        false);
>>
>> Since this is a per-vif allocation, is this going to scale?
> Good question, I'll look after this.
I've talked to David Vrabel about this: if ballooning is disabled, this 
will reserve real memory, therefore for every VIF you allocate usually 
1MB memory. But if you enable ballooning, it will use pages which are 
not actually reserved, and that's fine, because we never gonna really 
use them. The only issue is that you need to set the maximum at boot 
time, and it will consume memory also because of the page table 
reservations.
The long term solution would be to just use a bunch of struct pages, 
David said the ballooning driver has something like that, but it's 
broken at the moment.

>>>           if (data_len < txp->size) {
>>>               /* Append the packet payload as a fragment. */
>>>               txp->offset += data_len;
>>>               txp->size -= data_len;
>>> -        } else {
>>> +            skb_shinfo(skb)->destructor_arg =
>>> +                &vif-
>>>> pending_tx_info[pending_idx].callback_struct;
>>> +        } else if (!skb_shinfo(skb)->nr_frags) {
>>>               /* Schedule a response immediately. */
>>> +            skb_shinfo(skb)->destructor_arg = NULL;
>>> +            xenvif_idx_unmap(vif, pending_idx);
>>>               xenvif_idx_release(vif, pending_idx,
>>>                          XEN_NETIF_RSP_OKAY);
>>> +        } else {
>>> +            /* FIXME: first request fits linear space, I don't know
>>> +             * if any guest would do that, but I think it's possible
>>> +             */
>>
>> The Windows frontend, because it has to parse the packet headers, will
>> coalesce everything up to the payload in a single frag and it would be
>> a good idea to copy this directly into the linear area.
> I forgot to clarify this comment: the problem I wanted to handle here if
> the first request's size is PKT_PROT_LEN and there is more fragments.
> Then skb->len will be PKT_PROT_LEN as well, and the if statement falls
> through to the else branch. That might be problematic if we release the
> slot of the first request separately from the others. Or am I
> overlooking something? Does that matter to netfront anyway?
> And this problem, if it's true, applies to the previous, grant copy
> method as well.
> However, as I think, it might be better to change the condition to
> (data_len <= txp->size), rather than putting an if-else statement into
> the else branch.
I've talked to Wei, we think this is a broken guest behaviour, and 
therefore we shouldn't care if someone does such a stupid thing.

Zoli

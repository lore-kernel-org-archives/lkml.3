Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3LPS5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:57:49 -0500
Received: from smtp.citrix.com ([66.165.176.89]:60050 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab3LPS5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:57:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,496,1384300800"; 
   d="scan'208";a="85030136"
Message-ID: <52AF4D28.8070001@citrix.com>
Date: Mon, 16 Dec 2013 18:57:44 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v2 2/9] xen-netback: Change TX path from grant
 copy to mapping
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com> <1386892097-15502-3-git-send-email-zoltan.kiss@citrix.com> <20131213153612.GM21900@zion.uk.xensource.com> <52AF1E5D.20801@citrix.com> <20131216182138.GD25969@zion.uk.xensource.com>
In-Reply-To: <20131216182138.GD25969@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/13 18:21, Wei Liu wrote:
> On Mon, Dec 16, 2013 at 03:38:05PM +0000, Zoltan Kiss wrote:
> [...]
>>>> +	for (i = 0; i < MAX_PENDING_REQS; ++i) {
>>>> +		if (vif->grant_tx_handle[i] != NETBACK_INVALID_HANDLE) {
>>>> +			i = 0;
>>>> +			unmap_timeout++;
>>>> +			msleep(1000);
>>>> +			if (unmap_timeout > 9 &&
>>>> +				net_ratelimit())
>>>> +				netdev_err(vif->dev,
>>>> +					"Page still granted! Index: %x\n", i);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	free_xenballooned_pages(MAX_PENDING_REQS, vif->mmap_pages);
>>>> +
>>>
>>> If some pages are stuck and you just free them will it cause Dom0 to
>>> crash? I mean, if those pages are recycled by other balloon page users.
>>>
>>> Even if it will not cause Dom0 to crash, will it leak any resource in
>>> Dom0? At plain sight it looks like at least grant table entry is leaked,
>>> isn't it? We need to be careful about this because a malicious might be
>>> able to DoS Dom0 with resource leakage.
>> Yes, if we call free_xenballooned_pages while something is still
>> mapped, Xen kills Dom0 because balloon driver tries to touch the PTE
>> of a grant mapped page. That's why we make sure before that
>> everything is unmapped, and repeat an error message if it's not. I'm

There is an "i = 0" if we find a valid handle. So we start again 
checking the whole array from the second element (incorrectly, it should 
be "i = -1"!), and we print an incorrect error message, but essentially 
we are not leaving the loop, unless the first element was the 
problematic. We can modify that to "i--" or "i = -1" if we want to 
recheck the whole array. It shouldn't happen at this point that we 
transmit new packets, starting from the beginning is just an extra 
safety check.
Also, we should modify i after the printing of the error message.

Zoli


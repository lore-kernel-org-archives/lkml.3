Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3GJOqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:46:47 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:37654 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:46:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,1036,1363132800"; 
   d="scan'208";a="6543249"
Message-ID: <51DD73CF.70805@citrix.com>
Date: Wed, 10 Jul 2013 16:46:39 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Egger, Christoph" <chegger@amazon.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC 4/4] xen-block: introduce a new request
 type to unmap grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-5-git-send-email-roger.pau@citrix.com> <20130708194152.GJ4927@phenom.dumpdata.com> <51DD271B.3010408@citrix.com> <51DD6792.8040502@amazon.de>
In-Reply-To: <51DD6792.8040502@amazon.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 15:54, Egger, Christoph wrote:
> On 10.07.13 11:19, Roger Pau Monné wrote:
>> On 08/07/13 21:41, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Jul 08, 2013 at 03:03:27PM +0200, Roger Pau Monne wrote:
>>>> Right now blkfront has no way to unmap grant refs, if using persistent
>>>> grants once a grant is used blkfront cannot assure if blkback will
>>>> have this grant mapped or not. To solve this problem, a new request
>>>> type (BLKIF_OP_UNMAP) that allows requesting blkback to unmap certain
>>>> grants is introduced.
>>>
>>> I don't think this is the right way of doing it. It is a new operation
>>> (BLKIF_OP_UNMAP) that has nothing to do with READ/WRITE. All it is
>>> is just some way for the frontend to say: unmap this grant if you can.
>>>
>>> As such I would think a better mechanism would be to have a new
>>> grant mechanism that can say: 'I am done with this grant you can
>>> remove it' - that is called to the hypervisor. The hypervisor
>>> can then figure out whether it is free or not and lazily delete it.
>>> (And the guest would be notified when it is freed).
>>
>> I have a patch that I think implements something quite similar to what 
>> you describe, but it doesn't require any new patch to the hypervisor 
>> side. From blkfront we can check what grants blkback has chosen to 
>> persistently map and only keep those.
>>
>> This is different from my previous approach, were blkfront could 
>> specifically request blkback to unmap certain grants, but it still 
>> prevents blkfront from hoarding all grants (unless blkback is 
>> persistently mapping every possible grant). With this patch the number 
>> of persistent grants in blkfront will be the same as in blkback, so 
>> basically the backend can control how many grants will be persistently 
>> mapped. 
> 
> According to your blog
> http://blog.xen.org/index.php/2012/11/23/improving-block-protocol-scalability-with-persistent-grants/
> persistent grants in the frontend gives an benefit even when the backend does not support
> persistent grants. Is this still the case with this patch?

Not sure, I have not benchmarked this specific combination with this new
patch, but I would say probably not, because we remove the foreign
access if the backend has not persistently mapped the grant.


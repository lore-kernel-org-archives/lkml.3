Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHTJ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:56:47 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:49874 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaHTJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:56:46 -0400
Message-ID: <53F47063.7070800@hp.com>
Date: Wed, 20 Aug 2014 17:54:43 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linda Knippers <linda.knippers@hp.com>
Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
References: <1408352352-14449-1-git-send-email-zhen-hual@hp.com> <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net> <20140818232328.GK9809@8bytes.org> <1267BB84A242B24E81E0C0C8955CFFC061A4CA69@G9W0343.americas.hpqcorp.net> <20140819110239.GA16329@8bytes.org>
In-Reply-To: <20140819110239.GA16329@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On my system, error message:
[    4.322008] dmar: DRHD: handling fault status reg 2
[    4.327484] dmar: DMAR:[DMA Read] Request device [21:00.0] fault addr 
fff66000
[    4.327484] DMAR:[fault reason 01] Present bit in root entry is clear

fault happens on device : 21:00.0

To describe this problem clearly, we mark two time points:
A: Just before dump kernel init the DMAR/IOMMU structures.
B: Just after DMAR/IOMMU finished initialization.
C: Just before  21:00.0

When the first kernel crashed, then the dump kernel will boot.
Then there comes a DMA request on  21:00.0 when durting A to C. And this 
will cause this error.

If I clear the root entry table when iommu structure is allocted, this 
error will not happen during A to B, but still can be seen during B and 
C.  I guess the cause is the un-expected DMA request.

I will apply Bill Sumner's patch to see whether it will cause the errors 
disappear.


-- Zhenhua

On 08/19/2014 07:02 PM, Joerg Roedel wrote:
> On Mon, Aug 18, 2014 at 11:27:01PM +0000, Li, Zhen-Hua wrote:
>> : [fault reason 01] Present bit in root entry is clear
>> It appears when iommu initializing in the kdump kernel.
>
> Hmm, do you have an explanation how this can happen? From how I read the
> code, the kdump kernel disables translation on the IOMMU, then sets a
> new root entry, and then re-enabled translation. To me it looks like
> there is no point in time where translation is enabled and the
> root-entry is clear (present-bit==0).
>
> But obviously I am missing something if you see the message above.
>
> Btw, have you looked into this patch-set posted earlier this year:
>
> 	https://lkml.org/lkml/2014/4/24/836
>
> It approaches the same problem-space, but also cares about in-flight
> DMA.
>
>
> 	Joerg
>


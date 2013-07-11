Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab3GKPsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:48:10 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:58992 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3GKPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:48:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="6591148"
Message-ID: <51DED3B6.9090601@citrix.com>
Date: Thu, 11 Jul 2013 17:48:06 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC 4/4] xen-block: introduce a new request
 type to unmap grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>	<1373288607-1876-5-git-send-email-roger.pau@citrix.com>	<20130708194152.GJ4927@phenom.dumpdata.com> <51DD271B.3010408@citrix.com> <51DEB795.3000602@citrix.com> <51DECB4D.4020009@citrix.com> <51DECEC3.7090306@citrix.com>
In-Reply-To: <51DECEC3.7090306@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 17:26, David Vrabel wrote:
> On 11/07/13 16:12, Roger Pau Monné wrote:
>> On 11/07/13 15:48, David Vrabel wrote:
>>> On 10/07/13 10:19, Roger Pau Monné wrote:
>>>>
>>>> >From 1ede72ba10a7ec13d57ba6d2af54e86a099d7125 Mon Sep 17 00:00:00 2001
>>>> From: Roger Pau Monne <roger.pau@citrix.com>
>>>> Date: Wed, 10 Jul 2013 10:22:19 +0200
>>>> Subject: [PATCH RFC] xen-blkfront: revoke foreign access for grants not
>>>>  mapped by the backend
>>>> MIME-Version: 1.0
>>>> Content-Type: text/plain; charset=UTF-8
>>>> Content-Transfer-Encoding: 8bit
>>>>
>>>> There's no need to keep the foreign access in a grant if it is not
>>>> persistently mapped by the backend. This allows us to free grants that
>>>> are not mapped by the backend, thus preventing blkfront from hoarding
>>>> all grants.
>>>>
>>>> The main effect of this is that blkfront will only persistently map
>>>> the same grants as the backend, and it will always try to use grants
>>>> that are already mapped by the backend. Also the number of persistent
>>>> grants in blkfront is the same as in blkback (and is controlled by the
>>>> value in blkback).
>>>
>>> Does this place in implicit requirement on the behaviour of the backend.
>>>  i.e., the backend must persistently map the first N grants and always
>>> unmap the remainder?  If so, this should be clearly documented.
>>
>> No, the backend can persistently map whatever grants it wants, and in
>> fact we have a LRU in the backend that keeps unmapping a certain amount
>> of grants that have not been used over a period of time.
> 
> I don't see a mechanism by which the frontend can notice that the
> backend has unmapped an unused grant.  It can only notice when a request
> using that grant is completed.

Right.

> 
>>> It also seems odd to have the backend decide how much frontend resource
>>> can be consumed at anyone time.  It's not clear how the backend is
>>> supposed to know how many persistent grants it should hang on to.
>>
>> blkfront has to at least persistently map the same grants as the
>> backend. blkfront could persistently map all grants, but then we will
>> have grant shortage, and I doubt there's much performance gain from
>> persistently mapping grants in blkfront but not blkback (since the
>> biggest performance penalty comes from the unmapping done in blkback and
>> TLB flush involved).
> 
> I'm saying that the frontend needs to be able to set a cap on the number
> of persistent grants kept by the backend.  If other demands on a
> domain's grant table resource means it can only spare G grants for a
> particular frontend it needs to be able to ensure this (with the
> cooperation of the backend).

We could easily negotiate the maximum number of persistent grants with
the backend using a xenstore node, but how is blkfront going to decide
how many persistent grants it wants to use? Should we coordinate this
somehow with all the users of the grant table?

Doing it in the backend doesn't seem to me like a really bad approach,
the admin of the host should know the maximum number of disks/nics a
guest can have, and thus set the maximum number of persistent grants
appropriately (and also tune gnttab_max_nr_frames if needed).


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3CDRTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:19:11 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:21681 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3CDRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:19:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,781,1355097600"; 
   d="scan'208";a="2155218"
Message-ID: <5134D78B.4060400@citrix.com>
Date: Mon, 4 Mar 2013 18:19:07 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 01/12] xen-blkback: don't store dev_bus_addr
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-2-git-send-email-roger.pau@citrix.com> <512F467602000078000C1E0C@nat28.tlf.novell.com>
In-Reply-To: <512F467602000078000C1E0C@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 11:58, Jan Beulich wrote:
>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> dev_bus_addr returned in the grant ref map operation is the mfn of the
>> passed page, there's no need to store it in the persistent grant
>> entry, since we can always get it provided that we have the page.
> 
> Interesting that you come up with this, as I have a similar patch
> pending (not posted yet), aiming at reducing the stack usage in
> dispatch_rw_block_io(): seg[].buf is really unnecessary with the
> dev_bus_addr storing removed, as the only reader of that field
> can equally well use req->u.rw.seg[i].first_sect.

Well, it can if we are not using indirect descriptors, because once we
start using indirect descriptors segments are inside a gref frame, so
it's quite comfortable to store first_sect inside a separate array, this
way we can map indirect segments, copy whatever data we need from them
and unmap them, without having them around for the whole lifetime of the
request.

> 
> And then the biolist[] array really can be folded into a union
> with the remaining seg[] one, as their usage scopes are easily
> separable.

Could we leave that for a further patch? I would like to avoid messing
any more with blkback, as I'm already touching a lot of bits with this
patch series.

> 
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -621,9 +621,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>>  				 * If this is a new persistent grant
>>  				 * save the handler
>>  				 */
>> -				persistent_gnts[i]->handle = map[j].handle;
>> -				persistent_gnts[i]->dev_bus_addr =
>> -					map[j++].dev_bus_addr;
>> +				persistent_gnts[i]->handle = map[j++].handle;
>>  			}
>>  			pending_handle(pending_req, i) =
>>  				persistent_gnts[i]->handle;
>> @@ -631,7 +629,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>>  			if (ret)
>>  				continue;
>>  
>> -			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
>> +			seg[i].buf = pfn_to_mfn(page_to_pfn(
>> +				persistent_gnts[i]->page)) << PAGE_SHIFT |
> 
> So why do you do this? The only reader masks the field with
> ~PAGE_MASK anyway.

Yes, I only need to store first_sect.

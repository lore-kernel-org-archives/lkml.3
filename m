Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaHDEXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:23:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaHDEXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:23:03 -0400
Message-ID: <53DF0AA3.2040209@suse.com>
Date: Mon, 04 Aug 2014 06:22:59 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save command pool address of Scsi_Host
References: <1406874425-3528-1-git-send-email-jgross@suse.com>	 <20140801120301.GA27198@infradead.org> <1406924674.2654.19.camel@jarvis>
In-Reply-To: <1406924674.2654.19.camel@jarvis>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 10:24 PM, James Bottomley wrote:
> On Fri, 2014-08-01 at 05:03 -0700, Christoph Hellwig wrote:
>> On Fri, Aug 01, 2014 at 08:27:05AM +0200, jgross@suse.com wrote:
>>> From: Juergen Gross <jgross@suse.com>
>>>
>>> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
>>> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
>>> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
>>>
>>> This will result in an access error when the host is removed.
>>>
>>> Avoid the problem by saving the address of a new allocated command pool where
>>> it is expected.
>>>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>> Looks good, but minor nitpick below:
>>
>>> +	if (shost->hostt->cmd_size)
>>> +		shost->hostt->cmd_pool = pool;
>>> +
>>
>>
>> We already have a local hostt variable for the host template in this
>> function, please use it.
>
> Wait, that's not right at all.  There looks to be a thinko in the
> command pool handling code.  We have both a cmd_pool in the host
> structure and in the host template structure, but there's confusion
> about which one we're supposed to be using.
>
> The origin of confusion seems to be the reference counting in the pool
> itself ... you want the same pool for all hosts, since they can only
> have one cmd_size, but you want it created on first host use and
> destroyed again on the last one.
>
> If you take this patch, a host that attached, detaches and then attaches
> a host will panic because it will use a freed pool structure.

Indeed.

> This whole mess is created by the attempt to refcount the pools.  What's
> wrong with simply creating the pool at init time and deleting it again
> at module removal ... that way no refcounting and no bogus problems like
> this (and we can delete the cmd_pool from the host).  The restriction
> this would give is that cmd_size can only be set in the template, but
> that seems to be the only safe use anyway, since any driver trying to
> vary this in its host add routines will get unexpected results.

OTOH it would be possible to just delete .cmd_pool in the template when
deleting the pool. I'll send a patch doing this and you can decide
whether to take it or to use the other solution.

I'm not sure which to prefer: the init/remove version is simple, while
the dynamic version requires no changes in the driver's source and the
pool's resources are allocated only when really needed.


Juergen


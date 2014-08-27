Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaH0KGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:06:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19132 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbaH0KGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:06:32 -0400
X-IronPort-AV: E=Sophos;i="5.04,409,1406592000"; 
   d="scan'208";a="166321119"
Message-ID: <53FDADA5.6070802@citrix.com>
Date: Wed, 27 Aug 2014 11:06:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/grant-table.c: Be sure of unsigned value
 never comparing with 0
References: <53FCAA04.40009@gmail.com> <53FCBDD2.8040208@citrix.com> <53FCE338.1050304@gmail.com>
In-Reply-To: <53FCE338.1050304@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 20:42, Chen Gang wrote:
> On 08/27/2014 01:03 AM, David Vrabel wrote:
>> On 26/08/14 16:38, Chen Gang wrote:
>>> In grow_gnttab_list(), 'i' is 'unsigned int', and 'nr_glist_frames' may
>>> be 0 because 'nr_grant_frames' may be 0. So 'i' may never be less than
>>> 'nr_glist_frames' in failure processing, which cause infinite looping.
>>
>> nr_grant_frames is at least 1.  See gnttab_init().
>>
> 
> OK, thanks, that sounds reasonable to me, it is not a real wold bug, it
> is my fault.  :-)
> 
>>> --- a/drivers/xen/grant-table.c
>>> +++ b/drivers/xen/grant-table.c
>>> @@ -592,8 +592,8 @@ static int grow_gnttab_list(unsigned int more_frames)
>>>  	return 0;
>>>  
>>>  grow_nomem:
>>> -	for ( ; i >= nr_glist_frames; i--)
>>> -		free_page((unsigned long) gnttab_list[i]);
>>> +	while (i > nr_glist_frames)
>>> +		free_page((unsigned long) gnttab_list[--i]);
>>
>> while (i-- > nr_glist_frames)
>>     ...
>>
>> Would have been better.
>>
> 
> OK, thanks, that sounds reasonable to me.
> 
> If necessary to send patch v2 (change comments and contents), please
> let me know, and I shall send.

Applied to devel/for-linus-3.18 with this description:

    xen/grant-table: refactor error cleanup in grow_gnttab_list()

    The cleanup loop in grow_gnttab_list() is safe from the underflow of
    the unsigned 'i' since nr_glist_frames is >= 1, but refactor it
    anyway.

Thanks.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3CRRAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:00:44 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:13400 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3CRRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:00:43 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2617602"
Message-ID: <51474838.2070206@citrix.com>
Date: Mon, 18 Mar 2013 18:00:40 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 06/12] xen-blkback: implement LRU mechanism for persistent
 grants
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-7-git-send-email-roger.pau@citrix.com> <20130304201044.GJ15386@phenom.dumpdata.com> <513634FC.7000401@citrix.com> <20130305214950.GE8235@phenom.dumpdata.com>
In-Reply-To: <20130305214950.GE8235@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 22:49, Konrad Rzeszutek Wilk wrote:
>>> This could be written a bit differently to also run outside the xen_blkif_schedule
>>> (so a new thread). This would require using the lock mechanism and converting
>>> this big loop to two smaller loops:
>>>  1) - one quick that holds the lock - to take the items of the list,
>>>  2) second one to do the grant_set_unmap_op operations and all the heavy
>>>     free_xenballooned_pages call.
>>
>> Yes, I could add a list_head to persistent_gnt, so we can take them out
>> of the red-black tree and queue them in a list to be processed (unmap +
>> free) after we have looped thought the list, without holding the lock.

I've been trying to implement the "purge" on a different kthread, but
I'm not able to get the same performance. Since moving this a different
thread requires additional contention (spinlocks) around the red-black
tree of persistent grants, I think we should leave it as-is right now,
and consider moving it to a different thread if we can get a performance
benefit.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3GKQXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:23:47 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:1556 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3GKQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:23:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,1045,1363132800"; 
   d="scan'208";a="6592226"
Message-ID: <51DEDC10.3020702@citrix.com>
Date: Thu, 11 Jul 2013 18:23:44 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 1/4] xen-gnt: prevent adding duplicate
 gnt	callbacks
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-2-git-send-email-roger.pau@citrix.com> <51DEB070.3060106@citrix.com>
In-Reply-To: <51DEB070.3060106@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 15:17, David Vrabel wrote:
> On 08/07/13 14:03, Roger Pau Monne wrote:
>> With the current implementation, the callback in the tail of the list
>> can be added twice, because the check done in
>> gnttab_request_free_callback is bogus, callback->next can be NULL if
>> it is the last callback in the list. If we add the same callback twice
>> we end up with an infinite loop, were callback == callback->next.
>>
>> Replace this check with a proper one that iterates over the list to
>> see if the callback has already been added.
>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  drivers/xen/grant-table.c |   13 +++++++++++--
>>  1 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
>> index 04c1b2d..d5418c1 100644
>> --- a/drivers/xen/grant-table.c
>> +++ b/drivers/xen/grant-table.c
>> @@ -729,9 +729,18 @@ void gnttab_request_free_callback(struct gnttab_free_callback *callback,
>>  				  void (*fn)(void *), void *arg, u16 count)
>>  {
>>  	unsigned long flags;
>> +	struct gnttab_free_callback *cb;
>> +
>>  	spin_lock_irqsave(&gnttab_list_lock, flags);
>> -	if (callback->next)
>> -		goto out;
>> +
>> +	/* Check if the callback is already on the list */
>> +	cb = gnttab_free_callback_list;
>> +	while (cb) {
>> +		if (cb == callback)
>> +			goto out;
>> +		cb = cb->next;
>> +	}
> 
> O(N)?

IMHO we should not worry _that_ much about having a O(N) search here,
the number of elements in the list is probably going to be quite low (5,
maybe 10?). That doesn't mean I oppose to changing the free callback
list code.

> Suggest using the standard list infrastructure, or using something other
> than NULL for the end of the list (e.g., gnttab_free_callback_list).
> 
> gnttab_request_free_callback() is also putting the callbacks in the
> wrong order -- it should be FIFO not LIFO.  Might be nice to fix this as
> well.

Agree, all this free callback list mechanism is pretty ad-hoc, we should
use one of the list types provided by Linux, so bugs like the one I've
found can be avoided and we can use a FIFO list.


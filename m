Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaBDIjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:39:15 -0500
Received: from smtp.citrix.com ([66.165.176.89]:61563 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaBDIjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:39:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="99553275"
Message-ID: <52F0A729.5070009@citrix.com>
Date: Tue, 4 Feb 2014 09:39:05 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        DavidVrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkback: fix shutdown race
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com> <1390931015-5490-4-git-send-email-roger.pau@citrix.com> <52E8CF540200007800117D88@nat28.tlf.novell.com> <52EFCACF.6080604@citrix.com> <52F0AC990200007800118E09@nat28.tlf.novell.com> <52F0A1C7.2010607@citrix.com> <52F0B38A0200007800118E62@nat28.tlf.novell.com>
In-Reply-To: <52F0B38A0200007800118E62@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 09:31, Jan Beulich wrote:
>>>> On 04.02.14 at 09:16, Roger Pau Monné<roger.pau@citrix.com> wrote:
>> On 04/02/14 09:02, Jan Beulich wrote:
>>>>>> On 03.02.14 at 17:58, Roger Pau Monné<roger.pau@citrix.com> wrote:
>>>> On 29/01/14 09:52, Jan Beulich wrote:
>>>>>>>> On 28.01.14 at 18:43, Roger Pau Monne <roger.pau@citrix.com> wrote:
>>>>>> +		free_req(blkif, pending_req);
>>>>>> +		/*
>>>>>> +		 * Make sure the request is freed before releasing blkif,
>>>>>> +		 * or there could be a race between free_req and the
>>>>>> +		 * cleanup done in xen_blkif_free during shutdown.
>>>>>> +		 *
>>>>>> +		 * NB: The fact that we might try to wake up pending_free_wq
>>>>>> +		 * before drain_complete (in case there's a drain going on)
>>>>>> +		 * it's not a problem with our current implementation
>>>>>> +		 * because we can assure there's no thread waiting on
>>>>>> +		 * pending_free_wq if there's a drain going on, but it has
>>>>>> +		 * to be taken into account if the current model is changed.
>>>>>> +		 */
>>>>>> +		xen_blkif_put(blkif);
>>>>>> +		if (atomic_read(&blkif->refcnt) <= 2) {
>>>>>> +			if (atomic_read(&blkif->drain))
>>>>>> +				complete(&blkif->drain_complete);
>>>>>>  		}
>>>>>> -		free_req(pending_req->blkif, pending_req);
>>>>>>  	}
>>>>>>  }
>>>>>
>>>>> The put is still too early imo - you're explicitly accessing field in the
>>>>> structure immediately afterwards. This may not be an issue at
>>>>> present, but I think it's at least a latent one.
>>>>>
>>>>> Apart from that, the two if()s would - at least to me - be more
>>>>> clear if combined into one.
>>>>
>>>> In order to get rid of the race I had to introduce yet another atomic_t 
>>>> in xen_blkif struct, which is something I don't really like, but I 
>>>> could not see any other way to solve this. If that's fine I will resend 
>>>> the series, here is the reworked patch:
>>>
>>> Mind explaining why you can't simply move the xen_blkif_put()
>>> down between the if() and the free_ref().
>>
>> You mean doing something like:
>>
>> if (atomic_read(&blkif->refcnt) <= 3) {
>> 	if (atomic_read(&blkif->drain))
>> 		complete(&blkif->drain_complete);
>> }
>> xen_blkif_put(blkif);
>> free_req(blkif, pending_req);
> 
> Actually, I got the description wrong. I really meant
> 
> free_req();
> if (atomic_read ...)
> 	complete();
> xen_blkif_put();

IMHO this is still a race, since we evaluate refcnt before decrementing
it. If we have for example 2 in flight requests, both could read refcnt,
both could see it's greater than 3 (so no one would call complete), and
then both will decrement it, without anyone actually calling complete.

Roger.


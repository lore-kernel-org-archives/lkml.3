Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaA1QB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:01:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36959 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaA1QB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:01:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,736,1384300800"; 
   d="scan'208";a="95302164"
Message-ID: <52E7D472.1070007@citrix.com>
Date: Tue, 28 Jan 2014 17:01:54 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] xen-blkback: fix memory leaks
References: <1390817621-12031-1-git-send-email-roger.pau@citrix.com> <20140127212146.GA32007@phenom.dumpdata.com> <52E7A635.2090108@citrix.com> <20140128153710.GC4308@phenom.dumpdata.com>
In-Reply-To: <20140128153710.GC4308@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 16:37, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 28, 2014 at 01:44:37PM +0100, Roger Pau Monné wrote:
>> On 27/01/14 22:21, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Jan 27, 2014 at 11:13:41AM +0100, Roger Pau Monne wrote:
>>>> @@ -976,17 +983,19 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
>>>>  	 * the proper response on the ring.
>>>>  	 */
>>>>  	if (atomic_dec_and_test(&pending_req->pendcnt)) {
>>>> -		xen_blkbk_unmap(pending_req->blkif,
>>>> +		struct xen_blkif *blkif = pending_req->blkif;
>>>> +
>>>> +		xen_blkbk_unmap(blkif,
>>>>  		                pending_req->segments,
>>>>  		                pending_req->nr_pages);
>>>> -		make_response(pending_req->blkif, pending_req->id,
>>>> +		make_response(blkif, pending_req->id,
>>>>  			      pending_req->operation, pending_req->status);
>>>> -		xen_blkif_put(pending_req->blkif);
>>>> -		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
>>>> -			if (atomic_read(&pending_req->blkif->drain))
>>>> -				complete(&pending_req->blkif->drain_complete);
>>>> +		free_req(blkif, pending_req);
>>>> +		xen_blkif_put(blkif);
>>>> +		if (atomic_read(&blkif->refcnt) <= 2) {
>>>> +			if (atomic_read(&blkif->drain))
>>>> +				complete(&blkif->drain_complete);
>>>>  		}
>>>> -		free_req(pending_req->blkif, pending_req);
>>>
>>> I keep coming back to this and I am not sure what to think - especially
>>> in the context of WRITE_BARRIER and disconnecting the vbd.
>>>
>>> You moved the 'free_req' to be done before you do atomic_read/dec.
>>>
>>> Which means that we do:
>>>
>>> 	list_add(&req->free_list, &blkif->pending_free);
>>> 	wake_up(&blkif->pending_free_wq);
>>>
>>> 	atomic_dec
>>> 	if atomic_read <= 2 poke thread that is waiting for drain.
>>>
>>>
>>> while in the past we did:
>>>
>>> 	atomic_dec
>>> 	if atomic_read <= 2 poke thread that is waiting for drain.
>>>
>>> 	list_add(&req->free_list, &blkif->pending_free);
>>> 	wake_up(&blkif->pending_free_wq);
>>>
>>> which means that we are giving the 'req' _before_ we decrement
>>> the refcnts.
>>>
>>> Could that mean that __do_block_io_op takes it for a spin - oh
>>> wait it won't as it is sitting on a WRITE_BARRIER and waiting:
>>>
>>> 1226         if (drain)                                                              
>>> 1227                 xen_blk_drain_io(pending_req->blkif);  
>>>
>>> But still that feels 'wrong'?
>>
>> Mmmm, the wake_up call in free_req in the context of WRITE_BARRIER is
>> harmless since the thread is waiting on drain_complete as you say, but I
>> take your point that it's all confusing. Do you think it will feel
>> better if we gate the call to wake_up in free_req with this condition:
>>
>> if (was_empty && !atomic_read(&blkif->drain))
>>
>> Or is this just going to make it even messier?
> 
> My head spins around when thinking about the refcnt, drain, the two or
> three workqueues. 
> 
>>
>> Maybe just adding a comment in free_req saying that the wake_up call is
>> going to be ignored in the context of a WRITE_BARRIER, since the thread
>> is already waiting on drain_complete is enough.
> 
> Perhaps. You do pass in the 'force' bool flag and we could piggyback
> on that. Meaning you could do

In the new version I'm preparing I'm no longer calling drain_io on
xen_blkif_schedule (so there's no "force" flag), instead I've moved the
cleanup code to xen_blkif_free where I think it makes more sense.

Also the force flag was just a local variable to drain_io, I think it
would get even messier if we add yet another variable (force) to the
xen_blkif struct.

> 
> /* a comment about what we just mentioned */
> 
> if (!force) {
> 	// do it the old way
> } else {
> 
> 	/* A comment mentioning _why_ we need the code reshuffled */
> 
> 	// do it the new way
> }
> 
> It would be a bit messy - but:
>  - We won't have to worry about breaking WRITE_BARRIER as the old
>    logic would be preserved. So less worry about regressions.
>  - The bug-fix would be easy to backport as it would inject code for
>    just the usage you want - that is to drain all I/Os.
>  - It would make a nice distinction and allows us to refactor
>    this in future patches.
> The cons are that:
>  - It would add extra path for just the use-case of shutting down
>    without using the existing one.
>  - It would be messy
> 
> 
> But I think when it comes to fixes like these that are
> candidates for backports - messy is OK and if they don't have any
> posibility of introducing regressions on existing other behaviors -
> then we should stick with that.
> 
> 
> Then in the future we can refactor this to use less of these
> workqueues, refcnt and atomics we have. It is getting confusing.
> 
> Thoughts?

Let me post the whole series as I have them now, and we can pick it up
again from that.


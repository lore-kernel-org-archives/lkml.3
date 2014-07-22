Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaGVIJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:09:44 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:46613 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:08:56 -0400
Message-ID: <53CE1C13.6010103@bjorling.me>
Date: Tue, 22 Jul 2014 10:08:51 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Kent Overstreet <kmo@daterainc.com>
CC: John Utz <John.Utz@wdc.com>, Mike Snitzer <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, tytso@mit.edu
Subject: Re: ZAC target (Was: Re: dm-multipath: Accept failed paths for multipath
 maps)
References: <52B1B046.3040301@suse.de> <1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com> <20140718000411.GB337@redhat.com> <8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02> <20140718021806.GA1143@redhat.com> <8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02> <53C8B757.2000904@suse.de> <20140718143855.GA4762@redhat.com> <8A51900D08212F40B3DE22453052F69839C46EC0@wdscexmb02> <53CD226D.1070309@suse.de> <20140721192825.GA25962@kmo-pixel> <53CDFAD0.6090208@suse.de>
In-Reply-To: <53CDFAD0.6090208@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 07:46 AM, Hannes Reinecke wrote:
> On 07/21/2014 09:28 PM, Kent Overstreet wrote:
>> On Mon, Jul 21, 2014 at 04:23:41PM +0200, Hannes Reinecke wrote:
>>> On 07/18/2014 07:04 PM, John Utz wrote:
>>>>> On 07/18/2014 05:31 AM, John Utz wrote:
>>>>>> Thankyou very much for the exhaustive answer! I forwarded on to my
>>>>>> project peers because i don't think any of us where aware of the
>>>>>> existing infrastructure.
>>>>>>
>>>>>> Of course, said infrastructure would have to be taught about ZAC,
>>>>>> but it seems like it would be a nice place to start testing from....
>>>>>>
>>>>> ZAC is a different beast altogether; I've posted an initial set of
>>>>> patches a while back on linux-scsi.
>>>>> But I don't think multipath needs to be changed for that.
>>>>> Other areas of device-mapper most certainly do.
>>>>
>>>> Pretty sure John is working on a new ZAC-oriented DM target.
>>>>
>>>> YUP.
>>>>
>>>> Per Ted T'so's suggestion several months ago, the goal is to create
>>>> a new DM target that implements the ZAC/ZBC command set and the SMR
>>>> write pointer architecture so that FSfolksen can try their hand at
>>>> porting their stuff to it.
>>>>
>>>> It's in the very early stages so there is nothing to show yet, but
>>>> development is ongoing. There are a few unknowns about how to surface
>>>> some specific behaviors (new verbs and errors, particularly errors
>>>> with sense codes that return a write pointer) but i have not gotten
>>>> far enuf along in development to be able to construct succint and
>>>> specific questions on the topic so that will have to wait for a bit.
>>>>
>>> I was pondering the 'best' ZAC implementation, too, and found the
>>> 'report zones' command _very_ cumbersome to use.
>>> Especially the fact that in theory each zone could have a different size
>>> _and_ plenty of zones could be present will be making zone lookup
>>> hellish.
>>>
>>> However: it seems to me that we might benefit from a generic
>>> 'block boundaries' implementation.
>>> Reasoning here is that several subsystems (RAID, ZAC/ZBC, and things
>>> like
>>> referrals) impose I/O scheduling boundaries which must not be crossed
>>> when
>>> assembling requests.
>>
>> Wasn't Ted working on such a thing?
>>
>>> Seeing that we already have some block limitations I was wondering if we
>>> couldn't have some set of 'I/O scheduling boundaries' as part
>>> of the request_queue structure.
>>
>> I'd prefer not to dump yet more crap in request_queue, but that's a
>> fairly minor
>> quibble :)
>>
>> I also tend to think having different size zones is crazy and I would
>> avoid
>> making any effort to support that in practice, but OTOH there's good
>> reason for
>> wanting one or two "normal" zones and the rest append only so the
>> interface is
>> going to have to accomadate some differences between zones.
>>
>> Also, depending on the approach supporting different size zones might not
>> actually be problematic. If you're starting with something that's pure
>> COW and
>> you're just plugging in this "ZAC allocation" stuff (which I think is
>> what I'm
>> going to do in bcache) then it might not actually be an issue.
>>
> No, what I was suggesting is to introduce 'I/O scheduling barriers'.
> Some devices like RAID or indeed ZAC have internal boundaries which
> cannot be crossed by any I/O. So either the I/O has to be split up or
> the I/O scheduler have to be made aware of these boundaries.
>
> I have had this issue several times now (once with implementing
> Referrals, now with ZAC) so I was wondering whether we can have some
> sort of generic implementation in the block layer.

Would it make any sense to put the hole block allocation strategy within 
the block layer (or just on top of the device driver) and then let 
MDs/FSs users hook into this for allocating new blocks?

That allows multiple implementations to use the same block address space.

>
> And as we're already having request queue limits this might fall quite
> naturally into it. Or so I thought.
>
> Hmm. Guess I should start coding here.
>
> Cheers,
>
> Hannes


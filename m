Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaAVSSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:18:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaAVSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:18:09 -0500
Message-ID: <52E00B28.3060609@redhat.com>
Date: Wed, 22 Jan 2014 13:17:12 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Chris Mason <clm@fb.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>	 <20140122151913.GY4963@suse.de>	 <1390410233.1198.7.camel@ret.masoncoding.com>	 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>	 <1390413819.1198.20.camel@ret.masoncoding.com> <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 01:13 PM, James Bottomley wrote:
> On Wed, 2014-01-22 at 18:02 +0000, Chris Mason wrote:
>> On Wed, 2014-01-22 at 09:21 -0800, James Bottomley wrote:
>>> On Wed, 2014-01-22 at 17:02 +0000, Chris Mason wrote:
>> [ I like big sectors and I cannot lie ]
> I think I might be sceptical, but I don't think that's showing in my
> concerns ...
>
>>>> I really think that if we want to make progress on this one, we need
>>>> code and someone that owns it.  Nick's work was impressive, but it was
>>>> mostly there for getting rid of buffer heads.  If we have a device that
>>>> needs it and someone working to enable that device, we'll go forward
>>>> much faster.
>>> Do we even need to do that (eliminate buffer heads)?  We cope with 4k
>>> sector only devices just fine today because the bh mechanisms now
>>> operate on top of the page cache and can do the RMW necessary to update
>>> a bh in the page cache itself which allows us to do only 4k chunked
>>> writes, so we could keep the bh system and just alter the granularity of
>>> the page cache.
>>>
>> We're likely to have people mixing 4K drives and <fill in some other
>> size here> on the same box.  We could just go with the biggest size and
>> use the existing bh code for the sub-pagesized blocks, but I really
>> hesitate to change VM fundamentals for this.
> If the page cache had a variable granularity per device, that would cope
> with this.  It's the variable granularity that's the VM problem.
>
>>  From a pure code point of view, it may be less work to change it once in
>> the VM.  But from an overall system impact point of view, it's a big
>> change in how the system behaves just for filesystem metadata.
> Agreed, but only if we don't do RMW in the buffer cache ... which may be
> a good reason to keep it.
>
>>> The other question is if the drive does RMW between 4k and whatever its
>>> physical sector size, do we need to do anything to take advantage of
>>> it ... as in what would altering the granularity of the page cache buy
>>> us?
>> The real benefit is when and how the reads get scheduled.  We're able to
>> do a much better job pipelining the reads, controlling our caches and
>> reducing write latency by having the reads done up in the OS instead of
>> the drive.
> I agree with all of that, but my question is still can we do this by
> propagating alignment and chunk size information (i.e. the physical
> sector size) like we do today.  If the FS knows the optimal I/O patterns
> and tries to follow them, the odd cockup won't impact performance
> dramatically.  The real question is can the FS make use of this layout
> information *without* changing the page cache granularity?  Only if you
> answer me "no" to this do I think we need to worry about changing page
> cache granularity.
>
> Realistically, if you look at what the I/O schedulers output on a
> standard (spinning rust) workload, it's mostly large transfers.
> Obviously these are misalgned at the ends, but we can fix some of that
> in the scheduler.  Particularly if the FS helps us with layout.  My
> instinct tells me that we can fix 99% of this with layout on the FS + io
> schedulers ... the remaining 1% goes to the drive as needing to do RMW
> in the device, but the net impact to our throughput shouldn't be that
> great.
>
> James
>

I think that the key to having the file system work with larger sectors is to 
create them properly aligned and use the actual, native sector size as their FS 
block size. Which is pretty much back the original challenge.

Teaching each and every file system to be aligned at the storage 
granularity/minimum IO size when that is larger than the physical sector size is 
harder I think.

ric


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaLNDWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 22:22:34 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49413 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaLNDWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 22:22:32 -0500
Message-ID: <548D0271.9010602@gmail.com>
Date: Sun, 14 Dec 2014 12:22:25 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: samuel.huo@gmail.com
CC: dm-devel@redhat.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, thornber@redhat.com,
        linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
References: <54883195.1060304@gmail.com>	<20141211152626.GA8196@redhat.com>	<548A39E7.80508@gmail.com>	<20141212142447.GA30315@debian>	<548B0517.6070603@gmail.com>	<CAB=cV2Rvp95xuKNd0WzfLpMGrwdSCPxGt6npo+FH0H1y_5kY9Q@mail.gmail.com>	<548C483E.4020501@gmail.com> <CAB=cV2QV+o3wmo3cHSVfKHU3LOVkFLzK2v-YKwiRqzK90i6qkg@mail.gmail.com>
In-Reply-To: <CAB=cV2QV+o3wmo3cHSVfKHU3LOVkFLzK2v-YKwiRqzK90i6qkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianjian,

> How about invalidating previous writes on same sector address? if
> first write is stored in one 512KB log in SSD, later when user write
> the same address, will writeboost invalid old write by updating meta
> data header in place in that 512KB log?  and other meta data like
> superblock, will writeboost will update them in place? if writeboost
> has those frequent random in-place updates, probably those benefits
> except utilizing the faster sequential writes will be much discounted.
In runtime, Writeboost has equivalent metadata on the memory as hash table.
This makes not only cache lookup fast but also makes invalidation easy.
Without this, Writeboost's speed is really discounted.

Any logs on the cache device are never updated partially (it's too dangerous
if we consider partial write failure). Durability is another benefit of
log-structured caching.

As for writing on superblock, it's really random. But, we don't need to
update superblock every write but every seconds or so. To begin with, it's
not logically essential so you can turn it off (that's the default).
The option is for users much care for the resume time.

> Even if writeboost write everything sequentially, probably SSD won't
> be able to recognize that and do its own wear-leveling whatsoever. It
> will be easier, since there is no need to move cold data, etc.
> 
> Generally, SSDs vary a lot, IMHO, one certain optimization technique
> may work for certain model, but may not work for others, since they
> internal NAND Flash management algorithms can be very different.
Yes, Thanks.
I believe making the SSD-internal works easy can not only stabilize the
performance but also reduce the possibility of being trapped by some bugs
that the SSD provides such as petit freeze.

- Akira

On 12/14/14 11:46 AM, Jianjian Huo wrote:
> On Sat, Dec 13, 2014 at 6:07 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>> Hi,
>>
>> Jianjian, You really get a point at the fundamental design.
>>
>>> If I understand it correctly, the whole idea indeed is very simple,
>>> the consumer/provider and circular buffer model. use SSD as a circular
>>> write buffer, write flush thread stores incoming writes to this buffer
>>> sequentially as provider, and writeback thread write those data logs
>>> sequentially into backing device as consumer.
>>>
>>> If writeboost can do that without any random writes, then probably it
>>> can save SSD/FTL of doing a lot of dirty jobs, and utilize the faster
>>> sequential read/write performance from SSD. That'll be awesome.
>>> However, I saw every data log segment in its design has meta data
>>> header, like dirty_bits, so I guess writeboost has to randomly write
>>> those data headers of stored data logs in SSD; also, splitting all bio
>>> into 4KB will hurt its ability to get max raw SSD throughput, modern
>>> NAND Flash has pages much bigger than 4KB; so overall I think the
>>> actual benefits writeboost gets from this design will be discounted.
>> You understand *almost* correctly.
>>
>> Writeboost has two circular buffers, not one; RAM buffers and SSD.
>> The incoming bio is split into 4KB chunks at the virtual make_request
>> and are NOT directly remapped to the SSD.
>> As you mentioned, if I designed so, many update on the metadata happens.
>> That's really bad since SSD is very bad at small update.
>>
>> Actually, the 4KB bio is first stored in RAM buffer, which is 512KB large.
>> There are (512-4)/4=127 4KB bio data stored in the RAM buffer and 4KB metadata
>> section at the head is made after that.
>>
>> The RAM buffer is now called "log" and as you mentioned, flushed to the SSD
>> as 512KB sequential write. This definitely maximizes throughput and lifetime.
>>
>> Unfortunately, this is not always the case because of barrier request handlings.
>> But, when the writes is really heavy (e.g. massive dirty page writeback),
>> Writeboost works as above.
>>
> How about invalidating previous writes on same sector address? if
> first write is stored in one 512KB log in SSD, later when user write
> the same address, will writeboost invalid old write by updating meta
> data header in place in that 512KB log?  and other meta data like
> superblock, will writeboost will update them in place? if writeboost
> has those frequent random in-place updates, probably those benefits
> except utilizing the faster sequential writes will be much discounted.
> 
>>> The good thing is that it seems writeboost doesn't use garbage
>>> collection to clean old invalid logs, this will avoid the double
>>> garage collection effect other caching module has, which essentially
>>> both caching module and internal SSD will perform garbage collections
>>> twice.
>> Yes. And I believe SSDs can remove wear-leveling if I used it as fairly sequential.
>> Am I right? Indeed, Writeboost is really SSD frinedly.
>>
> Even if writeboost write everything sequentially, probably SSD won't
> be able to recognize that and do its own wear-leveling whatsoever. It
> will be easier, since there is no need to move cold data, etc.
> 
> Generally, SSDs vary a lot, IMHO, one certain optimization technique
> may work for certain model, but may not work for others, since they
> internal NAND Flash management algorithms can be very different.
> 
>>> And one question, how long will be data logs replay time during init,
>>> if SSD is almost full of dirty data logs?
>> Sorry, I don't have a data now but it's slow as you may imagine.
>> I will measure the time on later.
>>
>> The major reason is, it needs to read full 512KB segment to calculate checksum to
>> know if the log isn't half written.
>> (Read 500GB SSD that performs 500MB/sec seqread spends 1000secs)
>> I think making the procedure done in parallel to exploit the full internal parallelism
>> inside SSD may improve performance but it's just the matter of coefficient down from 1 to 1/n.
>> Definitely, Writeboost isn't fit for a machine that needs reboot frequently (e.g. desktop).
>>
>> There is a way to reduce the init time. We can dump "what is the latest log written back"
>> on the superblock. This can skip readings that aren't essential.
>>
>> The corresponding code is replay_log_on_cache() function. Please read if you are
>> interested.
>>
>> Thanks,
>>
>> - Akira
>>
>> On 12/13/14 3:45 PM, Jianjian Huo wrote:
>>> If I understand it correctly, the whole idea indeed is very simple,
>>> the consumer/provider and circular buffer model. use SSD as a circular
>>> write buffer, write flush thread stores incoming writes to this buffer
>>> sequentially as provider, and writeback thread write those data logs
>>> sequentially into backing device as consumer.
>>>
>>> If writeboost can do that without any random writes, then probably it
>>> can save SSD/FTL of doing a lot of dirty jobs, and utilize the faster
>>> sequential read/write performance from SSD. That'll be awesome.
>>> However, I saw every data log segment in its design has meta data
>>> header, like dirty_bits, so I guess writeboost has to randomly write
>>> those data headers of stored data logs in SSD; also, splitting all bio
>>> into 4KB will hurt its ability to get max raw SSD throughput, modern
>>> NAND Flash has pages much bigger than 4KB; so overall I think the
>>> actual benefits writeboost gets from this design will be discounted.
>>>
>>> The good thing is that it seems writeboost doesn't use garbage
>>> collection to clean old invalid logs, this will avoid the double
>>> garage collection effect other caching module has, which essentially
>>> both caching module and internal SSD will perform garbage collections
>>> twice.
>>>
>>> And one question, how long will be data logs replay time during init,
>>> if SSD is almost full of dirty data logs?
>>>
>>> Jianjian
>>>
>>> On Fri, Dec 12, 2014 at 7:09 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>>>>> However, after looking at the current code, and using it I think it's
>>>>> a long, long way from being ready for production.  As we've already
>>>>> discussed there are some very naive design decisions in there, such as
>>>>> copying every bio payload to another memory buffer, splitting all io
>>>>> down to 4k.  Think about the cpu overhead and memory consumption!
>>>>> Think about how it will perform when memory is constrained and it
>>>>> can't allocate many of those rambufs!  I'm sure more issues will be
>>>>> found if I read further.
>>>> These decisions are made based on measurement. They are not naive.
>>>> I am a man who dislikes performance optimization without measurement.
>>>> As a result, I regard things brought by the simplicity much important
>>>> than what's from other design decisions possible.
>>>>
>>>> About the CPU consumption,
>>>> the average CPU consumption while performing random write fio
>>>> with consumer level SSD is only 3% or so,
>>>> which is 5 times efficient than bcache per iops.
>>>>
>>>> With RAM-backed cache device, it reaches about 1.5GB/sec throughput.
>>>> Even in this case the CPU consumption is only 12%.
>>>> Please see this post,
>>>> http://www.redhat.com/archives/dm-devel/2014-February/msg00000.html
>>>>
>>>> I don't think the CPU consumption is small enough to ignore.
>>>>
>>>> About the memory consumption,
>>>> you seem to misunderstand the fact.
>>>> The rambufs are not dynamically allocated but statically.
>>>> The default amount is 8MB and this is usually not to argue.
>>>>
>>>>> Mike raised the question of why you want this in the kernel so much?
>>>>> You'd find none of the distros would support it; so it doesn't widen
>>>>> your audience much.  It's far better for you to maintain it outside of
>>>>> the kernel at this point.  Any users will be bold, adventurous people,
>>>>> who will be quite capable of building a kernel module.
>>>> Some people deploy Writeboost in their daily use.
>>>> The sound of "log-structured" seems to easily attract storage guys' attention.
>>>> If this driver is merged into upstream, I think it gains many audience and
>>>> thus feedback.
>>>> When my driver was introduced by Phoronix before, it actually drew attentions.
>>>> They must wait for Writeboost become available in upstream.
>>>> http://www.phoronix.com/scan.php?page=news_item&px=MTQ1Mjg
>>>>
>>>>> I'm sorry to have disappointed you so, but if I let this go upstream
>>>>> it would mean a massive amount of support work for me, not to mention
>>>>> a damaged reputation for dm.
>>>> If you read the code further, you will find how simple the mechanism is.
>>>> Not to mention the code itself is.
>>>>
>>>> - Akira
>>>>
>>>> On 12/12/14 11:24 PM, Joe Thornber wrote:
>>>>> On Fri, Dec 12, 2014 at 09:42:15AM +0900, Akira Hayakawa wrote:
>>>>>> The SSD-caching should be log-structured.
>>>>>
>>>>> No argument there, and this is why I've supported you with
>>>>> dm-writeboost over the last couple of years.
>>>>>
>>>>> However, after looking at the current code, and using it I think it's
>>>>> a long, long way from being ready for production.  As we've already
>>>>> discussed there are some very naive design decisions in there, such as
>>>>> copying every bio payload to another memory buffer, splitting all io
>>>>> down to 4k.  Think about the cpu overhead and memory consumption!
>>>>> Think about how it will perform when memory is constrained and it
>>>>> can't allocate many of those rambufs!  I'm sure more issues will be
>>>>> found if I read further.
>>>>>
>>>>> I'm sorry to have disappointed you so, but if I let this go upstream
>>>>> it would mean a massive amount of support work for me, not to mention
>>>>> a damaged reputation for dm.
>>>>>
>>>>> Mike raised the question of why you want this in the kernel so much?
>>>>> You'd find none of the distros would support it; so it doesn't widen
>>>>> your audience much.  It's far better for you to maintain it outside of
>>>>> the kernel at this point.  Any users will be bold, adventurous people,
>>>>> who will be quite capable of building a kernel module.
>>>>>
>>>>> - Joe
>>>>>
>>>>
>>>> --
>>>> dm-devel mailing list
>>>> dm-devel@redhat.com
>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>


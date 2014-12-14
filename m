Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaLNDBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 22:01:00 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61409 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaLNDA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 22:00:59 -0500
Message-ID: <548CFD65.2080207@gmail.com>
Date: Sun, 14 Dec 2014 12:00:53 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: thornber@redhat.com
CC: snitzer@redhat.com, gregkh@linuxfoundation.org, dm-devel@redhat.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com> <548A39E7.80508@gmail.com> <20141212142447.GA30315@debian> <548B0517.6070603@gmail.com>
In-Reply-To: <548B0517.6070603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just measured how split affects.

I think seqread can make the discussion solid
so these are the cases of reading 6.4GB (64MB * 100) sequentially.

HDD: 
64MB read
real     2m1.191s
user     0m0.000s
sys     0m0.470s

Writeboost (HDD+SSD):
64MB read
real     2m13.532s
user     0m0.000s
sys     0m28.740s

The splitting actually affects to some extent (2m1 -> 2m13 is 10% loss).
But not too big if we consider the typical workload is NOT seqreads
(if so, the user shouldn't use SSD caching).

Splitting bio into 4KB chunks makes the cache lookup and locking simple
and this contributes to the performance of both write and read is the fact,
don't miss it. Without this, especially, writes isn't so fast in Writeboost
but rather loses its charms.

Since simple and fast is the ideal for any softwares. I am really unwilling
to change this fundamental design; splitting.

But, an idea of selective splitting can be proposed for future enhancement.
Add a layer so that a target can choose if it needs splitting or not may be
interesting. I think Writeboost can bypass big writes/reads at the cost of
duplicated cache lookup. Can DM-cache also benefit from this extension?

Conceptually, it's like this
before: bio -> ~map:bio->bio
after: bio -> ~should_split:bio->bool -> ~map:bio->bio

- Akira


On 12/13/14 12:09 AM, Akira Hayakawa wrote:
>> However, after looking at the current code, and using it I think it's
>> a long, long way from being ready for production.  As we've already
>> discussed there are some very naive design decisions in there, such as
>> copying every bio payload to another memory buffer, splitting all io
>> down to 4k.  Think about the cpu overhead and memory consumption!
>> Think about how it will perform when memory is constrained and it
>> can't allocate many of those rambufs!  I'm sure more issues will be
>> found if I read further.
> These decisions are made based on measurement. They are not naive.
> I am a man who dislikes performance optimization without measurement.
> As a result, I regard things brought by the simplicity much important
> than what's from other design decisions possible.
> 
> About the CPU consumption,
> the average CPU consumption while performing random write fio
> with consumer level SSD is only 3% or so,
> which is 5 times efficient than bcache per iops.
> 
> With RAM-backed cache device, it reaches about 1.5GB/sec throughput.
> Even in this case the CPU consumption is only 12%.
> Please see this post,
> http://www.redhat.com/archives/dm-devel/2014-February/msg00000.html
> 
> I don't think the CPU consumption is small enough to ignore.
> 
> About the memory consumption,
> you seem to misunderstand the fact.
> The rambufs are not dynamically allocated but statically.
> The default amount is 8MB and this is usually not to argue.
> 
>> Mike raised the question of why you want this in the kernel so much?
>> You'd find none of the distros would support it; so it doesn't widen
>> your audience much.  It's far better for you to maintain it outside of
>> the kernel at this point.  Any users will be bold, adventurous people,
>> who will be quite capable of building a kernel module.
> Some people deploy Writeboost in their daily use.
> The sound of "log-structured" seems to easily attract storage guys' attention.
> If this driver is merged into upstream, I think it gains many audience and
> thus feedback.
> When my driver was introduced by Phoronix before, it actually drew attentions.
> They must wait for Writeboost become available in upstream.
> http://www.phoronix.com/scan.php?page=news_item&px=MTQ1Mjg
> 
>> I'm sorry to have disappointed you so, but if I let this go upstream
>> it would mean a massive amount of support work for me, not to mention
>> a damaged reputation for dm.
> If you read the code further, you will find how simple the mechanism is.
> Not to mention the code itself is.
> 
> - Akira
> 
> On 12/12/14 11:24 PM, Joe Thornber wrote:
>> On Fri, Dec 12, 2014 at 09:42:15AM +0900, Akira Hayakawa wrote:
>>> The SSD-caching should be log-structured.
>>
>> No argument there, and this is why I've supported you with
>> dm-writeboost over the last couple of years.
>>
>> However, after looking at the current code, and using it I think it's
>> a long, long way from being ready for production.  As we've already
>> discussed there are some very naive design decisions in there, such as
>> copying every bio payload to another memory buffer, splitting all io
>> down to 4k.  Think about the cpu overhead and memory consumption!
>> Think about how it will perform when memory is constrained and it
>> can't allocate many of those rambufs!  I'm sure more issues will be
>> found if I read further.
>>
>> I'm sorry to have disappointed you so, but if I let this go upstream
>> it would mean a massive amount of support work for me, not to mention
>> a damaged reputation for dm.
>>
>> Mike raised the question of why you want this in the kernel so much?
>> You'd find none of the distros would support it; so it doesn't widen
>> your audience much.  It's far better for you to maintain it outside of
>> the kernel at this point.  Any users will be bold, adventurous people,
>> who will be quite capable of building a kernel module.
>>
>> - Joe
>>
> 


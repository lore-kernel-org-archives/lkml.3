Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3BLSEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:04:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639Ab3BLSEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:04:41 -0500
Message-ID: <511A842B.1030101@redhat.com>
Date: Tue, 12 Feb 2013 19:04:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of buffers
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <1360671815-2135-2-git-send-email-pbonzini@redhat.com> <20130212145620.GA3392@redhat.com> <511A608B.5080007@redhat.com> <20130212154338.GA4083@redhat.com> <511A6457.80609@redhat.com> <20130212161326.GB4373@redhat.com> <511A6B2B.50700@redhat.com> <20130212163524.GB4555@redhat.com> <511A7493.50901@redhat.com> <20130212173454.GA5028@redhat.com>
In-Reply-To: <20130212173454.GA5028@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 18:34, Michael S. Tsirkin ha scritto:
> On Tue, Feb 12, 2013 at 05:57:55PM +0100, Paolo Bonzini wrote:
>> Il 12/02/2013 17:35, Michael S. Tsirkin ha scritto:
>>> On Tue, Feb 12, 2013 at 05:17:47PM +0100, Paolo Bonzini wrote:
>>>> Il 12/02/2013 17:13, Michael S. Tsirkin ha scritto:
>>>>>> In this series, however, I am still using nsg to choose between direct
>>>>>> and indirect.  I would like to use dirtect for small scatterlists, even
>>>>>> if they are surrounded by a request/response headers/footers.
>>>>>
>>>>> Shouldn't we base this on total number of s/g entries?
>>>>> I don't see why does it matter how many calls you use
>>>>> to build up the list.
>>>>
>>>> The idea is that in general the headers/footers are few (so their number
>>>> doesn't really matter) and are in singleton scatterlists.  Hence, the
>>>> heuristic checks at the data part of the request, and chooses
>>>> direct/indirect depending on the size of that part.
>>>
>>> Why? Why not the total size as we did before?
>>
>> "More than one buffer" is not a great heuristic.  In particular, it
>> causes all virtio-blk and virtio-scsi requests to go indirect.
> 
> If you don't do indirect you get at least 2x less space in the ring.
> For blk there were workloads where we always were out of buffers.

The heuristic is very conservative actually, and doesn't really get even
close to out-of-buffers.  You can see that in the single-queue results:

# of targets    single-queue
1                  540
2                  795
4                  997
8                 1136
16                1440
24                1408
32                1515

These are with the patched code; if queue space was a problem, you would
see much worse performance as you increase the number of targets (and
benchmark threads).  These are for virtio-scsi, that puts all disks on a
single request queue.

> Similarly for net, switching heuristics degrades some workloads.

Net is not affected.  Obviously for the mergeable buffers case that
always uses direct, but also for the others you can check that it will
always use direct/indirect as in the old scheme.  (Which is why I liked
this heuristic, too).

> Let's not change these things as part of unrelated API work,
> it should be a separate patch with benchmarking showing this
> is not a problem.

The change only happens for virtio-blk and virtio-scsi.  I benchmarked
it, if somebody found different results it would be easily bisectable.

>> More than three buffers, or more than five buffers, is just an ad-hoc
>> hack, and similarly not great.
> 
> If you want to expose control over indirect buffer to drivers,
> we can do this. There were patches on list. How about doing that
> and posting actual performance results?  In particular maybe this is
> where all the performance wins come from?

No, it's not.  Code that was high-ish in the profile disappears
(completely, not just from the profile :)).  But it's not just
performance wins, it's also simplified code and locking, so it would be
worthwhile even with no performance win.

Anyhow, I've sent v2 of this patch with the old heuristic.  It's a
one-line change, it's fine.

>>>> And we also have more complex (and slower) code, that would never be
>>>> used.
>>>
>>> Instead of 
>>> 	flags = (directon == from_device) ? out : in;
>>>
>>> you would do
>>>
>>> 	flags = idx > in ? out : in;
>>>
>>> why is this slower?
>>
>> You said "in + out instead of nsg + direction", but now instead you're
>> talking about specifying in/out upfront in virtqueue_start_buf.
>>
>> Specifying in/out in virtqueue_add_sg would have two loops instead of
>> one, one of them (you don't know which) unused on every call, and
>> wouldn't fix the problem of possibly misusing the API.
> 
> One loop, and it also let us avoid setting VRING_DESC_F_NEXT
> instead of set then later clear:
> 
> +               for_each_sg(sgl, sg, nents, n) {
> 
> +       		flags = idx > in_sg ? VRING_DESC_F_WRITE : 0;
> +       		flags |= idx < (in_sg + out_sg - 1) ? VRING_DESC_F_NEXT : 0;
> +                       tail = &vq->indirect_base[i];
> +                       tail->flags = flags;
> +                       tail->addr = sg_phys(sg);
> +                       tail->len = sg->length;
> +                       tail->next = ++i;
> +               }                           
> 

And slower it becomes.

>>  If not, you traded one possible misuse with another.
>>
>>>> You would never save more than one call, because you cannot
>>>> alternate out and in buffers arbitrarily.
>>>
>>> That's the problem with the API, it apparently let you do this, and
>>> if you do it will fail at run time.  If we specify in/out upfront in
>>> start, there's no way to misuse the API.
>>
>> Perhaps, but 3 or 4 arguments (in/out/nsg or in/out/nsg_in/nsg_out) just
>> for this are definitely too many and make the API harder to use.
>>
>> You have to find a balance.  Having actually used the API, the
>> possibility of mixing in/out buffers by mistake never even occurred to
>> me, much less happened in practice, so I didn't consider it a problem.
>> Mixing in/out buffers in a single call wasn't a necessity, either.
> 
> It is useful for virtqueue_add_buf implementation.

        ret = virtqueue_start_buf(vq, data, out + in, !!out + !!in,
				  gfp);
        if (ret < 0)
                return ret;

        if (out)
                virtqueue_add_sg(vq, sg, out, DMA_TO_DEVICE);
        if (in)
                virtqueue_add_sg(vq, sg + out, in, DMA_FROM_DEVICE);

        virtqueue_end_buf(vq);
	return 0;

How can it be simpler and easier to understand than that?

> Basically the more consistent the interface is with virtqueue_add_buf,
> the better.

The interface is consistent with virtqueue_add_buf_single, where out/in
clearly doesn't make sense.

virtqueue_add_buf and virtqueue_add_sg are very different, despite the
similar name.

> I'm not against changing virtqueue_add_buf if you like but let's keep
> it all consistent.

How can you change virtqueue_add_buf?

Paolo


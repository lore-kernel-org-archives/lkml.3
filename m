Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab3BLQR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:17:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758377Ab3BLQR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:17:57 -0500
Message-ID: <511A6B2B.50700@redhat.com>
Date: Tue, 12 Feb 2013 17:17:47 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of buffers
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <1360671815-2135-2-git-send-email-pbonzini@redhat.com> <20130212145620.GA3392@redhat.com> <511A608B.5080007@redhat.com> <20130212154338.GA4083@redhat.com> <511A6457.80609@redhat.com> <20130212161326.GB4373@redhat.com>
In-Reply-To: <20130212161326.GB4373@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 17:13, Michael S. Tsirkin ha scritto:
>>>>>>> + * @nsg: the number of sg lists that will be added
>>>>> This means number of calls to add_sg ? Not sure why this matters.
>>>>> How about we pass in in_num/out_num - that is total # of sg,
>>>>> same as add_buf?
>>>>
>>>> It is used to choose between direct and indirect.
>>>
>>> total number of in and out should be enough for this, no?
>>
>> Originally, I used nsg/nents because I wanted to use mixed direct and
>> indirect buffers.  nsg/nents let me choose between full direct (nsg ==
>> nents), mixed (num_free >= nsg), full indirect (num_free < nsg).  Then I
>> had to give up because QEMU does not support it, but I still would like
>> to keep that open in the API.
> 
> Problem is it does not seem to make sense in the API.

Why not?  Perhaps in the idea you have of the implementation, but in the
API it definitely makes sense.  It's a fast-path API, it makes sense to
provide as much information as possible upfront.

>> In this series, however, I am still using nsg to choose between direct
>> and indirect.  I would like to use dirtect for small scatterlists, even
>> if they are surrounded by a request/response headers/footers.
> 
> Shouldn't we base this on total number of s/g entries?
> I don't see why does it matter how many calls you use
> to build up the list.

The idea is that in general the headers/footers are few (so their number
doesn't really matter) and are in singleton scatterlists.  Hence, the
heuristic checks at the data part of the request, and chooses
direct/indirect depending on the size of that part.

>>>>>>> +/**
>>>>>>> + * virtqueue_add_sg - add sglist to buffer being built
>>>>>>> + * @_vq: the virtqueue for which the buffer is being built
>>>>>>> + * @sgl: the description of the buffer(s).
>>>>>>> + * @nents: the number of items to process in sgl
>>>>>>> + * @dir: whether the sgl is read or written (DMA_TO_DEVICE/DMA_FROM_DEVICE only)
>>>>>>> + *
>>>>>>> + * Note that, unlike virtqueue_add_buf, this function follows chained
>>>>>>> + * scatterlists, and stops before the @nents-th item if a scatterlist item
>>>>>>> + * has a marker.
>>>>>>> + *
>>>>>>> + * Caller must ensure we don't call this with other virtqueue operations
>>>>>>> + * at the same time (except where noted).
>>>>> Hmm so if you want to add in and out, need separate calls?
>>>>> in_num/out_num would be nicer?
>>>>
>>>> If you want to add in and out just use virtqueue_add_buf...
>>>
>>> I thought the point of this one is maximum flexibility.
>>
>> Maximum flexibility does not include doing everything in one call (the
>> other way round in fact: you already need to wrap with start/end, hence
>> doing one or two extra add_sg calls is not important).
> 
> My point is, we have exactly same number of parameters:
> in + out instead of nsg + direction, and we get more
> functionality.

And we also have more complex (and slower) code, that would never be
used.  You would never save more than one call, because you cannot
alternate out and in buffers arbitrarily.  And if you look at how the
API is actually used in virtio-blk and virtio-scsi, building the buffers
"two-piecewise" doesn't fit the flow of the code.

Paolo

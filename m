Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaIVJza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaIVJz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:55:29 -0400
Message-ID: <541FF20B.4080201@redhat.com>
Date: Mon, 22 Sep 2014 17:55:23 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/2] vhost: support urgent descriptors
References: <1404203661-7521-1-git-send-email-mst@redhat.com> <1404203661-7521-2-git-send-email-mst@redhat.com> <541BD6E9.2010707@redhat.com> <541D503B.3070507@redhat.com> <541F97CF.7000305@redhat.com> <20140922065539.GA12057@redhat.com>
In-Reply-To: <20140922065539.GA12057@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 02:55 PM, Michael S. Tsirkin wrote:
> On Mon, Sep 22, 2014 at 11:30:23AM +0800, Jason Wang wrote:
>> On 09/20/2014 06:00 PM, Paolo Bonzini wrote:
>>> Il 19/09/2014 09:10, Jason Wang ha scritto:
>>>>>>  
>>>>>> -	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>>>>>> +	if (vq->urgent || !vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>>>> So the urgent descriptor only work when event index was not enabled?
>>>> This seems suboptimal, we may still want to benefit from event index
>>>> even if urgent descriptor is used. Looks like we need return true here
>>>> when vq->urgent is true?
>>> Its ||, not &&.
>>>
>>> Without event index, all descriptors are treated as urgent.
>>>
>>> Paolo
>>>
>> The problem is if vq->urgent is true, the patch checks
>> VRING_AVAIL_F_NO_INTERRUPT bit. This bit were set unconditionally in
>> virtqueue_enable_cb() regardless of event index feature and cleared
>> unconditionally in virtqueue_disable_cb().
> The reverse actually, right?

Ah, right.
>
>> So virtqueue_enable_cb() was
>> used to not only publish a new event index but also enable the urgent
>> descriptor. And virtqueue_disable_cb() disabled all interrupts including
>> the urgent descriptor. Guest won't get urgent interrupts by just adding
>> virtqueue_add_outbuf_urgent() since what it needs is to enable and
>> disable interrupt for !urgent descriptor.
> Right, we want a new API that advances event index but does not
> set VRING_AVAIL_F_NO_INTERRUPT.
> IMO still want to set VRING_AVAIL_F_NO_INTERRUPT when handling tx
> interrupts, to avoid interrupt storms.

I see, so urgent descriptor needs to be disabled in this case. But vhost
parts need a little big changes, we could not just check
VRING_AVAIL_F_NO_INTERRUPT when vq->urgent is true. If event index is
enabled, we still need to check used event to make sure the current tx
delayed interrupt works.

But just re-using VRING_AVAIL_F_NO_INTERRUPT for urgent descriptor may
not work in some case. I see codes of virtqueue_get_buf() that may
breaks this:

        /* If we expect an interrupt for the next entry, tell
host                                                                                                       

         * by writing event index and flush out the write
before                                                                                                         

         * the read in the next get_buf call. */
        if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
                vring_used_event(&vq->vring) = vq->last_used_idx;
                virtio_mb(vq->weak_barriers);
        }

Consider if only urgent descriptor is enabled, this will publish used
event which in fact enable lots of unnecessary interrupt. In fact I
don't quite understand how the above lines is used. Virtio-net stop the
queue before enable the tx interrupt in start_xmit(), so the above lines
will not run at all.

>> Btw, not sure "urgent" is a suitable name, since interrupt is often slow
>> in kvm guest. And in fact virtio-net will probably use "urgent"
>> descriptor for those packets (e.g stream packets who can be delayed a
>> little bit to batch more bytes from userspace) who was not urgent
>> compared to other packets.
>>
> Yes but we are asking for an interrupt before event index is reached
> because something is waiting for the packet to be transmitted.
> I couldn't come up with a better name.
>

Ok.


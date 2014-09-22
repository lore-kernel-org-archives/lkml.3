Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaIVDaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaIVDa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:30:28 -0400
Message-ID: <541F97CF.7000305@redhat.com>
Date: Mon, 22 Sep 2014 11:30:23 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/2] vhost: support urgent descriptors
References: <1404203661-7521-1-git-send-email-mst@redhat.com>	<1404203661-7521-2-git-send-email-mst@redhat.com> <541BD6E9.2010707@redhat.com> <541D503B.3070507@redhat.com>
In-Reply-To: <541D503B.3070507@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 06:00 PM, Paolo Bonzini wrote:
> Il 19/09/2014 09:10, Jason Wang ha scritto:
>>>>  
>>>> -	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>>>> +	if (vq->urgent || !vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>> So the urgent descriptor only work when event index was not enabled?
>> This seems suboptimal, we may still want to benefit from event index
>> even if urgent descriptor is used. Looks like we need return true here
>> when vq->urgent is true?
> Its ||, not &&.
>
> Without event index, all descriptors are treated as urgent.
>
> Paolo
>

The problem is if vq->urgent is true, the patch checks
VRING_AVAIL_F_NO_INTERRUPT bit. This bit were set unconditionally in
virtqueue_enable_cb() regardless of event index feature and cleared
unconditionally in virtqueue_disable_cb(). So virtqueue_enable_cb() was
used to not only publish a new event index but also enable the urgent
descriptor. And virtqueue_disable_cb() disabled all interrupts including
the urgent descriptor. Guest won't get urgent interrupts by just adding
virtqueue_add_outbuf_urgent() since what it needs is to enable and
disable interrupt for !urgent descriptor.

Btw, not sure "urgent" is a suitable name, since interrupt is often slow
in kvm guest. And in fact virtio-net will probably use "urgent"
descriptor for those packets (e.g stream packets who can be delayed a
little bit to batch more bytes from userspace) who was not urgent
compared to other packets.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaFKOok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:44:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36464 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFKOoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:44:38 -0400
Message-ID: <53986B4F.9000106@redhat.com>
Date: Wed, 11 Jun 2014 16:44:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Rusty Russell <rusty@rustcorp.com.au>
CC: Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world
 switch
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>	<5387F8B2.1070509@kernel.dk>	<CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com>	<5387FC96.4030508@kernel.dk> <877g537q6d.fsf@rustcorp.com.au>	<53888D08.1050602@kernel.dk> <87sino5cl2.fsf@rustcorp.com.au> <CACVXFVN9aBrdmeAQJ6YadF_6grSjm9raiLV1=eUMAL20uUeeCw@mail.gmail.com>
In-Reply-To: <CACVXFVN9aBrdmeAQJ6YadF_6grSjm9raiLV1=eUMAL20uUeeCw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/06/2014 15:06, Ming Lei ha scritto:
>> >
>> > If you're running SMP under an emulator where exits are expensive, then
>> > this wins.  Under KVM it's marginal at best.
> Both my tests on arm64 and x86 are under KVM, and looks the
> patch can improve performance a lot. IMO, even though under
> KVM, virtio-blk performance still depends how well hypervisor(
> qemu, ...) emulates the device, and basically speaking, it is
> expensive to switch from guest to host and let host handle the
> notification.

The difference is that virtio-pci supports ioeventfd and virtio-mmio 
doesn't.

With ioeventfd you can tell KVM "I don't care about the value that is 
written to a memory location, only that it is accessed".  Then when the 
write happens, KVM doesn't do an expensive userspace exit; it just 
writes 1 to an eventfd.

It then returns to the guest, userspace picks up the eventfd via its 
poll() loop and services the device.

This is already useful for throughput on UP, and the small latency cost 
(because of the cost of the event loop in the I/O thread, and possibly 
the cost of waking up the thread) is usually offset by the benefit.

But on SMP you get double benefit.  Obviously, the kernel doesn't have 
to spin while userspace does its stuff.  On top of this, there is also a 
latency improvement from ioeventfd, because QEMU processes 
virtqueue_notify under its "big QEMU lock".  With ioeventfd, serialized 
virtqueue processing can be a bottleneck, but it doesn't affect latency. 
  Without ioeventfd it affects the VCPUs' latency and negates a lot of 
the benefit of Ming Lei's patch.

You can try disabling ioeventfd with "-global 
virtio-blk-pci.ioeventfd=off" on the QEMU command line.  Performance 
will plummet. :)

Paolo

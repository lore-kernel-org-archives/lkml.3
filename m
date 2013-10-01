Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3JAGjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3JAGjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:39:36 -0400
Message-ID: <524A6E29.1050702@redhat.com>
Date: Tue, 01 Oct 2013 08:39:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v3 3/3] tile: enable VIRTIO support for KVM
References: <20130826120445.GD8218@redhat.com> <54dadfbf688618a900310d10363b9c395fa3d322.1377736306.git.cmetcalf@tilera.com> <522F14F8.2000101@redhat.com> <5249DAEC.2090106@tilera.com>
In-Reply-To: <5249DAEC.2090106@tilera.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/09/2013 22:11, Chris Metcalf ha scritto:
> As I said to Gleb in the previous email - sorry for the delay in
> replying to your thoughtful comments!
> 
> 
> On 9/10/2013 8:47 AM, Paolo Bonzini wrote:
>> Il 28/08/2013 22:58, Chris Metcalf ha scritto:
>>> This change enables support for a virtio-based console,
>>> network support, and block driver support.
>>>
>>> We remove some debug code in relocate_kernel_64.S that made raw
>>> calls to the hv_console_putc Tilera hypervisor API, since everything
>>> now should funnel through the early_hv_write() API.
>>>
>>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> Why couldn't this use the "regular" virtio-mmio interface?
> 
> We probably should!  We were working with a CentOS 6 style distribution,
> which has an older version of qemu; we upgraded slightly to 0.13 in
> the thought that minimizing version skew would help distribution compatibility.
> That version doesn't have the virtio-mmio stuff.  But you're right, we probably
> should return the virtio-mmio stuff to the community instead, even if we're
> going to keep something like this patch in our local copy of KVM.

Thanks, that looks like the right thing to do.

The difference between s390-virtio and virtio-mmio is that s390 has a
single device that supports multiple "back-ends", with hotplug and
hot-unplug support.

virtio-mmio supports a fixed number of devices, defined in the board by
creating a number of instances of the "naked" virtio-mmio front-ends.

On the other hand, s390-virtio was never fully specified and is not part
of the virtio standardization effort (because s390 has now switched to a
different mechanism).

>>>  static void early_hv_write(struct console *con, const char *s, unsigned n)
>>>  {
>>> +#ifdef CONFIG_KVM_GUEST
>>> +     char buf[512];
>>> +
>>> +     if (n > sizeof(buf) - 1)
>>> +             n = sizeof(buf) - 1;
>>> +     memcpy(buf, s, n);
>>> +     buf[n] = '\0';
>>> +
>>> +     hcall_virtio(KVM_VIRTIO_NOTIFY, __pa(buf));
>> How can userspace know the difference between KVM_VIRTIO_NOTIFY with a
>> string buffer, and KVM_VIRTIO_NOTIFY with a config space pointer?
>>
>> In fact, this looks like a completely separate hypercall, why not keep
>> hv_console_putc?
> 
> Good point.  Right now in qemu the virtio hypercall with a KVM_VIRTIO_NOTIFY
> reason either does a virtio_queue_notify(), if the address is not in RAM,
> or a print, if it is.  It does seem we could just have separate calls;
> the reason we grouped it in with the KVM_VIRTIO stuff instead of implementing
> it with the hv_console_write() API is just that it uses the virtio_console
> API to do the work.  But we probably could do it the other way too, and
> that might arguably make more sense.  We'll think about it.

Yeah, using virtio-console is just an implementation-dependent issue.  I
think it's better to keep the previous guest code for early printk.

Paolo


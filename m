Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3D2Mxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:53:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab3D2Mxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:53:35 -0400
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
Date: Mon, 29 Apr 2013 14:53:32 +0200
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Peter Maydell <peter.maydell@linaro.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au> <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de> <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29.04.2013, at 14:48, Pranavkumar Sawargaonkar wrote:

> On 29 April 2013 17:52, Alexander Graf <agraf@suse.de> wrote:
>> 
>> 
>> Am 29.04.2013 um 05:09 schrieb Rusty Russell <rusty@rustcorp.com.au>:
>> 
>>> Alexander Graf <agraf@suse.de> writes:
>>>> On 26.04.2013, at 13:04, Pranavkumar Sawargaonkar wrote:
>>>> 
>>>>> This patch-set implements early printk support for virtio console devices without using any hypercalls.
>>>>> 
>>>>> The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch-set does not break existing hypercall based early print support.
>>>>> 
>>>>> This implementation adds:
>>>>> 1. Early writeonly register named early_wr in virtio console's config space.
>>>>> 2. Host feature flags namely VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-write capability in console device.
>>>>> 
>>>>> Early write mechanism:
>>>>> 1. When a guest wants to out some character, it has to simply write the character to early_wr register in config space of virtio console device.
>>>> 
>>>> I won't nack this patch set, but I'll definitely express that I'm not happy with it.
>>>> 
>>>> MMIO registers are handled by a different layer than the virtio console itself. After the virtio refactoring in QEMU, they will be completely separate drivers. So we'll be in a similar mess with early printk as we are on the s390-virtio machine, where early printk is done through hypercalls and thus we can't directly link it to the console output.
>>>> 
>>>> I still don't see what the issue is with just implementing a small irq-less virtio driver for early printk.
>>> 
>>> Well, this shouldn't be mmio-specific, but I kind of get what you mean.
>>> 
>>> I consider this misnamed: it's an emergency write facility.  Linux may
>>> use it for an early console,
>> 
>> If Linux uses it for early console, you won't see any messages from before the virtio-console driver is initialized, because Linux thinks that it's all been printed out.
> 
> So far i have tried this on foundation model for armv8 and i never saw
> any missed out prints.

It's what I got back on s390. If you run upstream QEMU, you'll simply lose half of your log messages. Because in upstream QEMU, the side channel used for early printk got nack'ed.

> 
>> 
>>> but it's also useful for bringup and to
>>> give a method of emitting errors like "the console ring is corrupt".
>>> 
>>> A valid implementation may well be to only offer it with some magic
>>> qemu developer-only commandline and dump it to stdout.
>> 
>> Why implement it differently from other machines? There are facilities to call into firmware, so you could use that. There's the special Foundation model call that you could implement and reuse for this.
>> 
>> I don't see why anything like this has to live in virtio-mmio. Oh, and it should default to off.
> 
> All the boards may not have firmware to do this. Foundation model call
> is also not useful on real hardware for armv8.  This is very helpful
> in debugging a guest on real hardware when guest crashes in early

Are you seriously considering to use virtio-console on real hardware?

> stages before virtio drivers come in to the picture.
> This is not a virtio-mmio change it is just an addition of device
> specific register in virtio console.

There are not device specific registers in virtio-console. Virtio-console lives behind a virtio bus which doesn't know what these registers are. Even if you shove it into config space, it'd be broken because config access happens without intercepts on some platforms.


Alex


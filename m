Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3D2MWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:22:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab3D2MWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:22:48 -0400
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au>
Mime-Version: 1.0 (1.0)
In-Reply-To: <87obcyc9sh.fsf@rustcorp.com.au>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Peter Maydell <peter.maydell@linaro.org>
X-Mailer: iPhone Mail (10B142)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Date: Mon, 29 Apr 2013 14:22:46 +0200
To: Rusty Russell <rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.04.2013 um 05:09 schrieb Rusty Russell <rusty@rustcorp.com.au>:

> Alexander Graf <agraf@suse.de> writes:
>> On 26.04.2013, at 13:04, Pranavkumar Sawargaonkar wrote:
>> 
>>> This patch-set implements early printk support for virtio console devices without using any hypercalls.
>>> 
>>> The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch-set does not break existing hypercall based early print support.
>>> 
>>> This implementation adds:
>>> 1. Early writeonly register named early_wr in virtio console's config space.
>>> 2. Host feature flags namely VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-write capability in console device.
>>> 
>>> Early write mechanism:
>>> 1. When a guest wants to out some character, it has to simply write the character to early_wr register in config space of virtio console device.
>> 
>> I won't nack this patch set, but I'll definitely express that I'm not happy with it.
>> 
>> MMIO registers are handled by a different layer than the virtio console itself. After the virtio refactoring in QEMU, they will be completely separate drivers. So we'll be in a similar mess with early printk as we are on the s390-virtio machine, where early printk is done through hypercalls and thus we can't directly link it to the console output.
>> 
>> I still don't see what the issue is with just implementing a small irq-less virtio driver for early printk.
> 
> Well, this shouldn't be mmio-specific, but I kind of get what you mean.
> 
> I consider this misnamed: it's an emergency write facility.  Linux may
> use it for an early console,

If Linux uses it for early console, you won't see any messages from before the virtio-console driver is initialized, because Linux thinks that it's all been printed out.

> but it's also useful for bringup and to
> give a method of emitting errors like "the console ring is corrupt".
> 
> A valid implementation may well be to only offer it with some magic
> qemu developer-only commandline and dump it to stdout.

Why implement it differently from other machines? There are facilities to call into firmware, so you could use that. There's the special Foundation model call that you could implement and reuse for this.

I don't see why anything like this has to live in virtio-mmio. Oh, and it should default to off.

Alex

> 
> So I think it has use, but less so if QEMU isn't ever going to implement
> it.
> 
> Cheers,
> Rusty.
> 

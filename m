Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab3BMQkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:40:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36164 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab3BMQkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:40:40 -0500
Message-ID: <511BC204.7060006@arm.com>
Date: Wed, 13 Feb 2013 16:40:36 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pawel Moll <Pawel.Moll@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH] virt_mmio: fix signature checking for BE guests
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com>  <1360768102.4045.107.camel@hornet> <511BB134.30003@arm.com> <1360770379.4045.115.camel@hornet>
In-Reply-To: <1360770379.4045.115.camel@hornet>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Feb 2013 16:40:37.0664 (UTC) FILETIME=[DA2BC200:01CE0A08]
X-MC-Unique: 113021316403802301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 15:46, Pawel Moll wrote:
> On Wed, 2013-02-13 at 15:28 +0000, Marc Zyngier wrote:
>>>> Fix it by encoding the magic as an integer instead of a string.
>>>> So I'm not completely sure this is the right fix, 
>>>
>>> It seems right, however...
>>>
>>>> - Using __raw_readl() instead. Is that a generic enough API?
>>>>
>>> ... this implies that either the spec is wrong (as it should say: the
>>> device registers are always LE, in the PCI spirit) or all readl()s & co.
>>> should be replaced with __raw equivalents.
>>
>> Well, the spec clearly says that the registers reflect the endianess of
>> the guest, and it makes sense: when performing the MMIO access, KVM
>> needs to convert between host and guest endianess.
> 
> The virtio-mmio spec says so because it seemed like a good idea at the
> time ;-) after reading the PCI device spec. But - as I said - I missed
> the fact that the readl()-like accessors will always do le32_to_cpu().
> Apparently ioread32() does the same (there's a separate ioread32be()).

Maybe. There's so much byte swapping at every possible level that my
head spins... ;-)

> So I'm not sure that the spec is correct in this aspect any more. Maybe
> it should specify the registers as LE always, similarly to PCI? This
> problem is already covered by "2.3.1 A Note on Virtqueue Endianness" in
> the spec...

This section basically covers shared memory, and there is not much we
can do about it. When it comes to the registers (that actually trap into
the hypervisor), it probably makes sense to declare them as LE indeed.

>>> Having said that, does the change make everything else work with a BE
>>> guest? (I assume we're talking about the guest being BE, right? ;-) If
>>> so it means that the host is not following the current spec and it
>>> treats all the registers as LE.
>>
>> Yes, I only care about a BE guest. And no, not much is actually working
>> (kvmtool is not happy about the guest addresses it finds in the
>> virtio-ring). Need to dive into it and understand what needs to be fixed...
> 
> Do the other registers like queuenum make sense? Could it be that the
> page number of the ring you're getting has wrong endianness?

The addresses are definitely wrong. kvmtool is spitting things like:
Warning: unable to translate guest address 0xe8fd828f00000000 to host

which tends to indicate that yes, page numbers are the other way around.
Cross-endianness shared memory fun.

	M.
-- 
Jazz is not dead. It just smells funny...


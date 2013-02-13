Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab3BMP26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:28:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39628 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab3BMP24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:28:56 -0500
Message-ID: <511BB134.30003@arm.com>
Date: Wed, 13 Feb 2013 15:28:52 +0000
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
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com> <1360768102.4045.107.camel@hornet>
In-Reply-To: <1360768102.4045.107.camel@hornet>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Feb 2013 15:28:53.0223 (UTC) FILETIME=[D4862F70:01CE09FE]
X-MC-Unique: 113021315285504601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 15:08, Pawel Moll wrote:
> On Wed, 2013-02-13 at 14:25 +0000, Marc Zyngier wrote:
>> Using readl() to read the magic value and then memcmp() to check it
>> fails on BE, as bytes will be the other way around (by virtue of
>> the registers to follow the endianess of the guest).
> 
> Hm. Interesting. I missed the fact that readl() as a "PCI operation"
> will always assume LE values...
> 
>> Fix it by encoding the magic as an integer instead of a string.
>> So I'm not completely sure this is the right fix, 
> 
> It seems right, however...
> 
>> - Using __raw_readl() instead. Is that a generic enough API?
>>
> ... this implies that either the spec is wrong (as it should say: the
> device registers are always LE, in the PCI spirit) or all readl()s & co.
> should be replaced with __raw equivalents.

Well, the spec clearly says that the registers reflect the endianess of
the guest, and it makes sense: when performing the MMIO access, KVM
needs to convert between host and guest endianess.

> Having said that, does the change make everything else work with a BE
> guest? (I assume we're talking about the guest being BE, right? ;-) If
> so it means that the host is not following the current spec and it
> treats all the registers as LE.

Yes, I only care about a BE guest. And no, not much is actually working
(kvmtool is not happy about the guest addresses it finds in the
virtio-ring). Need to dive into it and understand what needs to be fixed...

>> - Reading the MAGIC register byte by byte. Is that allowed? The spec
>>   only says it is 32bit wide.
> 
> And the spirit of the spec was: _exactly 32bit wide_. It's just simpler
> to implement one access width on the host side.

I guessed as much...

	M.
-- 
Jazz is not dead. It just smells funny...


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3BNGE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:04:56 -0500
Received: from ozlabs.org ([203.10.76.45]:42364 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3BNGEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:04:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [RFC PATCH] virt_mmio: fix signature checking for BE guests
In-Reply-To: <20130213165356.GA23193@redhat.com>
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com> <1360768102.4045.107.camel@hornet> <511BB134.30003@arm.com> <20130213165356.GA23193@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 14 Feb 2013 10:52:48 +1030
Message-ID: <87wqubkalj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Wed, Feb 13, 2013 at 03:28:52PM +0000, Marc Zyngier wrote:
>> On 13/02/13 15:08, Pawel Moll wrote:
>> > On Wed, 2013-02-13 at 14:25 +0000, Marc Zyngier wrote:
>> >> Using readl() to read the magic value and then memcmp() to check it
>> >> fails on BE, as bytes will be the other way around (by virtue of
>> >> the registers to follow the endianess of the guest).
>> > 
>> > Hm. Interesting. I missed the fact that readl() as a "PCI operation"
>> > will always assume LE values...
>> > 
>> >> Fix it by encoding the magic as an integer instead of a string.
>> >> So I'm not completely sure this is the right fix, 
>> > 
>> > It seems right, however...
>> > 
>> >> - Using __raw_readl() instead. Is that a generic enough API?
>> >>
>> > ... this implies that either the spec is wrong (as it should say: the
>> > device registers are always LE, in the PCI spirit) or all readl()s & co.
>> > should be replaced with __raw equivalents.
>> 
>> Well, the spec clearly says that the registers reflect the endianess of
>> the guest, and it makes sense: when performing the MMIO access, KVM
>> needs to convert between host and guest endianess.
>> 
>> > Having said that, does the change make everything else work with a BE
>> > guest? (I assume we're talking about the guest being BE, right? ;-) If
>> > so it means that the host is not following the current spec and it
>> > treats all the registers as LE.
>> 
>> Yes, I only care about a BE guest. And no, not much is actually working
>> (kvmtool is not happy about the guest addresses it finds in the
>> virtio-ring). Need to dive into it and understand what needs to be fixed...
>
> Does it work for qemu? I know people were using virtio on BE there.

It's had no end of problems: the powerpc folk are quite upset with me.

If I were doing virtio again, I'd use LE everywhere: device authors
*expect* to worry about endian, and it's confusing for them when they
don't.

It's tempting to use LE for the PCI config space for the new layout, for
example.

If you want to specify virtio-mmio as LE, feel free.

Cheers,
Rusty.

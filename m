Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3GZAtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:49:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38321 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab3GZAtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:49:07 -0400
Message-ID: <51F1C76A.8020407@zytor.com>
Date: Thu, 25 Jul 2013 17:48:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Ugly patches for stolen reservation
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org> <20130725200551.GA16719@gmail.com> <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com> <CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
In-Reply-To: <CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:31 PM, Linus Torvalds wrote:
> On Thu, Jul 25, 2013 at 3:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> So the bootloader is just as likely to step on things... what happens when/if it does?
> 
> This isn't a new problem. We've had this "firmware tables don't show
> all devices" issue before.
> 

Yes, I just want to know what happens.

> The only odd thing about this one is how the quirk in question uses
> "e820_add_region()" instead of just adding things to the MMIO list.
> And I think that's actually likely a mistake.
> 
> So Jesse, why don't you do what the other quirks do, and claim an
> actual MMIO resource? If you make it a real resource, you'll get to
> use fancy things like REAL NAMES, and actually document it. With
> human-readable strings.
> 
> See quirk_io_region() in drivers/pci/quirks.c for example. The same
> code except for IORESOURCE_MEM should do a lovely job..
> 
> And even *if* it's already marked reserved in the e820 table, it just
> looks nice in /proc/iomem.

We should do both -- mark it reserved in early boot, and add it as an
MMIO region later during boot.

The problem here, if I'm reading this right, is that this memory region
is marked as normal RAM in e820, which is much worse than just not
marking it as reserved; we need to intercept this memory before we
genuinely turn it into normal RAM.

At the same time, we have no protection against the bootloader using
this as memory or even placing the kernel there.  The BIOS needs to be
fixed regardless of what workarounds we do in the kernel.

	-hpa



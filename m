Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbaKNOKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbaKNOKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:10:39 -0500
Date: Fri, 14 Nov 2014 15:10:30 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] kvm: x86: increase user memory slots to 509
Message-ID: <20141114151030.75f588bd@igors-macbook-pro.local>
In-Reply-To: <545BA09E.7040301@redhat.com>
References: <1415289167-24661-1-git-send-email-imammedo@redhat.com>
	<545BA09E.7040301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2014 17:23:58 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
> 
> On 06/11/2014 16:52, Igor Mammedov wrote:
> > With the 3 private slots, this gives us 512 slots total.
> > Motivation for this is in addition to assigned devices
> > support more memory hotplug slots, where 1 slot is
> > used by a hotplugged memory stick.
> > It will allow to support upto 256 hotplug memory
> > slots and leave 253 slots for assigned devices and
> > other devices that use them.
> > 
> > Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> 
> It would use more memory, and some loops are now becoming more
> expensive.  In general adding a memory slot to a VM is not cheap, and
> I question the wisdom of having 256 hotplug memory slots.  But the
> slowdown mostly would only happen if you actually _use_ those memory
> slots, so it is not a blocker for this patch.
It might be useful to have a big amount of slots for big guests
and although linux works with minimum section 128Mb but Windows memory
hotplug works just fine even with page-sized slots so when unplug in
QEMU is implemented it would be possible to drop balooning driver at
least there.

And providing that memslots could be allocated during runtime when guest
programs devices or maps roms (i.e. no fail path), I don't see a way
to fix it in QEMU (i.e. avoid abort when limit is reached).
Hence an attempt to bump memslots limit to 512, where current 125
are reserved for initial memory mappings and passthrough devices 
256 goes to hotplug memory slots and leaves us 128 free slots for
future expansion.

To see what would be affected by large amount of slots I played with
perf a bit and the biggest hotspot offender with large amount of
memslots was:

 gfn_to_memslot() -> ... -> search_memslots()

I'll try to make it faster for this case so 512 memslots wouldn't
affect guest performance.

So please consider applying this patch.

> 
> Paolo


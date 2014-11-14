Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603AbaKNOxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:53:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965504AbaKNOxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:53:21 -0500
Message-ID: <54661758.5080707@redhat.com>
Date: Fri, 14 Nov 2014 15:53:12 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] kvm: x86: increase user memory slots to 509
References: <1415289167-24661-1-git-send-email-imammedo@redhat.com>	<545BA09E.7040301@redhat.com> <20141114151030.75f588bd@igors-macbook-pro.local>
In-Reply-To: <20141114151030.75f588bd@igors-macbook-pro.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/2014 15:10, Igor Mammedov wrote:
> On Thu, 06 Nov 2014 17:23:58 +0100 Paolo Bonzini <pbonzini@redhat.com> wrote:
>> It would use more memory, and some loops are now becoming more
>> expensive.  In general adding a memory slot to a VM is not cheap, and
>> I question the wisdom of having 256 hotplug memory slots.  But the
>> slowdown mostly would only happen if you actually _use_ those memory
>> slots, so it is not a blocker for this patch.
> It might be useful to have a big amount of slots for big guests
> and although linux works with minimum section 128Mb but Windows memory
> hotplug works just fine even with page-sized slots so when unplug in
> QEMU is implemented it would be possible to drop balooning driver at
> least there.

I think for a big (64G?) guest it doesn't make much sense anyway to
balloon at a granularity that is less than 1G or even more.  So I like
the idea of dropping ballooning in favor of memory hotplug for big guests.

> And providing that memslots could be allocated during runtime when guest
> programs devices or maps roms (i.e. no fail path), I don't see a way
> to fix it in QEMU (i.e. avoid abort when limit is reached).
> Hence an attempt to bump memslots limit to 512, where current 125
> are reserved for initial memory mappings and passthrough devices 
> 256 goes to hotplug memory slots and leaves us 128 free slots for
> future expansion.
> 
> To see what would be affected by large amount of slots I played with
> perf a bit and the biggest hotspot offender with large amount of
> memslots was:
> 
>  gfn_to_memslot() -> ... -> search_memslots()
> 
> I'll try to make it faster for this case so 512 memslots wouldn't
> affect guest performance.
> 
> So please consider applying this patch.

Yes, sorry for the delay---I am definitely going to apply it.

Paolo

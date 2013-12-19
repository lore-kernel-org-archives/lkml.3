Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LSAlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:41:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3LSAlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:41:11 -0500
Date: Wed, 18 Dec 2013 16:41:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
Message-Id: <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org>
In-Reply-To: <52B23CAF.809@sr71.net>
References: <20131213235903.8236C539@viggo.jf.intel.com>
	<20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>
	<52AF9EB9.7080606@sr71.net>
	<0000014301223b3e-a73f3d59-8234-48f1-9888-9af32709a879-000000@email.amazonses.com>
	<52B23CAF.809@sr71.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 16:24:15 -0800 Dave Hansen <dave@sr71.net> wrote:

> On 12/17/2013 07:17 AM, Christoph Lameter wrote:
> > On Mon, 16 Dec 2013, Dave Hansen wrote:
> > 
> >> I'll do some testing and see if I can coax out any delta from the
> >> optimization myself.  Christoph went to a lot of trouble to put this
> >> together, so I assumed that he had a really good reason, although the
> >> changelogs don't really mention any.
> > 
> > The cmpxchg on the struct page avoids disabling interrupts etc and
> > therefore simplifies the code significantly.
> > 
> >> I honestly can't imagine that a cmpxchg16 is going to be *THAT* much
> >> cheaper than a per-page spinlock.  The contended case of the cmpxchg is
> >> way more expensive than spinlock contention for sure.
> > 
> > Make sure slub does not set __CMPXCHG_DOUBLE in the kmem_cache flags
> > and it will fall back to spinlocks if you want to do a comparison. Most
> > non x86 arches will use that fallback code.
> 
> 
> I did four tests.  The first workload allocs a bunch of stuff, then
> frees it all with both the cmpxchg-enabled 64-byte struct page and the
> 48-byte one that is supposed to use a spinlock.  I confirmed the 'struct
> page' size in both cases by looking at dmesg.
> 
> Essentially, I see no worthwhile benefit from using the double-cmpxchg
> over the spinlock.  In fact, the increased cache footprint makes it
> *substantially* worse when doing a tight loop.
> 
> Unless somebody can find some holes in this, I think we have no choice
> but to unset the HAVE_ALIGNED_STRUCT_PAGE config option and revert using
> the cmpxchg, at least for now.
> 

So your scary patch series which shrinks struct page while retaining
the cmpxchg_double() might reclaim most of this loss?

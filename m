Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaJCEyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:54:06 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33862 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaJCEyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:54:04 -0400
Date: Fri, 3 Oct 2014 06:53:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        dave@sr71.net, linux-kernel@vger.kernel.org, eranian@google.com,
        x86@kernel.org, torvalds@linux-foundation.org,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: Re: [PATCH 2/2] x86: Only do a single page fault for
 copy_from_user_nmi
Message-ID: <20141003045359.GA24281@gmail.com>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-3-git-send-email-andi@firstfloor.org>
 <20140929115620.GH5430@worktop>
 <20140929152646.GC1629@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929152646.GC1629@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > For now, changing the semantics of the function seems like a 
> > sure way to fail in the future though.
> 
> I doubt it. Nearly nobody uses the exact return value 
> semantics.
> 
> (iirc it's mostly write() and some bizarre code in mount)
> 
> In fact it's a regular mistake to assume it returns -errno.
> 
> > > In theory we could also duplicate the whole copy_*_ path 
> > > for cases where the caller doesn't care about the exact 
> > > bytes. But that seems overkill for just this issue, and I'm 
> > > not sure anyone else cares about how fast this is. The 
> > > simpler check works as well for now.
> > 
> > So I don't get that code, but why not fix it in general? 
> > Taking two faults seems silly.
> 
> It's really complicated to reconstruct the exact bytes, as an 
> optimized memcpy is very complicated and has a lot of corner 
> cases.
> 
> I tried it originally when writing the original copy function, 
> but failed. That is why people came up later with this 
> two-fault scheme.
> 
> I think two fault is fine for most cases, just not for NMIs.

Slapping an ugly in_nmi() check into a generic memcpy routine, 
especially if it changes semantics, is asking for trouble.
It is a non-starter and I'm NAK-ing it.

There are cleaner ways to solve this problem - PeterZ offered 
one, but there are other options as well, such as:

 - removing exact-bytes semantics explicitly from almost all 
   cases and offering a separate (and more expensive, in the 
   faulting case) memcpy variant for write() and other code that 
   absolutely must know the number of copied bytes.

 - or adding a special no-bytes-copied memcpy variant that the 
   NMI code could use.

Use one of these or outline that they cannot possibly work.

It might be more work for you, but it gives us a cleaner and more 
maintainable kernel. The problem is that you should know this 
general principle already, instead you are wasting maintainer 
bandwidth via arguing in favor of ugly hacks again and again...

Thanks,

	Ingo

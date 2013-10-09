Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3JIKjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:39:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36368 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3JIKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:39:53 -0400
Date: Wed, 9 Oct 2013 12:39:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131009103932.GB3081@twins.programming.kicks-ass.net>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <52541556.5060907@gmail.com>
 <20131008194129.GC7315@gmail.com>
 <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
 <20131009095906.GB17480@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009095906.GB17480@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 11:59:06AM +0200, Ingo Molnar wrote:
> PeterZ didn't like exposing the physical RAM address, right?

More than not like; its useless and broken, see below.

> Peter: could we expose the page frame number instead? (Maybe mix it with a 
> random seed through the hash-mixer and expose that.) User-space will thus 
> be able to discover whether two pages are shared or not, but not extract 
> other information.

No, all physical stuff is useless, a page can get moved about through
swap/ksm/thp/compaction/etc.

> The global MM ID thing looked rather ugly as well.

I'm still having the argument with Stephane -- although it fell off-list
-- on why this wouldn't work.

AFAICT the mm_id should work for CLONE_VM, as CLONE_VM inherits the
entire address space so all should be identical when mm_id match.

> That way we could drop the inode info as well? That feels a bit hacky too.

No, the inode stuff is required for shared pages, its the only way to
track them; and barring a filename (which we've so far used for this)
the dev:ino:gen thing is the only way to uniquely identify files -- it
even works where filenames don't, eg. filesystem namespaces and weird
things like shm that don't have stable filenames.

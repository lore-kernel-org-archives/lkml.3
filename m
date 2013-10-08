Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3JHJys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:54:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60133 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3JHJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:54:47 -0400
Date: Tue, 8 Oct 2013 11:54:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131008095430.GQ3081@twins.programming.kicks-ass.net>
References: <20131002190001.GX3081@twins.programming.kicks-ass.net>
 <CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
 <20131002203107.GY3081@twins.programming.kicks-ass.net>
 <CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
 <20131003090347.GB3081@twins.programming.kicks-ass.net>
 <CABPqkBSmYBdBx1vXj3ZJycM311eQPeK6kFxvtm3jtovp-qgm+w@mail.gmail.com>
 <20131008065449.GL3081@twins.programming.kicks-ass.net>
 <CABPqkBROM9jZfkU7suD-7=N=M38BCcVgdbgKoe-GE1RhY0puEg@mail.gmail.com>
 <20131008093638.GO3081@twins.programming.kicks-ass.net>
 <CABPqkBQgnqhHwAo9hgg5b-UUV1Zwfs=9TC+-xb3BTP6GqJg8Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQgnqhHwAo9hgg5b-UUV1Zwfs=9TC+-xb3BTP6GqJg8Ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:42:06AM +0200, Stephane Eranian wrote:
> On Tue, Oct 8, 2013 at 11:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Oct 08, 2013 at 09:15:30AM +0200, Stephane Eranian wrote:
> >> Yes, it is but I am trying to see whether or not we could unify that and
> >> use a single u64 number to uniquely identify each mapping.
> >
> > No you cannot; two unrelated executables which have distinct mm_ids can
> > easily mmap() the same shared file.
> 
> That seems to indicate the mm_ids is not attached to the right level of VM
> data structure. 

No that's not it.. shared mappings can create arbitrary couplings
between mm's, there's really nothing you can do about that.

This is really only about anonymous memory shared with CLONE_VM.

> But I am okay with keeping it that way and stashing the mm_id
> as a pseudo inode number for the case of non file-backed mappings. If we
> say maj=min=ino=gen=0 means no "info", then any other combinations can
> be used to identify identical mappings. We use actual min,maj, ino, gen
> for file backed, and maj=min=gen=0 + ino = mm_ids for the other cases.
> That should work, shouldn't it?

I'm not sure if min=maj=0 is a valid device, nor do I know if ino=0 is a
valid ino. But I suppose the name "//anon" should be a big enough clue
if both of those fail.

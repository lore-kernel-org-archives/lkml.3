Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3I3Qyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:54:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3I3Qyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:54:32 -0400
Date: Mon, 30 Sep 2013 18:54:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20130930165420.GI3081@twins.programming.kicks-ass.net>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <20130930161546.GG3081@twins.programming.kicks-ass.net>
 <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 06:48:55PM +0200, Stephane Eranian wrote:
> On Mon, Sep 30, 2013 at 6:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Sep 30, 2013 at 05:44:41PM +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >> I was alerted by people trying to use the PERF_RECORD_MMAP2
> >> record to disambiguate virtual address mappings that there is a case
> >> where the record does not contain enough information.
> >>
> >> As you know, the MMAP2 record adds the major, minor, ino number,
> >> inode generation numbers to a mapping. But it does that only for
> >> file or pseudo -file backed mappings. That covers file mmaps and also
> >> SYSV shared memory segments.
> >>
> >> However there is a another kind of situation that arises in some
> >> multi-process benchmarks where a region of memory is cloned
> >> using VM_CLONE. As such, the virtual addresses match between
> >> the processes but the major, minor, inode, inode generation  fields
> >> are all zeroes because there is no inode associated with the mapping.
> >> Yet, it is important for the tool to know the mappings between the
> >> processes are pointing to the same physical data.
> >>
> >> We need to cover this case and I am seeking for advice on how to
> >> best address this need given that we discarded using the plain physical
> >> address for disambiguation.
> >
> > Urgh.. who in his bloody mind is playing VM_CLNOE games that is not
> > pthread_creatE() ?
> 
> Some matrix multiply benchmark, I guess.

So the problem is that we don't have a user visible address space
identifier; with CLONE_THREAD we have the thread group id that acts
like this. But for bare CLONE_VM usage there's nothing afaik.

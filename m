Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3JHTyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:54:51 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:57202 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3JHTyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131008194129.GC7315@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
	<52541556.5060907@gmail.com>
	<20131008194129.GC7315@gmail.com>
Date: Tue, 8 Oct 2013 21:54:49 +0200
Message-ID: <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 9:41 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> Stephane:
>>
>> On 9/30/13 9:44 AM, Stephane Eranian wrote:
>> >I was alerted by people trying to use the PERF_RECORD_MMAP2
>> >record to disambiguate virtual address mappings that there is a case
>> >where the record does not contain enough information.
>> >
>> >As you know, the MMAP2 record adds the major, minor, ino number,
>> >inode generation numbers to a mapping. But it does that only for
>> >file or pseudo -file backed mappings. That covers file mmaps and also
>> >SYSV shared memory segments.
>> >
>> >However there is a another kind of situation that arises in some
>> >multi-process benchmarks where a region of memory is cloned
>> >using VM_CLONE. As such, the virtual addresses match between
>> >the processes but the major, minor, inode, inode generation  fields
>> >are all zeroes because there is no inode associated with the mapping.
>> >Yet, it is important for the tool to know the mappings between the
>> >processes are pointing to the same physical data.
>> >
>> >We need to cover this case and I am seeking for advice on how to
>> >best address this need given that we discarded using the plain physical
>> >address for disambiguation.
>>
>>
>> If the current MMAP2 is not a complete solution for what you (Google)
>> need, should support be reverted before 3.12 is released? No sense in
>> making this part of the forever API if more work is needed on it.
>
> Instead of a full revert we could just turn off the ABI portion minimally
> and not recognize it for now. Assuming a more complete solution is in the
> works for v3.13.
>
That's a possibility. They are also pieces in the perf tool itself.
We could certainly make the attr->mmap2 bit disappear.

I think it boils down to how can we uniquely identify virtual
mapping to the same physical data either via shmat(), files, VM_CLONE.
We had all covered but the last case with the ino approach. We don't have
a solution for VM_CLONE yet.

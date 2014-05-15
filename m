Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaEOSC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:02:29 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34793 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEOSC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:02:26 -0400
Date: Thu, 15 May 2014 20:02:18 +0200
From: Robert Richter <rric@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
Message-ID: <20140515180218.GA32115@rric.localhost>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.05.14 18:08:30, Alexander Shishkin wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> This patch introduces "AUX space" in the perf mmap buffer, intended for
> exporting high bandwidth data streams to userspace, such as instruction
> flow traces.
> 
> AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> user_page structure, and read/write pointers aux_{head,tail}, which abide
> by the same rules as data_* counterparts of the main perf buffer.
> 
> In order to allocate/mmap AUX, userspace needs to set up aux_offset to
> such an offset that will be greater than data_offset+data_size and
> aux_size to be the desired buffer size. Both need to be page aligned.
> The latter is not forced to be a power of 2 number of pages, so that PMU
> drivers have to take care of this if necessary in their implementations
> of ->alloc_aux(). Then, same aux_offset and aux_size should be passed to
> mmap() call and if everything adds up, you should have an AUX buffer as
> a result.

Raw data sample (PERF_SAMPLE_RAW) already allow to pass data to
userspace. What is the reason for a separate buffer? I see the
following:

 * the buffer accessed from userspace should have a customized format
   unrelated to perf,

 * zero copying (not sure if this is really possible),

 * data size and alignment requirements that can not be handled by raw
   data samples.

If possible, raw data samples should be a first option.

On the other side there might the need of an aux buffer (I would
better call it raw buffer analog to raw data). So here some comments
on the implementation and the user i/f.

Instead of extending the current ringbuffer I would better add a 2nd
ring buffer. The mmap and ringbuffer handling and esp. the access from
userspace looks much more complex now and it was already complex
before. So with a 2nd buffer there would be less changes in the
implementation and handling. Access from userland would remain as it
currently is, there is no need to modify the header page layout. To
setup a 2nd buffer, you just need to modify the mmap call in a way
(maybe by prot, flags or offset argument) to let the kernel know an
aux buffer should be attached to the event.

Then, instead of introducing a new PERF_RECORD_AUX, just reuse
PERF_RECORD_SAMPLE. If an aux/raw buffer is connected to the event,
then the data is not part of the sample but passed to the raw buffer.

Tools, interfaces and helper functions would work already with such
raw samples, just the raw buffer handling need to be added.

How about this?

-Robert

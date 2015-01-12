Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbbALNPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:15:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:31450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbALNPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:15:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,744,1413270000"; 
   d="scan'208";a="660477023"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        "Metzger\, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        "Liang\, Kan" <kan.liang@intel.com>,
        "Hunter\, Adrian" <adrian.hunter@intel.com>,
        "mathieu.poirier\@linaro.org" <mathieu.poirier@linaro.org>,
        "acme\@infradead.org" <acme@infradead.org>
Subject: Re: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data streams
In-Reply-To: <20150109151814.GP3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com> <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com> <A78C989F6D9628469189715575E55B231E676088@IRSMSX104.ger.corp.intel.com> <20150109151814.GP3337@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 12 Jan 2015 15:12:58 +0200
Message-ID: <87d26knnvp.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Nov 17, 2014 at 09:33:00AM +0000, Metzger, Markus T wrote:
>> > From: Peter Zijlstra <peterz@infradead.org>
>> > 
>> > This patch introduces "AUX space" in the perf mmap buffer, intended for
>> > exporting high bandwidth data streams to userspace, such as instruction
>> > flow traces.
>> > 
>> > AUX space is a ring buffer, defined by aux_{offset,size} fields in the
>> > user_page structure, and read/write pointers aux_{head,tail}, which abide
>> > by the same rules as data_* counterparts of the main perf buffer.
>> > 
>> > In order to allocate/mmap AUX, userspace needs to set up aux_offset to
>> > such an offset that will be greater than data_offset+data_size and
>> > aux_size to be the desired buffer size. Both need to be page aligned.
>> > Then, same aux_offset and aux_size should be passed to mmap() call and
>> > if everything adds up, you should have an AUX buffer as a result.
>> 
>> Why would userspace need to fill in aux_offset and aux_size?  Can't the kernel
>> do this when userspace mmaps the aux buffer like it does for the respective
>> data_* fields?
>
> I suppose we could; I'm trying to remember why I did it like this, I'm
> failing to remember much past yesterday atm :/ 

Well, right now we can only map things in one order: user page + perf
buffer, then aux buffer. Ideally, we can reduce it to mapping the user
page first (always R/W), setting up the desired offsets for data and aux
buffers and then mapping those in whatever order. And we can also have
holes between them if we want (not sure if that's useful, though).

If we want to stick to the current scheme of things where user page is
mapped together with data, we should set up aux_{offset,size} in
kernel's perf_mmap() path, similarly to data_{offset,size}.

There is another problem with it, though: it makes it impossible to run
the aux buffer in "full trace mode" (where we move the tail as we read
the data out), while running the data buffer in overwrite mode, because
the latter requires the user_page to be mapped RO => no way to update
aux_tail for the user.

>> How would userspace fill in those fields if it mapped the data buffer read-only?
>
> Good point, its not used much atm. But yes. That also reminds me; we
> should probably finish this:
>
>   https://lkml.org/lkml/2013/7/8/154

Indeed, it's been on my todo list for some time.

Regards,
--
Alex

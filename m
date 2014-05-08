Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaEHJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:09:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:58885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaEHJJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="536948317"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <87ppjodiex.fsf@ashishki-desk.ger.corp.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140507152640.GR30445@twins.programming.kicks-ass.net> <87ppjodiex.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 May 2014 12:08:58 +0300
Message-ID: <87k39wd4d1.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:

> Peter Zijlstra <peterz@infradead.org> writes:
>
>> How about something like this for the itrace thing?
>
> It's much nicer than the page swizzling draft I was about to send you.
>
>> You would mmap() the regular buffer; when write ->aux_{offset,size} in
>> the control page. After which you can do a second mmap() with the .pgoff
>> matching the aux_offset you gave and .length matching the aux_size you
>> gave.
>
> Why do we need aux_{offset,size} at all, then? Userspace should know how
> they mmap()ed it.
>
>> This way the mmap() content still looks like a single linear file (could
>> be sparse if you leave a hole, although we could require the aux_offset
>> to match the end of the data section).
>>
>> And there is still the single event->rb, not more.
>
> Fair enough.
>
>> Then, when data inside that aux data store changes they should inject an
>> PERF_RECORD_AUX to indicate this did happen, which ties it back into the
>> normal event flow.
>>
>> With this there should be no difficult page table tricks or anything.
>
> True.
>
>> The patch is way incomplete but should sketch enough of the idea..
>
> Can I take it over?
>
>> So the aux_head/tail values should also be in the file space and not
>> start at 0 again, similar for the offsets in the AUX record.
>
> With PERF_RECORD_AUX carrying offset and size, we shouldn't need
> aux_{head,tail} either, don't you think?

I take this one back, as perf record doesn't actually parse records from
the buffer, it would still need the pointers.

Regards,
--
Alex

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaIIJkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:40:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:15429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbaIIJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="588457417"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
In-Reply-To: <20140909084436.GY19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com> <20140909084436.GY19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Sep 2014 12:40:39 +0300
Message-ID: <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 20, 2014 at 03:36:06PM +0300, Alexander Shishkin wrote:
>
>> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
>> index 925f369947..5006caba63 100644
>> --- a/kernel/events/ring_buffer.c
>> +++ b/kernel/events/ring_buffer.c
>
>> @@ -294,9 +295,22 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
>>  			 bool truncated)
>>  {
>>  	struct ring_buffer *rb = handle->rb;
>> +	unsigned long aux_head;
>>  
>> +	aux_head = local_read(&rb->aux_head);
>> +
>> +	if (rb->aux_overwrite) {
>> +		local_set(&rb->aux_head, size);
>> +
>> +		/*
>> +		 * Send a RECORD_AUX with size==0 to communicate aux_head
>> +		 * of this snapshot to userspace
>> +		 */
>> +		perf_event_aux_event(handle->event, size, 0, truncated);
>
> Humm.. why not write a 'normal' AUX record?

In this mode, the hardware is running in a circular buffer mode,
overwriting old data, so we don't actually know the size of the
snapshot, we have userspace figure it out later on (based on timestamps,
for example). I didn't want to configure PMI for this mode to avoid
overhead, but with PMI we can try to keep track of the overwrites and
try to infer the actual snapshot size in the kernel. For Intel PT. As
far as I can tell, ARM's scatter-gather trace-to-memory storing block
does not generate interrupts at all.

> Also, you didn't mention this in your Changelog _at_all_.

Will do.

Regards,
--
Alex

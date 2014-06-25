Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaFYLY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:24:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:39438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbaFYLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,545,1400050800"; 
   d="scan'208";a="533859281"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 6/7] perf: add api for pmus to write to AUX space
In-Reply-To: <20140624172723.GS3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com> <1402501310-31940-7-git-send-email-alexander.shishkin@linux.intel.com> <20140624172723.GS3213@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 25 Jun 2014 14:24:51 +0300
Message-ID: <87fvitxmd8.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jun 11, 2014 at 06:41:49PM +0300, Alexander Shishkin wrote:
>> +void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
>> +			 bool truncated)
>> +{
>> +	struct ring_buffer *rb = handle->rb;
>> +	unsigned long aux_head;
>> +
>> +	aux_head = local_read(&rb->aux_head);
>> +	local_add(size, &rb->aux_head);
>> +
>> +	rb->user_page->aux_head = local_read(&rb->aux_head);
>> +	smp_wmb();
>> +
>> +	perf_output_wakeup(handle);
>> +	handle->event = NULL;
>> +
>> +	ring_buffer_put(rb);
>> +}
>
> This thing is distinctly less complex than perf_output_put_handle().. ?

This one doesn't support nested writers, but there shouldn't be any
either. But I notice now that the barrier is misplaced. Wakeup watermark
is not yet taken care of, but will be. Anything else I'm missing?

Regards,
--
Alex

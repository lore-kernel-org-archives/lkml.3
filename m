Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaIIJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:54:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:49853 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIIJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:54:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="476289832"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 06/22] perf: Redirect output from inherited events to parents
In-Reply-To: <20140908152655.GU19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-7-git-send-email-alexander.shishkin@linux.intel.com> <20140908152655.GU19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Sep 2014 12:54:04 +0300
Message-ID: <87vboxt8zn.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 20, 2014 at 03:36:03PM +0300, Alexander Shishkin wrote:
>> In order to collect AUX data from an inherited event, we can redirect its
>> output to parent's ring buffer if possible (they must be cpu affine). This
>> patch adds set_output() to the inheritance path.
>> 
>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> ---
>>  kernel/events/core.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 67f857ab56..e36478564c 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -7962,6 +7962,12 @@ inherit_event(struct perf_event *parent_event,
>>  		= parent_event->overflow_handler_context;
>>  
>>  	/*
>> +	 * Direct child's output to parent's ring buffer (if any)
>> +	 */
>> +	if (parent_event->cpu != -1)
>> +		(void)perf_event_set_output(child_event, parent_event);
>> +
>> +	/*
>>  	 * Precalculate sample_data sizes
>>  	 */
>>  	perf_event__header_size(child_event);
>
> Uhm, nope, see perf_output_begin(), it always redirects output to parent
> events.

Ouch, indeed. We'll just do the same in perf_aux_output_begin().

Regards,
--
Alex

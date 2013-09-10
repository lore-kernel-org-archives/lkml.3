Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3IJR3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:29:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51102 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3IJR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:29:23 -0400
Message-ID: <522F56F0.4040206@gmail.com>
Date: Tue, 10 Sep 2013 10:29:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <20130909111749.GP31370@twins.programming.kicks-ass.net> <20130909113640.GA16401@krava.redhat.com> <20130909115518.GA26785@twins.programming.kicks-ass.net> <20130909140339.GB16401@krava.redhat.com> <522DD6FF.50107@gmail.com> <20130909160608.GB25555@gmail.com>
In-Reply-To: <20130909160608.GB25555@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/13 9:06 AM, Ingo Molnar wrote:
>> Aren't you losing potentially important events by doing that -- FORK,
>> COMM, MMAP?
>
> I suspect these could/should be tracked and emitted fully (in bulk) when a
> new data file is opened, so that each partial data file is fully
> consistent?

In my case I am not saving task events, but processing them. In Jiri's 
case where events are written to a file it should be possible to stash 
the unprocessed events on a list, when the exit happens move them to a 
dead threads list which can be cleaned up from time to time and then on 
file dump requests dump the task events followed by the sample events.

>
>> I have a flight recorder style command that address this problem
>> (long-running/daemons) by processing task events and then stashing the
>> sample events on a time-ordered list with chopping to maintain the time
>> window.
>
> Could this be used to emit currently relevant task context?

sure.

>
> Btw., I also think it would be useful to have kernel support for that -
> the 'collections' stuff I talked about a good while ago: the kernel would
> work with user-space to iterate over all MMAPs and all running COMMs at
> the opening of a tracing session.
>
> That way we could avoid racy access to /proc, we could make sure that all
> information that is emitted by FORK/COMM/MMAP is also emitted for the
> 'bulk' data, etc.

Walking the task list and emitting events would be better but wouldn't 
that be a performance hit holding the task lock (tasklist_lock?)? (I 
thought that one is needed when walking the task list.)

David


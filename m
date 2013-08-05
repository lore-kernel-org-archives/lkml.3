Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3HEPKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:10:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3HEPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:10:41 -0400
Message-ID: <51FFC020.9040300@redhat.com>
Date: Mon, 05 Aug 2013 11:09:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
References: <20130802205735.GS26476@sgi.com> <20130803170102.GD32568@redhat.com>
In-Reply-To: <20130803170102.GD32568@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 01:01 PM, Oleg Nesterov wrote:

>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	p->thp_disabled = current->thp_disabled;
>> +#endif
>
> Unneeded. It will be copied by dup_task_struct() automagically.
>
> But I simply can't understand why this flag is per-thread. It should be
> mm flag, no?

It has to be per-mm for another reason, too.

Think about what were to happen if one process were ptracing
a process with the thp_disabled flag, and ended up causing a
new anonymous page to be faulted in.

With the thp_disabled flag in the task, get_user_pages would
end up not seeing the flag, and the task could get a transparent
huge page.

With the thp_disabled flag in the mm, it would be possible for
get_user_pages to easily find the flag, and do the right thing.

-- 
All rights reversed

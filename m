Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbaEEXfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:35:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:36816 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaEEXe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:34:58 -0400
Date: Mon, 5 May 2014 16:34:45 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Jiri Kosina <jkosina@suse.cz>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
Message-ID: <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Jiri Kosina wrote:

> On Thu, 1 May 2014, Josh Poimboeuf wrote:
>
>> kpatch vs kGraft
>> ----------------
>>
>> I think the biggest difference between kpatch and kGraft is how they
>> ensure that the patch is applied atomically and safely.
>>
>> kpatch checks the backtraces of all tasks in stop_machine() to ensure
>> that no instances of the old function are running when the new function
>> is applied.  I think the biggest downside of this approach is that
>> stop_machine() has to idle all other CPUs during the patching process,
>> so it inserts a small amount of latency (a few ms on an idle system).
>>
>> Instead, kGraft uses per-task consistency: each task either sees the old
>> version or the new version of the function.  This gives a consistent
>> view with respect to functions, but _not_ data, because the old and new
>> functions are allowed to run simultaneously and share data.  This could
>> be dangerous if a patch changes how a function uses a data structure.
>> The new function could make a data change that the old function wasn't
>> expecting.
>
> Please correct me if I am wrong, but with kPatch, you are also unable to
> do a "flip and forget" switch between functions that expect different
> format of in-memory data without performing a non-trivial all-memory
> lookup to find structures in question and perfoming corresponding
> transformations.
>
> What we can do with kGraft si to perform the patching in two steps
>
> (1) redirect to a temporary band-aid function that can handle both
>    semantics of the data (persumably in highly sub-optimal way)
> (2) patching in (1) succeeds completely (kGraft claims victory), start a
>    new round of patching with redirect to the final function which
>    expects only the new semantics
>
> This basically implies that both aproaches need "human inspection" in this
> respect anyway.

how would you know that all instances of the datastructure in memory have been 
touched? just because all tasks have run and are outside the function in 
question doesn't tell you data structures have been converted. You have no way 
of knowing when (or if) the next call to the modified function will take place 
on any potential in-memory structure.

David Lang

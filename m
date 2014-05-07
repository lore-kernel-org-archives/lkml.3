Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaEGSZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaEGSZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:25:01 -0400
Message-ID: <536A7A59.8050708@redhat.com>
Date: Wed, 07 May 2014 20:24:25 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4 v2] nohz: Fix idle/iowait counts going backwards
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com> <1399470094-8070-3-git-send-email-dvlasenk@redhat.com> <20140507142321.GA2844@laptop.programming.kicks-ass.net> <536A642B.7080309@redhat.com> <20140507165638.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140507165638.GU30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 06:56 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 06:49:47PM +0200, Denys Vlasenko wrote:
>> On 05/07/2014 04:23 PM, Peter Zijlstra wrote:
>>> On Wed, May 07, 2014 at 03:41:33PM +0200, Denys Vlasenko wrote:
>>>> With this change, "iowait-ness" of every idle period is decided
>>>> at the moment it starts:
>>>> if this CPU's run-queue had tasks waiting on I/O, then this idle
>>>> period's duration will be added to iowait_sleeptime.
>>>>
>>>> This fixes the bug where iowait and/or idle counts could go backwards,
>>>> but iowait accounting is not precise (it can show more iowait
>>>> that there really is).
>>>>
>>>
>>> NAK on this, the thing going backwards is a symptom of the bug, not an
>>> actual bug itself.
>>
>> This patch does fix that bug.
> 
> Which bug, there's two here:
> 
>  1) that NOHZ and !NOHZ iowait accounting aren't identical

They can hardly be identical, considering how different these modes are.

And they don't have to be identical, in fact.
It is enough if they give similar numbers for similar usage scenarios.
E.g. if I run dd </dev/sda >/dev/null, I expect that iowait
counter increases while idle counter almost standing still
(on the CPU where dd runs, or course).

>  2) that iowait accounting in general is a steaming pile of crap

If you want to nuke iowait (for example, make its counter constant 0),
I personally won't object. Can't guarantee others won't...

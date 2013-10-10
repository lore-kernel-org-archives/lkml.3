Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3JJTJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:09:00 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59955 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3JJTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:08:59 -0400
Message-ID: <5256FA49.1090008@linux.vnet.ibm.com>
Date: Fri, 11 Oct 2013 00:34:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
References: <20131008102505.404025673@infradead.org> <20131009225006.7101379c.akpm@linux-foundation.org> <20131010121908.GB28601@twins.programming.kicks-ass.net> <20131010145738.GA5167@gmail.com> <20131010152612.GA13375@redhat.com> <20131010090044.7f12ddaf.akpm@linux-foundation.org> <20131010165412.GA16553@redhat.com>
In-Reply-To: <20131010165412.GA16553@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101019-9574-0000-0000-00000A052425
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:24 PM, Oleg Nesterov wrote:
> On 10/10, Andrew Morton wrote:
>>
>> On Thu, 10 Oct 2013 17:26:12 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>> On 10/10, Ingo Molnar wrote:
>>>>
>>>> So ... why not make it _really_ cheap, i.e. the read lock costing nothing,
>>>> and tie CPU hotplug to freezing all tasks in the system?
>>>>
>>>> Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a
>>>> system, I don't understand how we tolerate _any_ overhead from this utter
>>>> slowpath.
>>>
>>> Well, iirc Srivatsa (cc'ed) pointed out that some systems do cpu_down/up
>>> quite often to save the power.
>>
>> cpu hotremove already uses stop_machine,
> 
> And Srivatsa wants to remove it from cpu_down().
> 

Yes, I have worked on several designs to remove stop_machine() from the cpu_down
path.

http://lwn.net/Articles/538819/
http://lwn.net/Articles/556727/

>> so such an approach shouldn't
>> actually worsen things (a lot) for them?
> 
> this depends on what this "freezing all tasks" actually means.
> I understood it as try_to_freeze_tasks/etc, looks too heavy...
> 
> But my only point was, I am not sure we can assume that cpu_down/up
> is extremly rare and its cost does not matter.
> 
>> use stop_machine() on the add/remove
>> (ie, "writer") side and nothing at all on the "reader" side.  Is there
>> anything which fundamentally prevents cpu hotplug from doing the same?
> 

Its certainly possible to remove stop_machine() from CPU hotplug, as I've
demonstrated in the patchsets mentioned above. And there were pretty good
performance improvements too, arising out of that change, as described here:

http://article.gmane.org/gmane.linux.ports.ppc.embedded/56122

Regards,
Srivatsa S. Bhat




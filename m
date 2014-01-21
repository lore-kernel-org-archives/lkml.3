Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaAUMus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:50:48 -0500
Received: from mail2.unitn.it ([193.205.206.22]:62186 "EHLO mail2.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaAUMuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:50:46 -0500
Message-ID: <52DE6D21.1080602@unitn.it>
Date: Tue, 21 Jan 2014 13:50:41 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com> <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us> <52DE5B7F.8020900@unitn.it> <20140121123334.GJ30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140121123334.GJ30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:33 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 12:35:27PM +0100, Luca Abeni wrote:
>>> In a system, we typically look at a set of tasks. In Linux-kernel
>>> terminology, a particular task is normally a thread. When a thread is
>>> ready to run, we say that a *job* of that task is running.
>> This would be true in the original Liu&Layland model (where a task blocks
>> only when a job finishes), but I do not think it is correct in a real system...
>> For example: (notice: this discussion might be slightly off-topic, and I do not
>> think this should go in the document... I am writing just to clarify my point
>> of view)
>> - Let's consider a (over simplified) video decoder as an example of task
>> - The task periodically read a video frame (from disk or network), decodes it,
>>    and displays it
>> - So, each job starts when the frame is read, and finishes when the frame is
>>    displayed. And jobs are (in this case) activated periodically
>> - During the execution of a job, the task might invoke a blocking system call,
>>    and block... When it wakes up, it is still in the same job (decoding the same
>>    video frame), and not in a different one.
>> This is (IMHO) where all the confusion comes from.
>
> I would strongly urge you not to use that as an example, because its
> dead wrong design. An RT thread (be it RR,FIFO or DL) should _NEVER_ do
> blocking IO.
Well, but it does happen in reality :)
I mean: people might want to use SCHED_DEADLINE to schedule mplayer (or similar).
There are even scientific papers showing the advantage of doing so...
And if you try to use ftrace/kernelshark to check the wake-up times and similar
you will notice that even a single-threaded player like mplayer blocks and wakes-up
many times inside a job.

On the other hand, I agree with you that a hard real-time task should be designed
not to do things like this. But SCHED_DEADLINE is flexible enough to be used on
many different kinds of tasks (hard real-time, soft real-time, etc...).

> Have !RT tasks read the stuff from disk into a buffer, then let the RT
> task read data from the buffer and flip frames and such.
>
> If you want to mention blocking, then please use the most common one:
> blocking on a (hopefully PI) mutex.
Ok.

> On the other subject; I wouldn't actually mind if it grew into a proper
> (academic or not) summary of deadline scheduling theory and how it
> applies.
>
> Sure, refer to actual papers for all the proofs and such, but it would
> be very good to go over all the bits and pieces that make up the system.
>
> So cover the periodic, sporadic and aperiodic model like henr_k
> suggested, please do cover the job/instance idiom as it is used all over
> the place.
Ok... My point was that it would be better (IMHO) to first explain how
sched_deadline works (and no notion of job/instance, etc is needed for this),
and then explain how this applies to the real-time task model (and here, of
course all the formal notation can be introduced).

Do you think this can be reasonable?

> Then also treat schedulability tests and their ramification, explain
> what laxity is, what tardiness is, that GEDF doesn't have 0 tardiness
> but does have bounded tardiness.
>
> Maybe even mention the actual bounds -- but refer to papers for their
> proofs.
>
> Mention CBS and the ramification etc..
Ok.
I guess some of these details can be added incrementally, with additional
patches?


> Yes this is all a bit much, but I feel it is important, after all how
> can you properly use something you don't understand? (and yes I know its
> a very popular thing to not want to understand how things work but still
> use them :-/).
>
> I mean, I'm the kind of idiot that actually goes out and read a bunch of
> papers, but many people simply cannot read those things, or are not
> given the time to, even if they wanted and could (arguably they have
> bigger problems).
Ok.



				Thanks,
					Luca

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3CGPz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:55:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3CGPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:55:27 -0500
Message-ID: <5138B84F.1060807@oracle.com>
Date: Thu, 07 Mar 2013 09:54:55 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "aquini@redhat.com" <aquini@redhat.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net> <513626E9.2040509@redhat.com> <51364AB9.80206@hp.com> <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com> <51365B66.5010905@redhat.com> <1362645933.2606.14.camel@laptop> <20130307125546.GD13323@shiny.masoncoding.com>
In-Reply-To: <20130307125546.GD13323@shiny.masoncoding.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 06:55 AM, Chris Mason wrote:
> On Thu, Mar 07, 2013 at 01:45:33AM -0700, Peter Zijlstra wrote:
>> On Tue, 2013-03-05 at 15:53 -0500, Rik van Riel wrote:
>>
>>> Indeed.  Though how well my patches will work with Oracle will
>>> depend a lot on what kind of semctl syscalls they are doing.
>>>
>>> Does Oracle typically do one semop per semctl syscall, or does
>>> it pass in a whole bunch at once?
>>
>> https://oss.oracle.com/~mason/sembench.c
>>
>> I think Chris wrote that to match a particular pattern of semaphore
>> operations the database engine in question does. I haven't checked to
>> see if it triggers the case in point though.
>>
>> Also, Chris since left Oracle but maybe he knows who to poke.
>>
> 
> Dave Kleikamp (cc'd) took over my patches and did the most recent
> benchmarking.  Ported against 3.0:
> 
> https://oss.oracle.com/git/?p=linux-uek-2.6.39.git;a=commit;h=c7fa322dd72b08450a440ef800124705a1fa148c
> 
> The current versions are still in the 2.6.32 oracle kernel, but it looks
> like they reverted this 3.0 commit.  I think with Manfred's upstream
> work my more complex approach wasn't required anymore, but hopefully
> Dave can fill in details.

>From what I recall, I could never get better performance from your
patches that we saw with Manfred's work alone. I can't remember the
reasons for including and then reverting the patches from the 3.0
(2.6.39) Oracle kernel, but in the end we weren't able to justify their
inclusion.

> Here is some of the original discussion around the patch:
> 
> https://lkml.org/lkml/2010/4/12/257
> 
> In terms of how oracle uses IPC, the part that shows up in profiles is
> using semtimedop for bulk wakeups.  They can configure things to use
> either a bunch of small arrays or a huge single array (and anything in
> between). 
> 
> There is one IPC semaphore per process and they use this to wait for
> some event (like a log commit).  When the event comes in, everyone
> waiting is woken in bulk via a semtimedop call.
> 
> So, single proc waking many waiters at once.
> 
> -chris
> 

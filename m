Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaCSRjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:39:10 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57069 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaCSRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:39:07 -0400
Message-ID: <5329D629.6000004@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 23:08:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org> <532840FD.308@linux.vnet.ibm.com> <CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com> <53296870.5010505@linux.vnet.ibm.com> <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com> <53298A7D.3080400@linux.vnet.ibm.com> <CAKohpomQjvkAaty-nBSb=Qyxvk0RhvkwNXC9194gmYr6Vpw5WA@mail.gmail.com> <5329AE56.8080204@linux.vnet.ibm.com>
In-Reply-To: <5329AE56.8080204@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031917-5564-0000-0000-00000C9541F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 08:18 PM, Srivatsa S. Bhat wrote:
> On 03/19/2014 07:05 PM, Viresh Kumar wrote:
>> On 19 March 2014 17:45, Srivatsa S. Bhat
>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>>> +       bool                    transition_ongoing; /* Tracks transition status */
>>> +       struct mutex            transition_lock;
>>> +       wait_queue_head_t       transition_wait;
>>
>> Similar to what I have done in my last version, why do you need
>> transition_ongoing and transition_wait? Simply work with
>> transition_lock? i.e. Acquire it for the complete transition sequence.
>>
> 
> We *can't* acquire it for the complete transition sequence
> in case of drivers that do asynchronous notification, because
> PRECHANGE is done in one thread and POSTCHANGE is done in a
> totally different thread! You can't acquire a lock in one
> task and release it in a different task. That would be a
> fundamental violation of locking.
> 
> That's why I introduced the wait queue to help us create
> a "flow" which encompasses 2 different, but co-ordinating
> tasks. You simply can't do that elegantly by using plain
> locks alone.
> 

By the way, note the updated changelog in my patch. It includes a brief
overview of the synchronization design, which is copy-pasted below for
reference. I forgot to mention this earlier!

-----

This patch introduces a set of synchronization primitives to serialize
frequency transitions, which are to be used as shown below:

cpufreq_freq_transition_begin();

//Perform the frequency change

cpufreq_freq_transition_end();

The _begin() call sends the PRECHANGE notification whereas the _end() call
sends the POSTCHANGE notification. Also, all the necessary synchronization
is handled within these calls. In particular, even drivers which set the
ASYNC_NOTIFICATION flag can also use these APIs for performing frequency
transitions (ie., you can call _begin() from one task, and call the
corresponding _end() from a different task).

The actual synchronization underneath is not that complicated:

The key challenge is to allow drivers to begin the transition from one thread
and end it in a completely different thread (this is to enable drivers that do
asynchronous POSTCHANGE notification from bottom-halves, to also use the same
interface).

To achieve this, a 'transition_ongoing' flag, a 'transition_lock' mutex and a
wait-queue are added per-policy. The flag and the wait-queue are used in
conjunction to create an "uninterrupted flow" from _begin() to _end(). The
mutex-lock is used to ensure that only one such "flow" is in flight at any
given time. Put together, this provides us all the necessary synchronization.

Regards,
Srivatsa S. Bhat


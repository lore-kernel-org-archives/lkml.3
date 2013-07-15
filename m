Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3GOPZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:25:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:51290 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab3GOPZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,669,1367996400"; 
   d="scan'208";a="370547767"
Message-ID: <51E41431.5050901@linux.intel.com>
Date: Mon, 15 Jul 2013 08:24:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com> <51DE9859.8090405@linux.vnet.ibm.com> <20130712134811.GG20960@e103034-lin> <51E36FF3.1050909@linux.vnet.ibm.com> <20130715095504.GA15799@MacBook-Pro.local>
In-Reply-To: <20130715095504.GA15799@MacBook-Pro.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 2:55 AM, Catalin Marinas wrote:
> In terms of how it boosts the performance, a suggestion was to keep the
> power scheduler relatively simple with an API to a new model of power
> driver and have the actual scaling algorithm (governor) as library used
> by the low-level driver. We can keep the API simple like
> get_max_performance() etc. but the driver has the potential to choose
> what is best suited for the hardware.

I like simple ;-)
I like descriptive and intent-driven as well (rather than prescriptive) for high level concepts.
and I like libraries of functionality you can pull from.

one thing we're skirting around in this whole discussion is the concept of performance sensitivity.
or to phrase it in the form of a question "Is more performance desired to have right now?"
Some of these answers certainly can come from the scheduler, at certain specific cases
it will know that the answer is "yes" to that question. An oversubscribed runqueue
is certainly such a case. Scheduling a realtime/highpriority/whatever task.. the scheduler
knows more than anyone else about that.
There are other cases elsewhere in the kernel (the graphics driver may have ideas if it just missed a frame
for example).
Very high interrupt rates are another clear case of such sensitivity.

(and I'm quite fine presuming a "no unless" policy for the question)

what is hard for the scheduler is that by the time the scheduler realizes it's in a hole,
it may already be too late. Yes P states change relatively quickly... and it is certainly
worth saying "I'm in the hole, go faster!".
But seeing the impact of the "go faster" on the RQ will take time, e.g. only some time later
(say 10 to 100 msec) is the scheduler able to evaluate if the change helped enough.
It's tempting to just wait.. but maybe the right answer is to do two things: Load balance right now,
AND boost the P state of the cpus that run the load after the balance. And then 10 to 100 msec later,
evaluate if they can be balanced/consolidated back.
E.g. jump out of the whole instantly, and then look later if the hole is filled enough to jump back into later ;-)


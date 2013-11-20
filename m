Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3KTSVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:21:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:64520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3KTSVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438680538"
Message-ID: <528CFDB1.3020300@linux.intel.com>
Date: Wed, 20 Nov 2013 10:21:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, lenb@kernel.org, rjw@rjwysocki.net,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle implementations
References: <20131120160450.072555619@infradead.org> <20131120162736.508462614@infradead.org> <528CE611.8040903@linux.intel.com> <alpine.DEB.2.02.1311201814410.30673@ionos.tec.linutronix.de> <528CF028.2040002@linux.intel.com> <alpine.DEB.2.02.1311201851040.30673@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1311201851040.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 9:55 AM, Thomas Gleixner wrote:
> On Wed, 20 Nov 2013, Arjan van de Ven wrote:
>> On 11/20/2013 9:23 AM, Thomas Gleixner wrote:
>>> On Wed, 20 Nov 2013, Arjan van de Ven wrote:
>>>
>>>> On 11/20/2013 8:04 AM, Peter Zijlstra wrote:
>>>>> This does not fully preseve existing behaviour in that the generic
>>>>> idle cycle function calls into the normal cpuidle governed idle
>>>>> routines and should thus respect things like QoS parameters and the
>>>>> like.
>>>>
>>>>
>>>> NAK on the powerclamp side.
>>>>
>>>> powerclamp MUST NOT do that....
>>>> it is needed to go to the deepest state no matter what
>>>> (this is for when your system is overheating. there is not a lot of choice
>>>> here... alternative is an emergency reset that the hardware does for
>>>> safety)
>>>
>>> So that whole machinery falls apart when the thing which is running on
>>> that hot core is a while(1) loop with a higher or equal FIFO priority
>>> than this thread. Even if you'd run at prio 99, then there is no
>>> guarantee that the cpu hog does not run with prio 99 as well and due
>>> to FIFO and being on the CPU it's not going to let you on.
>>
>> the idea was to at least give people who know what they're doing a chance to
>> run
>
> You can't be serious about that. Even if people know what they are
> doing, they have no chance to prevent the occasional high prio runaway
> bug. And then you shrug your shoulders and tell that guy who spent
> time to tune the thing proper "bad luck" or what?

his system will crawl to a halt (and if it's for a long time on a system with
submarginal cooling, potentially reboot) due to the hardware protecting itself.
What powerclamp is trying to do is avoid these steps from the hardware (they are both
very harsh and very inefficient).

but for powerclamp to work, it needs to inject a deep idle....
I'm very ok using generic abstractions for that, but the abstraction needs to then
include a "don't be nice about picking shallow C states for performance reasons, just
pick something very deep" parameter.

(powerclamp will adjust if you have some periodic realtime task or interrupts or ..
taking away idle from it, by over time injecting a bit more idle)



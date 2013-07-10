Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3GJLLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:11:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39723 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GJLLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:11:43 -0400
Date: Wed, 10 Jul 2013 12:11:28 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 1/9] sched: Introduce power scheduler
Message-ID: <20130710111128.GB15989@e103687>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
 <51DCC287.40808@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51DCC287.40808@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jul 2013 11:11:35.0956 (UTC) FILETIME=[3DEB6D40:01CE7D5E]
X-MC-Unique: 113071012114000201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 03:10:15AM +0100, Arjan van de Ven wrote:
> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> > +	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
> > +				msecs_to_jiffies(INTERVAL));
> 
> so thinking about this more, this really really should not be a work queue.
> a work queue will cause a large number of context switches for no reason
> (on Intel and AMD you can switch P state from interrupt context, and I'm pretty sure
> that holds for many ARM as well)

Agree. I should have made it clear this is only a temporary solution. I
would prefer to tie the power scheduler to the existing scheduler tick
instead so we don't wake up cpus unnecessarily. nohz may be able handle
that for us. Also, currently the power scheduler updates all cpus.
Going forward this would change to per cpu updates and partial updates
of the global view to improve scalability.
 
> 
> and in addition, it causes some really nasty cases, especially around real time tasks.
> Your workqueue will schedule a kernel thread, which will run
> BEHIND real time tasks, and such real time task will then never be able to start running at a higher performance.
> 
> (and with the delta between lowest and highest performance sometimes being 10x or more,
> the real time task will be running SLOW... quite possible longer than several milliseconds)
> 
> and all for no good reason; a normal timer running in irq context would be much better for this kind of thing!
> 
> 


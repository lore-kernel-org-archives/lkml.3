Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3GJCKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:10:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:54702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab3GJCKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1032,1363158000"; 
   d="scan'208";a="329064506"
Message-ID: <51DCC287.40808@linux.intel.com>
Date: Tue, 09 Jul 2013 19:10:15 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 1/9] sched: Introduce power scheduler
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
In-Reply-To: <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> +	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
> +				msecs_to_jiffies(INTERVAL));

so thinking about this more, this really really should not be a work queue.

a work queue will cause a large number of context switches for no reason
(on Intel and AMD you can switch P state from interrupt context, and I'm pretty sure
that holds for many ARM as well)

and in addition, it causes some really nasty cases, especially around real time tasks.
Your workqueue will schedule a kernel thread, which will run
BEHIND real time tasks, and such real time task will then never be able to start running at a higher performance.

(and with the delta between lowest and highest performance sometimes being 10x or more,
the real time task will be running SLOW... quite possible longer than several milliseconds)


and all for no good reason; a normal timer running in irq context would be much better for this kind of thing!


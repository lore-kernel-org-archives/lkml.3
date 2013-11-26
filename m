Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3KZIuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:50:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40974 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KZIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:50:28 -0500
Date: Tue, 26 Nov 2013 09:50:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, hpa@zytor.com
Subject: Re: Add memory barrier when waiting on futex
Message-ID: <20131126085021.GC789@laptop.programming.kicks-ass.net>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
 <20131125143952.GB10022@twins.programming.kicks-ass.net>
 <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 01:07:25AM +0000, Ma, Xindong wrote:
> [ 1038.694701] putmetho-11202   1...1 1035007289001: futex_wait: LEON, wait ==, addr:41300384, pid:11202
> [ 1038.694716] putmetho-11202   1...1 1035007308860: futex_wait_queue_me: LEON, q->task => 11202
> [ 1038.694731] SharedPr-11272   0...1 1035007319703: futex_wake: LEON, wake xx, addr:41300384, NULL task

> From the log captured, task 11202 runs on cpu1 and wait on futex and set task to its pid in queue_me(). Then
> task 11272 get scheduled on cpu0, it tries to wake up 11202. But the q->task set by cpu1 is not visible at first to
> cpu0, after several instructions, it's visible to cpu0 again. So this is the problem maybe in cache or instruction out
> of order. After adding memory barrier, the issue does not reproduced anymore.

So that suggests the spinlock implementation doesn't actually serialize
proper; why would you place an extra memory barrier at the site that
shows this and not try and fix the spinlock implementation?

That's FAIL 1.

Secondly, the current x86 spinlocks are correct and work for all known
chips. This leads me to believe your chip is broken; esp. since you
haven't specified what kind of chip you're running on (and are somewhat
avoiding the issue).

That's FAIL 2.

Having this information and not enriching the initial changelog with it
to more fully explain your reasoning,

that's FAIL 3.

Peter A, can you please figure out wth these guys are doing?

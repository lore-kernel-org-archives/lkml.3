Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaIDFEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:04:31 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33188 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIDFE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:04:29 -0400
Date: Thu, 4 Sep 2014 07:04:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140904050424.GA26756@gmail.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
 <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com>
 <20140902164714.GA17033@redhat.com>
 <20140902173910.GF27892@worktop.ger.corp.intel.com>
 <20140903133640.GA25439@redhat.com>
 <20140903144450.GB7083@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903144450.GB7083@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > Ah, I simply do not know what is cheaper, even on x86. Well, 
> > we need to enable/disable irqs, but again I do not really 
> > know how much does this cost.
> 
> Ah good point about that IRQ thing, yes that's horribly 
> expensive.

Enabling/disabling local IRQs is not really expensive (it's a 
flat cost essentially - below 10 cycles on modern x86 CPUs) - 
especially if we consider the 100x-1000x frequency difference 
between schedule() and exit(), on typical systems:

  $ grep -E 'ctxt|processes' /proc/stat 
  ctxt 47166536
  processes 91876

And that's from a system that emphatically does not schedule 
much. On others the difference is much larger.

So please don't push complexity into the scheduler from 
lower-freq areas of the kernel!

Thanks,

	Ingo

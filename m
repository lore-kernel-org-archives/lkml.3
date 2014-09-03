Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbaICOo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:44:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:40465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbaICOoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:44:54 -0400
Date: Wed, 3 Sep 2014 16:44:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140903144450.GB7083@twins.programming.kicks-ass.net>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
 <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com>
 <20140902164714.GA17033@redhat.com>
 <20140902173910.GF27892@worktop.ger.corp.intel.com>
 <20140903133640.GA25439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903133640.GA25439@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 03:36:40PM +0200, Oleg Nesterov wrote:
> Peter, sorry for slow responses.

No worries, I'm not entirely fast myself. Slept most of the day :-)

> Ah, I simply do not know what is cheaper, even on x86. Well, we need
> to enable/disable irqs, but again I do not really know how much does
> this cost. 

Ah good point about that IRQ thing, yes that's horribly expensive.

> I can even say what (imo) looks better, lock/unlock above or
> 
> 	// Ensure that the previous __set_current_state(RUNNING) can't
> 	// leak after spin_unlock_wait()
> 	smp_mb();
> 	spin_unlock_wait();
> 	// Another mb to ensure this too can't be reordered with unlock_wait
> 	set_current_state(TASK_DEAD);
> 
> What do you think looks better?

spin_unlock_wait() would be a control dependency right? Therefore that
store could not creep up anyhow.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LKXJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:09:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3LKXJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:09:43 -0500
Message-ID: <52A8F073.9040500@zytor.com>
Date: Wed, 11 Dec 2013 15:08:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
References: <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de> <1386732093.5964.6.camel@marge.simpson.net> <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de> <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net> <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com> <20131211164318.GA2480@laptop.programming.kicks-ass.net> <20131211175036.GC12431@gmail.com>
In-Reply-To: <20131211175036.GC12431@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 09:50 AM, Ingo Molnar wrote:
> 
> Well, availability could be a problem too, if some CPU (real or 
> virtual) implements MWAIT but not CLFLUSH.
> 
> In theory we could make mwait an alternatives variant and patch in the 
> right combination of instructions? The CLFLUSH goes to the same 
> address as on which the monitoring happens, so it could be considered 
> one meta-instruction.
> 

The first thing to do is probably to drop the use of thread_info as a
wakeup doorbell.  It seemed like a good idea at the time -- after all,
there is one for each thread -- but it is extremely likely to be dirty
in the cache, which is (presumably) what causes these kinds of bugs to
be maximally likely.  Even if we don't do the CLFLUSH it is likely that
the hardware has to do something expensive behind the scenes.

So I would like to propose that we switch to using a percpu variable
which is a single cache line of nothing at all.  It would only ever be
touched by MONITOR and for explicit wakeup.  Hopefully that will resolve
this problem without the need for the CLFLUSH.

	-hpa



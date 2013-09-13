Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3IMHdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:33:55 -0400
Received: from chicago.guarana.org ([192.210.136.102]:35545 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3IMHdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:33:53 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2013 03:33:53 EDT
Date: Fri, 13 Sep 2013 17:25:00 +1000
From: Kevin Easton <kevin@guarana.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130913072459.GA15492@chicago.guarana.org>
References: <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130912022040.GT31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912022040.GT31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 04:20:40AM +0200, Peter Zijlstra wrote:
> On Wed, Sep 11, 2013 at 04:02:14PM -0700, Linus Torvalds wrote:
> > On Wed, Sep 11, 2013 at 11:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > OK, stripped it down further, I couldn't quite see how to collapse the
> > > unary and binary operator variants though :/
> > 
> > Ok, this looks pretty good. I assume it works too? ;)
> 
> Only compile tested that one.. the below is kvm boot tested until root
> mount -- I'll try on actual hardware when I've gotten some sleep.
> 
> I split the thing up into two macros GEN_UNARY_RMWcc and
> GEN_BINARY_RMWcc which ends up being more readable as well as smaller
> code overall.

If you wanted to collapse the unary and binary variants as you mentioned
upthread, you could do something like (for the CC_HAVE_ASM_GOTO case):

#define GEN_RMWcc(fullop, cc, ...) \
do { \
 asm volatile goto (fullop \
 "j" cc " %l[cc_label]" \
 : : __VA_ARGS__ \
 : "memory" : cc_label); \
 return 0; \
cc_label: \
 return 1; \
} while (0)

#define GEN_UNARY_RMWcc(op, var, arg0, cc) GEN_RMWcc(op " " arg0 ";", cc, "m" (var))
#define GEN_BINARY_RMWcc(op, var, val, arg0, cc) GEN_RMWcc(op " %1, " arg0 ";", cc, "m" (var), "er" (val))

    - Kevin

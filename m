Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaCMSIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:08:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59185 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754166AbaCMSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:08:08 -0400
Message-ID: <1394734070.26600.6.camel@pippen.local.home>
Subject: Re: [PATCH v6 6/7] arm64: ftrace: Add CALLER_ADDRx macros
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 14:07:50 -0400
In-Reply-To: <20140313155415.GB25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-7-git-send-email-takahiro.akashi@linaro.org>
	 <20140313155415.GB25472@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 15:54 +0000, Will Deacon wrote:
> On Thu, Mar 13, 2014 at 10:13:49AM +0000, AKASHI Takahiro wrote:
> > CALLER_ADDRx returns caller's address at specified level in call stacks.
> > They are used for several tracers like irqsoff and preemptoff.
> > Strange to say, however, they are refered even without FTRACE.
> > 
> > Please note that this implementation assumes that we have frame pointers.
> > (which means kernel should be compiled with -fno-omit-frame-pointer.)
> 
> How do you ensure that -fno-omit-frame-pointer is passed?

Perhaps -pg does the same thing?

> > +#define HAVE_ARCH_CALLER_ADDR
> > +
> > +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > +#define CALLER_ADDR1 ((unsigned long)return_address(1))
> > +#define CALLER_ADDR2 ((unsigned long)return_address(2))
> > +#define CALLER_ADDR3 ((unsigned long)return_address(3))
> > +#define CALLER_ADDR4 ((unsigned long)return_address(4))
> > +#define CALLER_ADDR5 ((unsigned long)return_address(5))
> > +#define CALLER_ADDR6 ((unsigned long)return_address(6))
> 
> Could we change the core definitions of these macros (in linux/ftrace.h) to
> use return_address, then provide an overridable version of return_address
> that defaults to __builtin_return_address, instead of copy-pasting this
> sequence?

We could add a new macro:

/* All archs should have this, but we define it for consistency */
#ifndef ftrace_return_address0
# define ftrace_return_address0  __builtin_return_address(0)
#endif
/* Archs may use other ways for ADDR1 and beyond */
#ifndef ftrace_return_address
# define ftrace_return_address(n) __builtin_return_address(n)
#endif

And then have:

#define CALLER_ADDR0 ((unsigned long)ftrace_return_address0)
#define CALLER_ADDR1 ((unsigned long)ftrace_return_address(1))
[...]

And then you would only need to redefine ftrace_return_address.

-- Steve



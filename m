Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3F2AJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:09:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60018 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3F2AJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:09:58 -0400
Date: Fri, 28 Jun 2013 17:09:51 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jed Davis <jld@mozilla.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: ARM: Record the user-mode PC in the call chain.
Message-ID: <20130629000951.GA5117@us.ibm.com>
References: <20130613232111.GA12536@mozilla.com>
 <20130618131319.GC6801@mudshark.cambridge.arm.com>
 <20130620031706.GB27428@mozilla.com>
 <20130620090728.GA2842@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620090728.GA2842@mudshark.cambridge.arm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062900-7182-0000-0000-000007938690
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon [will.deacon@arm.com] wrote:
| On Thu, Jun 20, 2013 at 04:17:06AM +0100, Jed Davis wrote:
| > On Tue, Jun 18, 2013 at 02:13:19PM +0100, Will Deacon wrote:
| > > On Fri, Jun 14, 2013 at 12:21:11AM +0100, Jed Davis wrote:
| > > > With this change, we no longer lose the innermost entry in the user-mode
| > > > part of the call chain.  See also the x86 port, which includes the ip.
| > > > 
| > > > It's possible to partially work around this problem by post-processing
| > > > the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
| > > > wasn't in the kernel when the sample was taken.
| > > 
| > > Thanks. I guess we need something similar for arm64 too. Could you cook a
| > > similar patch please?
| > 
| > Done (and tested, on the ARM V8 Foundation Model).
| 
| Wow, I didn't expect you to test it. Thanks!
| 
| > It looked as if the powerpc and sparc ports might have similar issues,
| > but I haven't checked on them yet.
| 
| I can extract some hardware from the pile in the corner of my flat if you
| want a hand with testing.

Interesting. Powerpc already saves the next_ip for the first entry:

	arch/powerpc/perf/callchain.c:

	perf_callchain_user_64():
	...

		next_ip = perf_instruction_pointer(regs);
		lr = regs->link;
		sp = regs->gpr[1];
		perf_callchain_store(entry, next_ip);

		for (;;) {


Do you have a test case/output that I can run on Power ?

We actually have the opposite problem where we see duplication in
callchains like this. We considered not saving the "link register"
but that seems to break for a "leaf-node" functions.

    13.65%  sprintft  libc-2.12.so       [.] __random                            
            | 
            --- __random
               |           
               |--62.82%-- __random
               |          |    
               |          |--97.31%-- rand
               |          |          do_my_sprintf
               |          |          main
               |          |          generic_start_main
               |          |          __libc_start_main
               |          |          0x0
               |          |
               |           --2.69%-- do_my_sprintf
               |                     main
               |                     generic_start_main
               |                     __libc_start_main
               |                     0x0
               |
                --37.18%-- rand
                          |
                          |--93.30%-- rand
                          |          do_my_sprintf
                          |          main
                          |          generic_start_main
                          |          __libc_start_main
                          |          0x0
                          |
                           --6.70%-- do_my_sprintf
                                     main
                                     generic_start_main
                                     __libc_start_main
                                     0x0


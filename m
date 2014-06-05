Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaFEJ5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:57:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34732 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:57:04 -0400
Date: Thu, 5 Jun 2014 11:56:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Differentiate exec() and non-exec() comm events
Message-ID: <20140605095659.GA23641@gmail.com>
References: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
 <20140528085538.GR11096@twins.programming.kicks-ass.net>
 <5385A7A9.80702@intel.com>
 <20140528095308.GS11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528095308.GS11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, May 28, 2014 at 12:08:57PM +0300, Adrian Hunter wrote:
> > On 05/28/2014 11:55 AM, Peter Zijlstra wrote:
> > > On Wed, May 28, 2014 at 11:45:04AM +0300, Adrian Hunter wrote:
> > >> perf tools like 'perf report' can aggregate samples by comm
> > >> strings, which generally works.  However, there are other
> > >> potential use-cases.  For example, to pair up 'calls'
> > >> with 'returns' accurately (from branch events like Intel BTS)
> > >> it is necessary to identify whether the process has exec'd.
> > >> Although a comm event is generated when an 'exec' happens
> > >> it is also generated whenever the comm string is changed
> > >> on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
> > >> flag to the comm event to differentiate one case from the
> > >> other.
> > >>
> > >> In order to determine whether the kernel supports the new
> > >> flag, a selection bit named 'exec' is added to struct
> > >> perf_event_attr.  The bit does nothing but will cause
> > >> perf_event_open() to fail if the bit is set on kernels
> > >> that do not have it defined.
> > >>
> > > 
> > >> --- a/include/uapi/linux/perf_event.h
> > >> +++ b/include/uapi/linux/perf_event.h
> > >> @@ -302,8 +302,8 @@ struct perf_event_attr {
> > >>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
> > >>  				exclude_callchain_user   : 1, /* exclude user callchains */
> > >>  				mmap2          :  1, /* include mmap with inode data     */
> > >> -
> > >> -				__reserved_1   : 40;
> > >> +				exec           :  1, /* flag comm events that are due to an exec */
> > >> +				__reserved_1   : 39;
> > >>  
> > > 
> > > Yah.. that's just sad :-(
> > > 
> > > the only capabilities mask we have is in the mmap() page, so without
> > > mmap()ing we have no way to test that.
> > > 
> > > Would it make sense to call it comm_exec?
> > 
> > Yes, that is better.  Do you want me to resend the patch?
> 
> Nah, I'll frob it. Thanks!

FYI, this patch breaks pretty much every non-x86 architecture:

/home/mingo/tip/fs/exec.c: In function 'setup_new_exec':
/home/mingo/tip/fs/exec.c:1113: error: implicit declaration of function 'perf_event_exec'
make[2]: *** [fs/exec.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs] Error 2
make[1]: *** Waiting for unfinished jobs....

Thanks,

	Ingo

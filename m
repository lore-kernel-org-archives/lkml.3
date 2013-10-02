Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3JBMkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:40:02 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:50683 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JBMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:39:57 -0400
Date: Wed, 2 Oct 2013 14:39:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131002123953.GB27811@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <20130930161546.GG3081@twins.programming.kicks-ass.net>
 <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
 <20130930165420.GI3081@twins.programming.kicks-ass.net>
 <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
 <20131002112316.GP3081@twins.programming.kicks-ass.net>
 <20131002115826.GM26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002115826.GM26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 02, 2013 at 01:23:16PM +0200, Peter Zijlstra wrote:
>
> > So the only thing I can come up with is something like the below; 
> > supposedly the sha hash mixing a boot time random seed and the mm 
> > pointer is enough to avoid it being a data leak.
> 
> That is, right until it becomes feasible to run 2^64 SHA1 computations. 
> I've actually no idea how hard that is given todays GPU assisted 
> efforts.

Well, here are the possible cryptanalytic attacks I can think of:

 - differential, because here you don't just have access to the hash
   value but you can essentially feed highly correlated plaintext to the 
   hash at will, by starting/stopping threads, knowing their typical mm 
   pointer differences, etc.

   I.e. less than 2^64, potentially a lot less.

 - then there are timing attacks, and someone having access to a PMU
   context and who can trigger this SHA1 computation arbitrarily in task 
   local context can run very accurate and low noise timing attacks...

   I don't think the kernel's sha_transform() is hardened against timing 
   attacks, it's performance optimized so it has variable execution time
   highly dependent on plaintext input - which leaks information about the 
   plaintext.

But then again, how realistic is an attack? All that effort just to 
recover the raw kernel data pointer value of a struct mm? Dunno whether we 
should worry about it.

Thanks,

	Ingo

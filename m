Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaCFRtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:49:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaCFRts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:49:48 -0500
Date: Thu, 6 Mar 2014 18:49:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 0/3] powerpc/perf: Enable linking with libunwind
Message-ID: <20140306174917.GC1269@krava.brq.redhat.com>
References: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 08:41:56PM -0800, Sukadev Bhattiprolu wrote:
> When we try to create backtraces (call-graphs) with the perf tool
> 
> 	perf record -g /tmp/sprintft
> 
> we get backtraces with duplicate arcs for sprintft[1]:
> 
>     14.61%  sprintft  libc-2.18.so       [.] __random                            
>             |
>             --- __random
>                |
>                |--61.09%-- __random
>                |          |
>                |          |--97.18%-- rand
>                |          |          do_my_sprintf
>                |          |          main
>                |          |          generic_start_main.isra.0
>                |          |          __libc_start_main
>                |          |          0x0
>                |          |
>                |           --2.82%-- do_my_sprintf
>                |                     main
>                |                     generic_start_main.isra.0
>                |                     __libc_start_main
>                |                     0x0
>                |
>                 --38.91%-- rand
>                           |          
>                           |--92.90%-- rand
>                           |          |
>                           |          |--99.87%-- do_my_sprintf
>                           |          |          main
>                           |          |          generic_start_main.isra.0
>                           |          |          __libc_start_main
>                           |          |          0x0
>                           |           --0.13%-- [...]
>                           |
>                            --7.10%-- do_my_sprintf
>                                      main
>                                      generic_start_main.isra.0
>                                      __libc_start_main
>                                      0x0
> 
> (where the two arcs both have the same backtrace but are not merged).
> 
> Linking with libunwind seems to create better backtraces. While x86 and
> ARM processors have support for linking with libunwind but Power does not.
> This patchset is an RFC for linking with libunwind.
> 
> With this patchset and running:
> 
> 	/tmp/perf record --call-graph=dwarf,8192 /tmp/sprintft
> 
> the backtrace is:
> 
>     14.94%  sprintft  libc-2.18.so       [.] __random                            
>             |
>             --- __random
>                 rand
>                 do_my_sprintf
>                 main
>                 generic_start_main.isra.0
>                 __libc_start_main
>                 (nil)
> 
> This appears better.
> 
> One downside is that we now need the kernel to save the entire user stack
> (the 8192 in the command line is the default user stack size).
> 
> A second issue is that this invocation of perf (with --call-graph=dwarf,8192)
> seems to fail for backtraces involving tail-calls[2]
> 
> 	/tmp/perf record -g ./tailcall
> gives 
> 
>     20.00%  tailcall  tailcall           [.] work2
>             |
>             --- work2
>                 work
> 
> shows the tail function 'work2' as "called from" 'work()'
> 
> But with libunwind:
> 
> 	/tmp/perf record --call-graph=dwarf,8192 ./tailcall
> we get:
> 
>    20.50%  tailcall  tailcall           [.] work2
>             |
>             --- work2
> 
> the caller of 'work' is not shown.
> 
> I am debugging this, but would appreciate any feedback/pointers on the
> patchset/direction:
> 
> 	- Does libunwind need the entire user stack to work or are there
> 	  optimizations we can do to save the minimal entries for it to
> 	  perform the unwind.

AFAIK you dont need to provide whole stack, but the more
you have the bigger chance you'll get full(er) backtrace

> 
> 	- Does libunwind work with tailcalls like the one above ?

not sure, but if you have x86 alternative to your tailcall (i cannot
read ppc assembly) I could try on x86 ;-)

CC-ing Jean, as he might have seen this issue..


> 
> 	- Are there benefits to linking with libunwind (even if it does not
> 	  yet solve the tailcall problem)

provides backtrace for binaries/distros/archs compiled without framepointer

> 
> 	- Are there any examples of using libdwarf to solve the tailcall
> 	  issue ?


btw there's now remote unwinder in elfutils (version 0.158)
the perf supprot is in Arnaldo's perf/core tree

jirka

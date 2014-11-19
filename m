Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaKSKzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:55:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbaKSKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:55:09 -0500
Date: Wed, 19 Nov 2014 11:54:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141119105450.GA22132@krava.brq.redhat.com>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
 <20141119092323.GC2592@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141119092323.GC2592@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:23:23AM +0100, Jiri Olsa wrote:
> On Wed, Nov 19, 2014 at 03:21:39PM +0900, Namhyung Kim wrote:
> > Hi Jiri,
> > 
> > On Tue, 18 Nov 2014 12:00:07 +0100, Jiri Olsa wrote:
> > > On Tue, Nov 18, 2014 at 11:44:16AM +0100, Jiri Olsa wrote:
> > >> On Mon, Nov 17, 2014 at 06:34:57PM -0300, Arnaldo Carvalho de Melo wrote:
> > >> > Em Wed, Nov 12, 2014 at 06:05:18PM -0800, Andi Kleen escreveu:
> > >> > > [Reworks to address all the review feedback. Rebased to latest tree]
> > >> > > [Just a repost after a rebase]
> > >> > > [Even more review feedback and some bugs addressed.]
> > >> > > [Only port to changes in perf/core. No other changes.]
> > >> > > [Rebase to latest perf/core]
> > >> > > [Another rebase. No changes]
> > >> > > 
> > >> > > This patchkit implements lbr-as-callgraphs in per freport,
> > >> > > as an alternative way to present LBR information.
> > >> > 
> > >> > Ok, I have this in my perf/core branch, but I need to test it further,
> > >> > as I couldn't get the output that appears on some of the changelogs.
> > >> > 
> > >> > If you could take a look at
> > >> > 
> > >> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> > >> > 
> > >> > To see if I made some mistake, that would be of help,
> > >> > 
> > >> 
> > >> I'm getting compile error for DEBUG=1
> > >
> > > looks like the BUILD_BUG_ON_MSG does not work correctly with -O6 we use
> > 
> > Nope, DEBUG=1 prevents -O6 from applied.  we have below in config/Makefile:
> 
> right.. the other way around ;))
> 
> > 
> >   ifndef DEBUG
> >     DEBUG := 0
> >   endif
> > 
> >   ifeq ($(DEBUG),0)
> >     CFLAGS += -O6
> >   endif
> > 
> > 
> > Looking at include/linux/bug.h, BUILD_BUG_ON is guarded under
> > __OPTIMIZE__ but BUILD_BUG_ON_MSG is not.  What about changing it to
> > BUILD_BUG_ON then?
> 
> sounds gut

hum, acme/perf/core changed and so has the compile error ;-)
we dont overload the <linux/bug.h>, so the kernel one got
included, which is wrong.. attached patch fixes that

jirka


[jolsa@krava perf]$ make JOBS=1
  BUILD:   Doing 'make -j1' parallel build
  CC       perf.o
  CC       builtin-annotate.o
In file included from util/machine.h:5:0,
                 from util/session.h:7,
                 from builtin-annotate.c:29:
/home/jolsa/kernel.org/linux-perf/include/linux/bug.h: In function ‘report_bug’:
/home/jolsa/kernel.org/linux-perf/include/linux/bug.h:105:59: error: unused parameter ‘bug_addr’ [-Werror=unused-parameter]
 static inline enum bug_trap_type report_bug(unsigned long bug_addr,
                                                           ^
/home/jolsa/kernel.org/linux-perf/include/linux/bug.h:106:26: error: unused parameter ‘regs’ [-Werror=unused-parameter]
          struct pt_regs *regs)
                          ^
cc1: all warnings being treated as errors
make[1]: *** [builtin-annotate.o] Error 1
make: *** [all] Error 2


---
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 180d16c19a2b..e8b7779a0a3f 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -2,7 +2,6 @@
 #define __PERF_MACHINE_H
 
 #include <sys/types.h>
-#include <linux/bug.h>
 #include <linux/rbtree.h>
 #include "map.h"
 #include "dso.h"

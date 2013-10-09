Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3JIGmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:42:12 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35146 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab3JIGmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:42:08 -0400
Date: Wed, 9 Oct 2013 08:42:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 53/52] tools/perf/build: Clean up feature_print_code()
Message-ID: <20131009064205.GG7664@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-38-git-send-email-mingo@kernel.org>
 <20131007221233.GF2900@krava.redhat.com>
 <20131008084610.GB3295@gmail.com>
 <20131008155110.GA15558@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008155110.GA15558@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Oct 08, 2013 at 10:46:10AM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > So, this is a bit of a GNU Make mystery to me. If I have a failure for at 
> > least one of the features, and if I leave out that DUMMY then I get this 
> > printout:
> > 
> > ...                       libperl: [ OFF ]
> > ...                     libpython: [ on  ]
> > ...             libpython-version: [ on  ]
> > ...                      libslang: [ on  ]
> > ...                     libunwind: [ on  ]
> > ...                       on-exit: [ on  ]
> > ...                stackprotector: [ on  ]
> > ...            stackprotector-all: [ on  ]
> > 
> >     GEN python/perf.so
> > 
> > Note how the last entry is missing: volatile-register-var.
> > 
> > If I add the DUMMY I get the full printout:
> > 
> > ...                       libperl: [ OFF ]
> > ...                     libpython: [ on  ]
> > ...             libpython-version: [ on  ]
> > ...                      libslang: [ on  ]
> > ...                     libunwind: [ on  ]
> > ...                       on-exit: [ on  ]
> > ...                stackprotector: [ on  ]
> > ...            stackprotector-all: [ on  ]
> > ...         volatile-register-var: [ on  ]
> > 
> >     GEN python/perf.so
> > 
> > Somehow GNU Make appears to be eating terminal ouput - or I might have 
> > misunderstood something.
> > 
> > I hope it's the latter - but if it's the former then the DUMMY entry is 
> > needed :-/
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> I think the issue might be in the eval handling the $(info $(MSG)).
> With following change on top of your v2 patchset it works for me.

Indeed - and that works here too. Initially I was trying to solve it by 
forcing expansion:

	MSG := ...

but I forgot that expansion does not necessarily force evaluation of the 
expression and that Make can still optimize such assignments away if their 
result is not used by a target, correct?

I've applied your cleanup patch below and added your signoff - is that 
fine with you?

Thanks,

	Ingo

=====================>
Subject: tools/perf/build: Clean up feature_print_code()
From: Jiri Olsa <jolsa@redhat.com>
Date: Tue, 8 Oct 2013 17:51:10 +0200

Remove DUMMY by making sure 'feature_print' is evaluated and thus
all messages are printed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/20131008155110.GA15558@krava.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip/tools/perf/config/Makefile
===================================================================
--- tip.orig/tools/perf/config/Makefile
+++ tip/tools/perf/config/Makefile
@@ -180,21 +180,21 @@ endif
 #
 # Print the result of the feature test:
 #
-feature_print = $(eval $(feature_print_code))
+feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+
 define feature_print_code
   ifeq ($(feature-$(1)), 1)
     MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
   else
     MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
   endif
-  $(info $(MSG))
 endef
 
 #
 # Only print out our features if we rebuilt the testcases or if a test failed:
 #
 ifeq ($(test-all-failed), 1)
-  $(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
   $(info )
 endif
 


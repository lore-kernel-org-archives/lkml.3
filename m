Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3JHPv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:51:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3JHPvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:51:22 -0400
Date: Tue, 8 Oct 2013 17:51:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 37/50] tools/perf/build: Improve printout-of
 auto-detected features
Message-ID: <20131008155110.GA15558@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-38-git-send-email-mingo@kernel.org>
 <20131007221233.GF2900@krava.redhat.com>
 <20131008084610.GB3295@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008084610.GB3295@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:46:10AM +0200, Ingo Molnar wrote:

SNIP

> So, this is a bit of a GNU Make mystery to me. If I have a failure for at 
> least one of the features, and if I leave out that DUMMY then I get this 
> printout:
> 
> ...                       libperl: [ OFF ]
> ...                     libpython: [ on  ]
> ...             libpython-version: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...                       on-exit: [ on  ]
> ...                stackprotector: [ on  ]
> ...            stackprotector-all: [ on  ]
> 
>     GEN python/perf.so
> 
> Note how the last entry is missing: volatile-register-var.
> 
> If I add the DUMMY I get the full printout:
> 
> ...                       libperl: [ OFF ]
> ...                     libpython: [ on  ]
> ...             libpython-version: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...                       on-exit: [ on  ]
> ...                stackprotector: [ on  ]
> ...            stackprotector-all: [ on  ]
> ...         volatile-register-var: [ on  ]
> 
>     GEN python/perf.so
> 
> Somehow GNU Make appears to be eating terminal ouput - or I might have 
> misunderstood something.
> 
> I hope it's the latter - but if it's the former then the DUMMY entry is 
> needed :-/
> 
> Thanks,
> 
> 	Ingo

I think the issue might be in the eval handling the $(info $(MSG)).
With following change on top of your v2 patchset it works for me.

jirka
---
 tools/perf/config/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c98ca34..43905fe 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
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
 
-- 
1.7.11.7

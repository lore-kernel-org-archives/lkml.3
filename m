Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbaDWOxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaDWOxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:53:47 -0400
Date: Wed, 23 Apr 2014 16:53:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140423145325.GB27585@krava.brq.redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423131433.GB23224@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:14:33PM +0200, Ingo Molnar wrote:
> 
> (Just reporting two bugs I found today - unrelated to your the 
> perf/urgent pull request.)
> 
> 1)
> 
> Even when the most modern unwind library is found, the autodetection 
> is spammy:
> 
> 
>  Auto-detecting system features:
>  ...                         dwarf: [ on  ]
>  ...                         glibc: [ on  ]
>  ...                          gtk2: [ on  ]
>  ...                      libaudit: [ on  ]
>  ...                        libbfd: [ on  ]
>  ...                        libelf: [ on  ]
>  ...                       libnuma: [ on  ]
>  ...                       libperl: [ on  ]
>  ...                     libpython: [ on  ]
>  ...                      libslang: [ on  ]
>  ...                     libunwind: [ on  ]
>  ...            libdw-dwarf-unwind: [ on  ]
>  ...     DWARF post unwind library: libunwind
> 
> The 'DWARF post unwind library' line is somewhat superfluous. I 
> realize that it prints out the library selected - but that's obvious 
> from the 'libdw-dwarf-unwind' line above it already, right?
> 
> Furthermore, it breaks the autodetection output format.
> 
> 2)
> 
> On latest Ubuntu (14.04) the tip:master build fails with:
> 
>  /usr/bin/ld: cannot find -liberty
>  collect2: error: ld returned 1 exit status
> 
> The autodetection sequence reports all green entries, so something's 
> funky going on there.

we add -liberty once -lbfd is detected, I guess we
assumed that was common case

  perf tools: fix BFD detection on opensuse
  commit 280e7c48c3b873e4987a63da276ecab25383f494
  Author: Andi Kleen <ak@linux.intel.com>
  Date:   Sat Jan 11 11:42:51 2014 -0800

could you please try patch below? it adds that only
if thats detected

'make VF=1' should display more status now

Andi,
could you please try that on opensuse?

thanks,
jirka


---
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ee21fa9..f511658 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -186,7 +186,10 @@ VF_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
-	bionic
+	bionic				\
+	liberty				\
+	liberty-z			\
+	cplus-demangle
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -504,7 +507,21 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd -lz -liberty
+  EXTLIBS += -lbfd
+
+  # call all detections now so we get correct
+  # status in VF output
+  $(call feature_check,liberty)
+  $(call feature_check,liberty-z)
+  $(call feature_check,cplus-demangle)
+
+  ifeq ($(feature-liberty), 1)
+    EXTLIBS += -lbfd -liberty
+  else
+    ifeq ($(feature-liberty-z), 1)
+      EXTLIBS += -lbfd -liberty -lz
+    endif
+  endif
 endif
 
 ifdef NO_DEMANGLE
@@ -515,15 +532,10 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     ifneq ($(feature-libbfd), 1)
-      $(call feature_check,liberty)
-      ifeq ($(feature-liberty), 1)
-        EXTLIBS += -lbfd -liberty
-      else
-        $(call feature_check,liberty-z)
-        ifeq ($(feature-liberty-z), 1)
-          EXTLIBS += -lbfd -liberty -lz
-        else
-          $(call feature_check,cplus-demangle)
+      ifneq ($(feature-liberty), 1)
+        ifneq ($(feature-liberty-z), 1)
+          # we dont have neither HAVE_CPLUS_DEMANGLE_SUPPORT
+          # or any of 'bfd iberty z' trinity
           ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
             CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT

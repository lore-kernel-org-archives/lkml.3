Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaIJNV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:21:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:37285 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaIJNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:21:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="597436012"
Message-ID: <54104FFF.60805@intel.com>
Date: Wed, 10 Sep 2014 16:19:59 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
References: <1410211089-28668-1-git-send-email-acme@kernel.org> <540EBED4.70900@intel.com> <20140909190812.GA5917@kernel.org>
In-Reply-To: <20140909190812.GA5917@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 10:08 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Sep 09, 2014 at 11:48:20AM +0300, Adrian Hunter escreveu:
>> On 09/09/2014 12:17 AM, Arnaldo Carvalho de Melo wrote:
>>> Hi Ingo,
>>>
>>> 	Please consider pulling,
>>>
>>> - Arnaldo
>>
>> I am very sorry Arnaldo but 2 patches are older versions, namely:
>>
>> 	perf tools: Build programs to copy 32-bit compatibility VDSOs
>> 	perf tools: Add support for 32-bit compatibility VDSOs
>>
>> Up-to-date versions can be found from 15 August:
>>
>> 	patchwork:
>>
>> 		https://patchwork.kernel.org/patch/4729131/
>> 		https://patchwork.kernel.org/patch/4729111/
> 
> Ok, those don't apply, as it expects other stuff, that you sent before,
> but were not processed yet, to be in place, I'm fixing it up.
> 

Something like this might prevent Ingo's error message:


From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 10 Sep 2014 16:14:50 +0300
Subject: [PATCH] perf tools: Do not attempt to run perf-read-vdso32 if it
 wasn't built

popen() causes an error message to print if perf-read-vdso32
does not run.  Avoid that by not trying to run it if it was
not built.  Ditto perf-read-vdsox32.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/Makefile |  8 ++++++--
 tools/perf/util/vdso.c     | 10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3ba2382..71264e4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -627,7 +627,9 @@ endif
 ifeq (${IS_64_BIT}, 1)
   ifndef NO_PERF_READ_VDSO32
     $(call feature_check,compile-32)
-    ifneq ($(feature-compile-32), 1)
+    ifeq ($(feature-compile-32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSO32
+    else
       NO_PERF_READ_VDSO32 := 1
     endif
   endif
@@ -636,7 +638,9 @@ ifeq (${IS_64_BIT}, 1)
   endif
   ifndef NO_PERF_READ_VDSOX32
     $(call feature_check,compile-x32)
-    ifneq ($(feature-compile-x32), 1)
+    ifeq ($(feature-compile-x32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSOX32
+    else
       NO_PERF_READ_VDSOX32 := 1
     endif
   endif
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 69daef6..5c7dd79 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -255,6 +255,16 @@ static int vdso__dso_findnew_compat(struct machine
*machine,
 	enum dso_type dso_type;

 	dso_type = machine__thread_dso_type(machine, thread);
+
+#ifndef HAVE_PERF_READ_VDSO32
+	if (dso_type == DSO__TYPE_32BIT)
+		return 0;
+#endif
+#ifndef HAVE_PERF_READ_VDSOX32
+	if (dso_type == DSO__TYPE_X32BIT)
+		return 0;
+#endif
+
 	switch (dso_type) {
 	case DSO__TYPE_32BIT:
 		*dso = vdso__findnew_compat(machine, &vdso_info->vdso32);
-- 
1.8.3.2




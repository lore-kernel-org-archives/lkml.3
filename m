Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaHDNDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:03:34 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:60763 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbaHDNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:03:31 -0400
Message-ID: <53DF8493.6070206@tu-dresden.de>
Date: Mon, 04 Aug 2014 15:03:15 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v3 2/2] perf tools: Default to python version 2
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org> <1406617040-26909-2-git-send-email-namhyung@kernel.org> <20140801202149.GB13375@kernel.org> <53DCC3F0.6000105@tu-dresden.de> <20140802132013.GC13375@kernel.org>
In-Reply-To: <20140802132013.GC13375@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-02 15:20, Arnaldo Carvalho de Melo wrote:
> Maybe the way python was packaged on f14 is problematic, as you
> describe, but the fact is that python support is not working on that
> platform after this patch.
> 
> Could you please try to prepare a patch that does as you suggest so that
> I can try?

Please try the patch below.
I tested (compiles and perf script runs) with the combinations:

1) python  -> python2.x, python-config  -> python2.x-config
   python2 N/A,          python2-config N/A

2) python  -> python3.x, python-config  -> python3.x-config
   python2 -> python2.x, python2-config -> python2.x-config

3) python  -> python2.x, python-config  -> python2.x-config
   python2 -> python2.x, python2-config -> python2.x-config

4) python  -> python2.x, python-config  -> python2.x-config
   python2 -> python2.x, python2-config N/A

Based on / replaces the patch 2/2 by Namhyung Kim.

Signed-off-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
---
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9ee2008..0528cd37 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -104,10 +104,16 @@ ifdef PARSER_DEBUG
 endif
 
 ifndef NO_LIBPYTHON
-  override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python)
+  # Try different combinations to accommodate systems that only have
+  # python[2][-config] in weird combinations but always preferring
+  # python2 and python2-config as per pep-0394. If we catch a
+  # python[-config] in version 3, the version check will kill it.
+  PYTHON2 := $(if $(call get-executable,python2),python2,python)
+  override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON2))
+  PYTHON2_CONFIG := \
+    $(if $(call get-executable,$(PYTHON)-config),$(PYTHON)-config,python-config)
   override PYTHON_CONFIG := \
-    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON2_CONFIG))
 
   PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaLIOqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaLIOq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:46:29 -0500
Date: Tue, 9 Dec 2014 14:53:01 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, ak@linux.intel.com,
        acme@kernel.org
Subject: perf tests: Fix attr tests size values interrupt
Message-ID: <20141209135301.GC6784@krava.brq.redhat.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
 <1411559322-16548-2-git-send-email-eranian@google.com>
 <20141121212631.GF5395@redhat.com>
 <20141209133031.GC2406@redhat.com>
 <20141209133947.GD2406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209133947.GD2406@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 11:39:47AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 09, 2014 at 11:30:31AM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Fri, Nov 21, 2014 at 07:26:31PM -0200, Arnaldo Carvalho de Melo escreveu:
> > > Em Wed, Sep 24, 2014 at 01:48:37PM +0200, Stephane Eranian escreveu:
> > > > This patch also adds a new ABI version
> > > > PERF_ATTR_SIZE_VER4 because we extend
> > > > the perf_event_attr struct with a new u64
> > > > field.
>  
> > I think this problem is also related to this changeset:
>  
> > [root@zoo ~]# perf test -v 15
> > 15: struct perf_event_attr setup                           :
> <SNIP>
> > running '/home/acme/libexec/perf-core/tests/attr/test-stat-default'
> > expected size=96, got 104
> > FAILED '/home/acme/libexec/perf-core/tests/attr/test-stat-default' -
> > match failure
> > test child finished with 0
> > ---- end ----
> > struct perf_event_attr setup: Ok
> > [root@zoo ~]# uname -r
> > 3.17.3-200.fc20.x86_64
> > [root@zoo ~]#
> > 
> > Checking if this is just a matter of updating the test entry.
> 
> Well, here I think that size variable needs to somehow be tested against
> the value of another field, the ABI one, so that for each ABI we test
> against the rightsize, that is, after this cset, 8 bytes (sizeof u64)
> bigger, Jiri?

well this patch enlarged the perf_event_attr
so the test needs to be adjusted like in patch below

[jolsa@krava perf]$ ./perf test attr -vv
15: struct perf_event_attr setup                           :
--- start ---
test child forked, pid 9719
running './tests/attr/test-stat-group1'
  'PERF_TEST_ATTR=/tmp/tmp4drvul ./perf stat -o /tmp/tmp4drvul/perf.data -e '{cycles,instructions}' kill >/dev/null 2>&1' ret 1 
expected size=96, got 104
FAILED './tests/attr/test-stat-group1' - match failure

jirka


---
Following change adjusted 'struct perf_event_attr', but let
the attr test's sizes untouched:
  60e2364e60e8 perf: Add ability to sample machine state on interrupt

Adjusting test size values for attr test.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f710b92ccff6..d3095dafed36 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0|1
-size=96
+size=104
 config=0
 sample_period=4000
 sample_type=263
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index dc3ada2470c0..872ed7e24c7c 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0
-size=96
+size=104
 config=0
 sample_period=0
 sample_type=0

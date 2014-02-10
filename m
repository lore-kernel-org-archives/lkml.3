Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBJRwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:52:35 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:40084 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaBJRwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:52:30 -0500
Date: Mon, 10 Feb 2014 14:52:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix perf build breakages in 3.13
Message-ID: <20140210175215.GD20833@ghostprotocols.net>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
 <20140206134817.GC8026@ghostprotocols.net>
 <1391695995.3003.108.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391695995.3003.108.camel@deadeye.wl.decadent.org.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 02:13:15PM +0000, Ben Hutchings escreveu:
> On Thu, 2014-02-06 at 10:48 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Feb 06, 2014 at 12:59:21AM +0000, Ben Hutchings escreveu:
> > > perf no longer compiles on powerpc and sparc due to changes in the trace
> > > sub-command.  This series fixes those compile errors; I compile-tested
> > > in Debian sid on armhf, i386, powerpc and sparc.
> > > 
> > > I would much prefer not to revert the tty ioctl decoding but I think
> > > it's going to take a much more sophisticated approach to do it right
> > > across all supported architectures.
> > 
> > Second thought on the revert one:
> > 
> > Do you have a problem of switching the big hammer to one that makes this
> > work just on x86/x86-64?
> 
> That seems reasonable as a temporary measure.

Applying this to my perf/urgent branch, ack?

- Arnaldo

commit 57f7077f41104c5499a89803f58b5886ee51555f
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Feb 10 14:09:48 2014 -0300

    perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches
    
    Supporting decoding the ioctl 'request' parameter needs more work to
    properly support more architectures, the current approach doesn't work
    on at least powerpc and sparc, as reported by Ben Hutchings in
    http://lkml.kernel.org/r/1391593985.3003.48.camel@deadeye.wl.decadent.org.uk .
    
    Work around that by making it to be ifdefed for the architectures known
    to work with the current, limited approach, i386 and x86_64 till better
    code is written.
    
    Reported-by: Ben Hutchings <ben@decadent.org.uk>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Link: http://lkml.kernel.org/n/tip-ss04k11insqlu329xh5g02q0@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 619d11c47a91..6aa6fb6f7bd9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -283,6 +283,11 @@ static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches as soon as the ioctl beautifier
+ * 	  gets rewritten to support all arches.
+ */
 static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 						 struct syscall_arg *arg)
 {
@@ -290,6 +295,7 @@ static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 }
 
 #define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
@@ -843,6 +849,10 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 #define TCGETS		0x5401
 
 static const char *tioctls[] = {
@@ -864,6 +874,7 @@ static const char *tioctls[] = {
 };
 
 static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
@@ -945,9 +956,16 @@ static struct syscall_fmt {
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 			     [1] = SCA_STRHEXARRAY, /* cmd */
 			     [2] = SCA_HEX, /* arg */ },
 	  .arg_parm	 = { [1] = &strarray__tioctls, /* cmd */ }, },
+#else
+			     [2] = SCA_HEX, /* arg */ }, },
+#endif
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,

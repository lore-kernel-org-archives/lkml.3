Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3I2O0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 10:26:19 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40625 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3I2O0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 10:26:17 -0400
Date: Sun, 29 Sep 2013 16:26:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] perf fix
Message-ID: <20130929142613.GA9244@gmail.com>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929114700.GB282@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2013.09.28 at 20:03 +0200, Ingo Molnar wrote:
> > Andi Kleen (1):
> >       perf symbols: Demangle cloned functions
> 
> The commit above e95ab53645:
> 
>  commit de95ab53645a2f0015e0f68ee723f18dce2b8b51
>  Author: Andi Kleen <ak@linux.intel.com>
>  Date:   Thu Sep 12 08:16:38 2013 -0700
> 
>      perf symbols: Demangle cloned functions
> 
> breaks "perf top" on my machine. I just see a gray screen with no text
> at all. Sometimes the following error messages are printed:
>  *** Error in `perf': invalid fastbin entry (free): 0x00000000029b18c0 ***
>  *** Error in `perf': malloc(): memory corruption (fast): 0x0000000000ee0b10 ***
> 
> Reverting the commit "fixes" the issue.

Sorry about that.

Looking at the commit it fails on several quality levels:

 - sloppy structure: the code is unreadable, it should have been a 
                     separate helper function

 - sloppy flow:      why the heck does it do strchr() twice? Not to 
                     mention the fragile way of how the new flow tries 
                     to merge with the old instead of cleanly separating.

 - sloppy types:     it casts a const char * over into char *

 - sloppy style:     variable block not separated from statements, 
                     meaningless temporary variable names, etc. etc.

 - and it's not even a regression fix to begin with!

So the right resolution is a revert. Andi, please send a fixed patch with 
all of these issues and the crash fixed.

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 14951f22f1cc8375ead345d2ca08455e91f2152b Revert "perf symbols: Demangle cloned functions"

It fixes the 'perf top' regression Markus Trippelsdorf reported.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      Revert "perf symbols: Demangle cloned functions"


 tools/perf/util/symbol-elf.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index d2a888e..a9c829b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -928,33 +928,8 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * to it...
 		 */
 		if (symbol_conf.demangle) {
-			/*
-			 * The demangler doesn't deal with cloned functions.
-			 * XXXX.clone.NUM or similar
-			 * Strip the dot part and readd it later.
-			 */
-			char *p = (char *)elf_name, *dot;
-			dot = strchr(elf_name, '.');
-			if (dot) {
-				p = strdup(elf_name);
-				if (!p)
-					goto new_symbol;
-				dot = strchr(p, '.');
-				*dot = 0;
-			}
-
-			demangled = bfd_demangle(NULL, p,
+			demangled = bfd_demangle(NULL, elf_name,
 						 DMGL_PARAMS | DMGL_ANSI);
-			if (dot)
-				*dot = '.';
-			if (demangled && dot) {
-				demangled = realloc(demangled, strlen(demangled) + strlen(dot) + 1);
-				if (!demangled)
-					goto new_symbol;
-				strcpy(demangled + (dot - p), dot);
-			}
-			if (p != elf_name)
-				free(p);
 			if (demangled != NULL)
 				elf_name = demangled;
 		}

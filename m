Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3JIPA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:00:28 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:54906 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3JIPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:00:27 -0400
Date: Wed, 9 Oct 2013 17:00:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools/perf/build: Fix non-existent build directory handling
Message-ID: <20131009150023.GA10167@gmail.com>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009145157.GA27139@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > It silently ignores the O= target, as it doesn't exists.
> > 
> > Previous, expected behaviour is for the build process to stop, 
> > complaining that the target directory doesn't exists.
> 
> Yeah. So the reproducer for me is:
> 
>  rm -rf /tmp/build
>  mkdir -p /tmp/build/perf
>  make O=/tmp/build/perf -C tools/perf/ install-bin
>  rm -rf /tmp/build
>  make O=/tmp/build/perf -C tools/perf/ install-bin
> 
> the second install-bin should fail, and on the old tree it fails correctly 
> - but with the new tree it pretends that it succeeds.
> 
> Looking into it.

does the patch below fix it?

Thanks,

	Ingo

=====================>
[PATCH] tools/perf/build: Fix non-existent build directory handling
From: Ingo Molnar <mingo@kernel.org>

Arnaldo reported that non-existent build directories were not recognized 
properly. The reason is readlink failure causing 'O' to become empty.

Solve it by passing through the 'O' variable unmodified if readlink fails.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5aa3d04..9147044 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,7 +34,7 @@ endif
 # Only pass canonical directory names as the output directory:
 #
 ifneq ($(O),)
-  FULL_O := $(shell readlink -f $(O))
+  FULL_O := $(shell readlink -f $(O) || echo $(O))
 endif
 
 define print_msg

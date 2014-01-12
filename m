Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbaALPRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:17:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:17:02 -0500
Date: Sun, 12 Jan 2014 16:16:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/9] perf, tools: fix BFD detection on opensuse
Message-ID: <20140112151615.GA6524@krava.brq.redhat.com>
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
 <1389469379-13340-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389469379-13340-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 11:42:51AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> opensuse libbfd requires -lz -liberty to build. Add those
> to the BFD feature detection.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/config/Makefile                | 2 +-
>  tools/perf/config/feature-checks/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 01dd43d..d86d33c 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -478,7 +478,7 @@ else
>  endif
>  
>  ifeq ($(feature-libbfd), 1)
> -  EXTLIBS += -lbfd
> +  EXTLIBS += -lbfd -lz -liberty
>  endif

ok, Fedora is using linker script in place of libbfd.so which
adds those anyway..

---
[jolsa@krava perf]$ cat /usr/lib64/libbfd.so 
/* GNU ld script */

/* Ensure this .so library will not be used by a link for a different format
   on a multi-architecture system.  */
OUTPUT_FORMAT(elf64-x86-64)

/* The libz dependency is unexpected by legacy build scripts.  */
/* The libdl dependency is for plugin support.  (BZ 889134)  */
INPUT ( /usr/lib64/libbfd.a -liberty -lz -ldl )
---

we also need to check and probably get rid of follow up settings of
EXTLIBS which seems useless now:

...
    ifneq ($(feature-libbfd), 1)
      $(call feature_check,liberty)
      ifeq ($(feature-liberty), 1)
        EXTLIBS += -lbfd -liberty
      else
        $(call feature_check,liberty-z)
        ifeq ($(feature-liberty-z), 1)
          EXTLIBS += -lbfd -liberty -lz
...

jirka

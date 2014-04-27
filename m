Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaD0J1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 05:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbaD0J1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 05:27:03 -0400
Date: Sun, 27 Apr 2014 11:26:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf x86: Fix perf to use non-executable stack, again
Message-ID: <20140427092649.GA1111@krava.brq.redhat.com>
References: <1398538965-10620-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398538965-10620-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 09:02:45PM +0200, Mathias Krause wrote:
> arch/x86/tests/regs_load.S is missing the linker note about the stack
> requirements, therefore making the linker fall back to an executable
> stack. As this object gets linked against the final perf binary, it'll
> needlessly end up with an executable stack.
> 
> Fix this by adding the appropriate linker note.
> 
> Fixes: 3c8b06f981 ("perf tests x86: Introduce perf_regs_load function")
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> 
> ---
>  tools/perf/arch/x86/tests/regs_load.S |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
> index 99167bf644..60875d5c55 100644
> --- a/tools/perf/arch/x86/tests/regs_load.S
> +++ b/tools/perf/arch/x86/tests/regs_load.S
> @@ -1,4 +1,3 @@
> -
>  #include <linux/linkage.h>
>  
>  #define AX	 0
> @@ -90,3 +89,10 @@ ENTRY(perf_regs_load)
>  	ret
>  ENDPROC(perf_regs_load)
>  #endif
> +
> +/*
> + * We need to provide note.GNU-stack section, saying that we want
> + * NOT executable stack. Otherwise the final linking will assume that
> + * the ELF stack should not be restricted at all and set it RWX.
> + */
> +.section .note.GNU-stack,"",@progbits
> -- 
> 1.7.10.4
> 

hum, how about fixing this once and for all.. ;-)
please check attached patch, thanks

jirka


---
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index fcd9cf0..a20780b 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -4,9 +4,3 @@
 #define Lmemcpy_c globl memcpy_c; memcpy_c
 #define Lmemcpy_c_e globl memcpy_c_e; memcpy_c_e
 #include "../../../arch/x86/lib/memcpy_64.S"
-/*
- * We need to provide note.GNU-stack section, saying that we want
- * NOT executable stack. Otherwise the final linking will assume that
- * the ELF stack should not be restricted at all and set it RWX.
- */
-.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/bench/mem-memset-x86-64-asm.S b/tools/perf/bench/mem-memset-x86-64-asm.S
index 9e5af89..cb92170 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm.S
+++ b/tools/perf/bench/mem-memset-x86-64-asm.S
@@ -4,10 +4,3 @@
 #define Lmemset_c globl memset_c; memset_c
 #define Lmemset_c_e globl memset_c_e; memset_c_e
 #include "../../../arch/x86/lib/memset_64.S"
-
-/*
- * We need to provide note.GNU-stack section, saying that we want
- * NOT executable stack. Otherwise the final linking will assume that
- * the ELF stack should not be restricted at all and set it RWX.
- */
-.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d50869e..dd56b6b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -117,6 +117,9 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
+# force non-executable stack
+LDFLAGS += -Wl,-z,noexecstack
+
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)

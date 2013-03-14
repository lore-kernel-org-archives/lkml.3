Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3CNLAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:00:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52844 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3CNKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:12 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-e7-5141a8557c70
From: Namhyung Kim <namhyung@kernel.org>
To: chenggang <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chenggang Qin <chenggang.qcg@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3]Perf: Fix Makefile to clean all object files
References: <1363252468-10170-1-git-send-email-chenggang.qin@gmail.com>
Date: Thu, 14 Mar 2013 19:37:09 +0900
In-Reply-To: <1363252468-10170-1-git-send-email-chenggang.qin@gmail.com>
	(chenggang's message of "Thu, 14 Mar 2013 17:14:28 +0800")
Message-ID: <87sj3yjmi2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Thu, 14 Mar 2013 17:14:28 +0800, chenggang wrote:
> From: Chenggang Qin <chenggang.qcg@taobao.com>
>
> If we execute "make clean" in perf's directory, many object files cannot be
> cleaned in the current version.
> For example:
> While we run "make clean" in perf's directory, and run the command:
> "fine ./ -name "*.o""
> we will get:
> ------------------------------------
> ./arch/x86/util/unwind.o
> ./arch/x86/util/header.o
> ./arch/x86/util/dwarf-regs.o
> ./util/scripting-engines/trace-event-python.o
> ./util/scripting-engines/trace-event-perl.o
> ./util/probe-finder.o
> ./util/dwarf-aux.o
> ./util/unwind.o
> ... ...
> ------------------------------------
> These ".o" files are not cleaned.
>
> The reason is:
> These object files are added into "BUILTIN_OBJS" while "make" process check the environment.
> If the make command is "clean", the environment check process is not executed. So,
> these object files will not be added into "BUILTIN_OBJS" while we execute "make clean".

s/BUILTIN/LIB/g

>
> This patch fixed this problem.
> We only add a command:
> "find . -name "*.o" -exec rm -f {} \;"

I think the path should be $(OUTPUT) rather than ".".  How about this?

  find $(OUTPUT) -name "*.o" -delete


Thanks,
Namhyung

>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Yanmin Zhang <yanmin.zhang@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
>
> ---
>  tools/perf/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index a2108ca..dec08ba 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -1174,6 +1174,7 @@ clean: $(LIBTRACEEVENT)-clean
>  	$(RM) $(OUTPUT)util/*-bison*
>  	$(RM) $(OUTPUT)util/*-flex*
>  	$(python-clean)
> +	$(FIND) . -name "*.o" -exec rm -f {} \;
>  
>  .PHONY: all install clean strip $(LIBTRACEEVENT)
>  .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell

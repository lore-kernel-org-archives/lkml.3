Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaL2HzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:55:03 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52002 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaL2HzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:55:00 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Mon, 29 Dec 2014 16:56:07 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        acme@kernel.org, jolsa@kernel.org
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on
Message-ID: <20141229075607.GC6081@sejong>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

(Adding Arnaldo and Jiri to CC)

On Sat, Dec 27, 2014 at 09:26:11AM +0800, Wang Nan wrote:
> When build with 'make ARCH=x86' and dwarf unwind is on, there is a
> compiling error:
> 
>    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
>    CC       /home/wn/perf/arch/x86/tests/regs_load.o
>  arch/x86/tests/regs_load.S: Assembler messages:
>  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
>  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
>  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
>  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
>  make: *** [all] Error 2
>  ...
> 
> Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
> 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'. However,
> with 'ARCH=x86', the underlying compile may also be x86_64, which causes
> mismatching.

Hmm.. how did you compile this?  I guess ARCH=x86 requires -m32 flag
to the gcc, did you pass it (like via EXTRA_CFLAGS=-m32)?

I'm confused by 'underlying compile may also be x86_64' part..

Thanks,
Namhyung


> 
> This patch fixes it by checking __x86_64__ in both case of
> 'ARCH=x86_64' and 'ARCH=x86'.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/perf/config/Makefile.arch | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
> index 851cd01..303a096 100644
> --- a/tools/perf/config/Makefile.arch
> +++ b/tools/perf/config/Makefile.arch
> @@ -15,6 +15,8 @@ endif
>  
>  ifeq ($(ARCH),x86_64)
>    override ARCH := x86
> +endif
> +ifeq ($(ARCH),x86)
>    IS_X86_64 := 0
>    ifeq (, $(findstring m32,$(CFLAGS)))
>      IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

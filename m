Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3KANzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:55:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:25076 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750917Ab3KANzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:55:12 -0400
Date: Fri, 1 Nov 2013 09:55:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip v2 1/3] kprobes: Introduce nokprobe annotation for
 non-probe-able functions
Message-ID: <20131101095510.6b43aef5@gandalf.local.home>
In-Reply-To: <20131101112532.14657.34462.stgit@kbuild-fedora.novalocal>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
	<20131101112532.14657.34462.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 11:25:32 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Instead of __kprobes annotation, introduce 'nokprobe' new annotation
> to annotate that the function is not probed by kprobes.
> 
> Previously the '__kprobes' is used just for avoiding probes on
> kprobes-related functions which will be used from kprobes. However
> nowadays we use it for prohibiting probing the functions implicitly
> invoked from kprobes int3 handler, since that causes infinit-loop
> lockup or sudden reboot. In this case, the annotated functions are
> not limited in the kprobes-related functions, and __kprobes looks
> very confusing. (Moreover, actually, most of control-side kprobes
> functions like as register_kprobes() are safely probed by kprobes)
> 
> Thus, we decide to introduce 'nokprobe' new annotation. We leave
> "__kprobes" just for compatibility but it should be replaced or
> removed eventually.
> 
> New commits must use 'nokprobe' for this purpose.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  include/linux/compiler.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 92669cd..173c64e 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -353,8 +353,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  
>  /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
>  #ifdef CONFIG_KPROBES
> -# define __kprobes	__attribute__((__section__(".kprobes.text")))
> +# define nokprobe	__attribute__((__section__(".kprobes.text")))

I wonder if we should have both a __kprobes and nokprobe annotation,
such that we have:

# define __kprobes	__attribute__((__section__(".kprobes.text")))
# define nokprobe	__attribute__((__section__(".nokprobes.text")))

Then use __kprobes for the actual kprobes code, and nokprobe for all
the places that must not be traced by kprobes.

It just seems strange to me grouping kprobes code with non kprobes code.

-- Steve


>  #else
> -# define __kprobes
> +# define nokprobe
>  #endif
> +#define __kprobes nokprobe
> +
>  #endif /* __LINUX_COMPILER_H */
> 


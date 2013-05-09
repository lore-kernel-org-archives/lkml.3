Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3EIQ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:27:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3EIQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:27:43 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DN1rENdJRV0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=CpQRuSp1N3wA:10 a=EYxp_Dzh4o9mpGsoCNMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368116860.7373.118.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on
 ftrace_regex_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 12:27:40 -0400
In-Reply-To: <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 14:44 +0900, Masami Hiramatsu wrote:

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 8a5c017..3f29b3d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -64,9 +64,17 @@
>  
>  #define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +#define INIT_REGEX_LOCK(opsname)	\
> +	.regex_lock	= __MUTEX_INITIALIZER(opsname.regex_lock),
> +#else
> +#define INIT_REGEX_LOCK(opsname)
> +#endif
> +
>  static struct ftrace_ops ftrace_list_end __read_mostly = {
>  	.func		= ftrace_stub,
>  	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
> +	INIT_REGEX_LOCK(ftrace_list_end)
>  };
>  

We probably should have a better way to initialize this. As there are 26
ftrace_ops currently in the kernel (and this patch doesn't cover all of
them). Maybe have the first time its registered to initialize it.

I think adding the INIT_REGEX_LOCK() all over the place is rather ugly.

-- Steve



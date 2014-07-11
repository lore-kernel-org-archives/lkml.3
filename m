Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaGKVka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:40:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:34046 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752384AbaGKVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:40:29 -0400
Date: Fri, 11 Jul 2014 17:40:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] rcu: define tracepoint strings only if
 CONFIG_TRACING is set
Message-ID: <20140711174027.2c6473e0@gandalf.local.home>
In-Reply-To: <1405111845-3588-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1405111845-3588-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 22:50:45 +0200
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
> infrastructure") unconditionally populates the __tracepoint_str input section,
> but this section is not assigned an output section if CONFIG_TRACING is not set.
> This results in the __tracepoint_str turning up in unexpected places, i.e.,
> after _edata.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: rostedt@goodmis.org
> Cc: paulmck@linux.vnet.ibm.com
> ---
> v2:
> - s/DEFINE_TPS/DEFINE_RCU_TPS/
> 
>  kernel/rcu/tree.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f1ba77363fbb..eec9f3d6f506 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -79,9 +79,16 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
>   * the tracing userspace tools to be able to decipher the string
>   * address to the matching string.
>   */
> +#ifdef CONFIG_TRACING
> +#define DEFINE_RCU_TPS(sname) \
> +static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
> +#else
> +#define DEFINE_RCU_TPS(sname)
> +#endif
> +
>  #define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
>  static char sname##_varname[] = #sname; \
> -static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
> +DEFINE_RCU_TPS(sname) \
>  struct rcu_state sname##_state = { \
>  	.level = { &sname##_state.node[0] }, \
>  	.call = cr, \

Looking at this a bit deeper (actually looking at it in the context of
the code), we can make this even better.

#ifdef CONFIG_TRACING
# define DEFINE_RCU_TPS(sname) \
static char sname##_varname[] = #sname; \
static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
# define RCU_STATE_NAME(sname) sname##_varname;
#else
# define DEFINE_RCU_TPS(sname)
# define RCU_STATE_NAME(sname) __stringify(sname)
#endif

Then add:

	.name = RCU_STATE_NAME(sname), \


This will get rid of the sname##_varname variable as well.

-- Steve



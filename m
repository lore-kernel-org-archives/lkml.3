Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3BDQOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:14:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39547 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3BDQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:14:32 -0500
Date: Mon, 4 Feb 2013 21:42:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] uprobes/tracing: Introduce
 is_trace_uprobe_enabled()
Message-ID: <20130204161227.GA4246@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
 <20130131191825.GA30447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130131191825.GA30447@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020416-9264-0000-0000-0000031AAA91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:25]:

> probe_event_enable/disable() check tu->consumer != NULL to avoid the
> wrong uprobe_register/unregister().
> 
> We are going to kill this pointer and "struct uprobe_trace_consumer",
> so we add the new helper, is_trace_uprobe_enabled(), which can rely
> on TP_FLAG_TRACE/TP_FLAG_PROFILE instead.
> 
> Note: the current logic doesn't look optimal, it is not clear why
> TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive, we will probably
> change this later.
> 
> Also kill the unused TP_FLAG_UPROBE.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_probe.h  |    1 -
>  kernel/trace/trace_uprobe.c |    9 +++++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 9337086..5c7e09d 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -66,7 +66,6 @@
>  #define TP_FLAG_TRACE		1
>  #define TP_FLAG_PROFILE		2
>  #define TP_FLAG_REGISTERED	4
> -#define TP_FLAG_UPROBE		8
> 
> 
>  /* data_rloc: data relative location, compatible with u32 */
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index f02bbec..947379a 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -536,12 +536,17 @@ partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
>  }
> 
> +static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
> +{
> +	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
> +}
> +
>  static int probe_event_enable(struct trace_uprobe *tu, int flag)
>  {
>  	struct uprobe_trace_consumer *utc;
>  	int ret = 0;
> 
> -	if (tu->consumer)
> +	if (is_trace_uprobe_enabled(tu))
>  		return -EINTR;
> 
>  	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
> @@ -565,7 +570,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
> 
>  static void probe_event_disable(struct trace_uprobe *tu, int flag)
>  {
> -	if (!tu->consumer)
> +	if (!is_trace_uprobe_enabled(tu))
>  		return;
> 
>  	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3BDKvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:51:00 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44535 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3BDKu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:50:58 -0500
Date: Mon, 4 Feb 2013 16:18:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] uprobes/tracing: Ensure inode != NULL in
 create_trace_uprobe()
Message-ID: <20130204104854.GA12900@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
 <20130131191822.GA30444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130131191822.GA30444@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020410-0260-0000-0000-0000027CA4CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:22]:

> probe_event_enable/disable() check tu->inode != NULL at the start.
> This is ugly, if igrab() can fail create_trace_uprobe() should not
> succeed and "postpone" the failure.
> 
> Note: alloc_uprobe() should probably check igrab() != NULL as well.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 7b75949..f02bbec 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -255,6 +255,8 @@ static int create_trace_uprobe(int argc, char **argv)
> 
>  	inode = igrab(path.dentry->d_inode);
>  	path_put(&path);
> +	if (!inode)
> +		goto fail_address_parse;
> 
>  	ret = kstrtoul(arg, 0, &offset);
>  	if (ret)
> @@ -539,7 +541,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
>  	struct uprobe_trace_consumer *utc;
>  	int ret = 0;
> 
> -	if (!tu->inode || tu->consumer)
> +	if (tu->consumer)
>  		return -EINTR;
> 
>  	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
> @@ -563,7 +565,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
> 
>  static void probe_event_disable(struct trace_uprobe *tu, int flag)
>  {
> -	if (!tu->inode || !tu->consumer)
> +	if (!tu->consumer)
>  		return;
> 
>  	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3FYKTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:19:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56575 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3FYKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:19:00 -0400
Message-ID: <51C96E91.7020602@hitachi.com>
Date: Tue, 25 Jun 2013 19:18:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
 multibuffer
References: <51C90ECC.9030303@huawei.com>
In-Reply-To: <51C90ECC.9030303@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/25 12:30), zhangwei(Jovi) wrote:
> @@ -605,33 +629,84 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
>  				struct mm_struct *mm);
> 
>  static int
> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> +		   filter_func_t filter)
>  {
> +	int enabled = 0;
>  	int ret = 0;
> 
> +	/* we cannot call uprobe_register twice for same tu */
>  	if (is_trace_uprobe_enabled(tu))
> -		return -EINTR;
> +		enabled = 1;
> +
> +	if (file) {
> +		struct event_file_link *link;
> +
> +		if (tu->flags & TP_FLAG_PROFILE)
> +			return -EINTR;
> +
> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
> +		if (!link)
> +			return -ENOMEM;
> +
> +		link->file = file;
> +		list_add_rcu(&link->list, &tu->files);

Maybe, list_add_tail_rcu() ? :) (but this is a minor one)

Other parts looks good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



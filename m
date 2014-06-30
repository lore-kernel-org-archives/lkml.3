Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaF3REQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:04:16 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57618 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaF3REP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:04:15 -0400
Date: Mon, 30 Jun 2014 22:34:09 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
 uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630170409.GD5619@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140627170116.GA18298@redhat.com>
 <20140627170146.GA18332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140627170146.GA18332@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063017-8878-0000-0000-00000D4100B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,
> 
> 1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
>    _enable() should be called only if !enabled.
> 
> 2. If uprobe_buffer_enable() fails probe_event_enable() should clear
>    tp.flags and free event_file_link.
> 
> 3. If uprobe_register() fails it should do uprobe_buffer_disable().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
(one nit .. )

> +	ret = uprobe_buffer_enable();
> +	if (ret)
> +		goto err_flags;
> +
>  	tu->consumer.filter = filter;
>  	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> -	if (ret) {
> -		if (file) {
> -			list_del(&link->list);
> -			kfree(link);
> -			tu->tp.flags &= ~TP_FLAG_TRACE;
> -		} else
> -			tu->tp.flags &= ~TP_FLAG_PROFILE;
> -	}
> +	if (ret)
> +		goto err_buffer;
> 
> +	return 0;
> +
> + err_buffer:
> +	uprobe_buffer_disable();
> +

How about avoiding err_buffer label?
+	if (!ret)
+		return 0;

+	uprobe_buffer_disable();
+


> + err_flags:
> +	if (file) {
> +		list_del(&link->list);
> 
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju


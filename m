Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3FYKKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:10:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49706 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:10:21 -0400
Message-ID: <51C96C89.6080207@hitachi.com>
Date: Tue, 25 Jun 2013 19:10:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2] tracing/kprobes: move free_trace_probe into unregister_trace_probe
References: <51C951BF.1090509@huawei.com>
In-Reply-To: <51C951BF.1090509@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/25 17:15), zhangwei(Jovi) wrote:
> There have no good reason to call free_trace_probe
> every time when unregister_trace_probe return 0.
> 
> Move free_trace_probe into unregister_trace_probe,
> make code simpler.

Sorry, nack. For the symmetrical coding reason, I don't like
involving "free" and "alloc" into "unregister"/"register"
functions. I think those should be just another actions.

Thank you,

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_kprobe.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 9f46e98..f193c38 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -401,6 +401,7 @@ static int unregister_trace_probe(struct trace_probe *tp)
>  	__unregister_trace_probe(tp);
>  	list_del(&tp->list);
>  	unregister_probe_event(tp);
> +	free_trace_probe(tp);
> 
>  	return 0;
>  }
> @@ -419,7 +420,6 @@ static int register_trace_probe(struct trace_probe *tp)
>  		ret = unregister_trace_probe(old_tp);
>  		if (ret < 0)
>  			goto end;
> -		free_trace_probe(old_tp);
>  	}
> 
>  	/* Register new event */
> @@ -550,8 +550,6 @@ static int create_trace_probe(int argc, char **argv)
>  		}
>  		/* delete an event */
>  		ret = unregister_trace_probe(tp);
> -		if (ret == 0)
> -			free_trace_probe(tp);
>  		mutex_unlock(&probe_lock);
>  		return ret;
>  	}
> @@ -680,7 +678,6 @@ static int release_all_trace_probes(void)
>  	while (!list_empty(&probe_list)) {
>  		tp = list_entry(probe_list.next, struct trace_probe, list);
>  		unregister_trace_probe(tp);
> -		free_trace_probe(tp);
>  	}
> 
>  end:
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



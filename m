Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaGDFVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:21:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55321 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGDFVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:21:42 -0400
Message-ID: <53B639DE.8030102@hitachi.com>
Date: Fri, 04 Jul 2014 14:21:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: __trace_remove_event_dirs() leaks file->filter ? (Was: probe_event_disable()->synchronize_sched())
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com> <20140703162211.GB5610@redhat.com> <20140703170109.GA10208@redhat.com>
In-Reply-To: <20140703170109.GA10208@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/04 2:01), Oleg Nesterov wrote:
> On 07/03, Oleg Nesterov wrote:
>>
>> Hmm. Off-topic, but it seems that instance_rmdir() leaks the memory? Say,
>> file->filter?
> 
> Perhaps I am totally confused, but don't we need something like the patch
> below? I'll try to recheck later...
> 
> Better yet, we can probably move destroy_preds() from event_remove() to
> remove_event_file_dir()... not sure, need to recheck.

Ah, yes, it seems event_remove releases preds, and remove_event_file_dir()
called from event_trace_del_tracer() doesn't release it.

BTW, with following patch, we'd better remove destroy_preds() from
event_remove() and add destroy_call_preds() at the very last of the
function.

Thank you,

> 
> Oleg.
> 
> --- x/kernel/trace/trace_events.c
> +++ x/kernel/trace/trace_events.c
> @@ -470,6 +470,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
>  
>  	list_del(&file->list);
>  	remove_subsystem(file->system);
> +	destroy_file_preds(file);
>  	kmem_cache_free(file_cachep, file);
>  }
>  
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



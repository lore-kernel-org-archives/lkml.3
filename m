Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3CSOr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:47:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3CSOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:47:54 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=s5RgfaFXP7gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=vcfcUXAzZI4A:10 a=dTCI8YJIh58n20LNyLQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363704473.5938.25.camel@gandalf.local.home>
Subject: Re: [PATCH 5/9] perf util: Handle failure case in trace_report()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 10:47:53 -0400
In-Reply-To: <1363683224-28804-6-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-6-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:

> @@ -3100,7 +3105,7 @@ int perf_event__process_tracing_data(union perf_event *event,
>  		}
>  	}
>  
> -	if (size_read + padding != size) {
> +	if (size_read + padding != size || session->pevent == NULL) {
>  		pr_err("%s: tracing data size mismatch", __func__);

This is a strange error to give when pevent is NULL. Could have been a
malloc failure.


>  		return -1;
>  	}
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index 7cb24635adf2..129362b97ca5 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -293,7 +293,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>  	int show_version = 0;
>  	int show_funcs = 0;
>  	int show_printk = 0;
> -	ssize_t size;
> +	ssize_t size = -1;
> +	struct pevent *pevent;
> +
> +	*ppevent = NULL;
>  
>  	calc_data_size = 1;
>  	repipe = __repipe;
> @@ -317,34 +320,38 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>  	file_bigendian = buf[0];
>  	host_bigendian = bigendian();
>  
> -	*ppevent = read_trace_init(file_bigendian, host_bigendian);
> -	if (*ppevent == NULL)
> -		die("read_trace_init failed");
> +	pevent = read_trace_init(file_bigendian, host_bigendian);
> +	if (pevent == NULL) {

Shouldn't we still set *ppevent to NULL? Or will the user now need to
make sure that its pevent is NULL and always check for error?

-- Steve


> +		pr_err("read_trace_init failed");
> +		goto out;
> +	}
>  
>  	read_or_die(buf, 1);
>  	long_size = buf[0];
>  
> -	page_size = read4(*ppevent);
> -
> -	read_header_files(*ppevent);
> +	page_size = read4(pevent);
>  
> -	read_ftrace_files(*ppevent);
> -	read_event_files(*ppevent);
> -	read_proc_kallsyms(*ppevent);
> -	read_ftrace_printk(*ppevent);
> +	read_header_files(pevent);
> +	read_ftrace_files(pevent);
> +	read_event_files(pevent);
> +	read_proc_kallsyms(pevent);
> +	read_ftrace_printk(pevent);
>  
>  	size = calc_data_size - 1;
>  	calc_data_size = 0;
>  	repipe = false;
>  
>  	if (show_funcs) {
> -		pevent_print_funcs(*ppevent);
> -		return size;
> -	}
> -	if (show_printk) {
> -		pevent_print_printk(*ppevent);
> -		return size;
> +		pevent_print_funcs(pevent);
> +	} else if (show_printk) {
> +		pevent_print_printk(pevent);
>  	}
>  
> +	*ppevent = pevent;
> +	pevent = NULL;
> +
> +out:
> +	if (pevent)
> +		pevent_free(pevent);
>  	return size;
>  }



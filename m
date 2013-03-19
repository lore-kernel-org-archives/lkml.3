Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3CSOfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:35:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8376 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3CSOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:35:13 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Jlu5nvpyoosA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dwZyKuPOOjEA:10 a=H_7SOnKhmV-JpEiTghUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363703711.5938.20.camel@gandalf.local.home>
Subject: Re: [PATCH 3/9] perf util: Get rid of write_or_die() from
 trace-event-info.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 10:35:11 -0400
In-Reply-To: <1363683224-28804-4-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:

>  struct tracing_data *tracing_data_get(struct list_head *pattrs,
> @@ -465,6 +516,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  {
>  	struct tracepoint_path *tps;
>  	struct tracing_data *tdata;
> +	int err1, err2, err3, err4, err5, err6;
>  
>  	output_fd = fd;
>  
> @@ -498,12 +550,12 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  		output_fd = temp_fd;
>  	}
>  
> -	tracing_data_header();
> -	read_header_files();
> -	read_ftrace_files(tps);
> -	read_event_files(tps);
> -	read_proc_kallsyms();
> -	read_ftrace_printk();
> +	err1 = tracing_data_header();
> +	err2 = read_header_files();
> +	err3 = read_ftrace_files(tps);
> +	err4 = read_event_files(tps);
> +	err5 = read_proc_kallsyms();
> +	err6 = read_ftrace_printk();

ugly ugly ugly

What about:
	int err = 0;

	err += tracing_data_header();
	err += read_header_files();
	[...]

	if (err < 0) {
		free(tdata);
		tdata = NULL;
	}

Also, is the only clean up needed be freeing tdata?

-- Steve


>  
>  	/*
>  	 * All tracing data are stored by now, we can restore
> @@ -515,22 +567,31 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  		output_fd = fd;
>  	}
>  
> +	if (err1 + err2 + err3 + err4 + err5 + err6 < 0) {
> +		free(tdata);
> +		tdata = NULL;
> +	}
> +
>  	put_tracepoints_path(tps);
>  	return tdata;
>  }
>  



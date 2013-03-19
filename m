Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3CSOyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:54:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3CSOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:54:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FVc5S2mYZKgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=-PlxAUMR4MkA:10 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=g4MMrkNaK493y_Y921UA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363704867.5938.28.camel@gandalf.local.home>
Subject: Re: [PATCH 7/9] perf util: Get rid of read_or_die() in
 trace-event-read.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 10:54:27 -0400
In-Reply-To: <1363683224-28804-8-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-8-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Rename it to do_read and original do_read to __do_read, and check
> their return value.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-read.c | 80 +++++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index 62dd2168f4f5..87f0ccd54cdc 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -48,7 +48,7 @@ static int long_size;
>  static ssize_t calc_data_size;
>  static bool repipe;
>  
> -static int do_read(int fd, void *buf, int size)
> +static int __do_read(int fd, void *buf, int size)
>  {
>  	int rsize = size;
>  
> @@ -61,8 +61,10 @@ static int do_read(int fd, void *buf, int size)
>  		if (repipe) {
>  			int retw = write(STDOUT_FILENO, buf, ret);
>  
> -			if (retw <= 0 || retw != ret)
> -				die("repiping input file");
> +			if (retw <= 0 || retw != ret) {
> +				pr_debug("repiping input file");

Again, why debug and not err?

> +				return -1;
> +			}
>  		}
>  
>  		size -= ret;
> @@ -72,14 +74,16 @@ static int do_read(int fd, void *buf, int size)
>  	return rsize;
>  }
>  
> -static int read_or_die(void *data, int size)
> +static int do_read(void *data, int size)
>  {
>  	int r;
>  
> -	r = do_read(input_fd, data, size);
> -	if (r <= 0)
> -		die("reading input file (size expected=%d received=%d)",
> -		    size, r);
> +	r = __do_read(input_fd, data, size);
> +	if (r <= 0) {
> +		pr_debug("reading input file (size expected=%d received=%d)",
> +			 size, r);
> +		return -1;
> +	}
>  
>  	if (calc_data_size)
>  		calc_data_size += r;
> @@ -95,7 +99,7 @@ static void skip(int size)
>  
>  	while (size) {
>  		r = size > BUFSIZ ? BUFSIZ : size;
> -		read_or_die(buf, r);
> +		do_read(buf, r);

Shouldn't this check the result of do_read()?

>  		size -= r;
>  	};
>  }

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3DIXDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:03:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3DIXDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:03:32 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Qp2S8Rs-8YMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=t72ugolhqXYA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=x-5Agw7zdRYsVNl7CMYA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365548611.25498.79.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] ftrace: Constify ftrace_profile_bits
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 09 Apr 2013 19:03:31 -0400
In-Reply-To: <1364820385-32027-3-git-send-email-namhyung@kernel.org>
References: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
	 <1364820385-32027-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:46 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It seems that function profiler's hash size is fixed at 1024.
> Make the ftrace_profile_bits const and update hash size macro.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/ftrace.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d38ad7145f2f..08bbc5952a3a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -486,7 +486,6 @@ struct ftrace_profile_stat {
>  #define PROFILES_PER_PAGE					\
>  	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
>  
> -static int ftrace_profile_bits __read_mostly;
>  static int ftrace_profile_enabled __read_mostly;
>  
>  /* ftrace_profile_lock - synchronize the enable and disable of the profiler */
> @@ -494,7 +493,10 @@ static DEFINE_MUTEX(ftrace_profile_lock);
>  
>  static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
>  
> -#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
> +#define FTRACE_PROFILE_HASH_BITS 10
> +#define FTRACE_PROFILE_HASH_SIZE (1 << FTRACE_PROFILE_HASH_BITS)
> +
> +static const int ftrace_profile_bits = FTRACE_PROFILE_HASH_BITS;

Actually, can you resubmit this, and remove ftrace_profile_bits totally,
and just use FTRACE_PROFILE_HASH_BITS directly?

Thanks,

-- Steve

>  
>  static void *
>  function_stat_next(void *v, int idx)
> @@ -724,13 +726,6 @@ static int ftrace_profile_init_cpu(int cpu)
>  	if (!stat->hash)
>  		return -ENOMEM;
>  
> -	if (!ftrace_profile_bits) {
> -		size--;
> -
> -		for (; size; size >>= 1)
> -			ftrace_profile_bits++;
> -	}
> -
>  	/* Preallocate the function profiling pages */
>  	if (ftrace_profile_pages_init(stat) < 0) {
>  		kfree(stat->hash);



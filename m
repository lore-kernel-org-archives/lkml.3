Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab3LISaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:30:19 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:53056 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab3LISaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:30:17 -0500
Date: Mon, 9 Dec 2013 15:30:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131209183009.GC8098@ghostprotocols.net>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
 <1386567251-22751-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386567251-22751-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 02:33:58PM +0900, Namhyung Kim escreveu:
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 2500e75583fc..0fc905c230ad 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -56,7 +56,21 @@ static void show_error(char **error_str, const char *fmt, ...)
>  	index = pevent_get_input_buf_ptr();
>  	len = input ? strlen(input) : 0;
>  
> -	error = malloc_or_die(MAX_ERR_STR_SIZE + (len*2) + 3);
> +	error = malloc(MAX_ERR_STR_SIZE + (len*2) + 3);
> +	if (error == NULL) {
> +		/*
> +		 * Maybe it's due to len is too long.
> +		 * Retry without the input buffer part.
> +		 */
> +		len = 0;
> +
> +		error = malloc(MAX_ERR_STR_SIZE);
> +		if (error == NULL) {
> +			/* no memory */
> +			*error_str = "failed to allocate memory";
> +			return;

Can *error_str point to either malloc'ed or constant strings? Who
releases the allocated memory?

- Arnaldo

> +		}
> +	}
>  
>  	if (len) {
>  		strcpy(error, input);
> -- 
> 1.7.11.7

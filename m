Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3K0Ibf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:31:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:24677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3K0Ibe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:31:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,780,1378882800"; 
   d="scan'208";a="415801666"
Message-ID: <5295AFA3.6060007@intel.com>
Date: Wed, 27 Nov 2013 10:38:59 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] tools/perf/util: Document and clean up readn() a bit
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com> <1385130268-10664-2-git-send-email-jolsa@redhat.com> <20131125192909.GA27323@ghostprotocols.net> <20131126175335.GA9300@gmail.com>
In-Reply-To: <20131126175335.GA9300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/13 19:53, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
>> Em Fri, Nov 22, 2013 at 03:24:26PM +0100, Jiri Olsa escreveu:
>>>  }
>>> +
>>> +ssize_t perf_data_file__write(struct perf_data_file *file,
>>> +			      void *buf, size_t size)
>>> +{
>>> +	ssize_t total = size;
>>> +
>>> +	while (size) {
>>> +		ssize_t ret = write(file->fd, buf, size);
>>> +
>>> +		if (ret < 0) {
>>> +			pr_err("failed to write perf data, error: %m\n");
>>> +			return -1;
>>> +		}
>>> +
>>> +		size -= ret;
>>> +		buf  += ret;
>>> +	}
>>> +
>>> +	return total;
>>
>> So this is the functional equivalent of "readn", so please move it to
>> just after "readn" and make this just a simple wrapper.
> 
> Btw., would be nice to add a small comment to readn() that describes 
> its semantics, it looks like a useful helper.
> 
> I also added a check for the input parameter 'n', plus I added a 
> 'left' variable to make the flow clearer, and added a debug check for 
> the return value - I think returning 'n' is more obvious.

It would be nicer to match what 'read' does.

> 
> Totally untested though.
> 
> Thanks,
> 
> 	Ingo
> 
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 28a0a89..4789081 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -6,6 +6,7 @@
>  #endif
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <linux/kernel.h>
>  
>  /*
>   * XXX We need to find a better place for these things...
> @@ -151,21 +152,29 @@ unsigned long convert_unit(unsigned long value, char *unit)
>  	return value;
>  }
>  
> -int readn(int fd, void *buf, size_t n)
> +/*
> + * Read exactly 'n' bytes or return an error:
> + */
> +int readn(int fd, void *buf, ssize_t n)

Should really be the same prototype as 'read' i.e.

	ssize_t readn(int fd, void *buf, size_t n)

Need to change callers that are using 'int' too.

>  {
>  	void *buf_start = buf;
> +	size_t left = n;
> +
> +	BUG_ON(n <= 0);

	BUG_ON(n == 0 || n > SSIZE_MAX);

>  
> -	while (n) {
> -		int ret = read(fd, buf, n);
> +	while (left) {
> +		int ret = read(fd, buf, left);

Should use the correct return type:

		ssize_t ret = read(fd, buf, left);

>  
>  		if (ret <= 0)
>  			return ret;

Don't return 0 if not all the bytes were read:

		if (ret < 0)
			return ret;
		if (!ret)
			break;

>  
> -		n -= ret;
> +		left -= ret;
>  		buf += ret;
>  	}
>  
> -	return buf - buf_start;
> +	BUG_ON(buf-buf_start != n);
> +
> +	return n;

Should return the same value as 'read' i.e the original

	return buf - buf_start;

>  }
>  
>  size_t hex_width(u64 v)
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index c8f362d..bb0a336 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -253,7 +253,7 @@ bool strlazymatch(const char *str, const char *pat);
>  int strtailcmp(const char *s1, const char *s2);
>  char *strxfrchar(char *s, char from, char to);
>  unsigned long convert_unit(unsigned long value, char *unit);
> -int readn(int fd, void *buf, size_t size);
> +int readn(int fd, void *buf, ssize_t size);
>  
>  struct perf_event_attr;
>  
> 
> 


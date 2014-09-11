Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaIKKdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaIKKdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:33:40 -0400
Date: Thu, 11 Sep 2014 12:33:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 13/14] tools lib fd array: Allow associating an integer
 cookie with each entry
Message-ID: <20140911103319.GA13634@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-14-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358129-9965-14-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:08:48AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

>  }
>  
> -int fdarray__filter(struct fdarray *fda, short revents)
> +int fdarray__filter(struct fdarray *fda, short revents,
> +		    void (*entry_destructor)(struct fdarray *fda, int fd))
>  {
>  	int fd, nr = 0;
>  
> @@ -80,11 +94,17 @@ int fdarray__filter(struct fdarray *fda, short revents)
>  		return 0;
>  
>  	for (fd = 0; fd < fda->nr; ++fd) {
> -		if (fda->entries[fd].revents & revents)
> +		if (fda->entries[fd].revents & revents) {
> +			if (entry_destructor)
> +				entry_destructor(fda, fd);

the desctructor callback could have the 'priv' as an argument
so we dont need to touch fdarray internals in upper layer

> +
>  			continue;
> +		}
>  
> -		if (fd != nr)
> +		if (fd != nr) {
>  			fda->entries[nr] = fda->entries[fd];
> +			fda->priv[nr]	 = fda->priv[fd];
> +		}
>  
>  		++nr;
>  	}
> diff --git a/tools/lib/api/fd/array.h b/tools/lib/api/fd/array.h
> index de38361ba69e..7b2870a96898 100644
> --- a/tools/lib/api/fd/array.h
> +++ b/tools/lib/api/fd/array.h
> @@ -10,6 +10,7 @@ struct fdarray {
>  	int	       nr_alloc;
>  	int	       nr_autogrow;
>  	struct pollfd *entries;
> +	int	      *priv;

I like the idea of private pointer for each fd, but I think
it should be 'void*' to keep the library generic. The 'int*'
is related only to the evlist usage of this.

jirka

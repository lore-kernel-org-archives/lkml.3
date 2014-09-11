Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaIKM2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbaIKM2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:28:13 -0400
Date: Thu, 11 Sep 2014 14:27:51 +0200
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
Subject: Re: [PATCH 14/14] perf evlist: Unmap ring buffer when fd is nuked
Message-ID: <20140911122751.GD13634@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-15-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358129-9965-15-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:08:49AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> +}
> +
>  int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
>  {
> -	return fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
> +	return __perf_evlist__add_pollfd(evlist, fd, -1);
> +}
> +
> +static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
> +{
> +	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
> +
> +	perf_evlist__mmap_put(evlist, fda->priv[fd]);

we cannot do this.. because of the way we read the map

getting error or hup does not mean the mmap is empty,
it can still have data, which we loose if we unmap it

following test will get data only with attached patch:

---
term1:
  $ cat

term2:
  $ cat perf record -p `pgrep cat`

term1:
  ^D
---

we get poll READ notification based on the wattermart settings,
which by default is half size of the ring buffer.. so for small
amount of perf data we dont get the poll read notification

I think we need to handle this in the record command context
and read out the mmap before we unmap it

jirka



>  }
>  
>  int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
>  {
> -	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
> +	return fdarray__filter(&evlist->pollfd, revents_and_mask,
> +			       perf_evlist__munmap_filtered);
>  }
>  
>  int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
> @@ -751,7 +774,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
>  			perf_evlist__mmap_get(evlist, idx);
>  		}
>  
> -		if (perf_evlist__add_pollfd(evlist, fd) < 0) {
> +		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
>  			perf_evlist__mmap_put(evlist, idx);
>  			return -1;
>  		}
> -- 
> 1.9.3
> 

---
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fdb755f..9e71a47 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -448,6 +448,7 @@ static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
 {
 	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
 
+if (0)
 	perf_evlist__mmap_put(evlist, fda->priv[fd]);
 }
 

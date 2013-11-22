Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3KVPoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:44:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37151 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3KVPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:44:07 -0500
Subject: Re: [PATCH 19/22] perf tools: Add filename__read_str util function
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-20-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-20-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Nov 2013 00:43:59 +0900
Message-ID: <1385135039.1747.118.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> Adding filename__read_str util function to read
> text file and return it in the char array.
> 
> The interface is:
>   int filename__read_str(const char *filename, char **buf, size_t *sizep)
> 
>   Returns 0/-1 if the read suceeded/fail respectively.
> 
>   buf  - place to store the data pointer
>   size - place to store data size

[SNIP]
> +int filename__read_str(const char *filename, char **buf, size_t *sizep)
> +{
> +	size_t size = 0, alloc_size = 0;
> +	void *bf = NULL, *nbf;
> +	int fd, n, err = 0;
> +
> +	fd = open(filename, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +
> +	do {
> +		if (size == alloc_size) {
> +			alloc_size += BUFSIZ;
> +			nbf = realloc(bf, alloc_size);
> +			if (!nbf) {
> +				err = -ENOMEM;
> +				break;
> +			}
> +
> +			bf = nbf;
> +		}
> +
> +		n = read(fd, bf + size, BUFSIZ);

Shouldn't it be "read(fd, bf + size, alloc_size - size)"?
Otherwise there might be a problem if read() returned early for some
reason with small size and then retry with a full BUFSIZ..


> +		if (n < 0) {
> +			err = 0;

I think it needs to check the size also since read() might fail at the
first invocation.  What about this?

		if (n < 0) {
			if (size)
				err = 0;
			else
				err = -errno;

Thanks,
Namhyung

> +			break;
> +		}
> +
> +		size += n;
> +	} while (n > 0);
> +
> +	if (!err) {
> +		*sizep = size;
> +		*buf   = bf;
> +	} else
> +		free(bf);
> +
> +	close(fd);
> +	return err;
> +}




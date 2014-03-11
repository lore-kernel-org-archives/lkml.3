Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaCKNio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaCKNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:38:38 -0400
Date: Tue, 11 Mar 2014 14:38:01 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140311133801.GD22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:31AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> +#endif /* __JSMN_H_ */
> diff --git a/tools/perf/util/json.c b/tools/perf/util/json.c
> new file mode 100644
> index 0000000..48201114
> --- /dev/null
> +++ b/tools/perf/util/json.c
> @@ -0,0 +1,156 @@
> +/* Parse JSON files using the JSMN parser. */
> +
> +/*
> + * Copyright (c) 2014, Intel Corporation
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright notice,
> + * this list of conditions and the following disclaimer.
> + *
> + * 2. Redistributions in binary form must reproduce the above copyright
> + * notice, this list of conditions and the following disclaimer in the
> + * documentation and/or other materials provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> + * OF THE POSSIBILITY OF SUCH DAMAGE.
> +*/
> +
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/fcntl.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include "jsmn.h"
> +#include "json.h"
> +
> +#define roundup(x, y) (((x) + (y) - 1) & ~((y) - 1))
> +
> +static char *mapfile(const char *fn, size_t *size)
> +{
> +	unsigned ps = sysconf(_SC_PAGESIZE);

you can use page_size instead

> +	struct stat st;
> +	char *map = NULL;
> +	int err;
> +	int fd = open(fn, O_RDONLY);
> +
> +	if (fd < 0)
> +		return NULL;
> +	err = fstat(fd, &st);
> +	if (err < 0)
> +		goto out;
> +	*size = st.st_size;
> +	map = mmap(NULL, roundup(st.st_size, ps),
> +		   PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
> +	if (map == (char *)MAP_FAILED)
> +		map = NULL;
> +out:
> +	close(fd);
> +	return map;
> +}
> +
> +static void unmapfile(char *map, size_t size)
> +{
> +	unsigned ps = sysconf(_SC_PAGESIZE);

ditto

jirka

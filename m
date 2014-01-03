Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaACIti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 03:49:38 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64527 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaACIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:49:37 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-d4-52c6799faa50
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 4/8] perf tools: Introduce struct perf_log
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
	<1388036284-32342-5-git-send-email-namhyung@kernel.org>
	<52BC426D.8020408@gmail.com>
Date: Fri, 03 Jan 2014 17:49:35 +0900
In-Reply-To: <52BC426D.8020408@gmail.com> (David Ahern's message of "Thu, 26
	Dec 2013 09:51:25 -0500")
Message-ID: <8761q1fo0w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 26 Dec 2013 09:51:25 -0500, David Ahern wrote:
> On 12/26/13, 12:38 AM, Namhyung Kim wrote:
>> diff --git a/tools/perf/util/log.c b/tools/perf/util/log.c
>> new file mode 100644
>> index 000000000000..3838d49f82de
>> --- /dev/null
>> +++ b/tools/perf/util/log.c
>> @@ -0,0 +1,105 @@
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include "util/debug.h"
>> +
>> +#define LINEMAP_GROW  128
>> +
>> +struct perf_log perf_log = {
>> +	.seen_newline = true,
>> +};
>> +
>> +int perf_log_init(void)
>
> Why return int if the rc is not checked? Failure here is not going to
> stop the perf command right?

Right.  I'll add a debug print if it's failed.

>
>> +{
>> +	FILE *fp;
>> +	char name[] = "/tmp/perf-log-XXXXXX";
>> +	int fd = mkstemp(name);
>> +
>> +	if (fd < 0)
>> +		return -1;
>> +
>> +	fp = fdopen(fd, "r+");
>> +	if (fp == NULL) {
>> +		close(fd);
>> +		return -1;
>> +	}
>> +
>> +	perf_log.fp = fp;
>
> Add 'unlink(name);' here to ensure the file is removed regardless of
> how perf terminates.

Ah, okay.  I thought the mkstemp() unlinked the file after open()
returns.  It seems this is what tmpfile(3) does.  I'll switch to
tmpfile() then.

>
>> +
>> +	return 0;
>> +}
>> +
>> +int perf_log_exit(void)
>> +{
>> +	FILE *fp = perf_log.fp;
>> +	if (fp)
>> +		fclose(fp);
>> +
>> +	free(perf_log.linemap);
>> +
>> +	perf_log.fp = NULL;
>> +	perf_log.linemap = NULL;
>> +	return 0;
>> +}
>> +
>> +static int grow_linemap(struct perf_log *log)
>> +{
>> +	off_t *newmap;
>> +	int newsize = log->nr_alloc + LINEMAP_GROW;
>> +
>> +	newmap = realloc(log->linemap, newsize * sizeof(*log->linemap));
>> +	if (newmap == NULL)
>> +		return -1;
>> +
>> +	log->nr_alloc = newsize;
>> +	log->linemap = newmap;
>> +	return 0;
>> +}
>
> What's the point of linemap?

To save an offset of each line.  We need to keep it in order to move to
an arbitraty line in the browser.

>
>> +
>> +static int __add_to_linemap(struct perf_log *log, off_t idx)
>> +{
>> +	if (log->lines == log->nr_alloc)
>> +		if (grow_linemap(log) < 0)
>> +			return -1;
>> +
>> +	log->linemap[log->lines++] = idx;
>> +	return 0;
>> +}
>> +
>> +static void add_to_linemap(struct perf_log *log, const char *msg, off_t base)
>> +{
>> +	const char *pos;
>> +
>> +	if (strlen(msg) == 0)
>> +		return;
>> +
>> +	if (log->seen_newline) {
>> +		if (__add_to_linemap(log, base) < 0)
>> +			return;
>> +	}
>> +
>> +	if ((pos = strchr(msg, '\n')) != NULL) {
>> +		log->seen_newline = true;
>> +		pos++;
>> +		add_to_linemap(log, pos, base + (pos - msg));
>> +	} else {
>> +		log->seen_newline = false;
>> +	}
>> +}
>> +
>> +void perf_log_add(const char *msg)
>> +{
>> +	FILE *fp = perf_log.fp;
>
> Don't assume every user of libperf calls perf_log_init() or that the
> file was actually created. i.e., add 'if (fp == NULL) return;'

Okay.

>
>
>> +	off_t offset = ftello(fp);
>> +
>> +	add_to_linemap(&perf_log, msg, offset);
>> +
>> +	fwrite(msg, 1, strlen(msg), fp);
>
> And if write fails?

Hmm.. it's a problem.  We might go back to original linemap position for
a failure case.  I'll save the offset and line number and restore them.

>
>> +}
>> +
>> +void perf_log_addv(const char *fmt, va_list ap)
>> +{
>> +	char buf[4096];
>
> Add as an optimization add the fp != NULL check here too. Don't need
> to do the vsnprintf only to drop it.

Okay.

>
>> +
>> +	vsnprintf(buf, sizeof(buf), fmt, ap);
>> +	perf_log_add(buf);
>> +}
>>
>
> What limits the size of the file - other than the obvious out of space
> in /tmp? Allow the file to grow without bounds in case a user wants
> the messages seems dangerous.

Hmm. I don't have an idea what the reasonable size.  It's a temp file
anyway and usually it contains not much data - well, 'perf top -vvv' is
different and might need some surgery.

>
> What about using a circular buffer instead?

Instead of a file?  Yes, it's possible but I think it might not be a
good choice for the browser since it could alter the index during the
circulation so that the browser can confuse to update the entries.

Thanks,
Namhyung

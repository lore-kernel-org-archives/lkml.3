Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab3CTBYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:24:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43680 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3CTBYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:24:36 -0400
X-AuditID: 9c93016f-b7b08ae000000bbd-61-51490fd064af
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 7/9] perf util: Get rid of read_or_die() in trace-event-read.c
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-8-git-send-email-namhyung@kernel.org>
	<1363704867.5938.28.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 10:24:32 +0900
In-Reply-To: <1363704867.5938.28.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 19 Mar 2013 10:54:27 -0400")
Message-ID: <87a9pyj227.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 10:54:27 -0400, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Rename it to do_read and original do_read to __do_read, and check
>> their return value.
>> 
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/trace-event-read.c | 80 +++++++++++++++++++++++++++-----------
>>  1 file changed, 57 insertions(+), 23 deletions(-)
>> 
>> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
>> index 62dd2168f4f5..87f0ccd54cdc 100644
>> --- a/tools/perf/util/trace-event-read.c
>> +++ b/tools/perf/util/trace-event-read.c
>> @@ -48,7 +48,7 @@ static int long_size;
>>  static ssize_t calc_data_size;
>>  static bool repipe;
>>  
>> -static int do_read(int fd, void *buf, int size)
>> +static int __do_read(int fd, void *buf, int size)
>>  {
>>  	int rsize = size;
>>  
>> @@ -61,8 +61,10 @@ static int do_read(int fd, void *buf, int size)
>>  		if (repipe) {
>>  			int retw = write(STDOUT_FILENO, buf, ret);
>>  
>> -			if (retw <= 0 || retw != ret)
>> -				die("repiping input file");
>> +			if (retw <= 0 || retw != ret) {
>> +				pr_debug("repiping input file");
>
> Again, why debug and not err?

Well, there's a pr_err() at the caller of top-level trace_report() in
case of error.  So if we use pr_err() there'll be multiple error message
for one failure and I don't think it's so helpful to normal users.  If
one really wants to know what happens inside, she will set -v to see
this low-level debug message.

Does that make sense?

>
>> +				return -1;
>> +			}
>>  		}
>>  
>>  		size -= ret;
>> @@ -72,14 +74,16 @@ static int do_read(int fd, void *buf, int size)
>>  	return rsize;
>>  }
>>  
>> -static int read_or_die(void *data, int size)
>> +static int do_read(void *data, int size)
>>  {
>>  	int r;
>>  
>> -	r = do_read(input_fd, data, size);
>> -	if (r <= 0)
>> -		die("reading input file (size expected=%d received=%d)",
>> -		    size, r);
>> +	r = __do_read(input_fd, data, size);
>> +	if (r <= 0) {
>> +		pr_debug("reading input file (size expected=%d received=%d)",
>> +			 size, r);
>> +		return -1;
>> +	}
>>  
>>  	if (calc_data_size)
>>  		calc_data_size += r;
>> @@ -95,7 +99,7 @@ static void skip(int size)
>>  
>>  	while (size) {
>>  		r = size > BUFSIZ ? BUFSIZ : size;
>> -		read_or_die(buf, r);
>> +		do_read(buf, r);
>
> Shouldn't this check the result of do_read()?

I was not so sure about this, but I skipped the check since all it does
is to "skip" and comment said "If it fails, the next read will report
it". :-)

Thanks,
Namhyung

>
>>  		size -= r;
>>  	};
>>  }
>
> -- Steve

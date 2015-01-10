Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbAJKQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:16:15 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:44348 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbAJKQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:16:12 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "bp@suse.de" <bp@suse.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH 4/5] perf tools: [uclibc] don't rely on glibc malloc
 working for sz 0
Thread-Topic: [PATCH 4/5] perf tools: [uclibc] don't rely on glibc malloc
 working for sz 0
Thread-Index: AQHQKbgZhWPRbzhLDkCxe6Z1ZbJk1w==
Date: Sat, 10 Jan 2015 10:16:06 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCA731@IN01WEMBXA.internal.synopsys.com>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
 <1420552335-26886-5-git-send-email-vgupta@synopsys.com>
 <20150108075125.GF7268@sejong>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 01:23 PM, Namhyung Kim wrote:
> Hi Vineet,
>
> On Tue, Jan 06, 2015 at 07:22:14PM +0530, Vineet Gupta wrote:
>> When running perf on ARC (uClibc based userspace), ran into this issue
>> ------------->8----------------
>> 	[ARCLinux]$ ./perf record ls
>> 	bin             etc             perf            sys
>> 	debug           init            perf.data       tmp
>> 	[ perf record: Woken up 1 times to write data ]
>> 	[ perf record: Captured and wrote 0.001 MB perf.data (~24 samples) ]
>>
>> 	[ARCLinux]$ ./perf report
>> 	incompatible file format (rerun with -v to learn more)
>> ------------->8----------------
>>
>> The problem happens in the following call stack when zalloc is called
>> with size zero
>>
>> glibc default / uClibc with MALLOC_GLIBC_COMPAT are OK, but not if that
>> config option is not enabled.
>>
>>   cmd_report
>>      perf_session__new
>> 	perf_session__open
>> 	    perf_session__read_header
>> 		read_attr(fd, header, &f_attr)
>> 		nr_ids = f_attr.ids.size / sizeof(u64); <-- 0
>> 		perf_evsel__alloc_id(vsel, 1, nr_ids)
>> 			zalloc(ncpus * nthreads * sizeof(u64)) <-- 0
>>
>> header.c: read_attr()
>>
>> (gdb) p *f_attr
>> $17 = {
>>   attr = {
>>     type = 0,
>>     size = 96,
>>     config = 0,
>>     {
>>       sample_period = 4000,
>>       sample_freq = 4000
>>     },
>> ...
>>   ids = {
>>     offset = 104,
>>     size = 0      <------
>>   }
>> }
> Hmm.. okay.  I think we don't need to allocate the id arrays when size
> is 0.  So perf_event__process_attr() will have the same problem IMHO.
> How about this?
>
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1e90c8557ede..1d826d63bc20 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -797,6 +797,9 @@ int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
>  
>  int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
>  {
> +	if (ncpus == 0 || nthreads == 0)
> +		return 0;
> +
>  	if (evsel->system_wide)
>  		nthreads = 1;

Fine by me as I'm not too familiar with perf tools internals.
So I need to spin a v2 for this or would you rather create a patch with me as
Reported-by:

-Vineet

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaAFIcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:32:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52970 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaAFIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:32:18 -0500
X-AuditID: 9c930179-b7c89ae000006438-8c-52ca6a10d3e2
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 09/21] perf ui/hist: Add support to accumulated hist stat
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-10-git-send-email-namhyung@kernel.org>
	<20140105173113.GH10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:32:16 +0900
In-Reply-To: <20140105173113.GH10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 18:31:13 +0100")
Message-ID: <8738l1ecj3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 18:31:13 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:15PM +0900, Namhyung Kim wrote:
>> +#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
>> +static u64 he_get_acc_##_field(struct hist_entry *he)				\
>> +{										\
>> +	return he->stat_acc->_field;						\
>> +}										\
>> +										\
>> +static int hpp__color_acc_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
>> +			      struct perf_hpp *hpp, struct hist_entry *he) 	\
>> +{										\
>> +	return __hpp__fmt(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
>> +			  (hpp_snprint_fn)percent_color_snprintf, true);	\
>> +}
>> +
>> +#define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
>> +static int hpp__entry_acc_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,	\
>> +			      struct perf_hpp *hpp, struct hist_entry *he) 	\
>> +{										\
>> +	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
>> +	return __hpp__fmt(hpp, he, he_get_acc_##_field, fmt,			\
>> +			  scnprintf, true);					\
>> +}
>> +
>>  #define __HPP_ENTRY_RAW_FN(_type, _field)					\
>>  static u64 he_get_raw_##_field(struct hist_entry *he)				\
>>  {										\
>> @@ -148,17 +170,25 @@ __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
>>  __HPP_COLOR_PERCENT_FN(_type, _field)					\
>>  __HPP_ENTRY_PERCENT_FN(_type, _field)
>>  
>> +#define HPP_PERCENT_ACC_FNS(_type, _str, _field, _min_width, _unit_width)\
>> +__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
>> +__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
>> +__HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
>> +__HPP_ENTRY_ACC_PERCENT_FN(_type, _field)
>
> how about add 'stat|stat_acc' parameter to the HPP_PERCENT_FNS
> macro and use it like:
>
> #define __HPP_COLOR_PERCENT_FN(_type, _field, _stat)                            \
> static u64 he_get_##_stat##_field(struct hist_entry *he)                        \
> {                                                                               \
>         return he->##_stat._field;                                              \
> }                                                                               \
>
>
> and use 'he_get_##_stat##_field' in __HPP_ENTRY_PERCENT_FN
>
> This way you dont need to duplicate the code, that differs
> only in the used stat data.. but it's possible I missed
> something ;-)

The problem is that he->stat is a in-struct data but ->stat_acc is
dynamically allocated.  So it should be 

  "he->stat. ## _field"
           ~
vs.

  "he->stat_acc-> ## _field"
               ~~
>
> btw just noticed __HPP_COLOR_PERCENT_FN does not use _type

???  It's used in hpp__color_##_type().


Thanks,
Namhyung

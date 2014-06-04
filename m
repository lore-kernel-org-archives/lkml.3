Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaFDOz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:55:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41078 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaFDOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:55:58 -0400
Subject: Re: [PATCH 3/3] Provide additional sample information on generic
 events
From: Namhyung Kim <namhyung@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com
In-Reply-To: <538F0BF6.9070904@tu-dresden.de>
References: <53031D2C.2050009@tu-dresden.de>
	 <20140307141857.GA3153@ghostprotocols.net>	<533D2283.3090703@tu-dresden.de>
	 <87wqd5f7j5.fsf@sejong.aot.lge.com>  <538F0BF6.9070904@tu-dresden.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jun 2014 23:55:51 +0900
Message-ID: <1401893751.1673.23.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-04 (수), 14:07 +0200, Joseph Schuchart:
> Provide additional sample information on generic events
> to Python scripts, including pid, tid, and cpu for which the event was
> recorded. At the moment, the pointer to the sample struct is passed to
> scripts, which seems to be of little use. The patch puts this information in
> a dictionary for easy access by Python scripts.
> 
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

I think it'd be better adding sample->ip also, but anyway

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thank you for doing this work!
Namhyung


> ---
>  .../util/scripting-engines/trace-event-python.c     | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 4f81dc7..c8d148b 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -445,7 +445,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  					 struct thread *thread,
>  					 struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *t, *dict, *callchain;
> +	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
>  	static char handler_name[64];
>  	unsigned n = 0;
>  
> @@ -461,6 +461,10 @@ static void python_process_general_event(struct perf_sample *sample,
>  	if (!dict)
>  		Py_FatalError("couldn't create Python dictionary");
>  
> +	dict_sample = PyDict_New();
> +	if (!dict_sample)
> +		Py_FatalError("couldn't create Python dictionary");
> +
>  	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
>  
>  	handler = PyDict_GetItemString(main_dict, handler_name);
> @@ -470,8 +474,19 @@ static void python_process_general_event(struct perf_sample *sample,
>  	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
>  	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
>  			(const char *)&evsel->attr, sizeof(evsel->attr)));
> -	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
> -			(const char *)sample, sizeof(*sample)));
> +
> +	pydict_set_item_string_decref(dict_sample, "pid",
> +			PyInt_FromLong(sample->pid));
> +	pydict_set_item_string_decref(dict_sample, "tid",
> +			PyInt_FromLong(sample->tid));
> +	pydict_set_item_string_decref(dict_sample, "cpu",
> +			PyInt_FromLong(sample->cpu));
> +	pydict_set_item_string_decref(dict_sample, "time",
> +			PyLong_FromUnsignedLongLong(sample->time));
> +	pydict_set_item_string_decref(dict_sample, "period",
> +			PyLong_FromUnsignedLongLong(sample->period));
> +	pydict_set_item_string_decref(dict, "sample", dict_sample);
> +
>  	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
>  			(const char *)sample->raw_data, sample->raw_size));
>  	pydict_set_item_string_decref(dict, "comm",




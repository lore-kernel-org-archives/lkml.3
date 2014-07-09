Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaGIIQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:16:12 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58045 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGIIQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:16:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3]  perf script: Provide additional sample information on generic events
References: <53031D2C.2050009@tu-dresden.de>
	<20140307141857.GA3153@ghostprotocols.net>
	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
	<538F0BF2.1010806@tu-dresden.de>
	<20140707171706.GA20752@krava.redhat.com>
	<53BCF1F4.7020906@tu-dresden.de>
Date: Wed, 09 Jul 2014 17:16:00 +0900
In-Reply-To: <53BCF1F4.7020906@tu-dresden.de> (Joseph Schuchart's message of
	"Wed, 09 Jul 2014 09:40:36 +0200")
Message-ID: <87vbr72bi7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2014 09:40:36 +0200, Joseph Schuchart wrote:
>  [PATCH 3/3]  perf script: Provide additional sample information on
>  generic events  to Python scripts, including pid, tid, and cpu for which the
>  event was  recorded. At the moment, the pointer to the sample struct is
>  passed to  scripts, which seems to be of little use. The patch puts this
>  information in  dictionaries for easy access by Python scripts.
>
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  .../util/scripting-engines/trace-event-python.c    | 23 +++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index dae78e4..64923cd 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -446,7 +446,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  					 struct thread *thread,
>  					 struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *t, *dict, *callchain;
> +	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
>  	static char handler_name[64];
>  	unsigned n = 0;
>  
> @@ -462,6 +462,10 @@ static void python_process_general_event(struct perf_sample *sample,
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
> @@ -471,8 +475,21 @@ static void python_process_general_event(struct perf_sample *sample,
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
> +	pydict_set_item_string_decref(dict_sample, "ip",
> +			PyLong_FromUnsignedLongLong(sample->ip));
> +	pydict_set_item_string_decref(dict_sample, "time",
> +			PyLong_FromUnsignedLongLong(sample->time));
> +	pydict_set_item_string_decref(dict_sample, "period",
> +			PyLong_FromUnsignedLongLong(sample->period));
> +	pydict_set_item_string_decref(dict, "sample", dict_sample);
> +
>  	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
>  			(const char *)sample->raw_data, sample->raw_size));
>  	pydict_set_item_string_decref(dict, "comm",

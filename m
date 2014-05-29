Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaE2GBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:01:06 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55950 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaE2GBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:01:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Provide additional sample information to Python scripts
References: <53031D2C.2050009@tu-dresden.de>
	<20140307141857.GA3153@ghostprotocols.net>
	<533D2283.3090703@tu-dresden.de>
Date: Thu, 29 May 2014 15:01:02 +0900
In-Reply-To: <533D2283.3090703@tu-dresden.de> (Joseph Schuchart's message of
	"Thu, 03 Apr 2014 10:57:39 +0200")
Message-ID: <87wqd5f7j5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

Sorry for late review, this looks very useful..  But please send a
separate email for each patch and make it inlined (not attached) in the
next version.


On Thu, 03 Apr 2014 10:57:39 +0200, Joseph Schuchart wrote:

[SNIP]
>  static void python_process_tracepoint(struct perf_sample *sample,
>  				      struct perf_evsel *evsel,
>  				      struct thread *thread,
>  				      struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
> +	PyObject *handler, *retval, *context, *t, *obj, *callchain;
> +	PyObject *dict = NULL;
>  	static char handler_name[256];
>  	struct format_field *field;
>  	unsigned long long val;
> @@ -327,6 +406,14 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			pydict_set_item_string_decref(dict, field->name, obj);
>  
>  	}
> +
> +	/* ip unwinding */
> +	callchain = python_process_callchain(sample, evsel, al);
> +	if (handler)
> +		PyTuple_SetItem(t, n++, callchain);
> +	else
> +		pydict_set_item_string_decref(dict, "callchain", callchain);

But this makes the script not runnable anymore due to argument number
mismatch:

  $ perf script -s perf-script.py
  ...
  TypeError: sched__sched_wakeup() takes exactly 12 arguments (13 given)
  Fatal Python error: problem in Python trace event handler
  Aborted (core dumped)


So you need to change to pass callchain when generating the handler.


diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf
index 255d45177613..94e395c9a875 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -716,7 +716,7 @@ static int python_generate_script(struct pevent *pevent, con
 
                        fprintf(ofp, "%s", f->name);
                }
-               fprintf(ofp, "):\n");
+               fprintf(ofp, ", callchain):\n");
 
                fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
                        "common_secs, common_nsecs,\n\t\t\t"


Also I think it's very useful to generate code to print callchain by
default if exists - something like below?

	for node in callchain:
		if 'sym' in node:
			print "\t[%x] %s" % (node['ip'], node['sym']['name'])
		else:
			print "\t[%x]" % (node['ip'])


  $ perf script -s perf-script.py
  in trace_begin
  sched__sched_wakeup      8 5021904.056096444    19713 :19713                comm=perf, pid=19714, prio=120, success=1, target_cpu=9
	[ffffffff81091512] ttwu_do_wakeup
	[ffffffff810916d6] ttwu_do_activate.constprop.87
	[ffffffff81093b64] try_to_wake_up
	[ffffffff81093c22] default_wake_function
	[ffffffff8108348d] autoremove_wake_function
	[ffffffff8108b215] __wake_up_common
	[ffffffff8108e933] __wake_up_sync_key
	[ffffffff811a5b20] pipe_write
	[ffffffff8119cc07] do_sync_write
	[ffffffff8119d2cc] vfs_write
	[ffffffff8119d762] sys_write
	[ffffffff816640d9] system_call_fastpath
  sched__sched_wakeup      8 5021904.056100334    19713 :19713                comm=perf, pid=19714, prio=120, success=1, target_cpu=9
	[ffffffff81091512] ttwu_do_wakeup
	[ffffffff810916d6] ttwu_do_activate.constprop.87
	[ffffffff81093b64] try_to_wake_up
	[ffffffff81093c22] default_wake_function
	[ffffffff8108348d] autoremove_wake_function
	[ffffffff8108b215] __wake_up_common
	[ffffffff8108e933] __wake_up_sync_key
	[ffffffff811a5b20] pipe_write
	[ffffffff8119cc07] do_sync_write
	[ffffffff8119d2cc] vfs_write
	[ffffffff8119d762] sys_write
	[ffffffff816640d9] system_call_fastpath
  ...


> +
>  	if (!handler)
>  		PyTuple_SetItem(t, n++, dict);
>  

[SNIP]
> @@ -385,15 +476,30 @@ static void python_process_general_event(struct perf_sample *sample,
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

And I think this part should be a separate patch.

> +
> +	/* ip unwinding */
> +	callchain = python_process_callchain(sample, evsel, al);
> +	pydict_set_item_string_decref(dict, "callchain", callchain);
> +
>  	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
>  			(const char *)sample->raw_data, sample->raw_size));
>  	pydict_set_item_string_decref(dict, "comm",
>  			PyString_FromString(thread__comm_str(thread)));
>  	if (al->map) {
>  		pydict_set_item_string_decref(dict, "dso",
> -			PyString_FromString(al->map->dso->name));
> +				PyString_FromString(al->map->dso->name));

It seems like an unnecessary change.


>  	}
>  	if (al->sym) {
>  		pydict_set_item_string_decref(dict, "symbol",



>
> Perf: Fix possible memory leaks in Python interface
>
> The function PyObject_CallObject() returns a new PyObject reference 
> on which Py_DECREF has to be called to avoid memory leaks.
> This patch adds these calls where necessary.
>
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
>
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index cd9774d..ee17f64 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -97,6 +97,8 @@ static void define_value(enum print_arg_type field_type,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		else
> +			Py_DECREF(retval);

It looks like the handler_call_die() is never returned.  So we can get
rid of the 'else' (like in the last hunk) for simplicity.

Thanks,
Namhyung


>  	}
>  
>  	Py_DECREF(t);
> @@ -143,6 +145,8 @@ static void define_field(enum print_arg_type field_type,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		else
> +			Py_DECREF(retval);
>  	}
>  
>  	Py_DECREF(t);
> @@ -333,6 +337,8 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		else
> +			Py_DECREF(retval);
>  	} else {
>  		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
>  		if (handler && PyCallable_Check(handler)) {
> @@ -340,6 +346,8 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			retval = PyObject_CallObject(handler, t);
>  			if (retval == NULL)
>  				handler_call_die("trace_unhandled");
> +			else
> +				Py_DECREF(retval);
>  		}
>  		Py_DECREF(dict);
>  	}
> @@ -399,6 +407,8 @@ static void python_process_general_event(struct perf_sample *sample,
>  	retval = PyObject_CallObject(handler, t);
>  	if (retval == NULL)
>  		handler_call_die(handler_name);
> +	else
> +		Py_DECREF(retval);
>  exit:
>  	Py_DECREF(dict);
>  	Py_DECREF(t);
> @@ -444,8 +454,8 @@ static int run_start_sub(void)
>  	retval = PyObject_CallObject(handler, NULL);
>  	if (retval == NULL)
>  		handler_call_die("trace_begin");
> -
> -	Py_DECREF(retval);
> +	else
> +		Py_DECREF(retval);
>  	return err;
>  error:
>  	Py_XDECREF(main_dict);

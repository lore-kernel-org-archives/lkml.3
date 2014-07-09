Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaGIIOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:14:21 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47268 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGIIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:14:18 -0400
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
Subject: Re: [PATCH 1/3] perf script: Add missing calls to Py_DECREF for return values
References: <53031D2C.2050009@tu-dresden.de>
	<20140307141857.GA3153@ghostprotocols.net>
	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
	<538F0BF2.1010806@tu-dresden.de>
	<20140707171706.GA20752@krava.redhat.com>
	<53BCF1ED.1000004@tu-dresden.de>
Date: Wed, 09 Jul 2014 17:14:15 +0900
In-Reply-To: <53BCF1ED.1000004@tu-dresden.de> (Joseph Schuchart's message of
	"Wed, 09 Jul 2014 09:40:29 +0200")
Message-ID: <874myr3q5k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

On Wed, 09 Jul 2014 09:40:29 +0200, Joseph Schuchart wrote:
> [PATCH 1/3] perf script: Add missing calls to Py_DECREF for return values
>
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/scripting-engines/trace-event-python.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 1c41932..631aa85 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -50,10 +50,14 @@ static int zero_flag_atom;
>  
>  static PyObject *main_module, *main_dict;
>  
> +static void handler_call_die(const char *handler_name) NORETURN;
>  static void handler_call_die(const char *handler_name)
>  {
>  	PyErr_Print();
>  	Py_FatalError("problem in Python trace event handler");
> +	// Py_FatalError does not return
> +	// but we have to make the compiler happy
> +	abort();
>  }
>  
>  /*
> @@ -97,6 +101,7 @@ static void define_value(enum print_arg_type field_type,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		Py_DECREF(retval);
>  	}
>  
>  	Py_DECREF(t);
> @@ -143,6 +148,7 @@ static void define_field(enum print_arg_type field_type,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		Py_DECREF(retval);
>  	}
>  
>  	Py_DECREF(t);
> @@ -334,6 +340,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		Py_DECREF(retval);
>  	} else {
>  		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
>  		if (handler && PyCallable_Check(handler)) {
> @@ -341,6 +348,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			retval = PyObject_CallObject(handler, t);
>  			if (retval == NULL)
>  				handler_call_die("trace_unhandled");
> +			Py_DECREF(retval);
>  		}
>  		Py_DECREF(dict);
>  	}
> @@ -400,6 +408,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  	retval = PyObject_CallObject(handler, t);
>  	if (retval == NULL)
>  		handler_call_die(handler_name);
> +	Py_DECREF(retval);
>  exit:
>  	Py_DECREF(dict);
>  	Py_DECREF(t);
> @@ -521,8 +530,7 @@ static int python_stop_script(void)
>  	retval = PyObject_CallObject(handler, NULL);
>  	if (retval == NULL)
>  		handler_call_die("trace_end");
> -	else
> -		Py_DECREF(retval);
> +	Py_DECREF(retval);
>  out:
>  	Py_XDECREF(main_dict);
>  	Py_XDECREF(main_module);

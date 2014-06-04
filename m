Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaFDOoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:44:16 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43795 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaFDOoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:44:13 -0400
Subject: Re: [PATCH 1/3] Add missing calls to Py_DECREF
From: Namhyung Kim <namhyung@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com
In-Reply-To: <538F0BEE.7070703@tu-dresden.de>
References: <53031D2C.2050009@tu-dresden.de>
	 <20140307141857.GA3153@ghostprotocols.net>	<533D2283.3090703@tu-dresden.de>
	 <87wqd5f7j5.fsf@sejong.aot.lge.com>  <538F0BEE.7070703@tu-dresden.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jun 2014 23:44:06 +0900
Message-ID: <1401893046.1673.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

(Adding Jiri Olsa to CC list as he's maintaining the tooling part as of
now..)

2014-06-04 (수), 14:07 +0200, Joseph Schuchart:
> Add missing calls to Py_DECREF.
> 
> The function PyObject_CallObject() returns a new PyObject reference 
> on which Py_DECREF has to be called to avoid memory leaks.
> This patch adds these calls where necessary.
> 
> It also marks handler_call_die() as NORETURN to make this clear and to 
> avoid unnecessary else statements. Note that the abort() is necessary 
> since Py_FatalError() does not return but seems to be missing the 
> __noretun__ attribute in Python versions <=2.7

Acked-by: Namhyung Kim <namhyung@kernel.org>

Just nitpicks below..

> ---
>  tools/perf/util/scripting-engines/trace-event-python.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index cd9774d..8454dc9 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -50,10 +50,14 @@ static int zero_flag_atom;
>  
>  static PyObject *main_module, *main_dict;
>  
> +static void handler_call_die(const char *handler_name) NORETURN;

Why is this extra decl line needed?  What about just adding the NORETURN
marker to the function definition?


>  static void handler_call_die(const char *handler_name)
>  {
>  	PyErr_Print();
>  	Py_FatalError("problem in Python trace event handler");
> +	// Py_FatalError does not return
> +	// but we have to make the compiler happy

Please use C-style /* ... */ comments.

Thanks,
Namhyung


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
> @@ -333,6 +339,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		Py_DECREF(retval);
>  	} else {
>  		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
>  		if (handler && PyCallable_Check(handler)) {
> @@ -340,6 +347,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			retval = PyObject_CallObject(handler, t);
>  			if (retval == NULL)
>  				handler_call_die("trace_unhandled");
> +			Py_DECREF(retval);
>  		}
>  		Py_DECREF(dict);
>  	}
> @@ -399,6 +407,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  	retval = PyObject_CallObject(handler, t);
>  	if (retval == NULL)
>  		handler_call_die(handler_name);
> +	Py_DECREF(retval);
>  exit:
>  	Py_DECREF(dict);
>  	Py_DECREF(t);
> @@ -520,8 +529,7 @@ static int python_stop_script(void)
>  	retval = PyObject_CallObject(handler, NULL);
>  	if (retval == NULL)
>  		handler_call_die("trace_end");
> -	else
> -		Py_DECREF(retval);
> +	Py_DECREF(retval);
>  out:
>  	Py_XDECREF(main_dict);
>  	Py_XDECREF(main_module);




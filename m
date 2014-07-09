Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaGITH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:07:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:35818 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbaGITHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:07:22 -0400
Date: Wed, 9 Jul 2014 16:07:17 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf script: Add missing calls to Py_DECREF
Message-ID: <20140709190717.GC5721@kernel.org>
References: <20140307141857.GA3153@ghostprotocols.net>
 <533D2283.3090703@tu-dresden.de>
 <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
 <20140707171706.GA20752@krava.redhat.com>
 <53BCF1F2.70100@tu-dresden.de>
 <20140709112721.GC1814@krava.redhat.com>
 <53BD2AD6.6020309@tu-dresden.de>
 <20140709114903.GA5767@krava.redhat.com>
 <53BD4EBF.5050407@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD4EBF.5050407@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 04:16:31PM +0200, Joseph Schuchart escreveu:
> 
>  perf script: Add missing calls to Py_DECREF for return values

I'm applying this one, but please next time write a few lines explaining
what happens without the patch and thus what it fixes, i.e. why is a
Py_DECREF needed in this case?

- Arnaldo
 
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> ---
>  tools/perf/util/scripting-engines/trace-event-python.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index e55b65a..b6c1a69 100644
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
> @@ -361,6 +367,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  		retval = PyObject_CallObject(handler, t);
>  		if (retval == NULL)
>  			handler_call_die(handler_name);
> +		Py_DECREF(retval);
>  	} else {
>  		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
>  		if (handler && PyCallable_Check(handler)) {
> @@ -368,6 +375,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
>  			retval = PyObject_CallObject(handler, t);
>  			if (retval == NULL)
>  				handler_call_die("trace_unhandled");
> +			Py_DECREF(retval);
>  		}
>  		Py_DECREF(dict);
>  	}
> @@ -427,6 +435,7 @@ static void python_process_general_event(struct perf_sample *sample,
>  	retval = PyObject_CallObject(handler, t);
>  	if (retval == NULL)
>  		handler_call_die(handler_name);
> +	Py_DECREF(retval);
>  exit:
>  	Py_DECREF(dict);
>  	Py_DECREF(t);
> @@ -548,8 +557,7 @@ static int python_stop_script(void)
>  	retval = PyObject_CallObject(handler, NULL);
>  	if (retval == NULL)
>  		handler_call_die("trace_end");
> -	else
> -		Py_DECREF(retval);
> +	Py_DECREF(retval);
>  out:
>  	Py_XDECREF(main_dict);
>  	Py_XDECREF(main_module);
> -- 
> 1.8.1.2
> 
> 



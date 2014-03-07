Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaCGOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:19:06 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:41300 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaCGOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:19:04 -0500
Date: Fri, 7 Mar 2014 11:18:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Provide additional sample information to Python scripts
Message-ID: <20140307141857.GA3153@ghostprotocols.net>
References: <53031D2C.2050009@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53031D2C.2050009@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 18, 2014 at 09:43:24AM +0100, Joseph Schuchart escreveu:
> Good morning,
> 
> We have developed a patch for the perf Python scripting interface to
> provide additional information about the pid, tid, and cpu of generic
> events as well as information about the call-stack and resolved symbol
> names. This provides scripts with a greater level of detail. The
> mentioned information is already available to the scripting engine and
> just has to be handed down. This is done by the attached patch. The
> patch is based on Linux-3.13.3.
> 
> Please let me know if you have any questions on this.

Can you please resend, against the perf/core branch in
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git, and as an
attachement or making sure that the patch is not mangled?

- Arnaldo
 
> Thanks
> Joseph
> -- 
> Dipl. Inf. Joseph Schuchart
> Computer Scientist
> 
> Technische Universität Dresden
> Center for Information Services and High Performance Computing (ZIH)
> 01062 Dresden, Germany
> 
> Phone: +49 351 463-36494
> Fax: +49 351 463-3773
> E-Mail: joseph.schuchart@tu-dresden.de

> Perf: Provide sample information and call-chain to Python script
> 
> Provide additional sample information on generic events to Python 
> scripts, including pid, tid, and cpu for which the event was recorded.
> Additionally, provide the call-stack recorded at each event with 
> resolved symbols. At the moment, the pointer to the sample struct
> is passed to scripts, which seems to be of little use. The patch
> puts this information in dictionaries for easy access by Python
> scripts. 
> 
> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> 
> @@ -359,7 +359,7 @@ static void python_process_general_event
>  					 struct thread *thread,
>  					 struct addr_location *al)
>  {
> -	PyObject *handler, *retval, *t, *dict;
> +	PyObject *handler, *retval, *t, *dict, *dict_sample;
>  	static char handler_name[64];
>  	unsigned n = 0;
>  
> @@ -375,6 +375,10 @@ static void python_process_general_event
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
> @@ -384,8 +388,76 @@ static void python_process_general_event
>  	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
>  	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
>  			(const char *)&evsel->attr, sizeof(evsel->attr)));
> -	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
> -			(const char *)sample, sizeof(*sample)));
> +
> +	/* PID/TIDs are limited to 2^29, so we can safely use PyInt */
> +	pydict_set_item_string_decref(dict_sample, "pid", PyInt_FromLong(sample->pid));
> +	pydict_set_item_string_decref(dict_sample, "tid", PyInt_FromLong(sample->tid));
> +	pydict_set_item_string_decref(dict_sample, "cpu", PyInt_FromLong(sample->cpu));
> +	pydict_set_item_string_decref(dict_sample, "time", PyLong_FromUnsignedLongLong(sample->time));
> +	pydict_set_item_string_decref(dict, "sample", dict_sample);
> +
> +	/* ip unwinding */
> +
> +	if (symbol_conf.use_callchain && sample->callchain) {
> +		PyObject *pylist;
> +
> +		if (machine__resolve_callchain(machine, evsel, al->thread,
> +						   sample, NULL, NULL, PERF_MAX_STACK_DEPTH) != 0) {
> +			pr_err("Failed to resolve callchain. Skipping\n");
> +			goto exit;
> +		}
> +		callchain_cursor_commit(&callchain_cursor);
> +
> +		pylist = PyList_New(0);
> +		if (!pylist)
> +			Py_FatalError("couldn't create Python list");
> +
> +		while (1) {
> +			PyObject *pyelem;
> +			struct callchain_cursor_node *node;
> +			node = callchain_cursor_current(&callchain_cursor);
> +			if (!node)
> +				break;
> +
> +			pyelem = PyDict_New();
> +			if (!pyelem)
> +				Py_FatalError("couldn't create Python dictionary");
> +
> +
> +			pydict_set_item_string_decref(pyelem, "ip", PyInt_FromLong(node->ip));
> +
> +			if (node->sym) {
> +				PyObject *pysym  = PyDict_New();
> +				if (!pysym)
> +					Py_FatalError("couldn't create Python dictionary");
> +				pydict_set_item_string_decref(pysym, "start",   PyInt_FromLong(node->sym->start));
> +				pydict_set_item_string_decref(pysym, "end",     PyInt_FromLong(node->sym->end));
> +				pydict_set_item_string_decref(pysym, "binding", PyInt_FromLong(node->sym->binding));
> +				pydict_set_item_string_decref(pysym, "name",    PyString_FromStringAndSize(node->sym->name, node->sym->namelen));
> +				pydict_set_item_string_decref(pyelem, "sym", pysym);
> +				Py_DECREF(pysym);
> +			}
> +
> +			if (node->map) {
> +				struct map *map = node->map;
> +				const char *dsoname = "[unknown]";
> +				if (map && map->dso && (map->dso->name || map->dso->long_name)) {
> +					if (symbol_conf.show_kernel_path && map->dso->long_name)
> +						dsoname = map->dso->long_name;
> +					else if (map->dso->name)
> +						dsoname = map->dso->name;
> +				}
> +				pydict_set_item_string_decref(pyelem, "dso", PyString_FromString(dsoname));
> +			}
> +
> +			callchain_cursor_advance(&callchain_cursor);
> +			PyList_Append(pylist, pyelem);
> +			Py_DECREF(pyelem);
> +		}
> +		PyDict_SetItemString(dict, "callstack", pylist);
> +		Py_DECREF(pylist);
> +	}
> +
>  	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
>  			(const char *)sample->raw_data, sample->raw_size));
>  	pydict_set_item_string_decref(dict, "comm",
> @@ -407,6 +479,7 @@ static void python_process_general_event
>  	if (retval == NULL)
>  		handler_call_die(handler_name);
>  exit:
> +	Py_DECREF(dict_sample);
>  	Py_DECREF(dict);
>  	Py_DECREF(t);
>  }




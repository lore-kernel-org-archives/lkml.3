Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaCLPwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:52:38 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:60517 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705AbaCLPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:52:37 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 11:52:36 EDT
Message-ID: <53207D3E.4010402@tu-dresden.de>
Date: Wed, 12 Mar 2014 16:29:02 +0100
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Provide additional sample information to Python scripts
References: <53031D2C.2050009@tu-dresden.de> <20140307141857.GA3153@ghostprotocols.net>
In-Reply-To: <20140307141857.GA3153@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-07 15:18, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 18, 2014 at 09:43:24AM +0100, Joseph Schuchart escreveu:
>> Good morning,
>>
>> We have developed a patch for the perf Python scripting interface to
>> provide additional information about the pid, tid, and cpu of generic
>> events as well as information about the call-stack and resolved symbol
>> names. This provides scripts with a greater level of detail. The
>> mentioned information is already available to the scripting engine and
>> just has to be handed down. This is done by the attached patch. The
>> patch is based on Linux-3.13.3.
>>
>> Please let me know if you have any questions on this.
> 
> Can you please resend, against the perf/core branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git, and as an
> attachement or making sure that the patch is not mangled?

Joseph and I are working on this but due to vacation we expect to send
you the patch with some improvements in the beginning of April. Please
let us know in case there is some deadline.

Thanks,
Thomas

> 
> - Arnaldo
>  
>> Thanks
>> Joseph
>> -- 
>> Dipl. Inf. Joseph Schuchart
>> Computer Scientist
>>
>> Technische Universität Dresden
>> Center for Information Services and High Performance Computing (ZIH)
>> 01062 Dresden, Germany
>>
>> Phone: +49 351 463-36494
>> Fax: +49 351 463-3773
>> E-Mail: joseph.schuchart@tu-dresden.de
> 
>> Perf: Provide sample information and call-chain to Python script
>>
>> Provide additional sample information on generic events to Python 
>> scripts, including pid, tid, and cpu for which the event was recorded.
>> Additionally, provide the call-stack recorded at each event with 
>> resolved symbols. At the moment, the pointer to the sample struct
>> is passed to scripts, which seems to be of little use. The patch
>> puts this information in dictionaries for easy access by Python
>> scripts. 
>>
>> Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
>> Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
>>
>> @@ -359,7 +359,7 @@ static void python_process_general_event
>>  					 struct thread *thread,
>>  					 struct addr_location *al)
>>  {
>> -	PyObject *handler, *retval, *t, *dict;
>> +	PyObject *handler, *retval, *t, *dict, *dict_sample;
>>  	static char handler_name[64];
>>  	unsigned n = 0;
>>  
>> @@ -375,6 +375,10 @@ static void python_process_general_event
>>  	if (!dict)
>>  		Py_FatalError("couldn't create Python dictionary");
>>  
>> +	dict_sample = PyDict_New();
>> +	if (!dict_sample)
>> +		Py_FatalError("couldn't create Python dictionary");
>> +
>>  	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
>>  
>>  	handler = PyDict_GetItemString(main_dict, handler_name);
>> @@ -384,8 +388,76 @@ static void python_process_general_event
>>  	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
>>  	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
>>  			(const char *)&evsel->attr, sizeof(evsel->attr)));
>> -	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
>> -			(const char *)sample, sizeof(*sample)));
>> +
>> +	/* PID/TIDs are limited to 2^29, so we can safely use PyInt */
>> +	pydict_set_item_string_decref(dict_sample, "pid", PyInt_FromLong(sample->pid));
>> +	pydict_set_item_string_decref(dict_sample, "tid", PyInt_FromLong(sample->tid));
>> +	pydict_set_item_string_decref(dict_sample, "cpu", PyInt_FromLong(sample->cpu));
>> +	pydict_set_item_string_decref(dict_sample, "time", PyLong_FromUnsignedLongLong(sample->time));
>> +	pydict_set_item_string_decref(dict, "sample", dict_sample);
>> +
>> +	/* ip unwinding */
>> +
>> +	if (symbol_conf.use_callchain && sample->callchain) {
>> +		PyObject *pylist;
>> +
>> +		if (machine__resolve_callchain(machine, evsel, al->thread,
>> +						   sample, NULL, NULL, PERF_MAX_STACK_DEPTH) != 0) {
>> +			pr_err("Failed to resolve callchain. Skipping\n");
>> +			goto exit;
>> +		}
>> +		callchain_cursor_commit(&callchain_cursor);
>> +
>> +		pylist = PyList_New(0);
>> +		if (!pylist)
>> +			Py_FatalError("couldn't create Python list");
>> +
>> +		while (1) {
>> +			PyObject *pyelem;
>> +			struct callchain_cursor_node *node;
>> +			node = callchain_cursor_current(&callchain_cursor);
>> +			if (!node)
>> +				break;
>> +
>> +			pyelem = PyDict_New();
>> +			if (!pyelem)
>> +				Py_FatalError("couldn't create Python dictionary");
>> +
>> +
>> +			pydict_set_item_string_decref(pyelem, "ip", PyInt_FromLong(node->ip));
>> +
>> +			if (node->sym) {
>> +				PyObject *pysym  = PyDict_New();
>> +				if (!pysym)
>> +					Py_FatalError("couldn't create Python dictionary");
>> +				pydict_set_item_string_decref(pysym, "start",   PyInt_FromLong(node->sym->start));
>> +				pydict_set_item_string_decref(pysym, "end",     PyInt_FromLong(node->sym->end));
>> +				pydict_set_item_string_decref(pysym, "binding", PyInt_FromLong(node->sym->binding));
>> +				pydict_set_item_string_decref(pysym, "name",    PyString_FromStringAndSize(node->sym->name, node->sym->namelen));
>> +				pydict_set_item_string_decref(pyelem, "sym", pysym);
>> +				Py_DECREF(pysym);
>> +			}
>> +
>> +			if (node->map) {
>> +				struct map *map = node->map;
>> +				const char *dsoname = "[unknown]";
>> +				if (map && map->dso && (map->dso->name || map->dso->long_name)) {
>> +					if (symbol_conf.show_kernel_path && map->dso->long_name)
>> +						dsoname = map->dso->long_name;
>> +					else if (map->dso->name)
>> +						dsoname = map->dso->name;
>> +				}
>> +				pydict_set_item_string_decref(pyelem, "dso", PyString_FromString(dsoname));
>> +			}
>> +
>> +			callchain_cursor_advance(&callchain_cursor);
>> +			PyList_Append(pylist, pyelem);
>> +			Py_DECREF(pyelem);
>> +		}
>> +		PyDict_SetItemString(dict, "callstack", pylist);
>> +		Py_DECREF(pylist);
>> +	}
>> +
>>  	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
>>  			(const char *)sample->raw_data, sample->raw_size));
>>  	pydict_set_item_string_decref(dict, "comm",
>> @@ -407,6 +479,7 @@ static void python_process_general_event
>>  	if (retval == NULL)
>>  		handler_call_die(handler_name);
>>  exit:
>> +	Py_DECREF(dict_sample);
>>  	Py_DECREF(dict);
>>  	Py_DECREF(t);
>>  }
> 
> 
> 

-- 
Dipl. Inf. Thomas Ilsche
Computer Scientist
Highly Adaptive Energy-Efficient Computing
CRC 912 HAEC: http://tu-dresden.de/sfb912
Technische Universität Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-42168
Fax: +49 351 463-3773
E-Mail: thomas.ilsche@tu-dresden.de

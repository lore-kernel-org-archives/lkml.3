Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaIXQMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:12:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:3479 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940AbaIXQMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:12:36 -0400
Date: Wed, 24 Sep 2014 12:12:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: add helper to read kernel_stack functions
Message-ID: <20140924121234.066bd249@gandalf.local.home>
In-Reply-To: <1411574609-12129-1-git-send-email-jbacik@fb.com>
References: <1411574609-12129-1-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 12:03:29 -0400
Josef Bacik <jbacik@fb.com> wrote:

> The way the ftrace kernel_stack event is handled doesn't work right with the
> normal event reading stuff in python.  The raw buffer read stuff expects the
> size of the event to be non-zero, but in the case of kernel_stack the caller
> array is 0 and we are given a size field
> 
> 	field:int size;	offset:8;	size:4;	signed:1;
> 	field:unsigned long caller;	offset:16;	size:0;	signed:0;
> 
> This screws up python becuase it uses the size field to indicate how much of the
> memory buffer is there to read, which in this case is 0.  This makes it
> impossible to actually read the caller array from python.  So add a new c
> binding to specially read the addr array and go ahead and look up the function
> names for the addr and return those strings.  With this I can now pull the
> function names for a kernel_stack event from the python library.  Thanks,

No need to add "Thanks" to a change log ;-)

Will this still work if we convert the kernel_stack to be the same as
the other dynamic_arrays?

I'm assuming so, as there doesn't seem to be anything here that looks
specific to the kernel_stack event, and we wouldn't want to break the
other events.

I just want to make sure you are testing both formats.

Thanks,

-- Steve


> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  ctracecmd.i | 24 ++++++++++++++++++++++++
>  tracecmd.py | 11 +++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/ctracecmd.i b/ctracecmd.i
> index 3970803..c175254 100644
> --- a/ctracecmd.i
> +++ b/ctracecmd.i
> @@ -49,6 +49,30 @@ void py_pevent_register_event_handler(struct pevent *pevent, int id,
>  				      python_callback, pyfunc);
>  }
>  
> +static PyObject *py_field_get_addr_string(struct pevent *pevent,
> +					  struct pevent_record *record,
> +					  struct format_field *field,
> +					  int long_size, int index)
> +{
> +	void *data = record->data;
> +	const char *func = NULL;
> +	off_t offset = field->offset + (index * long_size);
> +	unsigned long addr;
> +
> +	if (offset + long_size > record->size) {
> +		PyErr_SetString(PyExc_IndexError,
> +				"Index is beyond beyond the range");
> +		return NULL;
> +	}
> +
> +	addr = pevent_read_number(pevent, data + offset, long_size);
> +	func = pevent_find_function(pevent, addr);
> +	if (!func)
> +		return NULL;
> +
> +	return PyString_FromStringAndSize(func, strlen(func));
> +}
> +
>  static PyObject *py_field_get_data(struct format_field *f, struct pevent_record *r)
>  {
>  	if (!strncmp(f->type, "__data_loc ", 11)) {
> diff --git a/tracecmd.py b/tracecmd.py
> index cdd619b..a43d788 100644
> --- a/tracecmd.py
> +++ b/tracecmd.py
> @@ -117,6 +117,13 @@ class Event(object, DictMixin):
>              return None
>          return py_field_get_str(f, self._record)
>  
> +    def addr_field_index(self, name, long_size, index):
> +        f = pevent_find_any_field(self._format, name)
> +        if f is None:
> +            return None
> +        return py_field_get_addr_string(self._pevent, self._record, f,
> +                                        long_size, index)
> +
>  class TraceSeq(object):
>      def __init__(self, trace_seq):
>          self._trace_seq = trace_seq
> @@ -192,6 +199,10 @@ class Trace(object):
>      def cpus(self):
>          return tracecmd_cpus(self._handle)
>  
> +    @cached_property
> +    def long_size(self):
> +        return tracecmd_long_size(self._handle)
> +
>      def read_event(self, cpu):
>          rec = tracecmd_read_data(self._handle, cpu)
>          if rec:


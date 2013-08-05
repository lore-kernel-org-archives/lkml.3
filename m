Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3HEDFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:05:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24041 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3HEDFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:05:53 -0400
Message-ID: <51FF1649.80108@huawei.com>
Date: Mon, 5 Aug 2013 11:04:41 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix wrong output of the __array field type string
References: <51F36A27.9030709@huawei.com>
In-Reply-To: <51F36A27.9030709@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/27 14:35, zhangwei(Jovi) wrote:
>  A bug was found in events/sched/sched_switch/format.
> 
> 	field:char prev_comm[32];       offset:8;       size:16;        signed:1;
> 
> and prev_comm field is defined as:
> 
> 	__array(        char,   prev_comm,      TASK_COMM_LEN   )
> 
> Note TASK_COMM_LEN is 16, but the arrary len is 32 in there.
> 
> The root cause is we use global temp buffer event_storage as
> constant type string in trace_define_field function when
> define __array field, this will make old field type string
> flushed by new string in event_storage.
> 
> In this patch, type string is checked by core_kernel_data firstly,
> if it's not core kernel data, then copy the storage.
> 
> This patch also kill the global storage event_storage.
> 
> events/sched/sched_switch/format changed after patch:
> 
> 	field:char prev_comm[16];       offset:8;       size:16;        signed:1;
> 

Ping...


> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  include/linux/ftrace_event.h |    2 --
>  include/trace/ftrace.h       |    4 ++--
>  kernel/trace/trace_events.c  |   20 +++++++++++++-------
>  kernel/trace/trace_export.c  |    4 ++--
>  4 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4372658..bd91f0e 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -324,8 +324,6 @@ enum {
>  };
> 
>  #define EVENT_STORAGE_SIZE 128
> -extern struct mutex event_storage_mutex;
> -extern char event_storage[EVENT_STORAGE_SIZE];
> 
>  extern int trace_event_raw_init(struct ftrace_event_call *call);
>  extern int trace_define_field(struct ftrace_event_call *call, const char *type,
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index d615f78..c8bd295 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -303,7 +303,8 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
>  #undef __array
>  #define __array(type, item, len)					\
>  	do {								\
> -		mutex_lock(&event_storage_mutex);			\
> +		char event_storage[EVENT_STORAGE_SIZE];			\
> +									\
>  		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
>  		snprintf(event_storage, sizeof(event_storage),		\
>  			 "%s[%d]", #type, len);				\
> @@ -311,7 +312,6 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
>  				 offsetof(typeof(field), item),		\
>  				 sizeof(field.item),			\
>  				 is_signed_type(type), FILTER_OTHER);	\
> -		mutex_unlock(&event_storage_mutex);			\
>  		if (ret)						\
>  			return ret;					\
>  	} while (0);
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 5f694ce..5827287 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -27,12 +27,6 @@
> 
>  DEFINE_MUTEX(event_mutex);
> 
> -DEFINE_MUTEX(event_storage_mutex);
> -EXPORT_SYMBOL_GPL(event_storage_mutex);
> -
> -char event_storage[EVENT_STORAGE_SIZE];
> -EXPORT_SYMBOL_GPL(event_storage);
> -
>  LIST_HEAD(ftrace_events);
>  static LIST_HEAD(ftrace_common_fields);
> 
> @@ -100,7 +94,15 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  		goto err;
> 
>  	field->name = name;
> -	field->type = type;
> +
> +	/* for __array field, type is not a constant string */
> +	if (!core_kernel_data((unsigned long)type)) {
> +		field->type = kstrdup(type, GFP_KERNEL);
> +		if (!field->type)
> +			goto err;
> +	} else {
> +		field->type = type;
> +	}
> 
>  	if (filter_type == FILTER_OTHER)
>  		field->filter_type = filter_assign_type(type);
> @@ -166,6 +168,10 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
>  	head = trace_get_fields(call);
>  	list_for_each_entry_safe(field, next, head, link) {
>  		list_del(&field->link);
> +
> +		if (!core_kernel_data((unsigned long)field->type))
> +			kfree(field->type);
> +
>  		kmem_cache_free(field_cachep, field);
>  	}
>  }
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index d21a746..490eb32 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -95,15 +95,15 @@ static void __always_unused ____ftrace_check_##name(void)		\
>  #undef __array
>  #define __array(type, item, len)					\
>  	do {								\
> +		char event_storage[EVENT_STORAGE_SIZE];			\
> +									\
>  		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
> -		mutex_lock(&event_storage_mutex);			\
>  		snprintf(event_storage, sizeof(event_storage),		\
>  			 "%s[%d]", #type, len);				\
>  		ret = trace_define_field(event_call, event_storage, #item, \
>  				 offsetof(typeof(field), item),		\
>  				 sizeof(field.item),			\
>  				 is_signed_type(type), filter_type);	\
> -		mutex_unlock(&event_storage_mutex);			\
>  		if (ret)						\
>  			return ret;					\
>  	} while (0);
> 



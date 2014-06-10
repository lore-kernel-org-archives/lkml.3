Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaFJVAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:00:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65227 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753152AbaFJVAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:00:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: todd.e.brandt@linux.intel.com
Cc: rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: trace events for device pm callbacks
Date: Tue, 10 Jun 2014 23:17:46 +0200
Message-ID: <3737184.526pO4COlv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140610143122.GA12851@linux.intel.com>
References: <20140610143122.GA12851@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 07:31:22 AM Todd E Brandt wrote:
> Adds two trace events which supply the same info that initcall_debug 
> provides, but via ftrace instead of dmesg. The existing initcall_debug
> calls require the pm_print_times_enabled var to be set (either via
> sysfs or via the kernel cmd line). The new trace events provide all the
> same info as the initcall_debug prints but with less overhead, and also
> with coverage of device prepare and complete device callbacks.
> 
> These events replace the device_pm_report_time event (which has been
> removed). device_pm_callback_start is called first and provides the device
> and callback info. device_pm_callback_end is called after with the
> device name and error info. The time and pid are gathered from the trace
> data headers.
> 
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>

Steve needs to see this (CCed).

> ----
>  drivers/base/power/main.c    | 14 ++++++++++----
>  include/trace/events/power.h | 60 ++++++++++++++++++++++++++++++++++++++++++------------------
>  2 files changed, 52 insertions(+), 22 deletions(-)
> 
> Raphael, I know we discussed this a while back as an alternative to
> the initcall_debug calls so as to reduce the dmesg traffic. Do you want
> to completely remove the pm_print_times_enabled option and initcall_debug
> calls?

Yes, eventually, but not immediately.  Perhaps around two cycles after merging
the trace points.

> Also, I applied this patch to the bleeding-edge branch of your linux-pm
> tree.
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index de3fe4f..bf41296 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -214,9 +214,6 @@ static void initcall_debug_report(struct device *dev, ktime_t calltime,
>  		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
>  			error, (unsigned long long)nsecs >> 10);
>  	}
> -
> -	trace_device_pm_report_time(dev, info, nsecs, pm_verb(state.event),
> -				    error);
>  }
>  
>  /**
> @@ -387,7 +384,9 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>  	calltime = initcall_debug_start(dev);
>  
>  	pm_dev_dbg(dev, state, info);
> +	trace_device_pm_callback_start(dev, info, state.event);
>  	error = cb(dev);
> +	trace_device_pm_callback_end(dev, error);
>  	suspend_report_result(cb, error);
>  
>  	initcall_debug_report(dev, calltime, error, state, info);
> @@ -919,7 +918,9 @@ static void device_complete(struct device *dev, pm_message_t state)
>  
>  	if (callback) {
>  		pm_dev_dbg(dev, state, info);
> +		trace_device_pm_callback_start(dev, info, state.event);
>  		callback(dev);
> +		trace_device_pm_callback_end(dev, 0);
>  	}
>  
>  	device_unlock(dev);
> @@ -1307,7 +1308,9 @@ static int legacy_suspend(struct device *dev, pm_message_t state,
>  
>  	calltime = initcall_debug_start(dev);
>  
> +	trace_device_pm_callback_start(dev, info, state.event);
>  	error = cb(dev, state);
> +	trace_device_pm_callback_end(dev, error);
>  	suspend_report_result(cb, error);
>  
>  	initcall_debug_report(dev, calltime, error, state, info);
> @@ -1563,8 +1566,11 @@ static int device_prepare(struct device *dev, pm_message_t state)
>  		callback = dev->driver->pm->prepare;
>  	}
>  
> -	if (callback)
> +	if (callback) {
> +		trace_device_pm_callback_start(dev, info, state.event);
>  		ret = callback(dev);
> +		trace_device_pm_callback_end(dev, ret);
> +	}
>  
>  	device_unlock(dev);
>  
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index f88c857..d19840b 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -93,6 +93,17 @@ TRACE_EVENT(pstate_sample,
>  #define PWR_EVENT_EXIT -1
>  #endif
>  
> +#define pm_verb_symbolic(event) \
> +	__print_symbolic(event, \
> +		{ PM_EVENT_SUSPEND, "suspend" }, \
> +		{ PM_EVENT_RESUME, "resume" }, \
> +		{ PM_EVENT_FREEZE, "freeze" }, \
> +		{ PM_EVENT_QUIESCE, "quiesce" }, \
> +		{ PM_EVENT_HIBERNATE, "hibernate" }, \
> +		{ PM_EVENT_THAW, "thaw" }, \
> +		{ PM_EVENT_RESTORE, "restore" }, \
> +		{ PM_EVENT_RECOVER, "recover" })
> +
>  DEFINE_EVENT(cpu, cpu_frequency,
>  
>  	TP_PROTO(unsigned int frequency, unsigned int cpu_id),
> @@ -100,41 +111,54 @@ DEFINE_EVENT(cpu, cpu_frequency,
>  	TP_ARGS(frequency, cpu_id)
>  );
>  
> -TRACE_EVENT(device_pm_report_time,
> +TRACE_EVENT(device_pm_callback_start,
>  
> -	TP_PROTO(struct device *dev, const char *pm_ops, s64 ops_time,
> -		 char *pm_event_str, int error),
> +	TP_PROTO(struct device *dev, const char *pm_ops, int event),
>  
> -	TP_ARGS(dev, pm_ops, ops_time, pm_event_str, error),
> +	TP_ARGS(dev, pm_ops, event),
>  
>  	TP_STRUCT__entry(
>  		__string(device, dev_name(dev))
>  		__string(driver, dev_driver_string(dev))
>  		__string(parent, dev->parent ? dev_name(dev->parent) : "none")
>  		__string(pm_ops, pm_ops ? pm_ops : "none ")
> -		__string(pm_event_str, pm_event_str)
> -		__field(s64, ops_time)
> -		__field(int, error)
> +		__field(int, event)
>  	),
>  
>  	TP_fast_assign(
> -		const char *tmp = dev->parent ? dev_name(dev->parent) : "none";
> -		const char *tmp_i = pm_ops ? pm_ops : "none ";
> +		__assign_str(device, dev_name(dev));
> +		__assign_str(driver, dev_driver_string(dev));
> +		__assign_str(parent,
> +			dev->parent ? dev_name(dev->parent) : "none");
> +		__assign_str(pm_ops, pm_ops ? pm_ops : "none ");
> +		__entry->event = event;
> +	),
> +
> +	TP_printk("%s %s, parent: %s, %s[%s]", __get_str(driver),
> +		__get_str(device), __get_str(parent), __get_str(pm_ops),
> +		pm_verb_symbolic(__entry->event))
> +);
> +
> +TRACE_EVENT(device_pm_callback_end,
> +
> +	TP_PROTO(struct device *dev, int error),
>  
> +	TP_ARGS(dev, error),
> +
> +	TP_STRUCT__entry(
> +		__string(device, dev_name(dev))
> +		__string(driver, dev_driver_string(dev))
> +		__field(int, error)
> +	),
> +
> +	TP_fast_assign(
>  		__assign_str(device, dev_name(dev));
>  		__assign_str(driver, dev_driver_string(dev));
> -		__assign_str(parent, tmp);
> -		__assign_str(pm_ops, tmp_i);
> -		__assign_str(pm_event_str, pm_event_str);
> -		__entry->ops_time = ops_time;
>  		__entry->error = error;
>  	),
>  
> -	/* ops_str has an extra space at the end */
> -	TP_printk("%s %s parent=%s state=%s ops=%snsecs=%lld err=%d",
> -		__get_str(driver), __get_str(device), __get_str(parent),
> -		__get_str(pm_event_str), __get_str(pm_ops),
> -		__entry->ops_time, __entry->error)
> +	TP_printk("%s %s, err=%d",
> +		__get_str(driver), __get_str(device), __entry->error)
>  );
>  
>  TRACE_EVENT(suspend_resume,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

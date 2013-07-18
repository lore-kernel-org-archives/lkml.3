Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab3GRTtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:49:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3GRTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:49:21 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7ung_RA9bd8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BRhfnD90nwUA:10 a=hD80L64hAAAA:8 a=cxyyhLXqLLKNGT3qzMgA:9 a=QEXdDO2ut3YA:10 a=v3rLFGiuRE8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374176956.6458.265.camel@gandalf.local.home>
Subject: Re: [PATCH v4] power: new trace event to print device suspend and
 resume time
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, gregkh@linuxfoundation.org,
        fweisbec@gmail.com, mingo@redhat.com, paul.gortmaker@windriver.com,
        joe@perches.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Thu, 18 Jul 2013 15:49:16 -0400
In-Reply-To: <1374175349-3435-1-git-send-email-shuah.kh@samsung.com>
References: <1374175349-3435-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 13:22 -0600, Shuah Khan wrote:
> A new trace event is added to pm events to print time it takes to suspend and
> resume a device. It generates trace message that includes device, driver,
> parent information in addition to the type of pm ops invoked as well as the
> pm event and error status from the pm ops. Example trace below:
> 
> bash-2239  [000] ....   290.883035: device_pm_report_time: backlight
>  acpi_video0 parent=0000:00:02.0 state=freeze ops=class nsecs=332 err=0
> bash-2239  [000] ....   290.883041: device_pm_report_time: rfkill rf
> kill3 parent=phy0 state=freeze ops=legacy class nsecs=216 err=0
> bash-2239  [001] ....   290.973892: device_pm_report_time: ieee80211
>  phy0 parent=0000:01:00.0 state=freeze ops=legacy class nsecs=90846477 err=0
> 
> bash-2239  [001] ....   293.660129: device_pm_report_time: ieee80211 phy0 parent=0000:01:00.0 state=restore ops=legacy class nsecs=101295162 err=0
> bash-2239  [001] ....   293.660147: device_pm_report_time: rfkill rfkill3 parent=phy0 state=restore ops=legacy class nsecs=1804 err=0
> bash-2239  [001] ....   293.660157: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class nsecs=757 err=0
> 

I think I'm the thorn in your side.

> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/power/main.c    |   33 +++++++++++++++++++++++----------
>  include/trace/events/power.h |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 5a9b656..e7401c6 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -28,6 +28,7 @@
>  #include <linux/sched.h>
>  #include <linux/async.h>
>  #include <linux/suspend.h>
> +#include <trace/events/power.h>
>  #include <linux/cpuidle.h>
>  #include "../base.h"
>  #include "power.h"
> @@ -56,6 +57,8 @@ static pm_message_t pm_transition;
>  
>  static int async_error;
>  
> +static char *pm_verb(int);
> +
>  /**
>   * device_pm_sleep_init - Initialize system suspend-related device fields.
>   * @dev: Device object being initialized.
> @@ -172,16 +175,23 @@ static ktime_t initcall_debug_start(struct device *dev)
>  }
>  
>  static void initcall_debug_report(struct device *dev, ktime_t calltime,
> -				  int error)
> +				  int error, pm_message_t state, char *info)
>  {
> -	ktime_t delta, rettime;
> +	ktime_t rettime;
> +	s64 nsecs;
> +
> +	rettime = ktime_get();
> +	nsecs = (s64) ktime_to_ns(ktime_sub(rettime, calltime));

You still are calling this from the fast path. Why not put the
conversion into TP_printk()? Or is this just called once in a while and
you don't really care?

>  
>  	if (pm_print_times_enabled) {
> -		rettime = ktime_get();
> -		delta = ktime_sub(rettime, calltime);
>  		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
> -			error, (unsigned long long)ktime_to_ns(delta) >> 10);
> +			error, (unsigned long long)nsecs >> 10);
>  	}
> +
> +	trace_device_pm_report_time(dev_name(dev), dev_driver_string(dev),
> +				dev->parent ? dev_name(dev->parent) : "none",
> +				info ? info : "none ",
> +				nsecs, pm_verb(state.event), error);

I'd like to see this disassembled.

The tracepoints use jump-labels which is basically a code modification
of a branch.


   [ code ]
   nop
back:
   [ code ]
   return;

tracepoint:
   [ tracepoint code ]
   jmp back;


And when we enable the tracepoint, the code is modified to be:

  [ code ]
  jmp tracepoint
  [ code ]

tracepoint:
  [ tracepoint code ]
  jmp back;

Cool, eh?

But we sometimes have seen gcc getting confused it its optimization, and
process some of the work of the tracepoint parameters in the [ code ]
part, which is bad, because that's just overhead even when the
tracepoint is disabled.

Thus, it's usually better to do as much work in the TRACE_EVENT() macro
as possible. In otherwords:

	trace_device_pm_report_time(dev, info, nsecs,
		 pm_verb(state.event), error);

And in the TP_fast_assign, have:

	TP_fast_assign(
		char *tmp_dev = dev->parent ? dev_name(dev->parent) : "none";
		char *tmp_info = info ? info : "none ";

		__assign_str(tmp_dev, parent);
		__assign_str(tmp_info, info);
		[...]

Of course, that's only if gcc screws this up. And if this is just called
at boot up only a hand full of times, it may not be worth the trouble.

I just happen to be in a micro optimization mood.

-- Steve



>  }
>  
>  /**
> @@ -379,7 +389,7 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>  	error = cb(dev);
>  	suspend_report_result(cb, error);
>  
> -	initcall_debug_report(dev, calltime, error);
> +	initcall_debug_report(dev, calltime, error, state, info);
>  
>  	return error;
>  }
> @@ -1027,7 +1037,8 @@ EXPORT_SYMBOL_GPL(dpm_suspend_end);
>   * @cb: Suspend callback to execute.
>   */
>  static int legacy_suspend(struct device *dev, pm_message_t state,
> -			  int (*cb)(struct device *dev, pm_message_t state))
> +			  int (*cb)(struct device *dev, pm_message_t state),
> +			  char *info)
>  {
>  	int error;
>  	ktime_t calltime;
> @@ -1037,7 +1048,7 @@ static int legacy_suspend(struct device *dev, pm_message_t state,
>  	error = cb(dev, state);
>  	suspend_report_result(cb, error);
>  
> -	initcall_debug_report(dev, calltime, error);
> +	initcall_debug_report(dev, calltime, error, state, info);
>  
>  	return error;
>  }
> @@ -1097,7 +1108,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  			goto Run;
>  		} else if (dev->class->suspend) {
>  			pm_dev_dbg(dev, state, "legacy class ");
> -			error = legacy_suspend(dev, state, dev->class->suspend);
> +			error = legacy_suspend(dev, state, dev->class->suspend,
> +						"legacy class ");
>  			goto End;
>  		}
>  	}
> @@ -1108,7 +1120,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  			callback = pm_op(dev->bus->pm, state);
>  		} else if (dev->bus->suspend) {
>  			pm_dev_dbg(dev, state, "legacy bus ");
> -			error = legacy_suspend(dev, state, dev->bus->suspend);
> +			error = legacy_suspend(dev, state, dev->bus->suspend,
> +						"legacy bus ");
>  			goto End;
>  		}
>  	}
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index 8e42410..24afd22 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -66,6 +66,41 @@ TRACE_EVENT(machine_suspend,
>  	TP_printk("state=%lu", (unsigned long)__entry->state)
>  );
>  
> +TRACE_EVENT(device_pm_report_time,
> +
> +	TP_PROTO(const char *device, const char *driver, const char *parent,
> +		 const char *pm_ops, s64 ops_time, char *pm_event_str,
> +		 int error),
> +
> +	TP_ARGS(device, driver, parent, pm_ops, ops_time, pm_event_str, error),
> +
> +	TP_STRUCT__entry(
> +		__string(device, device)
> +		__string(driver, driver)
> +		__string(parent, parent)
> +		__string(pm_ops, pm_ops)
> +		__string(pm_event_str, pm_event_str)
> +		__field(s64, ops_time)
> +		__field(int, error)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(device, device);
> +		__assign_str(driver, driver);
> +		__assign_str(parent, parent);
> +		__assign_str(pm_ops, pm_ops);
> +		__assign_str(pm_event_str, pm_event_str);
> +		__entry->ops_time = ops_time;
> +		__entry->error = error;
> +	),
> +
> +	/* ops_str has an extra space at the end */
> +	TP_printk("%s %s parent=%s state=%s ops=%snsecs=%lld err=%d",
> +		__get_str(driver), __get_str(device), __get_str(parent),
> +		__get_str(pm_event_str), __get_str(pm_ops),
> +		__entry->ops_time, __entry->error)
> +);
> +
>  DECLARE_EVENT_CLASS(wakeup_source,
>  
>  	TP_PROTO(const char *name, unsigned int state),



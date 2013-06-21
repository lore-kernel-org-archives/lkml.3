Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965791Ab3FUMMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:12:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55177 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701Ab3FUMMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:12:54 -0400
Message-ID: <51C44342.7050904@hitachi.com>
Date: Fri, 21 Jun 2013 21:12:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] tracing: add basic event trigger framework
References: <cover.1371751701.git.tom.zanussi@linux.intel.com> <920295ddd25d36c03d809e49f6d39033b1a76dae.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <920295ddd25d36c03d809e49f6d39033b1a76dae.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:31), Tom Zanussi wrote:
> The event trigger functionality is built on top of SOFT_DISABLE
> functionality.  It adds a TRIGGER_MODE bit to the ftrace_event_file
> flags which is checked when any trace event fires.  Triggers set for a
> particular event need to be checked regardless of whether that event
> is actually enabled or not - getting an event to fire even if it's not
> enabled is essentially what's already implemented by SOFT_DISABLE
> mode, so trigger mode directly reuses that.  It essentially inherits
> the soft disable logic in __ftrace_event_enable_disable() while adding
> a bit of logic and trigger reference counting via tm_ref on top of
> that.  Because the enable_disable code needs to now be invoked from
> outside trace_events.c, a wrapper is also added for those usages.

Agreed, but I think the implementation looks not enough.
You implemented it directly in __ftrace_event_enable_disable(),
but I think it should be wrapped with other function, something
like ftrace_event_trigger_enable_disable(), and don't touch
__ftrce_event_enable_disable().

[..]
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index f9738dc..1fc1602 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -242,7 +242,8 @@ void trace_event_enable_cmd_record(bool enable)
>  }
>  
>  static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
> -					 int enable, int soft_disable)
> +					 int enable, int soft_disable,
> +					 int trigger_enable)

Here, you added trigger_enable, but the code implies this flag must
be set exclusively with soft_disable.

>  {
>  	struct ftrace_event_call *call = file->event_call;
>  	int ret = 0;
> @@ -263,7 +264,13 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  		 * we do nothing. Do not disable the tracepoint, otherwise
>  		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
>  		 */
> -		if (soft_disable) {
> +		if (trigger_enable) {
> +			if (atomic_dec_return(&file->tm_ref) > 0)
> +				break;
> +			clear_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
> +			ret = __ftrace_event_enable_disable(file, enable, 1, 0);
> +			break;

Why break here? If all triggers are gone, and no other user is on this event,
this event should be disabled hardly.

> +		} else if (soft_disable) {
>  			if (atomic_dec_return(&file->sm_ref) > 0)
>  				break;
>  			disable = file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
> @@ -279,7 +286,7 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  			}
>  			call->class->reg(call, TRACE_REG_UNREGISTER, file);
>  		}
> -		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
> +		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */

This part should be merged with previous patch (which I doubted...).

>  		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
>  			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
>  		else
> @@ -294,7 +301,13 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  		 * set SOFT_DISABLED before enabling the event tracepoint, so
>  		 * it still seems to be disabled.
>  		 */
> -		if (!soft_disable)
> +		if (trigger_enable) {
> +			if (atomic_inc_return(&file->tm_ref) > 1)
> +				break;
> +			set_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
> +			ret = __ftrace_event_enable_disable(file, enable, 1, 0);

Hmm, if you do this, you can simply do as below :)

int ftrace_event_trigger_enable_disable(file, enable)
{
	if (enable) {
		atomic-count-up-and-return-if-its-not-first-one
		set_bit(TRIGGER_MODE)
		__ftrace_event_enable_disable(file, 1, 1);
	} else {
		atomic-count-down-and-return-if-its-not-last-one
		clear_bit(TRIGGER_MODE)
		__ftrace_event_enable_disable(file, 0, 1);
	}
}

[OffTopic] BTW, I think current the 3rd argument name "soft_disable" is
a bit confused, it actually means "control event in soft-mode". Even if the
event is enabled, __ftrace_event_enable_disable(file, 0, 1) doesn't disable
it, but just removes soft-mode bit.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



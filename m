Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3GYIc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:32:28 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4957 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3GYIcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:32:21 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51F0E288.80501@broadcom.com>
Date: Thu, 25 Jul 2013 10:32:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>
Subject: Re: regression 3.11-rc1: rmmod hangs after tracing module
References: <51EEC646.7070306@broadcom.com>
 <1374605077.3356.128.camel@gandalf.local.home>
In-Reply-To: <1374605077.3356.128.camel@gandalf.local.home>
X-WSS-ID: 7DEE3FC92L851964710-02-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:44 PM, Steven Rostedt wrote:
> On Tue, 2013-07-23 at 20:07 +0200, Arend van Spriel wrote:
>> Hi Steven,
>>
>> During testing of our brcmfmac wireless driver I had a trace-cmd running
>> along (trace-cmd record -e brcmfmac:*). After the test I stopped the
>> trace, unplugged my usb device and did a rmmod resulting in the attached
>> lockdep splat. Hope you have an idea what is going wrong here.
>
> Thanks for the report!
>
> Does this fix you bug?

Thanks Steve,

Tested your patch and it indeed fixes my deadlock.

Regards,
Arend

> -- Steve
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 69cba47..882ec1d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1224,18 +1224,17 @@ void tracing_reset_current(int cpu)
>   	tracing_reset(&global_trace.trace_buffer, cpu);
>   }
>
> +/* Must have trace_types_lock held */
>   void tracing_reset_all_online_cpus(void)
>   {
>   	struct trace_array *tr;
>
> -	mutex_lock(&trace_types_lock);
>   	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
>   		tracing_reset_online_cpus(&tr->trace_buffer);
>   #ifdef CONFIG_TRACER_MAX_TRACE
>   		tracing_reset_online_cpus(&tr->max_buffer);
>   #endif
>   	}
> -	mutex_unlock(&trace_types_lock);
>   }
>
>   #define SAVED_CMDLINES 128
>
>
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab3GPWRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:17:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35061 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933295Ab3GPWRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:17:01 -0400
Message-ID: <1374013019.1949.52.camel@joe-AO722>
Subject: Re: [PATCH] power: new trace event to print device suspend and
 resume time
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Tue, 16 Jul 2013 15:16:59 -0700
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6173C1B6@sisaex02sj>
References: <1374009806-11823-1-git-send-email-shuah.kh@samsung.com>
	 <1374010741.1949.46.camel@joe-AO722>
	 <B8EFE96D1287C24090BAD9D858E15E6173C1B6@sisaex02sj>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 22:04 +0000, Shuah Khan wrote:
> On 07/16/2013 03:39 PM, Joe Perches wrote:
> > On Tue, 2013-07-16 at 15:23 -0600, Shuah Khan wrote:
> >> A new trace event is added to pm events to print time it takes to suspend and
> >> resume a device. It generates trace message that includes device, driver,
> >> parent information in addition to the type of pm ops invoked as well as the
> >> pm event and error status from the pm ops. Example trace below:
> >
> >> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> > []
> >> @@ -66,6 +66,41 @@ TRACE_EVENT(machine_suspend,
> >>   	TP_printk("state=%lu", (unsigned long)__entry->state)
> >>   );
> >>
> >> +TRACE_EVENT(device_pm_report_time,
> >> +
> >> +	TP_PROTO(const char *device, const char *driver, const char *parent,
> >> +		 const char *pm_ops, ktime_t ops_time, char *pm_event_str,
> >> +		 int error),
> >> +
> >> +	TP_ARGS(device, driver, parent, pm_ops, ops_time, pm_event_str, error),
> >> +
> >> +	TP_STRUCT__entry(
> >> +		__string(device, device)
> >> +		__string(driver, driver)
> >> +		__string(parent, parent)
> >> +		__string(pm_ops, pm_ops)
> >> +		__string(pm_event_str, pm_event_str)
> >> +		__field(unsigned long long, ops_time)
> >
> > s64
> 
> Followed the ktime_t example in include/trace/events/timer.h - thinking 
> it would be the correct way to cast ktime_t :)  I can change it to s64.

You mean this one below where s64 is used for the
variable type?

I do think the %llu is odd below here and it should be
%lld without the casts.

I prefer the TP_printk style of "foo=val" over "foo(val)"
but there's no requirement for one style over another.

c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 166)   TP_STRUCT__entry(
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 167)           __field( void *,        hrtimer         )
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 168)           __field( void *,        function        )
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 169)           __field( s64,           expires         )
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 170)           __field( s64,           softexpires     )
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 171)   ),
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 172) 
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 173)   TP_fast_assign(
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 174)           __entry->hrtimer        = hrtimer;
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 175)           __entry->function       = hrtimer->function;
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 176)           __entry->expires        = hrtimer_get_expires(hrtimer).tv64;
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 177)           __entry->softexpires    = hrtimer_get_softexpires(hrtimer).tv64;
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 178)   ),
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 179) 
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 180)   TP_printk("hrtimer=%p function=%pf expires=%llu softexpires=%llu",
434a83c3f (Ingo Molnar         2009-10-15 11:50:39 +0200 181)             __entry->hrtimer, __entry->function,
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 182)             (unsigned long long)ktime_to_ns((ktime_t) {
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 183)                             .tv64 = __entry->expires }),
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 184)             (unsigned long long)ktime_to_ns((ktime_t) {
c6a2a1770 (Xiao Guangrong      2009-08-10 10:51:23 +0800 185)                             .tv64 = __entry->softexpires }))



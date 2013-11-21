Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3KUC1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:27:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754314Ab3KUC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:27:06 -0500
Date: Wed, 20 Nov 2013 21:26:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: shuah.kh@samsung.com
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, anton@enomsg.org, dwmw2@infradead.org,
        fweisbec@gmail.com, mingo@redhat.com, keun-o.park@windriver.com,
        paul.gortmaker@windriver.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] PM: Fix Oops from NULL pointer dereference in
 wakeup_source_activate
Message-ID: <20131120212656.1df4515e@gandalf.local.home>
In-Reply-To: <528D6972.9010702@samsung.com>
References: <cover.1384990612.git.shuah.kh@samsung.com>
	<43b305b56bbbfc82b2684919e2d1ba2bd50fecae.1384990612.git.shuah.kh@samsung.com>
	<528D6972.9010702@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 19:01:22 -0700
Shuah Khan <shuah.kh@samsung.com> wrote:

> On 11/20/2013 06:40 PM, Shuah Khan wrote:

> > ---
> >   include/trace/events/power.h | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> > index cda100d..5ba545a 100644
> > --- a/include/trace/events/power.h
> > +++ b/include/trace/events/power.h
> > @@ -110,12 +110,14 @@ DECLARE_EVENT_CLASS(wakeup_source,
> >   	TP_ARGS(name, state),
> >
> >   	TP_STRUCT__entry(
> > -		__string(       name,           name            )
> > +		__string(name,  name ? name : "(no name)")
> >   		__field(        u64,            state           )
> >   	),
> >
> >   	TP_fast_assign(
> > -		__assign_str(name, name);
> > +		const char *tname = name ? name : "(no name)";
> > +
> > +		__assign_str(name, tname);
> >   		__entry->state = state;
> >   	),
> >
> >
> 
> Adding tracing maintainers.

Thanks!

This is one solution, but what about just making the tracing facility a
bit more robust for everyone. Following what glibc printf() does when
it is passed a NULL, does this patch fix it too?

-- Steve

(haven't even compile tested this)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 52594b2..bdac88c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -372,7 +372,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
+#define __string(item, src) __dynamic_array(char, item,			\
+				    strlen((src) ? (src) : "(null)") + 1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -501,7 +502,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-	strcpy(__get_str(dst), src);
+	strcpy(__get_str(dst), (src) ? (src) : "(null)");
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args


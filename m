Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3KWJPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:15:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20395 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750719Ab3KWJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:15:12 -0500
Date: Sat, 23 Nov 2013 04:15:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 07/22] tools lib traceevent: Add kvm plugin
Message-ID: <20131123041508.7a37b164@gandalf.local.home>
In-Reply-To: <1385131524.1747.50.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-8-git-send-email-jolsa@redhat.com>
	<1385131524.1747.50.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 23:45:24 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> > +	pevent_print_num_field(s, " root %u ",  event,
> > +			       "root_count", record, 1);
> > +
> > +	if (pevent_get_field_val(s, event, "unsync", record, &val, 1) < 0)
> > +		return -1;
> 
> Hmm.. it seems this returning from the middle of function can make
> output hard to parse.  How about printing 'unknown' if the field not
> found?

I wasn't fully correct in my last email. If the handler returns
anything but zero, the TP_print() will go in affect. Thus, if this
fails, then the default print will happen anyway.

It shouldn't fail. But yeah, we could think of adding "unknow" and such
too. That can go as a separate patch.

> 
> > +
> > +	trace_seq_printf(s, "%s%c",  val ? "unsync" : "sync", 0);
> 
> Why did you print %c (0) at the end?

I simulated exactly what was (and still is) in the kvm tracepoint:

arch/x86/kvm/mmutrace.h:

        trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s"               \
                         " %snxe root %u %s%c",                         \
                         __entry->gfn, role.level,                      \
                         role.cr4_pae ? " pae" : "",                    \
                         role.quadrant,                                 \
                         role.direct ? " direct" : "",                  \
                         access_str[role.access],                       \
                         role.invalid ? " invalid" : "",                \
                         role.nxe ? "" : "!",                           \
                         __entry->root_count,                           \
                         __entry->unsync ? "unsync" : "sync", 0);	\


-- Steve

> 
> Thanks,
> Namhyung
> 
> 
> > +	return 0;
> > +}
> 


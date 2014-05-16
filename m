Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaEPTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:02:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:30337 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932378AbaEPTCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:02:19 -0400
Date: Fri, 16 May 2014 15:02:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Shy Shuky <rousya@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>,
        "xiexiuqi@huawei.com" <xiexiuqi@huawei.com>
Subject: Re: [PATCH] time: Provide full featured jiffies_to_nsecs() function
Message-ID: <20140516150210.0ae55bcd@gandalf.local.home>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3280B567@ORSMSX114.amr.corp.intel.com>
References: <20140408153412.0648fb96@gandalf.local.home>
	<0286550@agluck-desk.sc.intel.com>
	<CAAhUcTTDQPZAC+Xg3u-KQvBwGX=B9HU5dnCjC7AJcUTDY2QLpw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3280B567@ORSMSX114.amr.corp.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 17:17:46 +0000
"Luck, Tony" <tony.luck@intel.com> wrote:

> Is this function safe to call in every context (including NMI & machine check)?
> [it uses read_seqcount_begin/read_seqcount_retry ... which I *think* is
> safe ... but this stuff is tricky, so I'd like some reassurance].

No, read_seqcount_begin() is not safe in NMI context. If it interrupts
a write, it goes into an infinite spin (see __read_seqcount_begin()).

> 
> Mauro, Steven: Did we just do math on jiffies because we wanted less overhead
> in a tracepoint?

As I meantioned. read_seqcount_begin() is not safe for tracing, it
had to be reimplemented.

-- Steve

> 
> Bigger question (mostly for Mauro) ... what was the motivation for the "uptime"
> tracer to begin with?  The rasdaemon code that is using it converts the times
> from traces into absolute times (by adding an offset it computes by comparing
> uptime and gettimeofday() when it starts).  But this would seem to be fraught
> with problems:
> 1) Do we get this right for events that happen in daylight saving time shift windows?
> 2) Is there a "drift" problem for systems that stay up for months and rely on ntp
> to keep wall clock time in line with reality?
> 
> -Tony


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaILQTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:19:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:54924 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaILQTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:19:40 -0400
Date: Fri, 12 Sep 2014 13:19:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Message-ID: <20140912161934.GJ1801@kernel.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
 <5412EA7A.9020807@codeaurora.org>
 <1410526672.16936.52.camel@hornet>
 <20140912134910.GG1801@kernel.org>
 <1410530335.16936.60.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410530335.16936.60.camel@hornet>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 02:58:55PM +0100, Pawel Moll escreveu:
> On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wrote:
> > Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
> > then there is a string right after it?
 
> How would this look like in userspace? Something like this?
 
> 8<----
> struct perf_event_marker {
> 	uint64_t value;
> 	char *string;
> } arg;
 
> arg.value = 0x1234;
 
> /* or */
 
> arg.value = 0;
> arg.string = "abcd";
 
> ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
> 8<----
 
> If so, maybe it would simpler just to go for classic size/data
> structure?
 
> 8<-----
> struct perf_event_marker {
> 	uint32_t size;
> 	void *data;
> }
> 8<-----
 
> This would directly map into struct perf_raw_record...

I can see the usefulness of having it all, i.e. if we do just:

perf trace --pid `pidof some-tool-in-debug-mode-using-this-interface`

Then 'perf trace' doesn't know about any binary format a tool may have,
getting strings there (hey, LD_PRELOADing some logging library to hook
into this comes to mind) and having it merged with other events
(syscalls, pagefaults, etc) looks useful.

As well as some specialized version of 'perf trace' that knows about
some binary protocol that would get app specific stats or lock status,
etc, perhaps even plugins for 'perf trace' that would be selected by
that first u64? Also seems useful.

I.e. having a way to provide just strings and another that would allow
passing perf_raw_record.

- Arnaldo

- Arnaldo

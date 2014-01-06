Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaAFPcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:32:11 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39251 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbaAFPcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:32:09 -0500
Message-ID: <1389022310.13828.9.camel@localhost.localdomain>
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 06 Jan 2014 16:31:50 +0100
In-Reply-To: <20140106142220.GB1183@krava.brq.redhat.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
	 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
	 <20140106092929.GA31570@twins.programming.kicks-ass.net>
	 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
	 <20140106142220.GB1183@krava.brq.redhat.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 06 janvier 2014 à 15:22 +0100, Jiri Olsa a écrit :
> On Mon, Jan 06, 2014 at 11:51:25AM +0100, Yann Droneaud wrote:
> > In a previous patch [1][2], flag PERF_FLAG_FD_CLOEXEC was
> > added to perf_event_open(2) syscall to allows userspace
> > to enable close-on-exec behavor atomically when creating
> > the file descriptor.
> > 
> > This patch makes perf tools use the new flag.
> > 
> > Beware that perf tools compiled with the new flag won't work
> > on older kernel which do not support flag PERF_FLAG_FD_CLOEXEC.
> 
> I think we should enhance the api probe routines (perf_do_probe_api)
> to detect that, than just bypass us from running on older kernels
> 

perf_probe_api() is only available in tools/perf/util/record.c module
(eg. it's a static function), while I've modified all calls to
perf_event_open().

So if you want to follow the probe path, a new function should be added.
This function must be used to retrieve the value of the
PERF_FLAG_FD_CLOEXEC flag if available.
For example:

static int cloexec = PERF_FLAG_FD_CLOEXEC;

int perf_flag_fd_cloexec(void)
{
    static int probed;

    if (!probed) {
        int fd = perf_event_open(&attr, 0, -1, -1,
PERF_FLAG_FD_CLOEXEC);
        probed = 1;
        if (fd >= 0)
            close(fd);
        else
            cloexec = 0;
     }

     return cloexec;
}

But I don't know how to setup a struct perf_event_attr which will work
in "all" case (and do no harm).

I was able to run this code with attr struct cleared (eg. set to 0), but
I don't know perf internals enough to be confident.

Regards.

-- 
Yann Droneaud
OPTEYA



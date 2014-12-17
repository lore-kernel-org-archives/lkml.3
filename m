Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaLQOA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:00:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:33528 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaLQOAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:00:55 -0500
Date: Wed, 17 Dec 2014 11:00:42 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/18] perf evlist: Do not use hard coded value for a
 mmap_pages default
Message-ID: <20141217140042.GA11607@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-6-git-send-email-acme@kernel.org>
 <20141217132330.GB18257@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217132330.GB18257@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 17, 2014 at 02:23:30PM +0100, Jiri Olsa escreveu:
> On Tue, Dec 16, 2014 at 01:57:07PM -0300, Arnaldo Carvalho de Melo wrote:
> > +	if (pages == UINT_MAX) {
> > +		int max;
> > +
> > +		if (sysctl__read_int("kernel/perf_event_mlock_kb", &max) < 0) {
> > +			/*
> > +			 * Pick a once upon a time good value, i.e. things look
> > +			 * strange since we can't read a sysctl value, but lets not
> > +			 * die yet...
> > +			 */
> > +			max = 512;
> > +		} else {
> > +			max -= (page_size / 1024);
> > +		}
 
> so this way you depend on value in perf_event_mlock_kb being power 2,
> otherwise:

> # echo 1000 > /proc/sys/kernel/perf_event_mlock_kb
> $ perf record ls
> failed to mmap with 22 (Invalid argument)

Right, I thought that perf_event_mlock_kb input was validated, realized
that it is not, see the following patchkit that makes it validate that
after reading, using rounddown_pow_of_two if not.

- Arnaldo
 
> maybe you could use the logic/code from parse_pages_arg function
> 
> jirka

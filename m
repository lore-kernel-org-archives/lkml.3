Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaILOLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:11:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:48740 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbaILOLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:11:22 -0400
Date: Fri, 12 Sep 2014 11:11:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140912141116.GH1801@kernel.org>
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
 <540964C0.1050702@intel.com>
 <20140905141123.GE30520@kernel.org>
 <1409930200.1662.16.camel@leonhard>
 <20140905154402.GF30520@kernel.org>
 <87ppf1mkkk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppf1mkkk.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 03:14:51PM +0900, Namhyung Kim escreveu:
> On Fri, 5 Sep 2014 12:44:02 -0300, Arnaldo Carvalho de Melo wrote:
> > It seems we need a way to state that an entry in the build-id table is
> > for the kernel, without looking at its file name.
 
> Maybe we can add a new build_id2_event (like mmap2) that has a new field
> to record that info.

Humm, take a look at machine__write_buildid_table() -> write_buildid(),
we already seem to set build_id_event.header.misc suitably, no?

> > That or to put the build-id into the synthesized kernel mmap
> > event. Which is better, because:

> > That leads to another problem that needs to get solved eventually: We
> > need to have the build-id into PERF_RECORD_MMAP, because we're now using
> > just the mmap filename as the key, not the contents, and for long
> > running sessions, DSOs can get updated, etc.
 
> But it'd require a realtime processing of events at record time.

Been there, done that, backtracked, yes, we can't do that at 'record
time', else we would be adding way too much noise to the recording
phase.

The idea is for the _kernel_ to do that, would take sizeof(buildid)
(about 20 bytes) on the per-DSO structure in the kernel.

When ELF loading it, stashing the contents of an ELF session
(.note.gnu.build-id) somewhere accessible at PERF_RECORD_MMAP3
generation time.

Doing that at the time we load the DSO from disk should add negligible
overhead.

With that we would not need to go over all the perf.data stream to
generate the build-id table after all record sessions, they would be at
the struct map already.

We could then have multiple entries in the build-id table for the same
pathname, with different build ids, that is something we don't support
now and that provides bogus results when it happens.

- Arnaldo

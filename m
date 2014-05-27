Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaE0H7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaE0H7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:59:47 -0400
Date: Tue, 27 May 2014 09:59:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 14/14] perf tests: Add test for closing dso objects on
 EMFILE error
Message-ID: <20140527075927.GF12920@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-15-git-send-email-jolsa@kernel.org>
 <878upohu76.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878upohu76.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:43:57AM +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 19:23:35 +0200, Jiri Olsa wrote:
> > Testing that perf properly closes opened dso objects
> > and tries to reopen in case we run out of allowed file
> > descriptors for dso data.
> >
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Jean Pihet <jean.pihet@linaro.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/tests/builtin-test.c |  4 +++
> >  tools/perf/tests/dso-data.c     | 70 +++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/tests/tests.h        |  1 +
> >  3 files changed, 75 insertions(+)
> >
> > diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> > index c4d581a..a489cda 100644
> > --- a/tools/perf/tests/builtin-test.c
> > +++ b/tools/perf/tests/builtin-test.c
> > @@ -60,6 +60,10 @@ static struct test {
> >  		.func = test__dso_data_cache,
> >  	},
> >  	{
> > +		.desc = "Test dso data reopen",
> > +		.func = test__dso_data_reopen,
> > +	},
> > +	{
> >  		.desc = "roundtrip evsel->name check",
> >  		.func = test__perf_evsel__roundtrip_name_test,
> >  	},
> > diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
> > index 84ab939..ecc8acd 100644
> > --- a/tools/perf/tests/dso-data.c
> > +++ b/tools/perf/tests/dso-data.c
> > @@ -328,3 +328,73 @@ int test__dso_data_cache(void)
> >  	TEST_ASSERT_VAL("failed leadking files", nr == open_files_cnt());
> >  	return 0;
> >  }
> > +
> > +int test__dso_data_reopen(void)
> > +{
> > +	struct machine machine;
> > +	long nr = open_files_cnt();
> > +#define BUFSIZE 10
> 
> Looks like a copy-n-paste error.. :)

yea.. ;) I wonder why gcc did not scream about that

SNIP

> > +
> > +	/*
> > +	 * dso_1 should get closed, because we reached
> > +	 * the file descriptor limit
> > +	 */
> > +	TEST_ASSERT_VAL("failed to close dso_0", dso_1->data.fd == -1);
> 
> s/dso_0/dso_1/
> 
> Btw, I don't see a big difference between this and previous testcase.
> Any chance to merge them into one?

- the first one tests the caching or closing of file descriptors
  after dso__data_close is called
  
- the second one tests that we actually try to close dso objects
  in case we cannot open new dso

thanks,
jirka

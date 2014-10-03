Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaJCIZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:25:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbaJCIY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:56 -0400
Date: Fri, 3 Oct 2014 10:24:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V6 0/3] perf tools: pmu event new style format fix
Message-ID: <20141003082452.GG19087@krava.brq.redhat.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
 <20140914132322.GB1731@krava.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701604EC2@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701604EC2@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 05:33:28PM +0000, Liang, Kan wrote:
> 
> 
> > 
> > On Thu, Sep 11, 2014 at 03:08:56PM -0400, kan.liang@intel.com wrote:
> > > From: Kan Liang <kan.liang@intel.com>
> > >
> > > There are two types of pmu event stytle formats, "pmu_event_name"
> > > or "cpu/pmu_event_name/". However, there is a bug on supporting these
> > > two formats, especially when they mixed with other perf events.
> > > The patch set intends to fix this issue.
> > >
> > > The patch set has been tested on my haswell.
> > > Here is the test script I used for this issue.
> > > (Note: please make sure that your test system supports TSX and
> > > L1-dcache-loads events. Otherwise, you may want to change the events
> > > to other pmu events.)
> > 
> > any chance changing this script to work for everyone?
> > and make it part of theautomated tests suite?
> > 
> > also how about something like in the attached change
> 
> It cannot trigger the issue, since current perf will automatically add cpu//  for pmu event.
> We have to test at least two events with different style.
> How about the change as below?

looks good,

jirka

> 
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -457,6 +457,36 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
>         return 0;
>  }
> 
> +
> +static int test__checkevent_pmu_events_mix(struct perf_evlist *evlist)
> +{
> +       struct perf_evsel *evsel = perf_evlist__first(evlist);
> +
> +       /* pmu-event:u */
> +       TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
> +       TEST_ASSERT_VAL("wrong exclude_user",
> +                       !evsel->attr.exclude_user);
> +       TEST_ASSERT_VAL("wrong exclude_kernel",
> +                       evsel->attr.exclude_kernel);
> +       TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
> +       TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
> +       TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
> +
> +       /* cpu/pmu-event/u*/
> +       evsel = perf_evsel__next(evsel);
> +       TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
> +       TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
> +       TEST_ASSERT_VAL("wrong exclude_user",
> +                       !evsel->attr.exclude_user);
> +       TEST_ASSERT_VAL("wrong exclude_kernel",
> +                       evsel->attr.exclude_kernel);
> +       TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
> +       TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
> +       TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
> +
> +       return 0;
> +}
> +
>  static int test__checkterms_simple(struct list_head *terms)
>  {
>         struct parse_events_term *term;
> @@ -1554,6 +1584,12 @@ static int test_pmu_events(void)
>                 e.check = test__checkevent_pmu_events;
> 
>                 ret = test_event(&e);
> +               if (ret)
> +                       break;
> +               snprintf(name, MAX_NAME, "%s:u,cpu/event=%s/u", ent->d_name, ent->d_name);
> +               e.name  = name;
> +               e.check = test__checkevent_pmu_events_mix;
> +               ret = test_event(&e);
>  #undef MAX_NAME
>         }
> 
> 
> Thanks,
> Kan
> 
> 
> > 
> > jirka
> > 
> > 
> > ---
> > diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-
> > events.c index 5941927a4b7f..2b7c48474761 100644
> > --- a/tools/perf/tests/parse-events.c
> > +++ b/tools/perf/tests/parse-events.c
> > @@ -1554,6 +1554,15 @@ static int test_pmu_events(void)
> >  		e.check = test__checkevent_pmu_events;
> > 
> >  		ret = test_event(&e);
> > +		if (ret)
> > +			break;
> > +
> > +		snprintf(name, MAX_NAME, "event=%s", ent->d_name);
> > +
> > +		e.name  = name;
> > +		e.check = test__checkevent_pmu_events;
> > +
> > +		ret = test_event(&e);
> >  #undef MAX_NAME
> >  	}

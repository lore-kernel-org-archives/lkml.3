Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaJBReE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:34:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:37569 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaJBReA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,640,1406617200"; 
   d="scan'208";a="612249301"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 0/3] perf tools: pmu event new style format fix
Thread-Topic: [PATCH V6 0/3] perf tools: pmu event new style format fix
Thread-Index: AQHPzfQIvNqB0oKg/EuR//1QzlLP+JwAHBgAgB0UDnA=
Date: Thu, 2 Oct 2014 17:33:28 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701604EC2@SHSMSX103.ccr.corp.intel.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
 <20140914132322.GB1731@krava.redhat.com>
In-Reply-To: <20140914132322.GB1731@krava.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Thu, Sep 11, 2014 at 03:08:56PM -0400, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > There are two types of pmu event stytle formats, "pmu_event_name"
> > or "cpu/pmu_event_name/". However, there is a bug on supporting these
> > two formats, especially when they mixed with other perf events.
> > The patch set intends to fix this issue.
> >
> > The patch set has been tested on my haswell.
> > Here is the test script I used for this issue.
> > (Note: please make sure that your test system supports TSX and
> > L1-dcache-loads events. Otherwise, you may want to change the events
> > to other pmu events.)
> 
> any chance changing this script to work for everyone?
> and make it part of theautomated tests suite?
> 
> also how about something like in the attached change

It cannot trigger the issue, since current perf will automatically add cpu//  for pmu event.
We have to test at least two events with different style.
How about the change as below?

--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -457,6 +457,36 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
        return 0;
 }

+
+static int test__checkevent_pmu_events_mix(struct perf_evlist *evlist)
+{
+       struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+       /* pmu-event:u */
+       TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+       TEST_ASSERT_VAL("wrong exclude_user",
+                       !evsel->attr.exclude_user);
+       TEST_ASSERT_VAL("wrong exclude_kernel",
+                       evsel->attr.exclude_kernel);
+       TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+       TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+       TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+       /* cpu/pmu-event/u*/
+       evsel = perf_evsel__next(evsel);
+       TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+       TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+       TEST_ASSERT_VAL("wrong exclude_user",
+                       !evsel->attr.exclude_user);
+       TEST_ASSERT_VAL("wrong exclude_kernel",
+                       evsel->attr.exclude_kernel);
+       TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+       TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+       TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+       return 0;
+}
+
 static int test__checkterms_simple(struct list_head *terms)
 {
        struct parse_events_term *term;
@@ -1554,6 +1584,12 @@ static int test_pmu_events(void)
                e.check = test__checkevent_pmu_events;

                ret = test_event(&e);
+               if (ret)
+                       break;
+               snprintf(name, MAX_NAME, "%s:u,cpu/event=%s/u", ent->d_name, ent->d_name);
+               e.name  = name;
+               e.check = test__checkevent_pmu_events_mix;
+               ret = test_event(&e);
 #undef MAX_NAME
        }


Thanks,
Kan


> 
> jirka
> 
> 
> ---
> diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-
> events.c index 5941927a4b7f..2b7c48474761 100644
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -1554,6 +1554,15 @@ static int test_pmu_events(void)
>  		e.check = test__checkevent_pmu_events;
> 
>  		ret = test_event(&e);
> +		if (ret)
> +			break;
> +
> +		snprintf(name, MAX_NAME, "event=%s", ent->d_name);
> +
> +		e.name  = name;
> +		e.check = test__checkevent_pmu_events;
> +
> +		ret = test_event(&e);
>  #undef MAX_NAME
>  	}

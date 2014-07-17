Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaGQIoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:44:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:30622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaGQIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="544670555"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf tools: Fix incorrect fd error comparison
Date: Thu, 17 Jul 2014 11:43:08 +0300
Message-Id: <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140716142031.GD9441@krava.redhat.com>
References: <20140716142031.GD9441@krava.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 05:20 PM, Jiri Olsa wrote:> On Mon, Jul 14, 2014 at 01:02:42PM +0300, Adrian Hunter wrote:
>> Add 'data_status' to record whether a dso has data
>> (i.e. an object file) as follows:
>>
>> 	dso->data_status	meaning
>> 	----------------------------------
>> 	0			don't know
>> 	-1			no data
>> 	1			has data
> 
> please add enum for this

Ok

> 
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/dso.c | 5 ++++-
>>  tools/perf/util/dso.h | 1 +
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index fc006fe..91a4eb4 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -556,8 +556,11 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
>>  ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
>>  			      u64 offset, u8 *data, ssize_t size)
>>  {
>> -	if (dso__data_fd(dso, machine) < 0)
>> +	if (dso__data_fd(dso, machine) < 0) {
>> +		dso->data.data_status = -1;
>>  		return -1;
>> +	}
>> +	dso->data.data_status = 1;
> 
> we have more callers to dso__data_fd, so I think we want
> to setup dso->data.data_status within dso__data_fd

Ok.  Here are 2 patches because I noticed another thing.

Adrian Hunter (2):
      perf tools: Fix incorrect fd error comparison
      perf tools: Record whether a dso has data

 tools/perf/util/dso.c | 27 +++++++++++++++++----------
 tools/perf/util/dso.h |  7 +++++++
 2 files changed, 24 insertions(+), 10 deletions(-)

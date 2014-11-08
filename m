Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaKHEPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 23:15:44 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59728 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaKHEPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 23:15:43 -0500
Message-ID: <545D98E7.3070006@hitachi.com>
Date: Sat, 08 Nov 2014 13:15:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi, brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <545CA436.8030306@linux.vnet.ibm.com>
In-Reply-To: <545CA436.8030306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/07 19:51), Hemant Kumar wrote:
>>
>> File Format
>> ===========
>> All the cache files are placed under ~/.debug/ by default.
>> The paths of buildid cache of binary/symbols are not changed.
>>
>> The SDT/probe caches are placed under the ~/.debug/.probes/path/to/bin/bu/ildid
>> and that is linked to ~/.debug/.probes/.buildid/bu/ildid
>> # To avoid conflict with files under /probes/*, I picked up .probes/.
>>
>> This SDT/probe caches contain probe-definitions as following format.
>> ----
>> #buildid:BUILDID
>> #path:PATH
>> p:%PROVIDER/EVENT PATH:OFFSET [ARGS]
> 
> I think this format isn't accepted by the uprobe_events file (because of
> the '%') if we want to cat and grep into uprobe_events file directly.
> Although, in case of perf record, we can process it to remove '%' and
> then write into uprobe_events file. And, '%' is required as a flag for
> the SDT entries.

Ah, right...

> So, either we can modify the uprobe_events file to ignore '%' in the
> event group name (with an additional patch in the SDT series) or we can
> leave it to the user to write a script which can do some processing to
> remove '%' and then echo it to uprobe_events file.
> What would you think?

Hmm, ok. I think we can unify SDT and probe cache as just an cached
event. So replacing % with probe_ prefix is OK I think.

What I mean is if you add a file to cache, perf adds SDTs in the file,
and if you add a file with some expressions, like '* $params', perf
also adds probe caches. And you can use both events for not only
tracing but also profiling.

e.g.
 perf cache --add /bin/foo  # add foo's SDTs
 perf cache --add /bin/foo --probe 'foofunc $params' # add a probe cache for foofunc
 perf record -e %foo:sdtevent -e %foo:foofunc ... # we can record both SDT and cache

So, % prefix means "recall cached probe/sdt events to record if needed".
If you already set up the probe-events on those, you don't need % as below.

 perf probe --add "%foo:sdtevent" # add new probe_foo:sdtevent for %foo:sdtevent
 perf record -e probe_foo:sdtevent ...

Note that to avoid crash with existing event groups, we'll add "probe_" prefix
for cached events.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



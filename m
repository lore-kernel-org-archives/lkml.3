Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaAMJDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:03:18 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49229 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAMJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:03:07 -0500
X-AuditID: 9c93017e-b7ba2ae000003516-bb-52d3abc7b61f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/9] perf, tools: fix BFD detection on opensuse
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
	<1389469379-13340-2-git-send-email-andi@firstfloor.org>
	<20140112151615.GA6524@krava.brq.redhat.com>
Date: Mon, 13 Jan 2014 18:03:03 +0900
In-Reply-To: <20140112151615.GA6524@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 12 Jan 2014 16:16:15 +0100")
Message-ID: <87bnzgb6ew.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014 16:16:15 +0100, Jiri Olsa wrote:
> On Sat, Jan 11, 2014 at 11:42:51AM -0800, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>> 
>> opensuse libbfd requires -lz -liberty to build. Add those
>> to the BFD feature detection.
>> 
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  tools/perf/config/Makefile                | 2 +-
>>  tools/perf/config/feature-checks/Makefile | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index 01dd43d..d86d33c 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -478,7 +478,7 @@ else
>>  endif
>>  
>>  ifeq ($(feature-libbfd), 1)
>> -  EXTLIBS += -lbfd
>> +  EXTLIBS += -lbfd -lz -liberty
>>  endif
>
> ok, Fedora is using linker script in place of libbfd.so which
> adds those anyway..
>
> ---
> [jolsa@krava perf]$ cat /usr/lib64/libbfd.so 
> /* GNU ld script */
>
> /* Ensure this .so library will not be used by a link for a different format
>    on a multi-architecture system.  */
> OUTPUT_FORMAT(elf64-x86-64)
>
> /* The libz dependency is unexpected by legacy build scripts.  */
> /* The libdl dependency is for plugin support.  (BZ 889134)  */
> INPUT ( /usr/lib64/libbfd.a -liberty -lz -ldl )
> ---
>
> we also need to check and probably get rid of follow up settings of
> EXTLIBS which seems useless now:
>
> ...
>     ifneq ($(feature-libbfd), 1)
>       $(call feature_check,liberty)
>       ifeq ($(feature-liberty), 1)
>         EXTLIBS += -lbfd -liberty
>       else
>         $(call feature_check,liberty-z)
>         ifeq ($(feature-liberty-z), 1)
>           EXTLIBS += -lbfd -liberty -lz
> ...

Agreed.  I think it's only for keeping dependency minimal.  But no need
to do it if it's always called with -liberty and -lz.

Thanks,
Namhyung

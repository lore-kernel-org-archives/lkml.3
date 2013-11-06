Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab3KFPPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:15:49 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49343 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab3KFPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:15:48 -0500
Message-ID: <527A5D20.3000308@gmail.com>
Date: Wed, 06 Nov 2013 08:15:44 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?56em5om/5Yia?= <chenggang.qcg@alibaba-inc.com>,
        Chenggang Qin <chenggang.qin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?56em5om/5Yia?= <chenggang.qcg@taobao.com>
Subject: Re: =?UTF-8?B?562U5aSN77yaW1BBVENIIDIvNF0gcGVyZiB0b29sczogcmVsYXQ=?=
 =?UTF-8?B?ZSAnc3RhcnQnICYgJ2VuZCcgdG8gcGVyZl9zZXNzaW9u?=
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com> <1383298146-3860-3-git-send-email-chenggang.qin@gmail.com>,52757E0B.3010805@gmail.com <f31aa7c2-c31a-47f2-a051-a5bd44f4d07d@alibaba-inc.com>
In-Reply-To: <f31aa7c2-c31a-47f2-a051-a5bd44f4d07d@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/13, 4:23 AM, 秦承刚 wrote:
> Hi David:
> The goal is to simplify transfering the times to function
> perf_session__process_events() and other functions in the sample
> processing path. Session is a parameter throughout the total sample
> processing path.

Right. By putting the time check in session code you are going to be 
dropping samples related to task events too. e.g., a task is created 
after the session is started and before the time window. Samples for the 
task (FORK, MMAP, COMM) will get dropped as will events for other tasks 
(e.g., EXIT). Then samples during the time window will not correlate 
nicely/correctly to a task with a name and maps.

I have patches locally with this same idea -- collect data for a broad 
time window but only show/analyze samples for a specific time window. 
Instead of having the time check in the session code I have it in the 
commands (report, script, etc). e.g., in sample event processing:

     if (perf_time__skip_sample(sample))
         goto out;

where that function has the logic to compare sample timestamps to a user 
given window.

I seem to recall Namhyung send out a patch on time intervals as well.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3GERKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:10:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22650 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GERKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:10:46 -0400
Message-ID: <51D6FE08.8030904@hp.com>
Date: Fri, 05 Jul 2013 13:10:32 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2 v5] SELinux: Reduce overhead of mls_level_isvalid()
 function call
References: <1370886908-65256-1-git-send-email-Waiman.Long@hp.com> <51B70EE4.5030209@tycho.nsa.gov>
In-Reply-To: <51B70EE4.5030209@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 07:49 AM, Stephen Smalley wrote:
> On 06/10/2013 01:55 PM, Waiman Long wrote:
>> v4->v5:
>>    - Fix scripts/checkpatch.pl warning.
>>
>> v3->v4:
>>    - Merge the 2 separate while loops in ebitmap_contains() into
>>      a single one.
>>
>> v2->v3:
>>    - Remove unused local variables i, node from mls_level_isvalid().
>>
>> v1->v2:
>>   - Move the new ebitmap comparison logic from mls_level_isvalid()
>>     into the ebitmap_contains() helper function.
>>   - Rerun perf and performance tests on the latest v3.10-rc4 kernel.
>>
>> While running the high_systime workload of the AIM7 benchmark on
>> a 2-socket 12-core Westmere x86-64 machine running 3.10-rc4 kernel
>> (with HT on), it was found that a pretty sizable amount of time was
>> spent in the SELinux code. Below was the perf trace of the "perf
>> record -a -s" of a test run at 1500 users:
>>
>>    5.04%            ls  [kernel.kallsyms]     [k] ebitmap_get_bit
>>    1.96%            ls  [kernel.kallsyms]     [k] mls_level_isvalid
>>    1.95%            ls  [kernel.kallsyms]     [k] find_next_bit
>>
>> The ebitmap_get_bit() was the hottest function in the perf-report
>> output.  Both the ebitmap_get_bit() and find_next_bit() functions
>> were, in fact, called by mls_level_isvalid(). As a result, the
>> mls_level_isvalid() call consumed 8.95% of the total CPU time of
>> all the 24 virtual CPUs which is quite a lot. The majority of the
>> mls_level_isvalid() function invocations come from the socket creation
>> system call.
>>
>> Looking at the mls_level_isvalid() function, it is checking to see
>> if all the bits set in one of the ebitmap structure are also set in
>> another one as well as the highest set bit is no bigger than the one
>> specified by the given policydb data structure. It is doing it in
>> a bit-by-bit manner. So if the ebitmap structure has many bits set,
>> the iteration loop will be done many times.
>>
>> The current code can be rewritten to use a similar algorithm as the
>> ebitmap_contains() function with an additional check for the
>> highest set bit. The ebitmap_contains() function was extended to
>> cover an optional additional check for the highest set bit, and the
>> mls_level_isvalid() function was modified to call ebitmap_contains().
>>
>> With that change, the perf trace showed that the used CPU time drop
>> down to just 0.08% (ebitmap_contains + mls_level_isvalid) of the
>> total which is about 100X less than before.
>>
>>    0.07%            ls  [kernel.kallsyms]     [k] ebitmap_contains
>>    0.05%            ls  [kernel.kallsyms]     [k] ebitmap_get_bit
>>    0.01%            ls  [kernel.kallsyms]     [k] mls_level_isvalid
>>    0.01%            ls  [kernel.kallsyms]     [k] find_next_bit
>>
>> The remaining ebitmap_get_bit() and find_next_bit() functions calls
>> are made by other kernel routines as the new mls_level_isvalid()
>> function will not call them anymore.
>>
>> This patch also improves the high_systime AIM7 benchmark result,
>> though the improvement is not as impressive as is suggested by the
>> reduction in CPU time spent in the ebitmap functions. The table below
>> shows the performance change on the 2-socket x86-64 system (with HT
>> on) mentioned above.
>>
>> +--------------+---------------+----------------+-----------------+
>> |   Workload   | mean % change | mean % change  | mean % change   |
>> |              | 10-100 users  | 200-1000 users | 1100-2000 users |
>> +--------------+---------------+----------------+-----------------+
>> | high_systime |     +0.1%     |     +0.9%      |     +2.6%       |
>> +--------------+---------------+----------------+-----------------+
>>
>> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
>
> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
>

Thank for the Ack. Will that patch go into v3.11?

Regards,
Longman

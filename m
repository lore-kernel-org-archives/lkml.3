Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3LPLmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:42:01 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38972 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3LPLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:41:59 -0500
Message-ID: <52AEE5DA.1010102@linux.vnet.ibm.com>
Date: Mon, 16 Dec 2013 17:06:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Paul Bolle <pebolle@tiscali.nl>,
        ziegler@email.mathematik.uni-freiburg.de, jbarnes@virtuousgeek.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
References: <52A448F2.4010208@redhat.com> <CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com> <87iouprrcw.fsf@nemi.mork.no>
In-Reply-To: <87iouprrcw.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121611-2674-0000-0000-00000BE906DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 04:32 PM, Bjørn Mork wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
>> On 8 December 2013 15:54, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>> I'm testing recent 3.13-rc kernel - and I've notice my Lenovo T61 is not
>>> able to resume.  After bisect I've found commit:
>>>
>>> 5a87182aa21d6d5d306840feab9321818dd3e2a3
>>
>> That's my patch, sorry for all the trouble.. Just came back after vacations
>> and multiple threads are there with this patch as culprit..
>>
>> I just tested this patch again on Rafael's linux-next branch and suspend/resume
>> and Hibernation are working fine for me on my Thinkpad T420. I don't see any
>> issues at all..
>>
>> scaling_governor: ondemand
>> scaling_driver: acpi-cpufreq
>>
>>> When I just revert this commit with 374b105797c3d4f29c685f3be535c35f5689b30e
>>> (3.13-rc3)   suspend/resume works again.
>>> (I'm using  ondemand CPU governor)
>>
>>> Here is bisect log:
>>
>>> # bad: [2167e2399dc5e69c62db56d933e9c8cbe107620a] cpufreq: fix garbage
>>> kobjects on errors during suspend/resume
>>> git bisect bad 2167e2399dc5e69c62db56d933e9c8cbe107620a
>>
>> I don't read bisect logs well but doesn't you log say that the culprit is
>> 2167e2399dc5e69c62db56d933e9c8cbe107620a instead?
>>
>> I am trying with this patch now, but will take some time for results to be out.
> 
> It's both patches in combination.  Interesting case, really :-)
>

True... Basically, what happens is that commit 5a87182 prevents POLICY_EXIT
of governors during suspend - ie., it just does a CPUFREQ_GOV_STOP and prevents
any further operations on governors.

Later, commit 2167e23 removes the special suspend/resume handling for CPU hotplug
and thus in this path, CPU offline sends out POLICY_EXIT and also frees up the
memory allocated to the policy structure. Since POLICY_EXIT is prevented by the
cpufreq_suspend() code, this tear-down only gets half-completed and thus goes
into an inconsistent state.

So, upon resume, the CPU online operation tries POLICY_INIT, GOV_START etc,
and again none of these get executed because of the cpufreq_suspend() code.
Eventually cpufreq_resume() will execute GOV_START, but by then the underlying
policy-structure is a newly allocated one, and things have already been messed
up so much that it just can't resume properly.

Overall, the inconsistency in handling governor code during suspend/resume
is the root-cause of the suspend/resume regression. And as Bjorn mentioned,
this is caused by the interaction of the 2 commits with one another, and cannot
be reproduced by either of the commits independently.

IIUC, mainline should be fine now, since Rafael reverted both the commits. We
need to be more careful in bringing back either functionality in the future.
As Bjorn and Rafael rightly pointed out in the other email threads, we need to
fundamentally rethink the design and come up with elegant interfaces/mechanisms
in the cpufreq subsystem that will allow us to write code that works as expected
and avoid such subtle regressions.


Regards,
Srivatsa S. Bhat


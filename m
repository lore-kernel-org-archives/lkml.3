Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaDXMs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:48:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33764 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaDXMsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:48:25 -0400
Message-ID: <53590835.9090803@arm.com>
Date: Thu, 24 Apr 2014 13:48:53 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology
 table
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org> <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org> <5357A802.1030804@arm.com> <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com> <5357DBA5.1010106@arm.com> <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com>
In-Reply-To: <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com>
X-OriginalArrivalTime: 24 Apr 2014 12:48:34.0840 (UTC) FILETIME=[8136A980:01CF5FBB]
X-MC-Unique: 114042413482208301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/14 08:30, Vincent Guittot wrote:
> On 23 April 2014 17:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> On 23/04/14 15:46, Vincent Guittot wrote:
>>> On 23 April 2014 13:46, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>>>> Hi,

[...]

> 
> More than the flag that is used for the example, it's about the
> cpumask which are inconsistent across CPUs for the same level and the
> build_sched_domain sequence rely on this consistency to build
> sched_group

Now I'm lost here. I thought so far that by specifying different cpu
masks per CPU in an sd level, we get the sd level folding functionality
in sd degenerate?

We discussed this here for an example on TC2 for the GMC level:
https://lkml.org/lkml/2014/3/21/126

Back than I had
  CPU0: cpu_corepower_mask=0-1
  CPU2: cpu_corepower_mask=2
so for GMC level the cpumasks are inconsistent across CPUs and it worked.

The header of '[PATCH v4 1/5] sched: rework of sched_domain topology
definition' mentions only the requirement "Then, each level must be a
subset on the next one" and this one I haven't broken w/ my
GMC/MC/GDIE/DIE set-up.

Do I miss something else here?

> 
>> Essentially what I want to do is bind an SD_SHARE_*FOO* flag to the GDIE
>> related sd's of CPU2/3/4 and not to the DIE related sd's of CPU0/1.
>>
>> I thought so far that I can achieve that by getting rid of GDIE sd level
>> for CPU0/1 simply by choosing the cpu_foo_mask() function in such a way
>> that it returns the same cpu mask as its child sd level (MC) and of DIE
>> sd level for CPU2/3/4 because it returns the same cpu mask as its child
>> sd level (GDIE) related cpu mask function. This will let sd degenerate
>> do it's job of folding sd levels which it does. The only problem I have
>> is that the groups are not created correctly any more.
>>
>> I don't see right now how the flag SD_SHARE_FOO affects the code in
>> get_group()/build_sched_groups().
>>
>> Think of SD_SHARE_FOO of something I would like to have for all sd's of
>> CPU's of cluster 1 (CPU2/3/4) and not on cluster 0 (CPU0/1) in the sd
>> level where each CPU sees two groups (group0 containing CPU0/1 and
>> group1 containing CPU2/3/4 or vice versa) (GDIE/DIE) .
> 
> I'm not sure that's it's feasible because it's not possible from a
> topology pov to have different flags if the span include all cpus.
> Could you give us more details about what you want to achieve with
> this flag ?

IMHO, the flag is not important for this discussion.  OTHA, information
like you can't use sd degenerate functionality to fold adjacent sd
levels (GFOO/FOO) on sd level which span all CPUs would be.  I want to
make sure we understand what are the limitations to use folding of
adjacent sd levels based on per-cpu differences in the return value of
cpu_mask functions.

-- Dietmar

[...]


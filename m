Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaIWIM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:12:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43782 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIWIM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:12:26 -0400
Message-ID: <54212B85.7060806@arm.com>
Date: Tue, 23 Sep 2014 09:12:53 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-3-git-send-email-juri.lelli@arm.com> <20140919212547.GG2832@worktop.localdomain>
In-Reply-To: <20140919212547.GG2832@worktop.localdomain>
X-OriginalArrivalTime: 23 Sep 2014 08:12:21.0263 (UTC) FILETIME=[196181F0:01CFD706]
X-MC-Unique: 114092309122311201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 19/09/14 22:25, Peter Zijlstra wrote:
> On Fri, Sep 19, 2014 at 10:22:40AM +0100, Juri Lelli wrote:
>> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
>> affinity (performing what is commonly called clustered scheduling).
>> Unfortunately, such thing is currently broken for two reasons:
>>
>>  - No check is performed when the user tries to attach a task to
>>    an exlusive cpuset (recall that exclusive cpusets have an
>>    associated maximum allowed bandwidth).
>>
>>  - Bandwidths of source and destination cpusets are not correctly
>>    updated after a task is migrated between them.
>>
>> This patch fixes both things at once, as they are opposite faces
>> of the same coin.
>>
>> The check is performed in cpuset_can_attach(), as there aren't any
>> points of failure after that function. The updated is split in two
>> halves. We first reserve bandwidth in the destination cpuset, after
>> we pass the check in cpuset_can_attach(). And we then release
>> bandwidth from the source cpuset when the task's affinity is
>> actually changed. Even if there can be time windows when sched_setattr()
>> may erroneously fail in the source cpuset, we are fine with it, as
>> we can't perfom an atomic update of both cpusets at once.
> 
> The thing I cannot find is if we correctly deal with updates to the
> cpuset. Say we first setup 2 (exclusive) sets A:cpu0 B:cpu1-3. Then
> assign tasks and then update the cpu masks like: B:cpu2,3, A:cpu1,2.
> 

Right, next week I should be able to properly test this.

Thanks a lot,

- Juri


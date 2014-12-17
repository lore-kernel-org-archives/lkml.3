Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaLQDDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:03:40 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:36142 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:03:39 -0500
Message-ID: <5490F24C.7090202@huawei.com>
Date: Wed, 17 Dec 2014 11:02:36 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <eranian@gmail.com>
CC: Stephane Eranian <eranian@googlemail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [perf tool] cgroup support broken on Debian?
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu> <20141215220150.GP9845@kernel.org> <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com> <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu> <5490E856.6050904@huawei.com> <CAMsRxfL2GrA-1N7AZM42LC+aLBRB-pvtTXs1ovLine=Hv3PFag@mail.gmail.com>
In-Reply-To: <CAMsRxfL2GrA-1N7AZM42LC+aLBRB-pvtTXs1ovLine=Hv3PFag@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.5490F24F.00CD,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 233d6f7fd5ca020b17f2f3071bf5e077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/17 10:29, Stephane Eranian wrote:
> On Wed, Dec 17, 2014 at 3:20 AM, Zefan Li <lizefan@huawei.com> wrote:
>> On 2014/12/17 1:17, Vince Weaver wrote:
>>> On Mon, 15 Dec 2014, Stephane Eranian wrote:
>>>> On Mon, Dec 15, 2014 at 11:01 PM, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
>>>
>>>> fs is visible. The cgroup file system type is not there anymore. They are using
>>>> tmpfs which is not ideal to detect just cgroup. Looks like now, we have to look
>>>> at the mount point which is flaky.
>>>
>>> The trivial fix is to just always assume things will be under
>>>       /sys/fs/cgroup
>>> which looks like to be the new official mount point.
>>>
>>> This will break on older systems though, or systems that mount cgroupfs in
>>> multiple locations.
>>>
>>> Another alternative is to change the interface to require the full
>>> cgroupfs pathname as an argument to -G
>>>
>>
>> What's the problem here?
>>
>> none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
>> systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0
>>
>> cgroup is mounted in /sys/fs/cgroup/systemd, so you should pass '/' to the -G argument:
>>
> Is that the only mountpoint possible?
> The tool needs to detect a valid mount point to locate the named cgroup.
> That's assuming that if I create cgroup foo, then it appears under
> //sys/fs/cgroup/systemd/foo
> 

There can be only one cgroupfs mountpoint which has perf_event subsystem
attached to it.

So for this setup:

mount -t tmpfs /sys/fs/cgroup
mkdir /sys/fs/cgroup/memory
mkdir /sys/fs/cgroup/perf
mount -t cgroup -o memory memcg /sys/fs/cgroup/memory
mount -t cgroup -o perf_event perf /sys/fs/cgroup/perf

The perf tool will locate the mountpoint as /sys/fs/cgroup/perf.


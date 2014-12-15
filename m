Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaLOWps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:45:48 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38156 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLOWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:45:47 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20141215220150.GP9845@kernel.org>
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu>
	<20141215220150.GP9845@kernel.org>
Date: Mon, 15 Dec 2014 23:45:46 +0100
Message-ID: <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com>
Subject: Re: [perf tool] cgroup support broken on Debian?
From: Stephane Eranian <eranian@googlemail.com>
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

On Mon, Dec 15, 2014 at 11:01 PM, Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
> Em Mon, Dec 15, 2014 at 04:07:46PM -0500, Vince Weaver escreveu:
>> Hello
>>
>> has anyone tested the perf tool cgroup support recently?
>>
>> I was trying to get it working with a command like
>>       sudo perf stat -a -e cycles:u,cycles:u,cycles:u -G systemd -- sleep 1
>>
It fails for me on Ubuntu Trusty as well. I think they have changed
the way cgroup
fs is visible. The cgroup file system type is not there anymore. They are using
tmpfs which is not ideal to detect just cgroup. Looks like now, we have to look
at the mount point which is flaky.


>> and it just failed by unhelfully dumping the "-G" help text.
>> Once I added a lot of extra debug printfs to tools/perf/util/cgroup.c
>> things became a little clearer.
>>
>> First, you apparently need "perf_event" passed as a mount option to the
>> cgroup or you cannot attach perf to it (should perf be modified to
>> print a warning in this case rather than just printing the unhelpful
>> helf text?)
>
> yes, please
>
Yes, the error needs to be improved or even added. The following common
errors are encountered:

- -G option requires -a (system-wide), otherwise it does not work at all
- -G option must always be specified AFTER the ALL event list
- -G and explicit event groups is not well supported by the tool yet.
An event group must have the same cgroup.
- Cgroups are specified per event
- -G cgroup order follows the event order: -e e1, e2, e3 -G g1,g2,g3:
g1->e1, g2->e2, g3->e3
- It is possible to indicate no cgroup with -G: -e e1,e2,e3 -G g1,,g3
using empty group (,,)


>> Secondly, the cgroup mount point detection completely fails on my debian
>> box.  On my machine /proc/mounts has this:
>>
>>   ...
>>   none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0

Yes, my Ubuntu system too.

>>   systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0
>>
>> The current perf code looks for "cgroup" in the type field to find the
>> root cgroupfs tree.  This fails because as seen above on my machine the
>> cgroup mount has type tmpfs.  And when it finds
>> /sys/fs/cgroup/systemd as the root it tacks the name onto the end
>> (/sys/fs/cgroup/systemd/systemd) which obviously doesn't exist.
>>
>> Once I hack the code to avoid that I do finally get some cgroup readings.
>>
>> I was checking if this was a known problem, a Debian issue, or what...
>
Obviously, the way cgroups are exposed has changed since I wrote the code
an it needs to update. Thanks for looking into this.

> Its just that the cgroup support is rough, patches are welcome to
> improve the situation.
>
> BTW, here its fedora20, same problem:
>
> [root@zoo ~]# mount | grep cgroup
> tmpfs on /sys/fs/cgroup type tmpfs
> (rw,nosuid,nodev,noexec,seclabel,mode=755)
> cgroup on /sys/fs/cgroup/systemd type cgroup
> (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
>
> - Arnaldo

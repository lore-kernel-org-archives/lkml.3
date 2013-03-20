Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab3CTA3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:29:11 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55246 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3CTA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:29:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Benoit Lourdelet <blourdel@juniper.net>, linux-kernel@vger.kernel.org,
        lxc-users <lxc-users@lists.sourceforge.net>
References: <20130319182829.GA15451@sergelap>
	<CD6E73D8.71FE%blourdel@juniper.net> <20130319203422.GA27263@sergelap>
Date: Tue, 19 Mar 2013 17:29:00 -0700
In-Reply-To: <20130319203422.GA27263@sergelap> (Serge Hallyn's message of
	"Tue, 19 Mar 2013 15:34:22 -0500")
Message-ID: <87txo6ewxf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+YvjO7p7Pyc75Opt+j1Kt9mriLOIxnHgA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [Lxc-users] Containers slow to start after 1600
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Hi,
>
> Benoit was kind enough to follow up on some scalability issues with
> larger (but not huge imo) numbers of containers.  Running a script
> to simply time the creation of veth pairs on a rather large (iiuc)
> machine, he got the following numbers (time is for creation of the
> full number, not latest increment - so 1123 seconds to create 5000
> veth pairs)

A kernel version and a profile would be interesting.

At first glance it looks like things are dramatically slowing down as
things get longer which should not happen.

There used to be quadratic issues in proc and sysfs that should have
been reduced to O(NlogN) as of 3.4 or so.  A comparison to the dummy
device which is a touch simpler than veth and is more frequently
benchmarked could also be revealing.

>> >Quoting Benoit Lourdelet (blourdel@juniper.net):
>> >> Hello Serge,
>> >> 
>> >> I put together a small table, running your script for various values :
>> >> 
>> >> Time are in seconds,
>> >> 
>> >> Number of veth, time to create, time to delete:
>> >> 
>> >> 500  18  26
>> >> 
>> >> 1000 57 70
>> >> 
>> >> 2000 193 250
>> >> 
>> >> 3000 435 510
>> >> 
>> >> 4000 752  824
>> >> 
>> >> 5000 1123  1185
>
>> 
>> Benoit
>
> Ok.  Ran some tests on a tiny cloud instance.  When I simply run 2k tasks in
> unshared new network namespaces, it flies by.
>
> #!/bin/sh
> rm -f /tmp/timings3
> date | tee -a /tmp/timings3
> for i in `seq 1 2000`; do
>     nsexec -n -- /bin/sleep 1000 &
>     if [ $((i % 100)) -eq 0 ]; then
>            echo $i | tee -a /tmp/timings3
>            date | tee -a /tmp/timings3
>     fi
> done
>
> (all scripts run under sudo, and nsexec can be found at
> https://code.launchpad.net/~serge-hallyn/+junk/nsexec))
>
> So that isn't an issue.
>
> When I run a script to just time veth pair creations like Benoit ran,
> creating 2000 veth pairs and timing the results for each 100, the time
> does degrade, from 1 second for the first 100 up to 8 seconds for the
> last 100.
>
> (that script for me is:
>
> #!/bin/sh
> rm -f /tmp/timings
> for i in `seq 1 2000`; do
>        ip link add type veth
>        if [ $((i % 100)) -eq 0 ]; then
>                echo $i | tee -a /tmp/timings
>                date | tee -a /tmp/timings
>                ls /sys/class/net > /dev/null
>        fi
> done
> )
>
> But when I actually pass veth instances to those unshared network
> namespaces:
>
> #!/bin/sh
> rm -f /tmp/timings2
> echo 0 | tee -a /tmp/timings2
> date | tee -a /tmp/timings2
> for i in `seq 1 2000`; do
>     nsexec -n -P /tmp/pid.$i -- /bin/sleep 1000 &
>     ip link add type veth
>     dev2=`ls -d /sys/class/net/veth* | tail -1`
>     dev=`basename $dev2`
>     pid=`cat /tmp/pid.$i`
>     ip link set $dev netns $pid
>     if [ $((i % 100)) -eq 0 ]; then
>            echo $i | tee -a /tmp/timings2
>            date | tee -a /tmp/timings2
>     fi
>     rm -f /tmp/pid.*
> done
>
> it goes from 4 seconds for the first hundred to 16 seconds for
> the last hundred - a worse regression than simply creating the
> veths.  Though I guess that could be accounted for simply by
> sysfs actions when a veth is moved from the old netns to the
> new?

And network stack actions.  Creating one end of the veth in the desired
network namespace is likely desirable. "ip link add type veth peer netns ..."

rcu in the past has also played a critical role, as what the network
configuration is when devices are torn down.

For device movement and device teardown there is at least one
synchronize_rcu, which at scale can slow things down. But if the
syncrhonize_rcu dominates it should be mostly a constant factor cost not
something that gets worse with each device creation.

Oh and to start with I would specify the name of each network device to
create.  Last I looked coming up with a network device name is a O(N)
operation in the number of device names.

Just to see what I am seeing in 3.9-rc1 I did:

# time for i in $(seq 1 2000) ; do ip link add a$i type veth peer name b$i; done
real	0m23.607s
user	0m0.656s
sys	0m18.132s

# time for i in $(seq 1 2000) ; do ip link del a$i ; done
real	2m8.038s
user	0m0.964s
sys	0m18.688s

Which is tremendously better than you are reporting below for device creation.
Now the deletes are still slow because it is hard to back that kind of
delete, having a bunch of network namespaces exit all at once would
likely be much faster as they can be batched and the syncrhonize_rcu
calls drastically reduced.

What is making you say there is a regression?  A regression compared to what?

Hmm.

# time for i in $(seq 1 5000) ; do ip link add a$i type veth peer name b$i; done
real	2m11.007s
user	0m3.508s
sys	1m55.452s

Ok there is most definitely something non-linear about the cost of
creating network devices.

I am happy to comment from previous experience but I'm not volunteering
to profile and fix this one.

Eric


> 0
> Tue Mar 19 20:15:26 UTC 2013
> 100
> Tue Mar 19 20:15:30 UTC 2013
> 200
> Tue Mar 19 20:15:35 UTC 2013
> 300
> Tue Mar 19 20:15:41 UTC 2013
> 400
> Tue Mar 19 20:15:47 UTC 2013
> 500
> Tue Mar 19 20:15:54 UTC 2013
> 600
> Tue Mar 19 20:16:02 UTC 2013
> 700
> Tue Mar 19 20:16:09 UTC 2013
> 800
> Tue Mar 19 20:16:17 UTC 2013
> 900
> Tue Mar 19 20:16:26 UTC 2013
> 1000
> Tue Mar 19 20:16:35 UTC 2013
> 1100
> Tue Mar 19 20:16:46 UTC 2013
> 1200
> Tue Mar 19 20:16:57 UTC 2013
> 1300
> Tue Mar 19 20:17:08 UTC 2013
> 1400
> Tue Mar 19 20:17:21 UTC 2013
> 1500
> Tue Mar 19 20:17:33 UTC 2013
> 1600
> Tue Mar 19 20:17:46 UTC 2013
> 1700
> Tue Mar 19 20:17:59 UTC 2013
> 1800
> Tue Mar 19 20:18:13 UTC 2013
> 1900
> Tue Mar 19 20:18:29 UTC 2013
> 2000
> Tue Mar 19 20:18:48 UTC 2013
>
> -serge

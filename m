Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab3CSUeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:34:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3CSUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:34:30 -0400
Date: Tue, 19 Mar 2013 15:34:22 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Benoit Lourdelet <blourdel@juniper.net>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lxc-users <lxc-users@lists.sourceforge.net>
Subject: Re: [Lxc-users] Containers slow to start after 1600
Message-ID: <20130319203422.GA27263@sergelap>
References: <20130319182829.GA15451@sergelap>
 <CD6E73D8.71FE%blourdel@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD6E73D8.71FE%blourdel@juniper.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Benoit was kind enough to follow up on some scalability issues with
larger (but not huge imo) numbers of containers.  Running a script
to simply time the creation of veth pairs on a rather large (iiuc)
machine, he got the following numbers (time is for creation of the
full number, not latest increment - so 1123 seconds to create 5000
veth pairs)

> >Quoting Benoit Lourdelet (blourdel@juniper.net):
> >> Hello Serge,
> >> 
> >> I put together a small table, running your script for various values :
> >> 
> >> Time are in seconds,
> >> 
> >> Number of veth, time to create, time to delete:
> >> 
> >> 500  18  26
> >> 
> >> 1000 57 70
> >> 
> >> 2000 193 250
> >> 
> >> 3000 435 510
> >> 
> >> 4000 752  824
> >> 
> >> 5000 1123  1185

> 
> Benoit

Ok.  Ran some tests on a tiny cloud instance.  When I simply run 2k tasks in
unshared new network namespaces, it flies by.

#!/bin/sh
rm -f /tmp/timings3
date | tee -a /tmp/timings3
for i in `seq 1 2000`; do
    nsexec -n -- /bin/sleep 1000 &
    if [ $((i % 100)) -eq 0 ]; then
           echo $i | tee -a /tmp/timings3
           date | tee -a /tmp/timings3
    fi
done

(all scripts run under sudo, and nsexec can be found at
https://code.launchpad.net/~serge-hallyn/+junk/nsexec))

So that isn't an issue.

When I run a script to just time veth pair creations like Benoit ran,
creating 2000 veth pairs and timing the results for each 100, the time
does degrade, from 1 second for the first 100 up to 8 seconds for the
last 100.

(that script for me is:

#!/bin/sh
rm -f /tmp/timings
for i in `seq 1 2000`; do
       ip link add type veth
       if [ $((i % 100)) -eq 0 ]; then
               echo $i | tee -a /tmp/timings
               date | tee -a /tmp/timings
               ls /sys/class/net > /dev/null
       fi
done
)

But when I actually pass veth instances to those unshared network
namespaces:

#!/bin/sh
rm -f /tmp/timings2
echo 0 | tee -a /tmp/timings2
date | tee -a /tmp/timings2
for i in `seq 1 2000`; do
    nsexec -n -P /tmp/pid.$i -- /bin/sleep 1000 &
    ip link add type veth
    dev2=`ls -d /sys/class/net/veth* | tail -1`
    dev=`basename $dev2`
    pid=`cat /tmp/pid.$i`
    ip link set $dev netns $pid
    if [ $((i % 100)) -eq 0 ]; then
           echo $i | tee -a /tmp/timings2
           date | tee -a /tmp/timings2
    fi
    rm -f /tmp/pid.*
done

it goes from 4 seconds for the first hundred to 16 seconds for
the last hundred - a worse regression than simply creating the
veths.  Though I guess that could be accounted for simply by
sysfs actions when a veth is moved from the old netns to the
new?

0
Tue Mar 19 20:15:26 UTC 2013
100
Tue Mar 19 20:15:30 UTC 2013
200
Tue Mar 19 20:15:35 UTC 2013
300
Tue Mar 19 20:15:41 UTC 2013
400
Tue Mar 19 20:15:47 UTC 2013
500
Tue Mar 19 20:15:54 UTC 2013
600
Tue Mar 19 20:16:02 UTC 2013
700
Tue Mar 19 20:16:09 UTC 2013
800
Tue Mar 19 20:16:17 UTC 2013
900
Tue Mar 19 20:16:26 UTC 2013
1000
Tue Mar 19 20:16:35 UTC 2013
1100
Tue Mar 19 20:16:46 UTC 2013
1200
Tue Mar 19 20:16:57 UTC 2013
1300
Tue Mar 19 20:17:08 UTC 2013
1400
Tue Mar 19 20:17:21 UTC 2013
1500
Tue Mar 19 20:17:33 UTC 2013
1600
Tue Mar 19 20:17:46 UTC 2013
1700
Tue Mar 19 20:17:59 UTC 2013
1800
Tue Mar 19 20:18:13 UTC 2013
1900
Tue Mar 19 20:18:29 UTC 2013
2000
Tue Mar 19 20:18:48 UTC 2013

-serge

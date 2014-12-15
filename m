Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaLOWP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:15:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:54926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOWPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:15:55 -0500
Date: Mon, 15 Dec 2014 19:01:50 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [perf tool] cgroup support broken on Debian?
Message-ID: <20141215220150.GP9845@kernel.org>
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 15, 2014 at 04:07:46PM -0500, Vince Weaver escreveu:
> Hello
> 
> has anyone tested the perf tool cgroup support recently?
> 
> I was trying to get it working with a command like
> 	sudo perf stat -a -e cycles:u,cycles:u,cycles:u -G systemd -- sleep 1
> 
> and it just failed by unhelfully dumping the "-G" help text.
> Once I added a lot of extra debug printfs to tools/perf/util/cgroup.c 
> things became a little clearer.
> 
> First, you apparently need "perf_event" passed as a mount option to the 
> cgroup or you cannot attach perf to it (should perf be modified to 
> print a warning in this case rather than just printing the unhelpful
> helf text?)

yes, please
 
> Secondly, the cgroup mount point detection completely fails on my debian 
> box.  On my machine /proc/mounts has this:
> 
>   ...
>   none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
>   systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0
> 
> The current perf code looks for "cgroup" in the type field to find the 
> root cgroupfs tree.  This fails because as seen above on my machine the
> cgroup mount has type tmpfs.  And when it finds
> /sys/fs/cgroup/systemd as the root it tacks the name onto the end
> (/sys/fs/cgroup/systemd/systemd) which obviously doesn't exist.
> 
> Once I hack the code to avoid that I do finally get some cgroup readings.
> 
> I was checking if this was a known problem, a Debian issue, or what...

Its just that the cgroup support is rough, patches are welcome to
improve the situation.

BTW, here its fedora20, same problem:

[root@zoo ~]# mount | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs
(rw,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup
(rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)

- Arnaldo

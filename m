Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbaLOVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:07:30 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37228 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLOVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:07:29 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 15 Dec 2014 16:07:46 -0500 (EST)
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [perf tool] cgroup support broken on Debian?
Message-ID: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

has anyone tested the perf tool cgroup support recently?

I was trying to get it working with a command like
	sudo perf stat -a -e cycles:u,cycles:u,cycles:u -G systemd -- sleep 1

and it just failed by unhelfully dumping the "-G" help text.
Once I added a lot of extra debug printfs to tools/perf/util/cgroup.c 
things became a little clearer.

First, you apparently need "perf_event" passed as a mount option to the 
cgroup or you cannot attach perf to it (should perf be modified to 
print a warning in this case rather than just printing the unhelpful
helf text?)

Secondly, the cgroup mount point detection completely fails on my debian 
box.  On my machine /proc/mounts has this:

  ...
  none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
  systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0

The current perf code looks for "cgroup" in the type field to find the 
root cgroupfs tree.  This fails because as seen above on my machine the
cgroup mount has type tmpfs.  And when it finds
/sys/fs/cgroup/systemd as the root it tacks the name onto the end
(/sys/fs/cgroup/systemd/systemd) which obviously doesn't exist.

Once I hack the code to avoid that I do finally get some cgroup readings.

I was checking if this was a known problem, a Debian issue, or what...

Vince


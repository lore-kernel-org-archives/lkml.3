Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaJGXcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:32:04 -0400
Received: from roy.gaast.net ([80.101.33.21]:33740 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaJGXcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:32:00 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 19:32:00 EDT
Message-ID: <54347520.3050109@gaast.net>
Date: Wed, 08 Oct 2014 00:20:00 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org
Subject: Machine crashes right *after* ~successful resume
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rafael, including you on this since 
http://linuxconcloudopenna2013.sched.org/event/d708f47d07cd44b9669610778c024708#.VDRzTDS_EUF 
mentions you as the maintainer for Linux + power management. I hope this 
is still accurate.

Since Linux 3.12 (Debian version 3.12.9-1~bpo70+1) and all the way up to 
3.16 (Debian version 3.16.3-2), I'm having suspend-resume issues on my 
machine (Intel Z68, i7-3770K) that are somewhat less obvious.

After every boot, I get two successful suspend+resume cycles, but after 
the third suspend, it won't resume successfully. On the VGA console I've 
never had anything useful logged, luckily over the serial console I've 
had more luck. I seem to get as far as:

[  153.787678] PM: resume of devices complete after 3797.737 msecs
[  153.787775] PM: resume devices took 3.796 seconds
[  154.238612] Restarting tasks ... done.

And indeed, while testing I was running a "ping -i0.01" to a host on my 
network, and it managed to get a few packets out. Timing already seems 
quite off though:

22:11:49.515489 IP 192.168.44.101 > 192.168.44.100: ICMP echo request, 
id 3074, seq 894, length 64
22:11:49.982265 IP 192.168.44.101 > 192.168.44.100: ICMP echo request, 
id 3074, seq 895, length 64
22:11:50.986779 IP 192.168.44.101 > 192.168.44.100: ICMP echo request, 
id 3074, seq 896, length 64

Note the gaps that are 0.4-1.0s instead of the 0.01s they should've 
been. To me these pings going *out* sound like userland's definitely 
waking up for a while, or at least some processes are. Also, for several 
seconds even during earlier stages of the resume, the machine is already 
responding to echo requests.

Sadly after this message to my serial console and these few ICMP 
packets, the machine locks up quite hard, to the point that SysRq 
doesn't respond anymore. :-(

This is happening for a while already and makes suspend+resume mostly 
useless on my machine. What other debugging info can I provide to help 
with getting this fixed?

I've found out about pm_trace, which always points at the same line (and 
no device):

/var/log/syslog.1:Oct 10 16:43:58 ruby kernel: [    0.780503]   Magic 
number: 0:52:740
/var/log/syslog.1:Oct 10 16:43:58 ruby kernel: [    0.780599]   hash 
matches /tmp/linux-3.16.3/drivers/base/power/main.c:812

In my source tree that line is:

         TRACE_RESUME(error);

Right at the end of device_resume(), under the Complete: label. Note 
that I might have to redo this though, as I now realise I had only 
recompiled my *kernel* with the PM_TRACE_RTC flag set, not all my 
modules, which I assume is not enough. (I'm thinking of filing a Debian 
bug requesting this flag to be enabled by default..) However since the 
kernel seems to declare the resume as complete I'm not sure whether 
pm_trace is still of any use?

With kernels 3.10 and older I have no such problems, I can 
suspend+resume as often as I want.

I've already tried to skip the NVidia + VMware modules at boot time (as 
you can see from the logs they're not loaded at any point), but it 
didn't help. I could try omitting more modules.

I'm attaching a full dmesg of boot + a few suspend+resume cycles in 3.10 
and 3.16, and a dump of the serial console showing the last resume cycle 
(which I couldn't get from dmesg of course).

You might notice the message about s2ram segfaulting which I've looked 
at, that seems to be VBE-related code, but this problem occurs even when 
I just echo ram to /sys/power/state directly without using s2ram, so I 
assume it's not related.

Sorry for the long message. I'd love some ideas for troubleshooting an 
issue like this.

"Attachments" in http://roy.gaast.net/~wilmer/.lkml/ since I just 
realised >200KB of attachments might not be appreciated. :-)


Cheers,

Wilmer van der Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +

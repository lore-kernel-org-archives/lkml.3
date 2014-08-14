Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaHNPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:33:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:59593 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbaHNPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:33:18 -0400
Date: Thu, 14 Aug 2014 12:33:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf probe: request: Better message when no debug info is found on
 vmlinux
Message-ID: <20140814153312.GO2718@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

	I was trying to figure out why sys_perf_event_open was returning
EACCES when trying to record, as a non priviledged user, a 'ping'
process started by this user, while it has no problem doing the same
thing if the monitored process is 'sleep' (reusing of ptrace perms seems
to be what is causing this, but I digress), when I stumbled in something
annoying:

  [root@ssdandy ~]# perf probe -v -L icmp_rcv
  Looking at the vmlinux_path (6 entries long)
  Using /lib/modules/3.16.0+/build/vmlinux for symbols
  Failed to open debuginfo file.
    Error: Failed to show lines. (-2)
  [root@ssdandy ~]# 

Huh? Why? So I went to look to see why it was "failing to open debuginfo
file":

  [root@ssdandy ~]# ls -la /lib/modules/3.16.0+/build/vmlinux
  -rwxrwxr-x. 3 acme acme 22505817 Aug 13 11:54
  /lib/modules/3.16.0+/build/vmlinux
  [root@ssdandy ~]# ls -la /lib/modules/3.16.0+/build
  lrwxrwxrwx. 1 root root 29 Aug 13 12:10 /lib/modules/3.16.0+/build ->
  /home/acme/git/build/v3.16.0+

The file is there, but... I forgot I had disabled CONFIG_DEBUG_INFO on
this machine:

  [root@ssdandy ~]# ls -la /lib/modules/3.16.0+/build/.config
  -rw-rw-r--. 1 acme acme 136217 Aug 13 11:40
  /lib/modules/3.16.0+/build/.config
  [root@ssdandy ~]# grep CONFIG_DEBUG_INFO
  /lib/modules/3.16.0+/build/.config
  # CONFIG_DEBUG_INFO is not set
  [root@ssdandy ~]# 

So, only the CFI ELF section was there, not the other with the -g stuff:

  [root@ssdandy ~]# readelf -SW /lib/modules/3.16.0+/build/vmlinux | grep \.debug_
    [29] .debug_frame  PROGBITS  0000000000000000 1266030 0021d0 00  0   0  8
  [root@ssdandy ~]#

So, I suggest that we improve that error message to be more clear:

  [root@ssdandy ~]# perf probe -L icmp_rcv
  Failed to open debuginfo file.
    Error: The /lib/modules/3.16.0+/build/vmlinux file has no
           debugging information, rebuild with CONFIG_DEBUG_INFO=y

  [root@ssdandy ~]# 

Since it knows it is a kernel image file, and that the config option to
enable it is CONFIG_DEBUG_INFO.

Thanks,

- Arnaldo


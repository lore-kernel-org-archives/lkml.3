Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaLVJwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:52:33 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46606 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaLVJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:52:32 -0500
Subject: [PATCH trace-cmd V5 0/6] perf-probe: Bugfix and add new options for
 cache
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:47:36 -0500
Message-ID: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the version 5 series of virtio-trace for trace-cmd.
The previous series is here; https://lkml.org/lkml/2014/7/10/747 

I took over this work from Yoshihiro Yunomae. This version includes
some fixes.
 - Add -N support for extract subcommand(1/6).
 - As Steven suggested, this send "-1V2\0<MAGIC>\0" instead
   of "V2\0<MAGIC>\0" at first.
 - Add a document of Protocol change in Documentation/Protocol.txt.
   (Now all the protocol descriptions are moved into that)
 - Cleanup the code and document a bit.

How to use
==========
1. Run virt-server on a host
   # trace-cmd virt-server --dom guest1 -c 2

2. Set up of virtio-serial pipe of guest1 on the host
   Add the following tags to domain XML files.
   # virsh edit guest1
   <channel type='unix'>
      <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
      <target type='virtio' name='agent-ctl-path'/>
   </channel>
   <channel type='pipe'>
      <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu0'/>
      <target type='virtio' name='trace-path-cpu0'/>
   </channel>
   <channel type='pipe'>
      <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu1'/>
      <target type='virtio' name='trace-path-cpu1'/>
   </channel>

3. Boot the guest
   # virsh start guest1

4. Run the guest1's client(see trace-cmd-record(1) with the *--virt* option)
   # trace-cmd record -e sched* --virt

If you want to boot another guest sends trace-data via virtio-serial,
you will manually make the guest domain directory and trace data I/Fs.

- Make guest domain directory on the host
   # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
   # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
   # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>

- Make FIFO on the host
   # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}

TODO
====
 - Don't use fixed directory and fifos. Make it flexible.
 - Don't depend on the libvirt. We can find fifos in /proc/<pid>/fd/*.
 - Cleanup the code. It is not well structured now.

Thank you,

---

Masami Hiramatsu (6):
      trace-cmd: Support -N option for trace-cmd extract
      trace-cmd/listen: Introduce trace-msg protocol (protocol v2)
      trace-cmd/msg: Use poll(2) to wait for a message
      trace-cmd/virt-server: Add virt-server mode for a virtualization environment
      trace-cmd/record: Add --virt option for record mode
      trace-cmd/virt-server: Add --dom option which makes a domain directory to virt-server


 Documentation/Protocol.txt                |  163 +++++
 Documentation/trace-cmd-record.1.txt      |   11 
 Documentation/trace-cmd-virt-server.1.txt |  113 ++++
 Makefile                                  |    2 
 trace-cmd.c                               |    3 
 trace-cmd.h                               |   15 +
 trace-listen.c                            |  666 +++++++++++++++++++---
 trace-msg.c                               |  870 +++++++++++++++++++++++++++++
 trace-msg.h                               |   31 +
 trace-output.c                            |    4 
 trace-record.c                            |  160 +++++
 trace-recorder.c                          |   50 +-
 trace-usage.c                             |   18 +
 13 files changed, 1966 insertions(+), 140 deletions(-)
 create mode 100644 Documentation/Protocol.txt
 create mode 100644 Documentation/trace-cmd-virt-server.1.txt
 create mode 100644 trace-msg.c
 create mode 100644 trace-msg.h

--
Masami HIRAMATSU
Software Platform Research Dpt. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


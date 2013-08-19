Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3HSJmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36472 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3HSJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:04 -0400
X-AuditID: 85900ec0-d1d29b9000001514-3a-5211e86a3e81
Subject: [RFC PATCH 00/11] trace-cmd: Support the feature recording trace
 data of guests on the host
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:20 +0900
Message-ID: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I'm considering "Integrated trace" which is a trace merging system for a
virtualization environment. Why do we need this system? Because we want to
analyze latency problems for a virtualization environment. For example, a host
OS runs two guest OSs and those OSs are sharing HW devices like CPUs, NIC, disk,
etc. In the situation, it will be difficult to directly tackle I/O delay
problems. This is because we don't have any methods which all trace data are
shown. The integrated trace will solve this problem by merging trace data in
chronological order. Moreover, the integrated trace will support the feature
collecting trace data of guests and a host on the host.

I want to support above two big features in trace-cmd. However, trace-cmd does
not have following features yet:

a) server and client for a virtualization environment
b) structured message platform between guests and a host
c) agent feature of a client
d) merge feature of trace data of multiple guests and a host in chronological
   order

This patch set supports above a) and b) features.

<overall view>

        +------------+        +------------+
Guest   |   a), c)   |        |   a), c)   | client/agent
  ^     +------------+        +------------+
  |         ^   ^                 ^   ^
============|===|=================|===|===========
  |         v b)v                 v b)v
  v     +----------------------------------+
Host    |               a)                 | server
        +----------------------------------+
            ||output    ||         ||
            \/          \/         \/
        /--------+  /--------+  /--------+
        | 010101 |  | 101010 |  | 100101 | binary data
        | 010100 |  | 010100 |  | 110011 |
        +--------+  +--------+  +--------+
      \                                     /
       \-----------------------------------/
                       || d)
                       \/
       /-----------------------------------+
       | (guest1) 123456: sched_switch...  | text data
       | (guest2) 123458: kmem_free...     |
       | (host)   123500: kvm_exit (guest1)|
       | (host)   123510: kvm_entry(guest1)|
       | (guest1) 123550: sched_switch...  |
       +-----------------------------------+

a) server and client for a virtualization environment
 trace-cmd has listen mode for network, but using network will be a high cost
operation for inducing a lot of memory copying. From kernel-3.6, the
virtio-console driver supports splice_write and ftrace supports "steal" for
fops. So, guest clients of trace-cmd can send trace data without copying memory 
by using splice(2). If guest clients use virtio-serial, the server also needs to
support virtio-serial I/F.

b) structured message platform between guests and a host
 Currently, a server(clients) sends unstructured character string to
clients(server), so clients(server) must parse the unstructured messages.
Since it is hard to add complex contents in the protocol, structured binary
message trace-msg is introduced as the communication protocol.

c) agent feature of a client
 Current trace-cmd client can operate only as "record" mode, so the client
will send trace data to the server immediately. However, when an user tries to
collect trace data of multiple guests on a host, the user must log in to
each guest. This is hard to use, I think. So, trace-cmd client had better
support agent mode which receives a message from the server.

d) merge feature of trace data of multiple guests and a host in chronological
   order
 Current trace-cmd cannot merge trace data of multiple guests and a host in
chronological order. If an user wants to analyze an I/O delay problem of a
guest, the user will want to check trace data of all guests and the host in a
file. However, trace-cmd does not support a merge feature yet, the user must
make a merging script. So, trace-cmd had better support a merge feature for
multiple files for virtualization.

For a), this patch introduces "virt-server" and "record --virt" modes for
achieving low-overhead communication of trace data of guests. "virt-server" is a
server mode for collecting trace data of guests. On the other hand,
"record --virt" mode is a guest client for sending trace data of the guest.
Although these functions are similar to "listen" and "record -N" modes each,
these do not use network but use virtio-serial for low-overhead communication.

For b), this patch series introduce specific message protocol in order to handle
communication messages with 8 commands. When we extend any messages, using
structured message will be easier than using unstructured message.

<How to use>
1. Run virt-server on a host
   # trace-cmd virt-server

2. Make guest domain directory
   # mkdir -p /tmp/trace-cmd/virt/<domain>
   # chmod 710 /tmp/trace-cmd/virt/<domain>
   # chgrp qemu /tmp/trace-cmd/virt/<domain>

3. Make FIFO on the host
   # mkfifo /tmp/trace-cmd/virt/<domain>/trace-path-cpu{0,1,...,X}.{in,out}

4. Set up of virtio-serial pipe of a guest on the host
   Add the following tags to domain XML files.
   # virsh edit <domain>
   <channel type='unix'>
      <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
      <target type='virtio' name='agent-ctl-path'/>
   </channel>
   <channel type='pipe'>
      <source path='/tmp/trace-cmd/virt/<domain>/trace-path-cpu0'/>
      <target type='virtio' name='trace-path-cpu0'/>
   </channel>
   ... (cpu1, cpu2, ...)

5. Boot the guest
   # virsh start <domain>

6. Execute "record --virt" on the guest
   # trace-cmd record --virt -e sched*

<Result>
I measured CPU usage outputted by top command on a guest when client sends
trace data. Client means "record -N"(NW) or "record --virt"(virtio-serial).

                      NW     virtio-serial(splice)
client(fedora19)    ~2.9[%]       ~1.7[%]

<Future work>
- Add an agent mode based on "record --virt"
- Add a merging feature of trace data of guests and host to "report"

I need your comments!
Thank you,

---

Yoshihiro YUNOMAE (11):
      [TRIVIAL] trace-cmd: Delete the variable iface in trace-listen
      [BUGFIX] trace-cmd: Add waitpid() when recorders are destoried
      [BUGFIX]trace-cmd: Quit from splice(read) if there are no data
      [CLEANUP] trace-cmd: Split out the communication with listener from setup_network()
      [CLEANUP] trace-cmd: Split out the connect waiting loop from do_listen()
      [CLEANUP] trace-cmd: Split out the communication with client from process_client()
      [CLEANUP] trace-cmd: Split out binding a port and fork reader from open_udp()
      trace-cmd: Apply the trace-msg protocol for communication between a server and clients
      trace-cmd: Use poll(2) to wait for a message
      trace-cmd: Add virt-server mode for a virtualization environment
      trace-cmd: Add --virt option for record mode


 Documentation/trace-cmd-record.1.txt      |   11 
 Documentation/trace-cmd-virt-server.1.txt |   89 +++
 Makefile                                  |    2 
 trace-cmd.c                               |    3 
 trace-cmd.h                               |   15 +
 trace-listen.c                            |  690 ++++++++++++++++-------
 trace-msg.c                               |  864 +++++++++++++++++++++++++++++
 trace-msg.h                               |   25 +
 trace-output.c                            |    4 
 trace-record.c                            |  138 ++---
 trace-recorder.c                          |   59 +-
 trace-usage.c                             |   10 
 12 files changed, 1602 insertions(+), 308 deletions(-)
 create mode 100644 Documentation/trace-cmd-virt-server.1.txt
 create mode 100644 trace-msg.c
 create mode 100644 trace-msg.h

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

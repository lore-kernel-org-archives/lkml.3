Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LQDAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:00:22 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37407 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3LQDAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:00:20 -0500
X-AuditID: 85900ec0-d312bb9000001514-ac-52afbe424fea
Subject: [PATCH V3 0/6] trace-cmd: Support the feature recording trace data
 of guests on the host
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 17 Dec 2013 12:00:17 +0900
Message-ID: <20131217030017.31730.66046.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This is a v3 patch set for realizing a part of "Integrated trace" feature which 
is a trace merging system for a virtualization environment. Currently, trace-cmd
does not have following features yet:

a) Server and client for a virtualization environment
b) Structured message platform between guests and host
c) Agent feature of a client
d) Merge feature of trace data of multiple guests and host in chronological
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

a) Server and client for a virtualization environment
 trace-cmd has listen mode for network, but using network will be a high cost
operation for inducing a lot of memory copying. From kernel-3.6, the
virtio-console driver supports splice_write and ftrace supports "steal" for
fops. So, guest clients of trace-cmd can send trace data without copying memory 
by using splice(2). If guest clients use virtio-serial, the server also needs to
support virtio-serial I/F.

b) Structured message platform between guests and a host
 Currently, a server(clients) sends unstructured character string to
clients(server), so clients(server) must parse the unstructured messages.
Since it is hard to add complex contents in the protocol, structured binary
message trace-msg is introduced as the communication protocol.

c) Agent feature of a client
 Current trace-cmd client can operate only as "record" mode, so the client
will send trace data to the server immediately. However, when an user tries to
collect trace data of multiple guests on a host, the user must log in to
each guest. This is hard to use, I think. So, trace-cmd client had better
support agent mode which receives a message from the server.

d) Merge feature of trace data of multiple guests and a host in chronological
   order
 Current trace-cmd has a merge feature for multiple machines whose times are
synchronized by NTP. When we use the feature, we execute "trace-cmd record"
with --date option on each machine, and then we run "trace-cmd report" with -i
option for each file.
 However, there are cases that times of those machines cannot be synchronized.
For example, although multiple users can run guests on virtualization
environments (e.g. multi-tenant cloud hosting), there are no guarantee that
they use the same NTP server. Moreover, even if the times are synchronized,
trace data cannot exactly be merged because the NTP-synchronized time
granularity may not be enough fine for sorting guest-host switching events.
 So, I'm considering that trace data use x86-tsc as timestamp in order to merge 
trace data. By using x86-tsc, we can merge trace data even if time of those
machines is not synchronized when CPU has the invariant TSC feature or the
constant TSC feature. And the precision will be enough for understanding
operations of guests and host. However, TSC values on a guest are not equal to
the values on the host because
         TSC_guest = TSC_host + TSC_offset.
 This series actually doesn't support TSC offset, but I'd like to add such
feature to fix host/guest clock difference in the other series. TSC offset
values can be gotten as write_tsc_offset trace event from kernel-3.11.
(see https://lkml.org/lkml/2013/6/12/72)

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

<Result>
I measured CPU usage outputted by top command on a guest when client sends
trace data. Client means "record -N"(NW) or "record --virt"(virtio-serial).

                      NW     virtio-serial(splice)
client(fedora19)    ~2.9[%]       ~1.7[%]

<Future work>
- Add an agent mode based on "record --virt"
- Add a merging feature of trace data of guests and host to "report"

Changes in V2:
[1/5] Add a comment in open_udp()
[2/5] Regacy protocol support in order to keep backward compatibility

Changes in V3:
[2/6] Change the license of trace-msg.c to LGPL v2.1
[4/6] Change _nw/_NW to _net/_NET
[5/6] Change _nw/_NW to _net/_NET
[6/6] Add this patch based on Steven's review
      (https://lkml.org/lkml/2013/10/14/618)

Thank you,

---

Yoshihiro YUNOMAE (6):
      [CLEANUP] trace-cmd: Split out binding a port and fork reader from open_udp()
      trace-cmd: Apply the trace-msg protocol for communication between a server and clients
      trace-cmd: Use poll(2) to wait for a message
      trace-cmd: Add virt-server mode for a virtualization environment
      trace-cmd: Add --virt option for record mode
      trace-cmd: Add --dom option which makes a domain directory to virt-server


 Documentation/trace-cmd-record.1.txt      |   11 
 Documentation/trace-cmd-virt-server.1.txt |  116 ++++
 Makefile                                  |    2 
 trace-cmd.c                               |    3 
 trace-cmd.h                               |   14 
 trace-listen.c                            |  727 ++++++++++++++++++++----
 trace-msg.c                               |  874 +++++++++++++++++++++++++++++
 trace-msg.h                               |   31 +
 trace-output.c                            |    4 
 trace-record.c                            |  146 ++++-
 trace-recorder.c                          |   54 +-
 trace-usage.c                             |   10 
 12 files changed, 1825 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/trace-cmd-virt-server.1.txt
 create mode 100644 trace-msg.c
 create mode 100644 trace-msg.h

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaGKA6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:58:31 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60469 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGKA6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:58:30 -0400
X-AuditID: 85900ec0-d1328b9000001514-99-53bf36b27444
Subject: [PATCHV4 0/5] trace-cmd: Support the feature which guests send
 trace data via virtio
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>
Date: Fri, 11 Jul 2014 00:58:24 +0000
Message-ID: <20140711005824.25516.24498.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This is a v4 patch set to support the feature which guests send trace data via
virtio. (Previous patch set is here: https://lkml.org/lkml/2013/12/16/688)

Any features in this V4 patch series are not changed from previous version.
I fixed some typos, rebased for current version, and added usage in this
version.

Would you review this patch series?

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

Changes in V4:
[1/5] Fix some typos, cleanup, and rebase for current trace-cmd-v2.4
      Change the argument of tracecmd_msg_recv()
[2/5] Fix some typos
      Change the argument of tracecmd_msg_recv_wait()
[3/5] Fix some typos and cleanup
[4/5] Introduce parse_args_virt() and add usage of virt-server in trace-usage.c
[5/5] Rebase for current trace-cmd-v2.4 and add usage of --virt for record in
      trace-usage.c
      Divide tracecmd_msg_connect_to_server() into two functions
       (tracecmd_msg_connect_to_server() and
                  tracecmd_msg_send_init_data_virt(fd))

Changes in V3:
[2/6] Change the license of trace-msg.c to LGPL v2.1
[4/6] Change _nw/_NW to _net/_NET
[5/6] Change _nw/_NW to _net/_NET
[6/6] Add this patch based on Steven's review
      (https://lkml.org/lkml/2013/10/14/618)

Changes in V2:
[1/5] Add a comment in open_udp()
[2/5] Regacy protocol support in order to keep backward compatibility


Thank you,

---

Yoshihiro YUNOMAE (5):
      trace-cmd/listen: Apply the trace-msg protocol for communication between a server and clients
      trace-cmd/msg: Use poll(2) to wait for a message
      trace-cmd/virt-server: Add virt-server mode for a virtualization environment
      trace-cmd/virt-server: Add --dom option which makes a domain directory to virt-server
      trace-cmd/record: Add --virt option for record mode


 Documentation/trace-cmd-record.1.txt      |   11 
 Documentation/trace-cmd-virt-server.1.txt |  113 ++++
 Makefile                                  |    2 
 trace-cmd.c                               |    3 
 trace-cmd.h                               |   15 
 trace-listen.c                            |  717 +++++++++++++++++++-----
 trace-msg.c                               |  873 +++++++++++++++++++++++++++++
 trace-msg.h                               |   31 +
 trace-output.c                            |    4 
 trace-record.c                            |  146 ++++-
 trace-recorder.c                          |   50 +-
 trace-usage.c                             |   18 +
 12 files changed, 1818 insertions(+), 165 deletions(-)
 create mode 100644 Documentation/trace-cmd-virt-server.1.txt
 create mode 100644 trace-msg.c
 create mode 100644 trace-msg.h

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

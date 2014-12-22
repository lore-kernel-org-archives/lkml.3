Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaLVQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:45:49 -0500
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:41008 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754632AbaLVQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:45:48 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:982:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1712:1730:1747:1777:1792:1801:2198:2199:2393:2525:2553:2560:2563:2682:2685:2693:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4184:4250:4362:4605:5007:6119:6120:6248:6261:7875:9025:10004:10848:10967:11232:11657:11658:11914:12043:12050:12109:12291:12517:12519:12555:12740:13095:13149:13230:13846:14096:14097:21060:21064:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jelly52_6c95edb1ad63c
X-Filterd-Recvd-Size: 5140
Date: Mon, 22 Dec 2014 11:45:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Subject: Re: [PATCH trace-cmd V5 0/6] perf-probe: Bugfix and add new options
 for cache
Message-ID: <20141222114544.236d59ee@gandalf.local.home>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 12:47:36 -0500
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> This is the version 5 series of virtio-trace for trace-cmd.
> The previous series is here; https://lkml.org/lkml/2014/7/10/747 

Thanks, I'll take a look at this.

I don't think you wanted the cover subject. Also, the date on this
email is still over an hour in the future from this reply.

-- Steve

> 
> I took over this work from Yoshihiro Yunomae. This version includes
> some fixes.
>  - Add -N support for extract subcommand(1/6).
>  - As Steven suggested, this send "-1V2\0<MAGIC>\0" instead
>    of "V2\0<MAGIC>\0" at first.
>  - Add a document of Protocol change in Documentation/Protocol.txt.
>    (Now all the protocol descriptions are moved into that)
>  - Cleanup the code and document a bit.
> 
> How to use
> ==========
> 1. Run virt-server on a host
>    # trace-cmd virt-server --dom guest1 -c 2
> 
> 2. Set up of virtio-serial pipe of guest1 on the host
>    Add the following tags to domain XML files.
>    # virsh edit guest1
>    <channel type='unix'>
>       <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
>       <target type='virtio' name='agent-ctl-path'/>
>    </channel>
>    <channel type='pipe'>
>       <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu0'/>
>       <target type='virtio' name='trace-path-cpu0'/>
>    </channel>
>    <channel type='pipe'>
>       <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu1'/>
>       <target type='virtio' name='trace-path-cpu1'/>
>    </channel>
> 
> 3. Boot the guest
>    # virsh start guest1
> 
> 4. Run the guest1's client(see trace-cmd-record(1) with the *--virt* option)
>    # trace-cmd record -e sched* --virt
> 
> If you want to boot another guest sends trace-data via virtio-serial,
> you will manually make the guest domain directory and trace data I/Fs.
> 
> - Make guest domain directory on the host
>    # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
>    # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
>    # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>
> 
> - Make FIFO on the host
>    # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}
> 
> TODO
> ====
>  - Don't use fixed directory and fifos. Make it flexible.
>  - Don't depend on the libvirt. We can find fifos in /proc/<pid>/fd/*.
>  - Cleanup the code. It is not well structured now.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (6):
>       trace-cmd: Support -N option for trace-cmd extract
>       trace-cmd/listen: Introduce trace-msg protocol (protocol v2)
>       trace-cmd/msg: Use poll(2) to wait for a message
>       trace-cmd/virt-server: Add virt-server mode for a virtualization environment
>       trace-cmd/record: Add --virt option for record mode
>       trace-cmd/virt-server: Add --dom option which makes a domain directory to virt-server
> 
> 
>  Documentation/Protocol.txt                |  163 +++++
>  Documentation/trace-cmd-record.1.txt      |   11 
>  Documentation/trace-cmd-virt-server.1.txt |  113 ++++
>  Makefile                                  |    2 
>  trace-cmd.c                               |    3 
>  trace-cmd.h                               |   15 +
>  trace-listen.c                            |  666 +++++++++++++++++++---
>  trace-msg.c                               |  870 +++++++++++++++++++++++++++++
>  trace-msg.h                               |   31 +
>  trace-output.c                            |    4 
>  trace-record.c                            |  160 +++++
>  trace-recorder.c                          |   50 +-
>  trace-usage.c                             |   18 +
>  13 files changed, 1966 insertions(+), 140 deletions(-)
>  create mode 100644 Documentation/Protocol.txt
>  create mode 100644 Documentation/trace-cmd-virt-server.1.txt
>  create mode 100644 trace-msg.c
>  create mode 100644 trace-msg.h
> 
> --
> Masami HIRAMATSU
> Software Platform Research Dpt. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com


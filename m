Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3JNV0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:26:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23400 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756665Ab3JNV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:26:42 -0400
Date: Mon, 14 Oct 2013 17:26:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 0/5] trace-cmd: Support the feature recording trace
 data of guests on the host
Message-ID: <20131014172637.2ced6be9@gandalf.local.home>
In-Reply-To: <20130913020627.28927.69090.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 11:06:27 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> <How to use>
> 1. Run virt-server on a host
>    # trace-cmd virt-server
> 
> 2. Make guest domain directory
>    # mkdir -p /tmp/trace-cmd/virt/<domain>
>    # chmod 710 /tmp/trace-cmd/virt/<domain>
>    # chgrp qemu /tmp/trace-cmd/virt/<domain>

Quick comment. I think the above should be done by trace-cmd. At least
have options for it like:

trace-cmd virt-server -d /tmp/trace-cmd/virt/domain -m 710 -g qemu

Perhaps default some of those, and have trace-cmd print out:

  Process Directory:     /tmp/trace-cmd/virt/domain
  Directory permission:  0710
  Group:                 qemu

OK, now to look at the actual code ;-)

-- Steve


> 
> 3. Make FIFO on the host
>    # mkfifo /tmp/trace-cmd/virt/<domain>/trace-path-cpu{0,1,...,X}.{in,out}
> 
> 4. Set up of virtio-serial pipe of a guest on the host
>    Add the following tags to domain XML files.
>    # virsh edit <domain>
>    <channel type='unix'>
>       <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
>       <target type='virtio' name='agent-ctl-path'/>
>    </channel>
>    <channel type='pipe'>
>       <source path='/tmp/trace-cmd/virt/<domain>/trace-path-cpu0'/>
>       <target type='virtio' name='trace-path-cpu0'/>
>    </channel>
>    ... (cpu1, cpu2, ...)
> 
> 5. Boot the guest
>    # virsh start <domain>
> 
> 6. Execute "record --virt" on the guest
>    # trace-cmd record --virt -e sched*
> 

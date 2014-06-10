Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFJSjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:39:20 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:53761 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFJSjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:39:18 -0400
X-MXL-Hash: 539750d621859ccc-0263a7933463d16da527b82abd6c29716f230dbf
X-MXL-Hash: 539750cf3a01f909-1a7eddccfd42f5c51ea8e503eca9bc21334b1784
Date: Tue, 10 Jun 2014 14:39:06 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Message-ID: <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
In-Reply-To: <20140609182728.GB31499@redhat.com>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
	<20140609174708.GA31499@redhat.com>
	<20140609182728.GB31499@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=cM9uszuN c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=EvufntpctroA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=20KFwNOVAAAA:8 a=uFGURb_VrD-gho]
X-AnalysisOut: [qlHJ0A:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014061026); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014 14:27:29 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
> ... snip ...
> So the question is why request queue is being freed early. Are there any
> reference counting issues.  

Hi Vivek,

Thanks for taking a look.  For extra debugging, I wrote a quick set of
kprobes that:

  1 - On blkg_alloc entry, save the request_queue's kobj address in a
      list
  2 - On kobject_put entry, dump the stack if the kobj is found in that
      list

and this was the trace for the final kobject put for the
request_queue before a crash:

JL: kobject_put kobj(queue) @ ffff88084d89c9e8, refcount=1
------------[ cut here ]------------
WARNING: CPU: 27 PID: 11060 at /h/jlawrenc/kprobes/docker/probes_blk.c:166 kret_entry_kobject_put+0x47/0x50 [docker_debug]()
[ ... snip modules ... ]
CPU: 27 PID: 11060 Comm: docker Tainted: G        W  OE 3.15.0 #1
Hardware name: Stratus ftServer 6400/G7LAZ, BIOS BIOS Version 6.3:57 12/25/2013
 0000000000000000 0000000093cbdc81 ffff88104196fae8 ffffffff8162738d
 0000000000000000 ffff88104196fb20 ffffffff8106d81d ffff88084d89c9e8
 ffff881041912cd0 ffffffffa0181020 ffff88104196fbe0 ffffffffa01810c8
Call Trace:
 [<ffffffff8162738d>] dump_stack+0x45/0x56
 [<ffffffff8106d81d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8106d94a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa017f107>] kret_entry_kobject_put+0x47/0x50 [docker_debug]
 [<ffffffff816335ee>] pre_handler_kretprobe+0x9e/0x1c0
 [<ffffffff81635a2f>] opt_pre_handler+0x4f/0x90
 [<ffffffff81631dd7>] optimized_callback+0x97/0xb0
 [<ffffffff812dde01>] ? kobject_put+0x1/0x60
 [<ffffffff812b4561>] ? blk_cleanup_queue+0x101/0x1a0
 [<ffffffffa011114b>] ? __dm_destroy+0x1db/0x260 [dm_mod]
 [<ffffffffa0111f53>] ? dm_destroy+0x13/0x20 [dm_mod]
 [<ffffffffa0117a2e>] ? dev_remove+0x11e/0x180 [dm_mod]
 [<ffffffffa0117910>] ? dev_suspend+0x250/0x250 [dm_mod]
 [<ffffffffa0118105>] ? ctl_ioctl+0x255/0x500 [dm_mod]
 [<ffffffff8118483f>] ? do_wp_page+0x38f/0x750
 [<ffffffffa01183c3>] ? dm_ctl_ioctl+0x13/0x20 [dm_mod]
 [<ffffffff811e1c20>] ? do_vfs_ioctl+0x2e0/0x4a0
 [<ffffffff81277d56>] ? file_has_perm+0xa6/0xb0
 [<ffffffff811e1e61>] ? SyS_ioctl+0x81/0xa0
 [<ffffffff816381e9>] ? system_call_fastpath+0x16/0x1b
---[ end trace b4b8112437afdac8 ]---
 
so I think when dm_destroy() is called, it leads to the request_queue
in question going away.

> I am wondering if we need to take a reference on the queue
> (blk_get_queue()) in blkg_alloc(), to make sure request queue is
> still around when blkg is being freed.

I experimented with this and the crash does go away (and the docker
invocation completes successfully).  I wasn't sure where the
accompanying blk_put_queue() should go.  If I put it in blkg_free, the
kref accounting doesn't seem to even out, ie they never fall to zero.

> I will try to reproduce the issue locally.

Any luck?  I found that slub_debug was required to draw out the crash,
otherwise the use-after-free silently goes about its business.

Hope this helps,

-- Joe

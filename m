Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaKDNEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:04:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:45158 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228AbaKDNEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:04:42 -0500
Date: Tue, 4 Nov 2014 08:04:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFA][PATCH 0/8] seq_file: Remove return checks of seq_printf()
Message-ID: <20141104080436.10904a7a@gandalf.local.home>
In-Reply-To: <20141029215602.535533597@goodmis.org>
References: <20141029215602.535533597@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 17:56:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> [ REQUEST FOR ACKS ]

Al,

Can you take a look at these, and give me an Acked-by if they are OK
with you?

Thanks,

-- Steve

> 
> I'm looking to clean up the seq_file code and to eventually merge the
> trace_seq code with seq_file as well, since they basically do the same thing.
> 
> Part of this process is to remove the return code of seq_printf() and friends
> as they are rather inconsistent. It is better to use the new function
> seq_has_overflowed() if you want to stop processing when the buffer
> is full. Note, if the buffer is full, the seq_file code will throw away
> the contents, allocate a bigger buffer, and then call your code again
> to fill in the data. The only thing that breaking out of the function
> early does is to save a little time which is probably never noticed.
> 
> But anyway, I'm asking for Acked-bys for code that touches the subsystems
> that have been modified.
> 
> I started with patches from Joe Perches and modified them as well.
> There's many more places that need to be updated before we can convert
> seq_printf() and friends to return void. But this patch set introduces
> the seq_has_overflowed() and does some initial updates.
> 
> Please ack!
> 
> Thanks!
> 
> -- Steve
> 
> 
> 
> Joe Perches (6):
>       seq_file: Rename seq_overflow() to seq_has_overflowed() and make public
>       netfilter: Convert print_tuple functions to return void
>       dlm: Remove seq_printf() return checks and use seq_has_overflowed()
>       dlm: Use seq_puts() instead of seq_printf() for constant strings
>       fs: Convert show_fdinfo functions to void
>       debugfs: Have debugfs_print_regs32() return void
> 
> Steven Rostedt (Red Hat) (2):
>       netfilter: Remove return values for print_conntrack callbacks
>       netfilter: Remove checks of seq_printf() return values
> 
> ----
>  Documentation/filesystems/debugfs.txt              |   2 +-
>  Documentation/filesystems/seq_file.txt             |  22 +-
>  Documentation/filesystems/vfs.txt                  |   2 +-
>  drivers/net/tun.c                                  |   4 +-
>  fs/debugfs/file.c                                  |  15 +-
>  fs/dlm/debug_fs.c                                  | 263 ++++++++++-----------
>  fs/eventfd.c                                       |   9 +-
>  fs/eventpoll.c                                     |  13 +-
>  fs/notify/fdinfo.c                                 |  78 +++---
>  fs/notify/fdinfo.h                                 |   4 +-
>  fs/proc/fd.c                                       |   3 +-
>  fs/seq_file.c                                      |  15 +-
>  fs/signalfd.c                                      |   4 +-
>  fs/timerfd.c                                       |  27 ++-
>  include/linux/debugfs.h                            |   7 +-
>  include/linux/fs.h                                 |   2 +-
>  include/linux/seq_file.h                           |  15 ++
>  include/net/netfilter/nf_conntrack_core.h          |   2 +-
>  include/net/netfilter/nf_conntrack_l3proto.h       |   4 +-
>  include/net/netfilter/nf_conntrack_l4proto.h       |   6 +-
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   6 +-
>  .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  53 +++--
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |  10 +-
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   6 +-
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |  10 +-
>  net/netfilter/nf_conntrack_l3proto_generic.c       |   5 +-
>  net/netfilter/nf_conntrack_proto_dccp.c            |  14 +-
>  net/netfilter/nf_conntrack_proto_generic.c         |   5 +-
>  net/netfilter/nf_conntrack_proto_gre.c             |  18 +-
>  net/netfilter/nf_conntrack_proto_sctp.c            |  14 +-
>  net/netfilter/nf_conntrack_proto_tcp.c             |  14 +-
>  net/netfilter/nf_conntrack_proto_udp.c             |  10 +-
>  net/netfilter/nf_conntrack_proto_udplite.c         |  10 +-
>  net/netfilter/nf_conntrack_standalone.c            |  77 +++---
>  net/netfilter/nf_log.c                             |  30 +--
>  net/netfilter/nfnetlink_queue_core.c               |  13 +-
>  net/netfilter/x_tables.c                           |  19 +-
>  net/netfilter/xt_hashlimit.c                       |  36 ++-
>  38 files changed, 410 insertions(+), 437 deletions(-)


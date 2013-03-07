Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3CGQU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:20:29 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42387 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3CGQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:20:28 -0500
Message-ID: <1362673223.15793.215.camel@edumazet-glaptop>
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 08:20:23 -0800
In-Reply-To: <20130307125424.GI13493@beaver>
References: <20130209141029.GA13493@beaver>
	 <1360422473.6696.28.camel@edumazet-glaptop> <20130307125424.GI13493@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 16:54 +0400, Alexey Vlasov wrote:
> Hi,
> 
> On Sat, Feb 09, 2013 at 07:07:53AM -0800, Eric Dumazet wrote:
> > >
> > > I used 2.6.2x kernel for a long time on my shared hosting and I didn't
> > > have any problems. Kernels worked well and server uptime was about 2-3
> > > years.
> > > 
> > > ...
> > > 
> > > it doesn't happen on an empty server, only on loaded ones. Unfortunately
> > > I don't know how to provoke such hanging artificially.
> > > 
>  
> > Your traces dont contain symbols, its quite hard to guess the issue.
> 
> Well the server got high loaded and began to crash almost once a day.
> 
> =====
> BUG: soft lockup - CPU#1 stuck for 23s! [httpd:21686]
> Call Trace:
> [<ffffffff8110bba5>] ? mntput_no_expire+0x25/0x170
> [<ffffffff810f9389>] ? path_lookupat+0x189/0x890
> [<ffffffff810f9b67>] ? filename_lookup.clone.39+0xd7/0xe0
> [<ffffffff810fc85c>] ? user_path_at_empty+0x5c/0xb0
> [<ffffffff8102b5f9>] ? __do_page_fault+0x1b9/0x480
> [<ffffffff810f146e>] ? vfs_fstatat+0x3e/0x90
> [<ffffffff810c54bf>] ? remove_vma+0x5f/0x70
> [<ffffffff810f168f>] ? sys_newstat+0x1f/0x50
> [<ffffffff814b09c2>] ? page_fault+0x22/0x30
> [<ffffffff814b0f49>] ? system_call_fastpath+0x18/0x1d
> =====
> 
> There's a full trace in attachment. 
> 


Seems a VFS issue. 

A "umount" is done, blocking almost all other cpus in lg_local_lock()

What are gr_xxxx symbols ?

Mar  7 00:50:00 l25 [1735187.889877]  [<ffffffff8110e118>] ? is_path_reachable+0x48/0x60
Mar  7 00:50:00 l25 [1735187.889880]  [<ffffffff8110e163>] ? path_is_under+0x33/0x60
Mar  7 00:50:00 l25 [1735187.889887]  [<ffffffff812257a4>] ? gr_is_outside_chroot+0x54/0x70
Mar  7 00:50:00 l25 [1735187.889890]  [<ffffffff81225815>] ? gr_chroot_fchdir+0x55/0x80
Mar  7 00:50:00 l25 [1735187.889894]  [<ffffffff810f9b2e>] ? filename_lookup.clone.39+0x9e/0xe0
Mar  7 00:50:00 l25 [1735187.889897]  [<ffffffff810fc85c>] ? user_path_at_empty+0x5c/0xb0
Mar  7 00:50:00 l25 [1735187.889903]  [<ffffffff8102b5f9>] ? __do_page_fault+0x1b9/0x480
Mar  7 00:50:00 l25 [1735187.889907]  [<ffffffff814b09c2>] ? page_fault+0x22/0x30
Mar  7 00:50:00 l25 [1735187.889910]  [<ffffffff810f146e>] ? vfs_fstatat+0x3e/0x90
Mar  7 00:50:00 l25 [1735187.889914]  [<ffffffff812278cb>] ? gr_learn_resource+0x3b/0x1e0
Mar  7 00:50:00 l25 [1735187.889918]  [<ffffffff810f168f>] ? sys_newstat+0x1f/0x50
Mar  7 00:50:00 l25 [1735187.889922]  [<ffffffff810ea4b4>] ? filp_close+0x54/0x80
Mar  7 00:50:00 l25 [1735187.889925]  [<ffffffff814b09c2>] ? page_fault+0x22/0x30
Mar  7 00:50:00 l25 [1735187.889928]  [<ffffffff814b0f49>] ? system_call_fastpath+0x18/0x1d



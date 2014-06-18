Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaFRXbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:31:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:48562 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaFRXbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:31:14 -0400
Date: Wed, 18 Jun 2014 16:31:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/seq_file: fallback to vmalloc allocation
In-Reply-To: <1402909492-36486-3-git-send-email-heiko.carstens@de.ibm.com>
Message-ID: <alpine.DEB.2.02.1406181630430.22789@chino.kir.corp.google.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com> <1402909492-36486-3-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Heiko Carstens wrote:

> There are a couple of seq_files which use the single_open() interface.
> This interface requires that the whole output must fit into a single buffer.
> 
> E.g. for /proc/stat allocation failures have been observed because an order-4
> memory allocation failed due to memory fragmentation. In such situations
> reading /proc/stat is not possible anymore.
> 
> Therefore change the seq_file code to fallback to vmalloc allocations which
> will usually result in a couple of order-0 allocations and hence also work
> if memory is fragmented.
> 
> For reference a call trace where reading from /proc/stat failed:
> 
> [62129.701569] sadc: page allocation failure: order:4, mode:0x1040d0
> [62129.701573] CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
> [...]
> [62129.701586] Call Trace:
> [62129.701588] ([<0000000000111fbe>] show_trace+0xe6/0x130)
> [62129.701591] [<0000000000112074>] show_stack+0x6c/0xe8
> [62129.701593] [<000000000020d356>] warn_alloc_failed+0xd6/0x138
> [62129.701596] [<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
> [62129.701598] [<000000000021168e>] __get_free_pages+0x2e/0x58
> [62129.701599] [<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
> [62129.701602] [<00000000002f3ffa>] stat_open+0x5a/0xd8
> [62129.701604] [<00000000002e9aaa>] proc_reg_open+0x8a/0x140
> [62129.701606] [<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
> [62129.701608] [<000000000027411e>] finish_open+0x46/0x60
> [62129.701610] [<000000000028675a>] do_last+0x382/0x10d0
> [62129.701612] [<0000000000287570>] path_openat+0xc8/0x4f8
> [62129.701614] [<0000000000288bde>] do_filp_open+0x46/0xa8
> [62129.701616] [<000000000027541c>] do_sys_open+0x114/0x1f0
> [62129.701618] [<00000000005b1c1c>] sysc_tracego+0x14/0x1a
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Tested-by: David Rientjes <rientjes@google.com>

Very nice!

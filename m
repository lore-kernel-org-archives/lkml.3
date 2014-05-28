Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaE1LOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:14:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33659 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbaE1LOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:14:47 -0400
X-Sasl-enc: Oziki4EcqRFK53QYHa4pZ41LXOXldkVrQ8cj+dr0UmzH 1401275680
Message-ID: <1401275679.2497.8.camel@perseus.fritz.box>
Subject: Re: [PATCH 1/2] fs: proc/stat: use num_online_cpus() for buffer size
From: Ian Kent <raven@themaw.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Date: Wed, 28 May 2014 19:14:39 +0800
In-Reply-To: <1401275180.2497.5.camel@perseus.fritz.box>
References: <20140521122521.GB7471@osiris>
	 <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris>
	 <20140528085954.GB4219@osiris> <1401275180.2497.5.camel@perseus.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 19:06 +0800, Ian Kent wrote:
> On Wed, 2014-05-28 at 10:59 +0200, Heiko Carstens wrote:
> > The number of bytes contained 'within' /proc/stat depends on the number
> > of online cpus and not of the numbe of possible cpus.
> > 
> > This reduces the number of bytes requested for the initial buffer allocation
> > within stat_open(). Which is usually way too high and for nr_possible_cpus()
> > == 256 cpus would result in an order 4 allocation.
> > 
> > Order 4 allocations however may fail if memory is fragmented and we would
> > end up with an unreadable /proc/stat file:
> > 
> > 62129.701569] sadc: page allocation failure: order:4, mode:0x1040d0
> > [62129.701573] CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
> > [...]
> > [62129.701586] Call Trace:
> > [62129.701588] ([<0000000000111fbe>] show_trace+0xe6/0x130)
> > [62129.701591] [<0000000000112074>] show_stack+0x6c/0xe8
> > [62129.701593] [<000000000020d356>] warn_alloc_failed+0xd6/0x138
> > [62129.701596] [<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
> > [62129.701598] [<000000000021168e>] __get_free_pages+0x2e/0x58
> > [62129.701599] [<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
> > [62129.701602] [<00000000002f3ffa>] stat_open+0x5a/0xd8
> > [62129.701604] [<00000000002e9aaa>] proc_reg_open+0x8a/0x140
> > [62129.701606] [<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
> > [62129.701608] [<000000000027411e>] finish_open+0x46/0x60
> > [62129.701610] [<000000000028675a>] do_last+0x382/0x10d0
> > [62129.701612] [<0000000000287570>] path_openat+0xc8/0x4f8
> > [62129.701614] [<0000000000288bde>] do_filp_open+0x46/0xa8
> > [62129.701616] [<000000000027541c>] do_sys_open+0x114/0x1f0
> > [62129.701618] [<00000000005b1c1c>] sysc_tracego+0x14/0x1a
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  fs/proc/stat.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> > index 9d231e9e5f0e..3898ca5f1e92 100644
> > --- a/fs/proc/stat.c
> > +++ b/fs/proc/stat.c
> > @@ -184,7 +184,7 @@ static int show_stat(struct seq_file *p, void *v)
> >  
> >  static int stat_open(struct inode *inode, struct file *file)
> >  {
> > -	size_t size = 1024 + 128 * num_possible_cpus();
> > +	size_t size = 1024 + 128 * num_online_cpus();
> 
> Yes, I thought of this too when I was looking at the problem but was
> concerned about the number of online cpus changing during the read.
> 
> If a system can hotplug cpus then I guess we don't care much about the
> number of cpus increasing during the read, we'll just see incorrect data
> once, but what would happen if some cpus were removed? Do we even care
> about that case?

Oh hang on, that's not right it's the opposite, if the number of cpus
increases between the call to stat_open() and show_stat() there might
not be enough space.

> 
> >  	char *buf;
> >  	struct seq_file *m;
> >  	int res;
> 



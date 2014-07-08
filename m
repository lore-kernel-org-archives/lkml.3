Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaGHR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:27:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29765 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaGHR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:27:51 -0400
Date: Tue, 8 Jul 2014 11:01:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH net-next v2] xen-netback: Adding debugfs
 "io_ring_qX" files
Message-ID: <20140708150104.GA2863@laptop.dumpdata.com>
References: <1404330830-24504-1-git-send-email-zoltan.kiss@citrix.com>
 <20140702200252.GA17294@laptop.dumpdata.com>
 <53BC014E.5090600@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC014E.5090600@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:33:50PM +0100, Zoltan Kiss wrote:
> On 02/07/14 21:02, Konrad Rzeszutek Wilk wrote:
> >On Wed, Jul 02, 2014 at 08:53:50PM +0100, Zoltan Kiss wrote:
> >>+static ssize_t
> >>+xenvif_write_io_ring(struct file *filp, const char __user *buf, size_t count,
> >>+		     loff_t *ppos)
> >>+{
> >>+	struct xenvif_queue *queue =
> >>+		((struct seq_file *)filp->private_data)->private;
> >>+	int len;
> >>+	char write[sizeof("kick")];
> >
> ><blinks>
> >>+
> >>+	/* don't allow partial writes and check the length */
> >>+	if (*ppos != 0)
> >>+		return 0;
> >>+	if (count < sizeof("kick") - 1)
> >
> >Um, could you just use a #define please?
> OK
> 
> >
> >>+		return -ENOSPC;
> >>+
> >>+	len = simple_write_to_buffer(write,
> >>+				     sizeof(write),
> >>+				     ppos,
> >>+				     buf,
> >>+				     count);
> >>+	if (len < 0)
> >>+		return len;
> >>+
> >>+	if (!strncmp(write, "kick", sizeof("kick") - 1))
> >>+		xenvif_interrupt(0, (void *)queue);
> >>+	else
> >>+		pr_warn("Unknown command to io_ring. Available: kick\n");
> >
> >It is 'io_ring_q%d'?
> Yes
> 
> >Why don't you split that back out to the user
> >instead of the console?
> How do you mean? Printing it into buf? I don't think the user cares about
> its content after doing the write syscall. More importantly, I don't know if
> that buffer is big enough to hold the message.

Isn't it 4K? 

Either way I think you need to do 'count = -EINVAL' here.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaGIFjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:39:54 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43093 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIFjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:39:53 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 9 Jul 2014 14:39:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.15 093/122] zram: revalidate disk after capacity change
Message-ID: <20140709053957.GD9824@bbox>
References: <20140707235734.234226883@linuxfoundation.org>
 <20140707235737.041217860@linuxfoundation.org>
 <20140708105617.GA947@swordfish>
 <20140708150226.GA4113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140708150226.GA4113@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Tue, Jul 08, 2014 at 08:02:26AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 08, 2014 at 07:56:17PM +0900, Sergey Senozhatsky wrote:
> > On (07/07/14 16:57), Greg Kroah-Hartman wrote:
> > > Date: Mon,  7 Jul 2014 16:57:35 -0700
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> > >  stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>, "Alexander E.
> > >  Patrakov" <patrakov@gmail.com>, Sergey Senozhatsky
> > >  <sergey.senozhatsky@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Jerome
> > >  Marchand <jmarchan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
> > >  Linus Torvalds <torvalds@linux-foundation.org>
> > > Subject: [PATCH 3.15 093/122] zram: revalidate disk after capacity change
> > > X-Mailer: git-send-email 2.0.0.254.g50f84e3
> > > User-Agent: quilt/0.63-1
> > > 
> > > 3.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Minchan Kim <minchan@kernel.org>
> > > 
> > > commit 2e32baea46ce542c561a519414c840295b229c8f upstream.
> > > 
> > > Alexander reported mkswap on /dev/zram0 is failed if other process is
> > > opening the block device file.
> > > 
> > > Step is as follows,
> > > 
> > > 0. Reset the unused zram device.
> > > 1. Use a program that opens /dev/zram0 with O_RDWR and sleeps
> > >    until killed.
> > > 2. While that program sleeps, echo the correct value to
> > >    /sys/block/zram0/disksize.
> > > 3. Verify (e.g. in /proc/partitions) that the disk size is applied
> > >    correctly. It is.
> > > 4. While that program still sleeps, attempt to mkswap /dev/zram0.
> > >    This fails: mkswap: error: swap area needs to be at least 40 KiB
> > > 
> > > When I investigated, the size get by ioctl(fd, BLKGETSIZE64, xxx) on
> > > mkswap to get a size of blockdev was zero although zram0 has right size by
> > > 2.
> > > 
> > > The reason is zram didn't revalidate disk after changing capacity so that
> > > size of blockdev's inode is not uptodate until all of file is close.
> > > 
> > > This patch should fix the BUG.
> > > 
> > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> > > Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> > > Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > Cc: Nitin Gupta <ngupta@vflare.org>
> > > Acked-by: Jerome Marchand <jmarchan@redhat.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Hello,
> > 
> > this patch is known to cause problems. please see
> > https://lkml.org/lkml/2014/7/3/885
> 
> Did the fix ever get merged to Linus's tree?  If not, why not?  I'd
> rather just take that fix as well.

Not yet.
Because Andrew picked his tree(ie, mmotm) today.

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaHGJLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:11:15 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57859 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaHGJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:11:13 -0400
Message-ID: <53E342AD.2070303@gmail.com>
Date: Thu, 07 Aug 2014 12:11:09 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/4] brd: Fix all partitions BUGs
References: <53E21125.9080308@plexistor.com>	 <53E2127B.1020805@plexistor.com> <1407366387.2869.3.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1407366387.2869.3.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 02:06 AM, Ross Zwisler wrote:
> On Wed, 2014-08-06 at 14:33 +0300, Boaz Harrosh wrote:
> 
> With this patch we end up in what feels like a weird place where we're half
> using the old scheme of major/minor allocation, and half in the world of
> dynamic major/minors.  Devices have a major of 1 and minors that increment by
> 1, but partitions have a major of 259 (BLOCK_EXT_MAJOR):
> 
> 	brw-rw---- 1 root disk   1, 0 Aug  6 14:10 /dev/ram0
> 	brw-rw---- 1 root disk   1, 1 Aug  6 14:13 /dev/ram1
> 	brw-rw---- 1 root disk 259, 0 Aug  6 14:14 /dev/ram1p1
> 	brw-rw---- 1 root disk 259, 1 Aug  6 14:13 /dev/ram1p2
> 	brw-rw---- 1 root disk 259, 2 Aug  6 14:14 /dev/ram1p51
> 

This is when you use max_part = 1. If someone really cares, why
would he care, but if he cares like if he wants persistent
partition minors than he can use  max_part = 8, say and it will
all go nice. (And if he creates 9 partitions on a device then
the last one will be from the 259 dynamic range)

So you see it is all in the user choice. If he cares at all
because I do not see why it matters

> For NVMe and PRD you get a major of 259 all around:
> 
> 	brw-rw---- 1 root disk 259, 0 Aug  6 16:55 /dev/pmem0
> 	brw-rw---- 1 root disk 259, 2 Aug  6 16:55 /dev/pmem0p1
> 	brw-rw---- 1 root disk 259, 3 Aug  6 16:55 /dev/pmem0p2
> 	brw-rw---- 1 root disk 259, 1 Aug  6 16:54 /dev/pmem1
> 
> It could be that this is fine, but it just smells fishy to me I guess.
> 

If you go this way then dynamic creation with the mknod trick does not work
because there is no association in the system with your driver. Whats so fishy
I have read the all partitions code this is simple math really. This is the way
it works.

> Also, it looks like you can still create a new device with this patch, but you
> can't create partitions on that device.  Not sure if this is just what you get
> when you dynamically create a device on the fly, or if it's a symptom of
> something larger.
> 

What? I just tried again this all works fine for me, here with fdisk.
$ modprobe brd      # will create ram0-7
$ mknod /dev/ram8 b 1 8
$ fdisk /dev/ram8
  g, n, , , +2M, n, , , , , w 

I create 2 partitions 2M each and press w and it is all there.

What numbers did you use ? rd_nr, max_part, and the mknod numbers. Here it
just works fine. What did you try?

Thanks
Boaz


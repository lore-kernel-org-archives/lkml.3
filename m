Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3HPCym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:54:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57502 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3HPCyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:54:37 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: RE: [PATCH] block: support embedded device command line partition
Thread-Topic: [PATCH] block: support embedded device command line partition
Thread-Index: Ac6QL80+CfVf2IEATPuoaFA0S7oaSQJXItIAACUqDBA=
Date: Fri, 16 Aug 2013 02:54:04 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C0643F8@szxeml512-mbx.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
 <520CF92A.90909@wwwdotorg.org>
In-Reply-To: <520CF92A.90909@wwwdotorg.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +blkdevparts=<blkdev-def>[;<blkdev-def>]
> > +  <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
> > +    <partdef> := <size>[@<offset>](part-name)
> > +
> > +<blkdev-id>
> > +    block device disk name, embedded device used fixed block device,
> > +    it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.
> 
> The device-name isn't always fixed.
> 
> For example, what if there are multiple SDHCI controllers, one hosting a
> fixed eMMC device and the other an SD card? It's quite typical for the
> eMMC's device name (which is likely what should be affected by this
> feature) to be mmcblk0 when no SD card is present, yet be mmcblk1 when
> an SD card is present. Is there a more precise/stable way to define
> which device the command-line option applies to?
  
Yes. Fixed is for single controller.
For multiple controllers, currently, there is not a simple way.
I tend to do something in the eMMC driver, such as initialize order,
but I have not tried.

> 
> For the root= command-line option, we use UUID= or PARTUUID= to work
> around this issue, but that won't work for naming the whole device.
> 
> What about using the MMIO address of the controller hosting the device,
> or something like that?
> 

  MMIO may be not a good idea, it is not intuitive. 

> > +<size>
> > +    partition size, in bytes, such as: 512, 1m, 1G.
> 
> s/m/M/?
> 
> I assume M/G are MiB/GiB?
> 
> Does it make sense to allow specifying the sizes in units of
> sectors/blocks? If so, which specific block/sector size in the case of
> things like NAND flash which IIRC have multiple types/levels of sectors;
> perhaps this is a bad idea. I guess we could easily add this feature
> later by introducing a new suffix, so no need to solve the issue now.
> 
> > +
> > +<offset>
> > +    partition start address, in bytes.
> > +
> > +(part-name)
> > +    partition name, kernel send uevent with "PARTNAME". application can create
> > +    a link to block device partition with the name "PARTNAME".
> > +    user space application can access partition by partition name.
> 
> Do partitions usually have a PARTNAME attribute when probed through
> normal mechanisms like MBR? If so, I guess this is fine.
> 
> Perhaps we can just use , as the delimiter for all fields, rather than
> special-casing part-name to use (), so:
> 
> size,offset,partname,size,offset,partname,...
> 
> The partname field could easily be empty if not needed.
> 

If no need partname, your bootargs are mmcblk0:1G,1G,1G,...
 
> > +Example:
> > +    eMMC disk name is "mmcblk0" and "mmcblk0boot0"
> > +
> > +  bootargs:
> > +
> 'blkdevparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'
> > +
> > +  dmesg:
> > +    mmcblk0: p1(data0) p2(data1) p3()
> > +    mmcblk0boot0: p1(boot) p2(kernel)


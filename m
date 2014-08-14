Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaHNUNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:13:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbaHNUNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:13:00 -0400
Date: Thu, 14 Aug 2014 13:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux MM <linux-mm@kvack.org>, Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: Re: linux-next: Tree for Aug 14 (mm/memory_hotplug.c and
 drivers/base/memory.c)
Message-Id: <20140814131259.0e56829123ba1123bbe1685a@linux-foundation.org>
In-Reply-To: <53ECCF7E.2090305@infradead.org>
References: <20140814152749.24d43663@canb.auug.org.au>
	<53ECCF7E.2090305@infradead.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 08:02:22 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 08/13/14 22:27, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add code intended for v3.18 until after v3.17-rc1 is
> > released.
> > 
> > Changes since 20140813:
> > 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `show_zones_online_to':
> memory.c:(.text+0x13f306): undefined reference to `test_pages_in_a_zone'
> 
> in drivers/base/memory.c
> 
> when CONFIG_MEMORY_HOTREMOVE is not enabled.
> 
> The function implementation in mm/memory_hotplug.c is only built if
> CONFIG_MEMORY_HOTREMOVE is enabled.

Thanks.   This way, I suppose.

--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2
+++ a/drivers/base/memory.c
@@ -373,6 +373,7 @@ static ssize_t show_phys_device(struct d
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static int __zones_online_to(unsigned long end_pfn,
 				struct page *first_page, unsigned long nr_pages)
 {
@@ -432,12 +433,13 @@ static ssize_t show_zones_online_to(stru
 
 	return sprintf(buf, "%s\n", zone->name);
 }
+static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
+#endif
 
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
-static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
 
 /*
  * Block size attribute stuff
@@ -584,7 +586,9 @@ static struct attribute *memory_memblk_a
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
+#ifdef CONFIG_MEMORY_HOTREMOVE
 	&dev_attr_zones_online_to.attr,
+#endif
 	NULL
 };
 


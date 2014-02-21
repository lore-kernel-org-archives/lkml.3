Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaBURdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:33:11 -0500
Received: from jcornwall.me ([198.58.100.172]:40269 "EHLO jcornwall.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbaBURdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:33:10 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 12:33:10 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Feb 2014 11:23:39 -0600
From: Jay Cornwall <jay@jcornwall.me>
To: linux-kernel@vger.kernel.org
Subject: =?UTF-8?Q?put=5Fpage=20on=20transparent=20huge=20page=20leaks=3F?=
Message-ID: <ff08f2ccbcd50d2d353392a81defe619@jcornwall.me>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm tracking a possible memory leak in iommu/amd. The driver uses this 
logic to fault a page in response to a PRI from a device:

npages = get_user_pages(fault->state->task, fault->state->mm,
                         fault->address, 1, write, 0, &page, NULL);

if (npages == 1)
         put_page(page);
else
         ...

This works correctly when get_user_pages returns a 4KB page. When 
transparent huge pages are enabled any 2MB page returned by this call 
appears to leak on process exit. The non-cached memory usage stays 
elevated by the set of faulted 2MB pages. This behavior is not observed 
when the exception handler demand faults 2MB pages.

I notice there is a difference in reference count between the 4KB/2MB 
paths.

get_user_pages (4KB): page_count()=3, page_mapcount()=1
put_page       (4KB): page_count()=2, page_mapcount()=1

get_user_pages (2MB): page_count()=3, page_mapcount()=1
put_page       (2MB): page_count()=3, page_mapcount()=0

I'm concerned that the driver appears to be holding a reference count 
after put_page(). Am I interpreting this observation correctly?

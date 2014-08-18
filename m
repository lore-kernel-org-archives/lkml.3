Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaHRWuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:50:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:43736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaHRWuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:50:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,889,1400050800"; 
   d="scan'208";a="589900622"
Date: Mon, 18 Aug 2014 16:49:45 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        rlnelson@google.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v12] NVMe: Convert to blk-mq
In-Reply-To: <1408126604-10611-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1408181643280.4696@AMR>
References: <1408126604-10611-1-git-send-email-m@bjorling.me> <1408126604-10611-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-323818201-1408402186=:4696"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-323818201-1408402186=:4696
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 15 Aug 2014, Matias Bjørling wrote:
>
> * NVMe queues are merged with the tags structure of blk-mq.
>

I see the driver's queue suspend logic is removed, but I didn't mean to
imply it was safe to do so without replacing it with something else. I
thought maybe we could use the blk_stop/start_queue() functions if I'm
correctly understanding what they're for.

With what's in version 12, we could free an irq multiple times that
doesn't even belong to the nvme queue anymore in certain error conditions.

A couple other things I just noticed:

  * We lose the irq affinity hint after a suspend/resume or device reset
  because the driver's init_hctx() isn't called in these scenarios.

  * After a reset, we are not guaranteed that we even have the same number
  of h/w queues. The driver frees ones beyond the device's capabilities,
  so blk-mq may have references to freed memory. The driver may also
  allocate more queues if it is capable, but blk-mq won't be able to take
  advantage of that.
--8323328-323818201-1408402186=:4696--

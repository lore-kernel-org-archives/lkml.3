Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaHNSUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:20:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:37109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaHNSUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,864,1400050800"; 
   d="scan'208";a="558683842"
Date: Thu, 14 Aug 2014 12:20:24 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
In-Reply-To: <53ECD842.40302@bjorling.me>
Message-ID: <alpine.LRH.2.03.1408141209500.14603@AMR>
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me>
 <53ECD125.3080701@fb.com> <53ECD842.40302@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014, Matias Bjorling wrote:
>> nr_tags must be uninitialized or screwed up somehow, otherwise I don't
>> see how that kmalloc() could warn on being too large. Keith, are you
>> running with slab debugging? Matias, might be worth trying.

The queue's tags were freed in 'blk_mq_map_swqueue' because some queues
weren't mapped to a s/w queue, but the driver has a pointer to that
freed memory, so it's a use-after-free error.

This part in the driver looks different than it used to be in v8 when I
last tested. The nvme_queue used to have a pointer to the 'hctx', but now
it points directly to the 'tags', but it doesn't appear to be very safe.

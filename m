Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbbAVPVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:21:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:25697 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbbAVPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:21:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,449,1418112000"; 
   d="scan'208";a="665917037"
Date: Thu, 22 Jan 2015 15:21:28 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Christoph Hellwig <hch@infradead.org>
cc: Keith Busch <keith.busch@intel.com>, Yan Liu <yan@purestorage.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <20150122084517.GA2093@infradead.org>
Message-ID: <alpine.LNX.2.00.1501221430040.15481@localhost.lm.intel.com>
References: <1421886503-25276-1-git-send-email-yan@purestorage.com> <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com> <20150122084517.GA2093@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Christoph Hellwig wrote:
> On Thu, Jan 22, 2015 at 12:47:24AM +0000, Keith Busch wrote:
>> The IOCTL's purpose was to let someone submit completely arbitrary
>> commands on IO queues. This technically shouldn't even need a namespace
>> handle, but we don't have a request_queue associated to IO queues without
>> one like the admin queue has. In fact, we ought to fix that so we can
>> issue IO commands without namespaces.
>
> Honestly, this sounds like a horrible idea.  As namespaces aren't really
> any different from SCSI LUNs they should only be accessible through
> the device associated with the namespaces, and admin commands should
> only be allowed through the character device (if at all).

The case I considered was the "hidden" attribute in the NVMe LBA Range
Type feature. It only indicates the storage should be hidden from the OS
for general use, but the host may still use it for special purposes. In
truth, the driver doesn't handle the hidden attribute very well and it
doesn't seem like a well thought out feature in the spec anyway.

But if you really need to restrict namespace access, shouldn't that be
enforced on the target side with reservations or similar mechanism?

I agree on your last point. Admin commands through namespaces carried over
from before the management device existed, but removing it now will break
some customer tooling. There's probably a responsible way to migrate.

> For these security and usability reasons we did get rid of the
> SG_FLAG_LUN_INHIBIT flag in the SCSI passthrough interface, which
> allowed for similar horrible things in the distant past.

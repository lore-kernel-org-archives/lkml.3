Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaB0OBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:01:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbaB0OB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:01:29 -0500
Message-ID: <530F451F.9020107@redhat.com>
Date: Thu, 27 Feb 2014 15:01:03 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        willy@linux.intel.com
Subject: Re: [PATCH v6 00/22] Support ext4 on NV-DIMMs
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:18 PM, Matthew Wilcox wrote:
> One of the primary uses for NV-DIMMs is to expose them as a block device
> and use a filesystem to store files on the NV-DIMM.  While that works,
> it currently wastes memory and CPU time buffering the files in the page
> cache.  We have support in ext2 for bypassing the page cache, but it
> has some races which are unfixable in the current design.  This series
> of patches rewrite the underlying support, and add support for direct
> access to ext4.

I'm wondering if there is a potential security issue lurking here.

Some distributions use udisks2 to grant permission to local console 
users to create new loop devices from files.  File systems on these 
block devices are then mounted.  This is a replacement for several file 
systems implemented in user space, and for the users, this is a good 
thing because the in-kernel implementations are generally of higher quality.

What happens if we have DAX support in the entire stack, and an 
enterprising user mounts a file system?  Will she be able to fuzz the 
file system or binfmt loaders concurrently, changing the bits while they 
are being read?

Currently, it appears that the loop device duplicates pages in the page 
cache, so this does not seem to be possible, but DAX support might 
change this.

-- 
Florian Weimer / Red Hat Product Security Team

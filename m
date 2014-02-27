Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaB0QgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:36:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaB0QgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:36:17 -0500
Message-ID: <530F697B.1010802@redhat.com>
Date: Thu, 27 Feb 2014 17:36:11 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/22] Support ext4 on NV-DIMMs
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com> <530F451F.9020107@redhat.com> <20140227162923.GH5744@linux.intel.com>
In-Reply-To: <20140227162923.GH5744@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 05:29 PM, Matthew Wilcox wrote:

>> Some distributions use udisks2 to grant permission to local console
>> users to create new loop devices from files.  File systems on these
>> block devices are then mounted.  This is a replacement for several
>> file systems implemented in user space, and for the users, this is a
>> good thing because the in-kernel implementations are generally of
>> higher quality.
>
> Just to be sure I understand; the user owns the file (so can change any
> bit in it at will), and the loop device is used to present that file
> to the filesystem as a block device to be mounted?

Yes, that's a fair summary.

 > Have we fuzz-tested
> all the filesystems enough to be sure that's safe?  :-)

It raised some eyebrows.  But I've looked at some of the userspace 
alternatives, and I can see why we ended up with this.

>> What happens if we have DAX support in the entire stack, and an
>> enterprising user mounts a file system?  Will she be able to fuzz
>> the file system or binfmt loaders concurrently, changing the bits
>> while they are being read?
>>
>> Currently, it appears that the loop device duplicates pages in the
>> page cache, so this does not seem to be possible, but DAX support
>> might change this.
>
> I haven't looked at adding DAX support to the loop device, although
> that would make sense.  At the moment, neither ext2 nor ext4 (our only
> DAX-supporting filesystems) use DAX for their metadata, only for user
> data.  As far as fuzzing the binfmt loaders ... are these filesystems not
> forced to be at least nosuid?

The kernel binfmt parser runs as root even without a SUID bit. :)

 > I might go so far as to make them noexec.

Oh, that's an interesting idea.

> Thanks for thinking about this.  I didn't know allowing users to mount
> files they owned was something distros actually did.  Have we considered
> prohibiting the user from modifying the file while it's mounted, eg
> forcing its permissions to 0 or pretending it's immutable?

Perhaps like "Text file busy" for executables?  How reliable is that in 
practice?

Changing file permissions doesn't affected already open descriptors and 
might not always be possible (the file system might be mounted 
read-only, but still be modifiable beneath).

-- 
Florian Weimer / Red Hat Product Security Team

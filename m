Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3HIRmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:42:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:44197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758412Ab3HIRmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:42:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,847,1367996400"; 
   d="scan'208";a="360317744"
Message-ID: <520529FD.2080407@intel.com>
Date: Fri, 09 Aug 2013 10:42:21 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz> <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com> <20130808101807.GB4325@quack.suse.cz> <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com> <20130808185340.GA13926@quack.suse.cz> <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com> <5204229F.8000507@intel.com> <20130809075523.GA14574@quack.suse.cz>
In-Reply-To: <20130809075523.GA14574@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 12:55 AM, Jan Kara wrote:
> On Thu 08-08-13 15:58:39, Dave Hansen wrote:
>> > I was coincidentally tracking down what I thought was a scalability
>> > problem (turned out to be full disks :).  I noticed, though, that ext4
>> > is about 20% slower than ext2/3 at doing write page faults (x-axis is
>> > number of tasks):
>> > 
>> > http://www.sr71.net/~dave/intel/page-fault-exts/cmp.html?1=ext3&2=ext4&hide=linear,threads,threads_idle,processes_idle&rollPeriod=5
>> > 
>> > The test case is:
>> > 
>> > 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c
>   The reason is that ext2/ext3 do almost nothing in their write fault
> handler - they are about as fast as it can get. ext4 OTOH needs to reserve
> blocks for delayed allocation, setup buffers under a page etc. This is
> necessary if you want to make sure that if data are written via mmap, they
> also have space available on disk to be written to (ext2 / ext3 do not care
> and will just drop the data on the floor if you happen to hit ENOSPC during
> writeback).

I did try throwing a fallocate() in there to see if it helped.  It
didn't appear to help.  Should it have?

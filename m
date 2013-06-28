Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3F1Psk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:48:40 -0400
Received: from www.sr71.net ([198.145.64.142]:41148 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3F1Psk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:48:40 -0400
Message-ID: <51CDB056.5090308@sr71.net>
Date: Fri, 28 Jun 2013 08:48:38 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: madvise: MADV_POPULATE for quick pre-faulting
References: <20130627231605.8F9F12E6@viggo.jf.intel.com> <20130628054757.GA10429@gmail.com>
In-Reply-To: <20130628054757.GA10429@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 10:47 PM, Zheng Liu wrote:
>> I've been doing some testing involving large amounts of
>> page cache.  It's quite painful to get hundreds of GB
>> of page cache mapped in, especially when I am trying to
>> do it in parallel threads.  This is true even when the
>> page cache is already allocated and I only need to map
>> it in.  The test:
>>
>> 1. take 160 16MB files
>> 2. clone 160 threads, mmap the 16MB files, and either
>>   a. walk through the file touching each page
> 
> Why not change MAP_POPULATE flag in mmap(2)?  Now it is only for private
> mappings.  But maybe we could let it support shared mapping.

Adding that support to mmap() will certainly _help_ some folks.  But,
anything that mmap()s something is taking mmap_sem for write.  That
means that threaded apps doing mmap()/munmap() frequently are _not_
scalable.

IOW, a process needing to do a bunch of MAP_POPULATEs isn't
parallelizable, but one using this mechanism would be.

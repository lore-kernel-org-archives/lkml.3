Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3HBPkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:40:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:45024 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3HBPkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:40:14 -0400
Message-ID: <51FBD2DF.50506@parallels.com>
Date: Fri, 2 Aug 2013 19:40:15 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <riel@redhat.com>, <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <linux-mm@kvack.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <fengguang.wu@intel.com>, <devel@openvz.org>, <mgorman@suse.de>
Subject: Re: [PATCH 10/16] fuse: Implement writepages callback
References: <20130629172211.20175.70154.stgit@maximpc.sw.ru> <20130629174525.20175.18987.stgit@maximpc.sw.ru> <20130719165037.GA18358@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130719165037.GA18358@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07/19/2013 08:50 PM, Miklos Szeredi пишет:
> On Sat, Jun 29, 2013 at 09:45:29PM +0400, Maxim Patlasov wrote:
>> From: Pavel Emelyanov <xemul@openvz.org>
>>
>> The .writepages one is required to make each writeback request carry more than
>> one page on it. The patch enables optimized behaviour unconditionally,
>> i.e. mmap-ed writes will benefit from the patch even if fc->writeback_cache=0.
> I rewrote this a bit, so we won't have to do the thing in two passes, which
> makes it simpler and more robust.  Waiting for page writeback here is wrong
> anyway, see comment above fuse_page_mkwrite().  BTW we had a race there because
> fuse_page_mkwrite() didn't take the page lock.  I've also fixed that up and
> pushed a series containing these patches up to implementing ->writepages() to
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git writepages
>
> Passed some trivial testing but more is needed.

Thanks a lot for efforts. The approach you implemented looks promising, 
but it introduces the following assumption: a page cannot become dirty 
before we have a chance to wait on fuse writeback holding the page 
locked. This is already true for mmap-ed writes (due to your fixes) and 
it seems doable for cached writes as well (like we do in 
fuse_perform_write). But the assumption seems to be broken in case of 
direct read from local fs (e.g. ext4) to a memory region mmap-ed to a 
file on fuse fs. See how dio_bio_submit() marks pages dirty by 
bio_set_pages_dirty(). I can't see any solution for this use-case. Do you?

Thanks,
Maxim

>
> I'll get to the rest of the patches next week.
>
> Thanks,
> Miklos
>

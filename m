Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966422Ab3HHW6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:58:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:56927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966300Ab3HHW6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,842,1367996400"; 
   d="scan'208";a="359919734"
Message-ID: <5204229F.8000507@intel.com>
Date: Thu, 08 Aug 2013 15:58:39 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz> <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com> <20130808101807.GB4325@quack.suse.cz> <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com> <20130808185340.GA13926@quack.suse.cz> <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
In-Reply-To: <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was coincidentally tracking down what I thought was a scalability
problem (turned out to be full disks :).  I noticed, though, that ext4
is about 20% slower than ext2/3 at doing write page faults (x-axis is
number of tasks):

http://www.sr71.net/~dave/intel/page-fault-exts/cmp.html?1=ext3&2=ext4&hide=linear,threads,threads_idle,processes_idle&rollPeriod=5

The test case is:

	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

A 'perf diff' shows some of the same suspects that you've been talking
about, Andy:

	http://www.sr71.net/~dave/intel/page-fault-exts/diffprofile.txt

>      2.39%   +2.34%  [kernel.kallsyms]      [k] __set_page_dirty_buffers               
>              +2.50%  [kernel.kallsyms]      [k] __block_write_begin                    
>              +2.16%  [kernel.kallsyms]      [k] __block_commit_write                   

The same test on ext4 but doing MAP_PRIVATE instead of MAP_SHARED goes
at the same speed as ext2/3:

	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault2.c

This is looking to me more like an ext4-specific problem that needs to
get solved rather than through some interfaces (like MADV_WILLWRITE).

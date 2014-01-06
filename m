Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaAHIBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:01:45 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24856 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbaAHIB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:01:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigKAFIFzVK2/3kU/2dsb2JhbABZgwuDOaMhjlaFVIEQFnSCJQEBAQQ6PxAIAw0LCSUPBSg0iAPERRePBQcWgw6BEwSYFoZtiymDQSg
Date: Tue, 7 Jan 2014 00:10:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: fengguang.wu@intel.com
Cc: Glauber Costa <glommer@parallels.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lkp@linux.intel.com
Subject: Re: [numa shrinker] 9b17c62382: -36.6% regression on sparse file copy
Message-ID: <20140106131042.GA5145@destitution>
References: <20140106082048.GA567@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106082048.GA567@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:20:48PM +0800, fengguang.wu@intel.com wrote:
> Hi Dave,
> 
> We noticed throughput drop in test case
> 
>         vm-scalability/300s-lru-file-readtwice (*)
> 
> between v3.11 and v3.12, and it's still low as of v3.13-rc6:
> 
>           v3.11                      v3.12                  v3.13-rc6
> ---------------  -------------------------  -------------------------
>   14934707 ~ 0%     -48.8%    7647311 ~ 0%     -47.6%    7829487 ~ 0%  vm-scalability.throughput
>              ^^     ^^^^^^
>         stddev%    change%

What does this vm-scalability.throughput number mean?

> (*) The test case basically does
> 
>         truncate -s 135080058880 /tmp/vm-scalability.img
>         mkfs.xfs -q /tmp/vm-scalability.img
>         mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability 
> 
>         nr_cpu=120
>         for i in $(seq 1 $nr_cpu)
>         do     
>                 sparse_file=/tmp/vm-scalability/sparse-lru-file-readtwice-$i
>                 truncate $sparse_file -s 36650387592
>                 dd if=$sparse_file of=/dev/null &
>                 dd if=$sparse_file of=/dev/null &
>         done

So a page cache load of reading 120x36GB files twice concurrently?
There's no increase in system time, so it can't be that the
shrinkers are running wild.

FWIW, I'm at LCA right now, so it's going to be a week before I can
look at this, so if you can find any behavioural difference in the
shrinkers (e.g. from perf profiles, on different filesystems, etc)
I'd appreciate it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

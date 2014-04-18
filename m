Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaDRRJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:09:43 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42143 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaDRRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:09:39 -0400
Date: Fri, 18 Apr 2014 13:09:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 3/8] idr: fix NULL pointer dereference when
 ida_remove(unallocated_id)
Message-ID: <20140418170935.GA23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:50PM +0800, Lai Jiangshan wrote:
> If the ida has at least one existed_id, and when an special unallocated_id

		existing id or allocated id

					  when an unallocated id which
					  meets a certain condition is passed to...

> is passed to the ida_remove(), the system will crash because it hits NULL
> pointer dereference.
> 
> This special unallocated_id is that it shares the same lowest idr layer with

The condition is that the ID shares the...

> an exsited_id, but the idr slot is different(if the unallocated_id is allocated).

the existing ID,                  would be different if the unallocated ID were to be allocated.

> In this case the supposed idr slot of the unallocated_id is NULL,

                   matching          for

> It means @bitmap == NULL, and when the code dereference it, it crash the kernel.

causing @bitmap to be NULL which the function dereferences without
checking crashing the kernel.

> 
> See the test code:
> 
> static void test3(void)
> {
> 	int id;
> 	DEFINE_IDA(test_ida);
> 
> 	printk(KERN_INFO "Start test3\n");
> 	if (ida_pre_get(&test_ida, GFP_KERNEL) < 0) return;
> 	if (ida_get_new(&test_ida,  &id) < 0) return;
> 	ida_remove(&test_ida, 4000); /* bug: null deference here */
> 	printk(KERN_INFO "End of test3\n");
> }
> 
> It only happens when unallocated_id, it is caller's fault. It is not

It happens only when the caller tries to free an unallocated ID which
is the caller's fault.

> a bug. But it is better to add the proper check and complains instead

                                                  and complain rather than crashing the kernel

> of crashing the kernel.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

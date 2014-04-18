Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaDRQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:29:39 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:62209 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:29:34 -0400
Date: Fri, 18 Apr 2014 12:29:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 1/8] idr: fix overflow bug for the max-high layer
Message-ID: <20140418162930.GC12515@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Subject: idr: fix overflow bug during maximum ID calculation at maximum height

On Fri, Apr 18, 2014 at 08:49:48PM +0800, Lai Jiangshan wrote:
> In idr_replace(), when the top layer is the max-high layer(p->layer == 3),
> The "(1 << n)" will overflow and the result is 0, it causes idr_replace()
> return -EINVAL even the id is actually valid.

  idr_replace() open-codes the logic to calculate the maximum valid ID
  given the height of the idr tree; unfortunately, the open-coded logic
  doesn't account for the fact that the top layer may have unused slots
  and over-shifts the limit to zero when the tree is at its maximum
  height.

> The following test code shows it fails to replace the value for id=((1<<27)+42):
> 
> static void test5(void)
> {
> 	int id;
> 	DEFINE_IDR(test_idr);
> #define TEST5_START ((1<<27)+42) /* use the highest layer */
> 
> 	printk(KERN_INFO "Start test5\n");
> 	id = idr_alloc(&test_idr, (void *)1, TEST5_START, 0, GFP_KERNEL);
> 	BUG_ON(id != TEST5_START);
> 	TEST_BUG_ON(idr_replace(&test_idr, (void *)2, TEST5_START) != (void *)1);
> 	idr_destroy(&test_idr);
> 	printk(KERN_INFO "End of test5\n");
> }
> 
> Fixed the bug by using idr_max() instead of the incorrect open code.

  Fix the bug by using idr_max() which correctly takes into account the
  maximum allowed shift.

> There is the same problem in sub_alloc(). The overflow causes sub_alloc()
> returns -EAGAIN unexpectedly. But the idr_get_empty_slot() will call it
> again with increased @id. So the bug is hided.

  sub_alloc() shares the same problem and may incorrectly fail with
  -EAGAIN; however, this bug doesn't affect correct operation because
  idr_get_empty_slot(), which already uses idr_max(), retries with the
  increased @id in such cases.

> CC: stable@vger.kernel.org
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3JNKVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:21:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9650 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3JNKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:21:22 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-14-525bc5478d64
Message-id: <1381745990.24685.45.camel@AMDC1943>
Subject: Re: [PATCH] swap: fix set_blocksize race during swapon/swapoff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Weijie Yang <weijie.yang.kh@gmail.com>, Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>
Date: Mon, 14 Oct 2013 12:19:50 +0200
In-reply-to: <20131011115542.a81a9215d9b876706ec58a72@linux-foundation.org>
References: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
 <20131011115542.a81a9215d9b876706ec58a72@linux-foundation.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xa7ruR6ODDC59s7SYs34Nm0XXqaks
	FssWP2W0uLxrDpvFvTX/WS2WfX3PbnFqOYfFkxP/WRw4PJ40/WT22DnrLrvHplWdbB6bPk1i
	9zgx4zeLx8ent1g8Pm+SC2CP4rJJSc3JLEst0rdL4Mq4dHoic8EM3orTf6awNzDe5Opi5OSQ
	EDCRaL53gQ3CFpO4cG89kM3FISSwlFFi5tEljBDOZ0aJhkc32EGqeAUMJHr//GUCsYUF3CX2
	9r5gBbHZBIwlNi9fAjZJREBXYtXzXcwgzcwCnxgl2r52gBWxCKhKPG5tZQSxOQW8JX6+fwu1
	oYNR4tqKd2AbmAXUJSbNW8QMcZOSxO72Tqi4vMTmNW+ZIa4QlPgx+R7LBEaBWUhaZiEpm4Wk
	bAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkDj4uoNx6TGrQ4wCHIxKPLwCTtFBQqyJ
	ZcWVuYcYJTiYlUR4BecBhXhTEiurUovy44tKc1KLDzEycXBKNTCmPFnmaSey/9PpDztMbuZp
	vpggbvpqwvkw1h2X2b/0HPeprZrj8yv+wcFiWyd/5plCWTvk4u2M0qa/kHpe6uJqfO3N7Rft
	cYfnJHtvfjSzI+d/w5/WWT1n7eVnnrnyl0vRZbruoqemTZ7f6x7MfB2zad8m6XQdCe6S3tRJ
	kTzcD0w3tlntNnVSYinOSDTUYi4qTgQAxSaV+2ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 11:55 -0700, Andrew Morton wrote:
> On Fri, 11 Oct 2013 11:54:22 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
> > Swapoff used old_block_size from swap_info which could be overwritten by
> > concurrent swapon.
> 
> Better changelogs, please.  What were the user-visible effects of the
> bug, and how is it triggered?
Let me update a little the changelog:
--------
Fix race between swapoff and swapon. Swapoff used old_block_size from
swap_info outside of swapon_mutex so it could be overwritten by
concurrent swapon.

The race has visible effect only if more than one swap block device
exists with different block sizes (e.g. /dev/sda1 with block size 4096
and /dev/sdb1 with 512). In such case it leads to setting the blocksize
of swapped off device with wrong blocksize.

The bug can be triggered with multiple concurrent swapoff and swapon:
0. Swap for some device is on.
1. swapoff:
First the swapoff is called on this device and "struct swap_info_struct
*p" is assigned. This is done under swap_lock however this lock is
released for the call try_to_unuse().

2. swapon:
After the assignment above (and before acquiring swapon_mutex &
swap_lock by swapoff) the swapon is called on the same device.
The p->old_block_size is assigned to the value of block_size the device.
This block size should be the same as previous but sometimes it is not.
The swapon ends successfully.

3. swapoff:
Swapoff resumes, grabs the locks and mutex and continues to disable this
swap device. Now it sets the block size to value taken from swap_info
which was overwritten by swapon in 2.
--------

Best regards,
Krzysztof


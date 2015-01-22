Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbAVIaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:30:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52120 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbAVIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:30:07 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-42-54c0b47b2bd9
Message-id: <1421915402.11239.0.camel@AMDC1943>
Subject: Re: Bisected BUG: using smp_processor_id() in preemptible
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Mo rton <akpm@linux-foundation.org>,
        BartlomiejZolnierkiewicz <b.zolnierkie@samsung.com>,
        KyungminPark <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Thu, 22 Jan 2015 09:30:02 +0100
In-reply-to: <20150122015344.GC21444@js1304-P5Q-DELUXE>
References: <1421746712.6847.5.camel@AMDC1943>
 <20150122015344.GC21444@js1304-P5Q-DELUXE>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7rVWw6EGGw7KW4xZ/0aNouNM9az
	Whxc1M1qcf3bG0aLld3NbBZnm96wW1zeNYfN4t6a/6wWa4/cZbdo+/yP1aJtyUYmB26PBZtK
	PTat6mTz2PRpErtH19srTB4nZvxm8XhyZTqTx/t9V9k8+rasYvT4vEkugDOKyyYlNSezLLVI
	3y6BK6O3+SxzwTOhiq6nZ9kaGDfzdzFyckgImEjseLqWDcIWk7hwbz2QzcUhJLCUUeLExLtM
	EM5nRonmq4fYQap4BfQlNi+awQxiCws4SWw5O4kVxGYTMJbYvHwJ2CQRAQ2J1as2M4M0Mwv0
	M0tMnzMTrIFFQFVi7ZMdLCA2p4C5xK0F7UBDOYA2REtc2qENEmYWUJeYNG8RM0hYQkBZorHf
	DWKtoMSPyfdYIErkJTavecs8gVFgFpKOWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJGa+7GBcfMzqEKMAB6MSD2/AygMhQqyJZcWVuYcYJTiYlUR4d24ACvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamDk+P122RIpoWuZIv/SVe4vObAn6OGNuIAXTnxfd19c8SjoSjNjWELI
	xf+P3j39E6NiVcd0zDnjsUrBvpRYq/nOzTrHfrC/8zrSwJ5ass65f2W0lsGU8umrEz49/3ku
	/NFF2xfmd0RO3LK4pm3Dcbnj3esXTEUSjrK69wv2rtV5vCJEquTXkYb/SizFGYmGWsxFxYkA
	nIt4f3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2015-01-22 at 10:53 +0900, Joonsoo Kim wrote:
> On Tue, Jan 20, 2015 at 10:38:32AM +0100, Krzysztof Kozlowski wrote:
> > Hi,
> > 
> > 
> > Since next-20150119 booting of Exynos4 based boards is nearly impossible
> > because of continuous BUG on messages. The system finally boots... but
> > console log is polluted with:
> > 
> > [    9.700828] BUG: using smp_processor_id() in preemptible [00000000] code: udevd/1656
> > [    9.708525] caller is kfree+0x8c/0x198
> > [    9.712229] CPU: 2 PID: 1656 Comm: udevd Tainted: G        W      3.19.0-rc4-00279-gd2dc80750ee0 #1630
> > [    9.721501] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> > [    9.727602] [<c0014980>] (unwind_backtrace) from [<c0011904>] (show_stack+0x10/0x14)
> > [    9.735324] [<c0011904>] (show_stack) from [<c0585bbc>] (dump_stack+0x70/0xbc)
> > [    9.742525] [<c0585bbc>] (dump_stack) from [<c01e79e0>] (check_preemption_disabled+0xf8/0x128)
> > [    9.751114] [<c01e79e0>] (check_preemption_disabled) from [<c00c501c>] (kfree+0x8c/0x198)
> > [    9.759265] [<c00c501c>] (kfree) from [<c0299b7c>] (uevent_show+0x38/0x104)
> > [    9.766210] [<c0299b7c>] (uevent_show) from [<c0299fb8>] (dev_attr_show+0x1c/0x48)
> > [    9.773763] [<c0299fb8>] (dev_attr_show) from [<c0122424>] (sysfs_kf_seq_show+0x8c/0x10c)
> > [    9.781920] [<c0122424>] (sysfs_kf_seq_show) from [<c0120f90>] (kernfs_seq_show+0x24/0x28)
> > [    9.790172] [<c0120f90>] (kernfs_seq_show) from [<c00e93b0>] (seq_read+0x1ac/0x480)
> > [    9.797806] [<c00e93b0>] (seq_read) from [<c00cacf4>] (__vfs_read+0x18/0x4c)
> > [    9.804833] [<c00cacf4>] (__vfs_read) from [<c00cada4>] (vfs_read+0x7c/0x100)
> > [    9.811950] [<c00cada4>] (vfs_read) from [<c00cae68>] (SyS_read+0x40/0x8c)
> > [    9.818810] [<c00cae68>] (SyS_read) from [<c000f160>] (ret_fast_syscall+0x0/0x30)
> > 
> > I bisected this to:
> > 
> > d2dc80750ee05ceb03c9b13b0531a782116d1ade
> > Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Date:   Sat Jan 17 11:23:23 2015 +1100
> > mm/slub: optimize alloc/free fastpath by removing preemption on/off
> > 
> > Full dmesg and config attached.
> > 
> > Any ideas?
> 
> Hello,
> 
> This issue will be fixed in next mmotm release.
> Following patch is next version of
> commit d2dc80750ee05ceb03c9b13b0531a782116d1ade.
> 
> https://lkml.org/lkml/2015/1/19/17

Great! Thanks.
Krzysztof



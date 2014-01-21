Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaAUJpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:45:12 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:57581 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaAUJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:44:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAMAG_efOD03wLtetfNAfymsCs6kVEqoJx6e7qY2txBBMDgbmfQ@mail.gmail.com>
References: <20140114004509.27138.50345.stgit@viggo.jf.intel.com>
	<20140114004622.27138.54103.stgit@viggo.jf.intel.com>
	<CAMAG_eduH4M2OPVh-R4Q6KG1DDcinEDzC-fQyXj1mLdZG=49hw@mail.gmail.com>
	<CAPcyv4hzNT15R41zSOM98f-0aQ60HBZoD_DAvf6VED7iXoCZ8w@mail.gmail.com>
	<CAPcyv4ixMVV5-9NPR_Nx-hgwAGBS8uh1DQabjimCaNfYt30kiA@mail.gmail.com>
	<CAMAG_efOD03wLtetfNAfymsCs6kVEqoJx6e7qY2txBBMDgbmfQ@mail.gmail.com>
Date: Tue, 21 Jan 2014 01:44:34 -0800
Message-ID: <CAPcyv4h10vAw3rwNo25+RaZwFsnrjWrpoktj+Yg8eR1QDDW2tw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] net_dma: simple removal
From: Dan Williams <dan.j.williams@intel.com>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Whipple <whipple@securedatainnovations.ch>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 12:16 PM, saeed bishara <saeed.bishara@gmail.com> wrote:
> Dan,
>
> isn't this issue similar to direct io case?
> can you please look at the following article
> http://lwn.net/Articles/322795/

I guess it's similar, but the NET_DMA dma api violation is more
blatant.  The same thread that requested DMA is also writing to those
same pages with the cpu.  The fix is either guaranteeing that only the
dma engine ever touches the gup'd pages or synchronizing dma before
every cpu fallback.

> regarding performance improvement using NET_DMA, I don't have concrete
> numbers, but it should be around 15-20%. my system is i/o coherent.

That sounds too high... is that throughput or cpu utilization?  It
sounds high because NET_DMA also makes the data cache cold while the
cpu copy warms the data before handing it to the application.

Can you measure relative numbers and share your testing details?  You
will need to fix the data corruption and verify that the performance
advantage is still there before proposing NET_DMA be restored.

I have a new dma_debug capability in Andrew's tree that can you help
you identify holes in the implementation.

http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-introduce-debug_dma_assert_idle.patch

--
Dan

>
> saeed
>
> On Wed, Jan 15, 2014 at 11:33 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Wed, Jan 15, 2014 at 1:31 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Wed, Jan 15, 2014 at 1:20 PM, saeed bishara <saeed.bishara@gmail.com> wrote:
>>>> Hi Dan,
>>>>
>>>> I'm using net_dma on my system and I achieve meaningful performance
>>>> boost when running Iperf receive.
>>>>
>>>> As far as I know the net_dma is used by many embedded systems out
>>>> there and might effect their performance.
>>>> Can you please elaborate on the exact scenario that cause the memory corruption?
>>>>
>>>> Is the scenario mentioned here caused by "real life" application or
>>>> this is more of theoretical issue found through manual testing, I was
>>>> trying to find the thread describing the failing scenario and couldn't
>>>> find it, any pointer will be appreciated.
>>>
>>> Did you see the referenced commit?
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=77873803363c
>>>
>>> This is a real issue in that any app that forks() while receiving data
>>> can cause the dma data to be lost.  The problem is that the copy
>>> operation falls back to cpu at many locations.  Any one of those
>>> instance could touch a mapped page and trigger a copy-on-write event.
>>> The dma completes to the wrong location.
>>>
>>
>> Btw, do you have benchmark data showing that NET_DMA is beneficial on
>> these platforms?  I would have expected worse performance on platforms
>> without i/o coherent caches.

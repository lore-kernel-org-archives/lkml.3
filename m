Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3GRNe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:34:26 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24942 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab3GRNeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:34:24 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-3a-51e7eede30d5
Message-id: <51E7EEDC.9080003@samsung.com>
Date: Thu, 18 Jul 2013 15:34:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620
 Thunderbird/17.0.7
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com>
 <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
 <51E69F49.10500@samsung.com>
 <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
 <51E7960C.8050707@samsung.com>
 <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
In-reply-to: <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xK7r33j0PNNh5VdjibNMbdovLu+aw
	WfRs2MpqsefoYXaLKW9/slt0dc9jcmDz2DnrLrvH418v2Tze77vK5tG3ZRWjx+dNcgGsUVw2
	Kak5mWWpRfp2CVwZX/ZMZyr4JFxx/9tu1gbGL/xdjJwcEgImEk/nzmGFsMUkLtxbz9bFyMUh
	JLCUUeLgi5eMEE4zk8Sqd3OYQKp4BbQkzjw+BdbBIqAq8aL1DjuIzSZgKNH1tosNxBYVCJWY
	tmQBI0S9oMSPyfdYQGwRAXOJyx86wWqYBY4ySjRNBZsjLOAl8WLOb2aIZf+YJBb+3gO2jFMg
	WOLWitdMEA1mEo9a1jFD2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgx
	t7g0L10vOT93EyMkvL/sYFx8zOoQowAHoxIPryH/80Ah1sSy4srcQ4wSHMxKIryVL4FCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGEOUeW7ECjCFcV7IUm+sYZ526/2NrXyMXMY3I1TqArwCW7+c
	CxF8vaLTw60v+rlmTM2JTy6sfw5GaQjt1bqVxuOdGLQ7sqEs9sacmV4TdWViGr1f/w5mMLu9
	VfrNhY2/VP58is3/WZM47cBVx5N1LTNWib14ujRWddXD0MIFqXdDmkyPLXryVImlOCPRUIu5
	qDgRALaZ+IlNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 7/18/2013 9:39 AM, Ricardo Ribalda Delgado wrote:
> Hello again:
>
> I have started to implemt it, but I think there is more hidden work in
> this task as it seems. In order to call dma_map_sg and
> max_dma_segment_size I need acess to the struct device, but (correct
> me if I am wrong), vb2 is device agnostic. Adding the above
> functionality will mean not only updating marvell-ccic and solo6x10,
> but updating all the vb2 buffers.

For getting device pointer, vb2-dma-sg need to be extended with so called
'allocator context'. Please check how it is done in vb2-dma-contig
(vb2_dma_contig_init_ctx() function).


> Also after some readings, maybe the sg compactation should not be done
> here, but in dma_map_sg. According to the doc:
>
> """
> The implementation is free to merge several consecutive sglist entries
> into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
> consecutive sglist entries can be merged into one provided the first one
> ends and the second one starts on a page boundary - in fact this is a huge
> advantage for cards which either cannot do scatter-gather or have very
> limited number of scatter-gather entries) and returns the actual number
> of sg entries it mapped them to. On failure 0 is returned.
> """
>
> So, my proposal would be to alloc with alloc_pages to try to get
> memory as coherent as possible, then split the page, set the sg in
> PAGE_SIZE lenghts, and then let the dma_map_sg do its magic. if it
> doesnt do compactation, fix dma_map_sg, so more driver could take
> advantage of it.

Right, this approach is probably the best one, but this way you would need
to do the compaction in every dma-mapping implementation for every supported
architecture. IMHO vb2-dma-sg can help dma-mapping by at least by allocating
memory in larger chunks and constructing shorter scatter list. Updating
dma-mapping functions across all architectures is a lot of work and testing,
so for initial version we should focus on vb2-dma-sg. Memory allocators
already do some work to ease mapping a buffer to dma space.

> I could also of course fix marvell-ccic and solo6x10 to use sg_table.
>
> Does anything of this make sense?

I would also like to help you as much as possible, but for the next 10 days
I will be not available for both personal reasons and holidays. If you have
any questions, feel free to leave them on my mail, I will reply asap I get
back.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland



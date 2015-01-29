Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbbA2Prf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:47:35 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:34439 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbbA2Prd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:47:33 -0500
Date: Thu, 29 Jan 2015 15:47:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher
 constraints with dma-parms
Message-ID: <20150129154718.GB26493@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <1422347154-15258-2-git-send-email-sumit.semwal@linaro.org>
 <20150129143908.GA26493@n2100.arm.linux.org.uk>
 <CAO_48GEOQ1pBwirgEWeVVXW-iOmaC=Xerr2VyYYz9t1QDXgVsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GEOQ1pBwirgEWeVVXW-iOmaC=Xerr2VyYYz9t1QDXgVsw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 09:00:11PM +0530, Sumit Semwal wrote:
> So, short answer is, it is left to the exporter to decide. The dma-buf
> framework should not even attempt to decide or enforce any of the
> above.
> 
> At each dma_buf_attach(), there's a callback to the exporter, where
> the exporter can decide, if it intends to handle these kind of cases,
> on the best way forward.
> 
> The exporter might, for example, decide to migrate backing storage,

That's a decision which the exporter can not take.  Think about it...

If subsystem Y has mapped the buffer, it could be accessing the buffer's
backing storage at the same time that subsystem Z tries to attach to the
buffer.

Once the buffer has been exported to another user, the exporter has
effectively lost control over mediating accesses to that buffer.

All that it can do with the way the dma-buf API is today is to allocate
a _different_ scatter list pointing at the same backing storage which
satisfies the segment size and number of segments, etc.

There's also another issue which you haven't addressed.  What if several
attachments result in lowering max_segment_size and max_segment_count
such that:

	max_segment_size * max_segment_count < dmabuf->size

but individually, the attachments allow dmabuf->size to be represented
as a scatterlist?

If an exporter were to take notice of the max_segment_size and
max_segment_count, the resulting buffer is basically unrepresentable
as a scatterlist.

> > Please consider the possible sequences of use (such as the scenario
> > above) when creating or augmenting an API.
> >
> 
> I tried to think of the scenarios I could think of, but If you still
> feel this approach doesn't help with your concerns, I'll graciously
> accept advice to improve it.

See the new one above :)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

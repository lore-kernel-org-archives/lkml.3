Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3LMQCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:02:32 -0500
Received: from smtp-out-050.synserver.de ([212.40.185.50]:1152 "EHLO
	smtp-out-047.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752772Ab3LMQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:02:30 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12968
Message-ID: <52AB2FB2.7000009@metafoo.de>
Date: Fri, 13 Dec 2013 17:02:58 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        djbw@fb.com, arnd@arndb.de, linux@arm.linux.org.uk,
        mark.rutland@arm.com, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH v14] dmaengine: Add MOXA ART DMA engine driver
References: <1386774824-1638-1-git-send-email-jonas.jensen@gmail.com> <1386851534-11288-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1386851534-11288-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 01:32 PM, Jonas Jensen wrote:
> The MOXA ART SoC has a DMA controller capable of offloading expensive
> memory operations, such as large copies. This patch adds support for
> the controller including four channels. Two of these are used to
> handle MMC copy on the UC-7112-LX hardware. The remaining two can be
> used in a future audio driver or client application.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
[...]
> +static size_t moxart_dma_desc_size_in_flight(struct moxart_chan *ch)
> +{
> +	size_t size;
> +	unsigned int completed_cycles, cycles, i;
> +
> +	for (size = i = 0; i <= ch->sgidx; i++)
> +		size += ch->desc->sg[i].len;

This still does not look right. The residue is the amount of data that still
needs to be transferred, so you need to count the the segments that have not
been completed yet. Just like I wrote in the last mail loop from ch->sgidx
to ch->desc->sglen.

> +	cycles = readl(ch->base + REG_OFF_CYCLES);
> +	completed_cycles = (ch->desc->dma_cycles - cycles);
> +	size -= completed_cycles << es_bytes[ch->desc->es];
> +
> +	dev_dbg(chan2dev(&ch->vc.chan), "%s: size=%zu\n", __func__, size);
> +
> +	return size;
> +}
[...]

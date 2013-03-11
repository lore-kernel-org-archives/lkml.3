Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3CKQ4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:56:00 -0400
Received: from smtp-out-222.synserver.de ([212.40.185.222]:1142 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CKQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:55:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28480
Message-ID: <513E0D0C.1080203@metafoo.de>
Date: Mon, 11 Mar 2013 17:57:48 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Dan Williams <djbw@fb.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
References: <1362599767-11292-1-git-send-email-mporter@ti.com> <1362599767-11292-2-git-send-email-mporter@ti.com>
In-Reply-To: <1362599767-11292-2-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>   *	struct with auxiliary transfer status information, otherwise the call
>   *	will just return a simple status code
>   * @device_issue_pending: push pending transactions to hardware
> + * @device_slave_sg_limits: return the slave SG capabilities
>   */
>  struct dma_device {
>  
> @@ -602,6 +615,9 @@ struct dma_device {
>  					    dma_cookie_t cookie,
>  					    struct dma_tx_state *txstate);
>  	void (*device_issue_pending)(struct dma_chan *chan);
> +	struct dma_slave_sg_limits *(*device_slave_sg_limits)(
> +		struct dma_chan *chan, enum dma_slave_buswidth addr_width,
> +		u32 maxburst);

In my opinion it is better to pass in a pointer to a dma_slave_sg_limits
struct and let the driver fill it. Instead of passing back a pointer to an
internal structure. It is kind of problematic because you never really know
when the user is done using the struct and you don't know when it is safe to
free or reuse it. E.g. in your implementation for the edma driver if the
function is called with different parameters for the same channel, the
previous result will also be overwritten.

- Lars

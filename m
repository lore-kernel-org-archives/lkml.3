Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbaGCQMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:07 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:33618 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758663AbaGCQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3872:3876:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: waves93_862a745d7e127
X-Filterd-Recvd-Size: 1650
Message-ID: <1404403920.14741.44.camel@joe-AO725>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
From: Joe Perches <joe@perches.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, sr@denx.de
Date: Thu, 03 Jul 2014 09:12:00 -0700
In-Reply-To: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 17:54 +0200, Jean-Michel Hautbois wrote:
> This patch corrects three big/little endian issues. Tested on i.MX6.

trivial:

> diff --git a/drivers/misc/lattice-ecp3-config.c
[]
> @@ -165,8 +165,8 @@ static void firmware_load(const struct firmware
> *fw, void *context)
> 
>      txbuf[0] = FPGA_CMD_READ_STATUS;
>      ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> -    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
> -    status = *(u32 *)&rxbuf[4];
> +    dev_dbg(&spi->dev, "FPGA Status=%08x\n", be32_to_cpu(*(u32 *)&rxbuf[4]));
> +    status = be32_to_cpu(*(u32 *)&rxbuf[4]);

This should emit a sparse error.
It'd be simpler as:

	status = be32_to_cpu(*(__be32 *)&rxbuf[4]);
	dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaAWNvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:51:09 -0500
Received: from smtp-out-197.synserver.de ([212.40.185.197]:1077 "EHLO
	smtp-out-085.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772AbaAWNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:51:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24799
Message-ID: <52E11E39.6090901@metafoo.de>
Date: Thu, 23 Jan 2014 14:50:49 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>  <1390409565-4200-2-git-send-email-sthokal@xilinx.com>  <52E0FC22.8060903@metafoo.de> <1390484317.7619.81.camel@smile>
In-Reply-To: <1390484317.7619.81.camel@smile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 02:38 PM, Shevchenko, Andriy wrote:
> On Thu, 2014-01-23 at 12:25 +0100, Lars-Peter Clausen wrote:
>> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
> 
> [...]
> 
>>> +	/* Request the interrupt */
>>> +	chan->irq = irq_of_parse_and_map(node, 0);
>>> +	err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
>>> +			       IRQF_SHARED, "xilinx-vdma-controller", chan);
>>
>> This is a clasic example of where to not use devm_request_irq. 'chan' is
>> accessed in the interrupt handler, but if you use devm_request_irq 'chan'
>> will be freed before the interrupt handler has been released, which means
>> there is now a race condition where the interrupt handler can access already
>> freed memory.ta
> 
> Could you elaborate this case? As far as I understood managed resources
> are a kind of stack pile. In this case you have no such condition. Where
> am I wrong?

The stacked stuff is only ran after the remove() function. Which means that
you call dma_async_device_unregister() before the interrupt handler is
freed. Another issue with the interrupt handler is a bit hidden. The driver
does not call tasklet_kill in the remove function. Which it should though to
make sure that the tasklet does not race against the freeing of the memory.
And in order to make sure that the tasklet is not rescheduled you need to
free the irq before killing the tasklet, since the interrupt handler
schedules the tasklet.

- Lars


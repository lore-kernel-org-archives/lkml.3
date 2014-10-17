Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaJQLQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:16:04 -0400
Received: from smtp-out-111.synserver.de ([212.40.185.111]:1041 "EHLO
	smtp-out-111.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJQLQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:16:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30700
Message-ID: <5440FA6B.6040303@metafoo.de>
Date: Fri, 17 Oct 2014 13:15:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Ray Jui <rjui@broadcom.com>, Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
References: <rjui@broadcom.com> <1413506896-4536-1-git-send-email-rjui@broadcom.com> <5440C929.9050906@metafoo.de> <20141017073535.GN1638@intel.com>
In-Reply-To: <20141017073535.GN1638@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 09:35 AM, Vinod Koul wrote:
> On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
>> On 10/17/2014 02:48 AM, Ray Jui wrote:
>>> As part of subsystem that many slave drivers depend on, it's more
>>> appropriate for the pl330 DMA driver to be initialized at
>>> subsys_initcall than device_initcall
>>
>> Well, we do have -EPROBE_DEFER these days to handle these kinds of
>> dependencies so we no longer have to these kinds of manual init
>> reordering tricks.
> How ould that work?
>
> Consider for example SPI and dmanegine. SPI driver got probed, then to start
> a transaction requested a channel... while dmaengine driver is still getting
> probed/not probed yet. So SPI driver didnt get a channel.
>

Ideally the SPI driver requests the channel in probe function and if the DMA 
controller is not yet probed returns EPROBE_DEFER. If the SPI driver 
requests the channel in the transfer handler it needs to deal with being 
able to fall back to non DMA transfers anyway so this shouldn't be a problem.

But in any case fiddling around with the init sequences is just a quick hack 
and might makes the problem less likely to appear in some cases, but there 
is no guarantee that it works. And I think the proper solution at the moment 
is to use probe deferral.

Other subsystems have seen patches which moved drivers from using 
subsys_initcall to device_initcall/module_..._driver/ with the reasoning 
that this is no longer necessary because of EPROBE_DEFER. So I don't think 
we should be doing the exact opposite in DMA framework. Also if we'd apply 
this patch it won't take to long until somebody suggest going back to 
module_platform_driver() instead of subsys_initcall.

- Lars

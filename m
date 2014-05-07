Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaEGTP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:15:56 -0400
Received: from smtp-out-029.synserver.de ([212.40.185.29]:1027 "EHLO
	smtp-out-016.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751010AbaEGTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:15:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4471
Message-ID: <536A865B.1060007@metafoo.de>
Date: Wed, 07 May 2014 21:15:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Christopher Freeman <cfreeman@nvidia.com>, ldewangan@nvidia.com,
        swarren@nvidia.com, vinod.koul@intel.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] dma: tegra: avoid int overflow for transferred
 count
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com> <1399411343-12222-4-git-send-email-cfreeman@nvidia.com> <536A61A3.3050601@wwwdotorg.org>
In-Reply-To: <536A61A3.3050601@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 06:38 PM, Stephen Warren wrote:
> On 05/06/2014 03:22 PM, Christopher Freeman wrote:
>> bytes_transferred will overflow during long audio playbacks.  Since
>> the driver only ever consults this value modulo bytes_requested, store the
>> value modulo bytes_requested.
>
> The audio driver may only interpret the value modulo bytes_requested,
> but what about other drivers such as the high-speed UART (and SPI?) drivers?
>
> What is the dmaengine API's design requirement here, and what do other
> dmaengine drivers do. If it's to store the modulo, then I'm fine with
> this change.

Yep, this part of the API. The residue should be between transfer length and 
0. While 0 is special and should only be returned if the transfer has 
finished. For cyclic transfers this means it should never be zero. So if 
transferred_bytes is incremented modulo length and residue is length - 
transferred_bytes you get the correct result.


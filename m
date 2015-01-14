Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbbANB5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:57:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55822 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbbANB5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:57:10 -0500
Message-ID: <54B5CCDA.4040304@ti.com>
Date: Tue, 13 Jan 2015 19:56:42 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Lokesh Vutla <lokeshvutla@ti.com>, Roger Quadros <rogerq@ti.com>,
        <tony@atomide.com>, <santosh.shilimkar@oracle.com>, <t-kristo@ti.com>,
        <nm@ti.com>, <nsekhar@ti.com>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com> <alpine.DEB.2.02.1501060202540.28771@utopia.booyaka.com> <54AB9983.1040703@ti.com> <54AC1800.1020406@ti.com> <alpine.DEB.2.02.1501132324150.28034@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1501132324150.28034@utopia.booyaka.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 01/13/2015 05:29 PM, Paul Walmsley wrote:
> Hi Suman,
> 
> thanks for pitching in on this!
> 
> On Tue, 6 Jan 2015, Suman Anna wrote:
> 
>> You have removed the return from the above block on failure. If any DT
>> entry doesn't have the reg property, this will hang the kernel boot.
>> Just remove the "reg" entry from any of the existing DT, and you will
>> run into the issue, this is what 6423d6df1440 ("ARM: OMAP2+: hwmod:
>> check for module address space during init") fixed. 
> 
> Seems like that's the problem that we need to track down, then.  If a 
> hwmod has no MPU-accessible registers, it should still be possible to 
> init the clocks for the device, etc. ...

Yes true, and I should have rephrased above statement a little better -
its for modules with sysc but with no reg property to supply the base
for the module's SYSCONFIG or SYSSTATUS registers. The commit
6423d6df1440 has the explanation for the hang.

> 
>> Also, are you sure you want to turn the WARN into a pr_debug, it won't 
>> even show during the kernel boot log if the reg base is missing.
> 
> No, I'm not sure :-)  I guess it depends how many hwmods we'll have with 
> no MPU-accessible registers.  We don't seem to have address ranges for the 
> interconnects defined; we could fix that fairly easily.

The WARN_ON previously was to throw a eye-catchy print for the case
where hwmods have sysc but no address space defined (is an error
usually, but this is what we run into during the DT conversion of a
device as the hwmod and DTS changes come in through separate topic
branches).  I still think that the sysc check should be before the check
for _HWMOD_NO_MPU_PORT, a module with sysc mandates it has an MPU port.

regards
Suman

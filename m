Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3FFS3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:29:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46525 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3FFS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:29:19 -0400
Message-ID: <51B0D4FA.5070500@wwwdotorg.org>
Date: Thu, 06 Jun 2013 12:29:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
CC: gnurou@gmail.com, devicetree-discuss@lists.ozlabs.org,
        Chris Johnson <CJohnson@nvidia.com>, linux-kernel@vger.kernel.org,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <51B0BC80.9040007@wwwdotorg.org> <20130606180824.GC3320@localhost.localdomain>
In-Reply-To: <20130606180824.GC3320@localhost.localdomain>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 12:08 PM, Dave Martin wrote:
> On Thu, Jun 06, 2013 at 10:44:48AM -0600, Stephen Warren wrote:
>> On 06/06/2013 01:28 AM, Alexandre Courbot wrote:
>>> Boot loaders on some Tegra devices can be unlocked but do not let the
>>> system operate without SecureOS. SecureOS prevents access to some
>>> registers and requires the operating system to perform certain
>>> operations through Secure Monitor Calls instead of directly accessing
>>> the hardware.
>>>
>>> This patch introduces basic SecureOS support for Tegra. SecureOS support
>>> can be enabled by adding a "nvidia,secure-os" property to the "chosen"
>>> node of the device tree.
...
> So, something like
> 
> 	foo-firmware {
> 		compatible = "vendor1,foo-firmware-1.0", "vendor1,foo-firmware";
> 		method = "smc";
> 
> 		// ...
> 	};
> 
> 	bar-firmware {
> 		compatible = "vendor2,bar-firmware-1.6", "vendor2,bar-firmware";
> 		method = "smc";
> 
> 		// ...
> 	};
> 
> Could make sense.

I'm not sure if the method property is useful in most cases. For generic
ABIs such as PSCI that actually support multiple communication paths,
yes, it makes sense. However, it seems like for most custom ABIs, such
as is presumably implemented by whatever "SecureOS" is on Tegra, the
firmware type (or compatible value) directly implies that it operates
over SMC not HVC. After all, presumably if the kernel was virtualized,
it wouldn't have access to the raw secure monitor? I suppose you could
argue that the hypervisor might end up emulating the same ABI over HVC
instead? I'm not sure how likely that is. A compromise might be to
assume SMC if no property was present, which would allow it to be
optionally added later if it turned out to be useful.

> ...where we would require all new firmware interface bindings to
> include the "-firmware" in their node names and compatible strings
> (with a version suffix encouraged for the compatible strings, where
> relevant).

That's probably a good convention, but I'm not sure it should be
required (or at least validated by code). Requiring this by code review
might be OK. Node names aren't meant to be interpreted semantically.

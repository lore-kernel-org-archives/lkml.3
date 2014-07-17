Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaGQH4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:56:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5750 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaGQH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:56:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Jul 2014 00:49:19 -0700
Message-ID: <53C781BE.8080608@nvidia.com>
Date: Thu, 17 Jul 2014 10:56:46 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405510814-31928-1-git-send-email-mperttunen@nvidia.com> <53C666E5.6030009@redhat.com> <20140716131306.GB23384@ulmo> <53C6908A.2050200@redhat.com> <20140716195136.GB5212@mithrandir> <53C77263.7050903@redhat.com> <20140717073956.GA18640@ulmo>
In-Reply-To: <20140717073956.GA18640@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 10:39, Thierry Reding wrote:
> ...
> One other thing that I've been thinking about is whether it would make
> sense to make the ahci_platform library use a list of clock names that
> it should request. This would better mirror the clock bindings
> convention and allow drivers (such as the Tegra one) to take ownership
> of clocks that need special handling while at the same time leaving it
> to the helpers to do the bulk of the work.
>
> One way I can think of to handle this would be by adding a struct
> ahci_platform_resources * parameter to ahci_platform_get_resources(),
> sowewhat like this:
>
> 	struct ahci_platform_resources {
> 		const char *const *clocks;
> 		unsigned int num_clocks;
>
> 		const char *const *resets;
> 		unsigned int num_resets;
> 	};
>
> 	struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
> 							   const struct ahci_platform_resources *res)
> 	{
> 		...
>
> 		for (i = 0; i < res->num_clocks; i++) {
> 			clk = clk_get(&pdev->dev, res->clocks[i]);
> 			...
> 		}
>
> 		...
>
> 		for (i = 0; i < res->num_resets; i++) {
> 			rst = reset_control_get(&pdev->dev, res->resets[i]);
> 			...
> 		}
>
> 		...
> 	}
>

I think something like this would be required to support reset_controls 
anyway, as you can only get reset controls by name. This is what I 
alluded to (in the cover letter) when saying that adding reset control 
support would require an API break.

Also: is there a reason to not use the devm_* variants? I note that the 
helper code has not been able to prevent any of the ahci_platform 
drivers from messing up by not calling ahci_platform_put_resources.

- Mikko

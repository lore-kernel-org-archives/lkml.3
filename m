Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3EJUEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:04:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53953 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3EJUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:04:29 -0400
Message-ID: <518D52CA.7000100@wwwdotorg.org>
Date: Fri, 10 May 2013 14:04:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 10/10] Usb: Move PORTSC access to PHY
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com> <1368194051-4925-11-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1368194051-4925-11-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 07:54 AM, Venu Byravarasu wrote:
> Changes with this patch:
> 1. As PHY is being registered as separate platform driver & EHCI Tegra
> is no more calling PHY open, moved tegra_ehci_set_pts & tegra_ehci_set_phcd
> functions to PHY driver,
> 
> 2. Removed unused defines for multiple USB port base addresses

This patch (mostly?) is a revert of bbdabdb "usb: add APIs to access
host registers from Tegra PHY". I don't think we want to revert this[1].

Instead, once patch 9/10 in this series is applied, the Tegra EHCI
module should no longer directly reference any symbols in the Tegra USB
PHY module. This is because the functions exposed by the Tegra PHY
module are now accessed using the new standard PHY APIs, rather than
directly by symbol name.

Assuming that's true, it is then permissible for the Tegra PHY module to
once again directly reference symbols exported by the Tegra EHCI module.
So, instead of moving the functions from the EHCI code to the PHY code,
keep them in the EHCI code, and call them from the PHY code, but call
them by function name instead of by function pointer. That way, there's
no need to pass the function pointers during initialization.

You will have to roll that change into patch 9/10 to make git bisect work.


[1] The background is that NVIDIA HW has added some non-standard
register bits to the PORTSC register, related to PHY control. The PHY
driver needs to control those bits, but they're in the EHCI register
space. Since the non-standard bits are controlled by read-modify-write,
the EHCI driver should implement the register accesses, so the it can
implement locking against its own read-modify-write of that register if
required.

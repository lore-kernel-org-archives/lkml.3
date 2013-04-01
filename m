Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3DAFqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:46:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43352 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3DAFp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:45:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51591EEE.60401@jp.fujitsu.com>
Date: Mon, 01 Apr 2013 14:45:18 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: joro@8bytes.org
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com> <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com> <20130327103122.GK30540@8bytes.org>
In-Reply-To: <20130327103122.GK30540@8bytes.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/27 19:31), Joerg Roedel wrote:
> On Wed, Mar 27, 2013 at 02:02:44PM +0900, Takao Indoh wrote:
>> The root cause of this problem is mismatch between iommu->gcmd and
>> global command register in the case of kdump. At boot time, initial
>> value of iommu->gcmd is zero as I wrote above, but actual global command
>> register is *not* zero because some bits like IRE/TE/QIE are already set
>> in *first* kernel. Therefore this patch synchronize them to fix this
>> problem.
> 
> Ok, I understand, but I still don't see why this is a problem. There is
> no point for the kdump kernel to preserve hardware state from the
> previous kernel. So I think the way it is implemented is correct.

Sorry, my explanation was misleading. The purpose is not preserving
hardware state, but cleaning up hardware status at appropriate place.

kdump kernel boots up without power-on-reset, so we have to disable
hardware functions like DMAR before initializing them.

<Current flow on kdump boot>
enable_IR
  intel_enable_irq_remapping
    iommu_disable_irq_remapping  <== IRES/QIES/TES disabled here
    dmar_disable_qi              <== do nothing
    dmar_enable_qi               <== QIES enabled
    intel_setup_irq_remapping    <== IRES enabled

intel_iommu_init
  init_dmars
    iommu_enable_translation     <== TES enabled


<New flow on kdump boot after applying patch>
enable_IR
  intel_enable_irq_remapping
    iommu_disable_irq_remapping  <== IRES disabled
    dmar_disable_qi              <== QIES disabled
    dmar_enable_qi               <== QIES enabled
    intel_setup_irq_remapping    <== IRES enabled

intel_iommu_init
  init_dmars
    iommu_disable_translation    <== TES disabled (added by patch)
    iommu_enable_translation     <== TES enabled

I want to change flow like this to avoid misunderstanding. In that sense,
this patch is a kind of cleanup rather than fixing problem.

Backgroud:
I'm working on kdump problem with iommu and investigated when DMAR and
IR are disabled in kdump kernel boot. As for IR, I can easily find the
code in intel_enable_irq_remapping() since there is good comment for
that.

                /*
                 * Disable intr remapping and queued invalidation, if already
                 * enabled prior to OS handover.
                 */
                iommu_disable_irq_remapping(iommu);

                dmar_disable_qi(iommu);

However, there is no code to disable DMAR on startup, but it is actually
disabled somewhere during bootup. And finally I found out is is done in
intel_enable_irq_remapping(). This is very misleading. Why
"iommu_disable_irq_remapping" is disabling bits other than IR? After
applying patch, it is easy to understand because it disables only IR, as
the name suggests.

Thanks,
Takao Indoh


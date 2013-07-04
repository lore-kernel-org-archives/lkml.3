Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3GDIhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:37:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35600 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3GDIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:36:58 -0400
Date: Thu, 4 Jul 2013 09:35:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Stephen Warren <swarren@nvidia.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: add missing __FINIT to head-common.S to match
	__INIT
Message-ID: <20130704083520.GI24642@n2100.arm.linux.org.uk>
References: <1372875174-26812-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372875174-26812-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 12:12:54PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Macro __INIT is used to place various code in head-common.S into the init
> section. This should be matched by a closing __FINIT at the end of the
> code destined for the init section. Add this missing macro.
> 
> This historically caused no problem, because macro __CPUINIT was used at
> the exact location where __FINIT was missing, which then placed following
> code into the cpuinit section. However, with commit 22f0a2736 "init.h:
> remove __cpuinit sections from the kernel" applied, __CPUINIT becomes a
> no-op, thus leaving all this code in the init section, rather than the
> regular text section. This caused issues such as secondary CPU boot
> failures or crashes.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> v2: Moved __FINIT after lookup_processor_type, to correctly match the
> location of __CPUINIT.
> 
> Russell, I assume I should add this to the ARM patch tracker.

See the discussion I've had with Paul on this.  I disagree that adding
__FINIT "solves" the problem.  It just _changes_ the possibilities for
getting it wrong to a different set of possibilities.

__FINIT just swaps the current section with the one which was last in
use, which might be a fair way back up the file.  The problem is what
happens if someone changes the section before the __INIT without
checking the following code.

If we want to mark the end of the .init.text section, then __FINIT is
a good way to do that, but follow it with an explicit statement about
what section you want the following code to be in to ensure that it
is placed into the intended section irrespective of what future changes
occur.

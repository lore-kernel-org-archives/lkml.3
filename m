Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335Ab3DDSHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:07:32 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:45838 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294Ab3DDSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:07:29 -0400
Date: Thu, 4 Apr 2013 11:07:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 05/20] x86, ACPI: Split acpi_initrd_override to
 find/copy two functions
Message-ID: <20130404180721.GT9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362897887-30808-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:44:32PM -0800, Yinghai Lu wrote:
> To parse srat early, we need to move acpi table probing early.
> acpi_initrd_table_override is before acpi table probing. So we need to
> move it early too.
> 
> Current code acpi_initrd_table_override is after init_mem_mapping and
> relocate_initrd(), so it can scan initrd and copy acpi tables with kernel
> virtual address of initrd.
> Copying need to be after memblock is ready, because it need to allocate
> buffer for new acpi tables.
> 
> So we have to split that function to find and copy two functions.
> Find should be as early as possible. Copy should be after memblock is ready.
> 
> Finding could be done in head_32.S and head64.c, just like microcode
> early scanning. In head_32.S, it is 32bit flat mode, we don't
> need to set page table to access it. In head64.c, #PF set page table
> could help us access initrd with kernel low mapping address.
> 
> Copying could be done just after memblock is ready and before probing
> acpi tables, and we need to early_ioremap to access source and target
> range, as init_mem_mapping is not called yet.
> 
> Also move down two functions declaration to avoid #ifdef in setup.c
> 
> ACPI_INITRD_TABLE_OVERRIDE depends one ACPI and BLK_DEV_INITRD.
> So could move declaration out from #ifdef CONFIG_ACPI protection.

Heh, I couldn't really follow the above.  How about something like the
following.

 While a dummy version of acpi_initrd_override() was defined when
 !CONFIG_ACPI_INITRD_TABLE_OVERRIDE, the prototype and dummy version
 were conditionalized inside CONFIG_ACPI.  This forced setup_arch() to
 have its own #ifdefs around acpi_initrd_override() as otherwise build
 would fail when !CONFIG_ACPI.  Move the prototypes and dummy
 implementations of the newly split functions below CONFIG_ACPI block
 in acpi.h so that we can do away with #ifdefs in its user.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

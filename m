Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3FRAYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:24:31 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:42325 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3FRAY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:24:29 -0400
Message-ID: <1371515047.13194.6.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 06/22] x86, ACPI: Split acpi_initrd_override to
 find/copy two functions
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Date: Mon, 17 Jun 2013 18:24:07 -0600
In-Reply-To: <1371257800-11720-7-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
	 <1371257800-11720-7-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 17:56 -0700, Yinghai Lu wrote:
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
> While a dummy version of acpi_initrd_override() was defined when
> !CONFIG_ACPI_INITRD_TABLE_OVERRIDE, the prototype and dummy version
> were conditionalized inside CONFIG_ACPI.  This forced setup_arch() to
> have its own #ifdefs around acpi_initrd_override() as otherwise build
> would fail when !CONFIG_ACPI.  Move the prototypes and dummy
> implementations of the newly split functions below CONFIG_ACPI block
> in acpi.h so that we can do away with #ifdefs in its user.
> 
> -v2: Split one patch out according to tj.
>      also don't pass table_nr around.
> -v3: Add Tj's changelog about moving down to #idef in acpi.h to
>      avoid #idef in setup.c
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Jacob Shin <jacob.shin@amd.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Acked-by: Tejun Heo <tj@kernel.org>
> Tested-by: Thomas Renninger <trenn@suse.de>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>

Looks good to me.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



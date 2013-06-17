Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3FQXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:52:22 -0400
Received: from mail-ye0-f177.google.com ([209.85.213.177]:62797 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3FQXwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:52:21 -0400
Date: Mon, 17 Jun 2013 16:52:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [Part1 PATCH v5 07/22] x86, ACPI: Store override acpi tables
 phys addr in cpio files info array
Message-ID: <20130617235212.GQ32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:02:54PM +0800, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> This patch introduces a file_pos struct to store physaddr. And then changes
> acpi_initrd_files[] to file_pos type. Then store physaddr of ACPI tables
> in acpi_initrd_files[].
> 
> For finding, we will find ACPI tables with physaddr during 32bit flat mode
> in head_32.S, because at that time we don't need to setup page table to
> access initrd.
> 
> For copying, we could use early_ioremap() with physaddr directly before
> memory mapping is set.
> 
> To keep 32bit and 64bit platforms consistent, use phys_addr for all.

Also, how about something like the following?

Subject: x86, ACPI: introduce a new struct to store phys_addr of acpi override tables

ACPI initrd override table handling has been recently broken into two
functions - acpi_initrd_override_find() and
acpi_initrd_override_copy().  The former function currently stores the
virtual addresses and sizes of the found override tables in an array
of struct cpio_data for the latter function.

To make NUMA information available earlier during boot,
acpi_initrd_override_find() will be used much earlier - on 32bit, from
head_32.S before linear address translation is set up, which will make
it impossible to use the virtual addresses of the tables.

This patch introduces a new struct - file_pos - which records
phys_addr and size of a memory area, and replaces the cpio_data array
with it so that acpi_initrd_override_find() can record the phys_addrs
of the override tables instead of virtual addresses.  This will allow
using the function before the linear address is set up.

acpi_initrd_override_copy() now accesses the override tables using
early_ioremap() on the stored phys_addrs.

-- 
tejun

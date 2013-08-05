Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3HENQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:16:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56522 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3HENQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:16:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 05/18] x86, ACPICA: Split acpi_boot_table_init() into two parts.
Date: Mon, 05 Aug 2013 15:26:37 +0200
Message-ID: <2500845.tndtCsERty@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51FF1A4F.1050309@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com> <7364455.HW1C4G1skW@vostro.rjw.lan> <51FF1A4F.1050309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 05, 2013 11:21:51 AM Tang Chen wrote:
> Hi Rafael,
> 
> On 08/02/2013 09:00 PM, Rafael J. Wysocki wrote:
> ......
> >> This patch splits acpi_boot_table_init() into two steps:
> >> 1. Parse RSDT, which cannot be overrided, and initialize
> >>     acpi_gbl_root_table_list. (step 1 + 2 above)
> >> 2. Install all ACPI tables into acpi_gbl_root_table_list.
> >>     (step 3 + 4 above)
> >>
> >> In later patches, we will do step 1 + 2 earlier.
> >
> > Please note that Linux is not the only user of the code you're modifying, so
> > you need to make it possible to use the existing functions.
> >
> > In particular, acpi_tb_parse_root_table() can't be modified the way you did it,
> > because that would require all of the users of ACPICA to be modified.
> 
> OK, I understand it. Then how about acpi_tb_install_table() ?
> 
> acpi_tb_install_table() is also an ACPICA API. But can we split the
> acpi_initrd_table_override part out ? Like the following:

I'm not sure what you mean.  acpi_tb_install_table() doesn't call
acpi_initrd_table_override() directly.

Do you want to split the acpi_tb_table_override() call out of it?

I'm afraid that still wouldn't be OK.

> 1. Initialize acpi_gbl_root_table_list earlier, and install all tables
>     provided by firmware.
> 2. Find SRAT in initrd. If no overridden SRAT, get the SRAT in 
> acpi_gbl_root_table_list
>     directly. And mark hotpluggable memory. (This the job I want to do.)
> 3. DO acpi_initrd_table_override job.
> 
> Finally it will work like the current kernel. The only difference is:
> Before the patch-set, it try to do override first, and then install 
> firmware tables.
> After the patch-set, it installs firmware tables, and then do the override.

I think I understand what you're trying to achieve and I don't have objections
agaist the goal, but the matter is *how* to do that.

Why don't you do something like this:
(1) Introduce two new functions that will each do part of
    acpi_tb_parse_root_table() such that calling them in sequence, one right
    after the other, will be exactly equivalent to the current
    acpi_tb_parse_root_table().
(2) Redefine acpi_tb_parse_root_table() as a wrapper calling those two new
    function one right after the other.
(3) Make Linux use the two new functions directly instead of calling
    acpi_tb_parse_root_table()?

Then, Linux will use your new functions and won't call acpi_tb_parse_root_table()
at all, but the other existing users of ACPICA may still call it without any
modifications.

Does this make sense to you?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

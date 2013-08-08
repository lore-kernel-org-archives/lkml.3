Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3HHF1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:27:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34714 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096Ab3HHF12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:27:28 -0400
Message-ID: <1375939646.2424.132.camel@joe-AO722>
Subject: Re: [PATCH part2 3/4] acpi: Remove "continue" in macro
 INVALID_TABLE().
From: Joe Perches <joe@perches.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
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
Date: Wed, 07 Aug 2013 22:27:26 -0700
In-Reply-To: <1375938239-18769-4-git-send-email-tangchen@cn.fujitsu.com>
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1375938239-18769-4-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 13:03 +0800, Tang Chen wrote:

> Change it to the style like other macros:
> 
>  #define INVALID_TABLE(x, path, name)                                    \
>          do { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); } while (0)

Single statement macros do _not_ need to use 
	"do { foo(); } while (0)"
and should be written as
	"foo()"

> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
[]
> @@ -564,8 +564,8 @@ static const char * const table_sigs[] = {
>  	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
>  
>  /* Non-fatal errors: Affected tables/files are ignored */
> -#define INVALID_TABLE(x, path, name)					\
> -	{ pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
> +#define ACPI_INVALID_TABLE(x, path, name)					\
> +	do { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); } while (0)

Just remove the silly macro altogether

> @@ -593,9 +593,11 @@ void __init acpi_initrd_override(void *data, size_t size)
[]
> -		if (file.size < sizeof(struct acpi_table_header))
> -			INVALID_TABLE("Table smaller than ACPI header",
> +		if (file.size < sizeof(struct acpi_table_header)) {
> +			ACPI_INVALID_TABLE("Table smaller than ACPI header",
>  				      cpio_path, file.name);

and use the normal style

			pr_err("ACPI OVERRIDE: Table smaller than ACPI header [%s%s]\n",
			       cpio_path, file.name);

> @@ -603,15 +605,21 @@ void __init acpi_initrd_override(void *data, size_t size)

etc...


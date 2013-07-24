Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab3GXKJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:09:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16793 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3GXKJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:09:20 -0400
X-IronPort-AV: E=Sophos;i="4.89,734,1367942400"; 
   d="scan'208";a="8005608"
Message-ID: <51EFA873.9050300@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 18:12:03 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 13/21] x86, acpi: Try to find SRAT in firmware earlier.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-14-git-send-email-tangchen@cn.fujitsu.com> <20130723204949.GR21100@mtj.dyndns.org>
In-Reply-To: <20130723204949.GR21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:07:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:07:16,
	Serialize complete at 2013/07/24 18:07:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 04:49 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:26PM +0800, Tang Chen wrote:
......
>> +	for (pos = 0;
>> +	     pos<  acpi_gbl_root_table_list.current_table_count;
>> +	     pos++) {
>> +		if (!ACPI_COMPARE_NAME
>> +		    (&(acpi_gbl_root_table_list.tables[pos].signature),
>> +		    signature))
>
> Hohumm... creative formatting.  Can't you just cache the tables
> pointer in a local variable with short name and avoid the creativity?

OK, followed.

>
>> +			continue;
>> +
>> +		memcpy(out_desc,&acpi_gbl_root_table_list.tables[pos],
>> +		       sizeof(struct acpi_table_desc));
>> +
>> +		return_ACPI_STATUS(AE_OK);
>> +	}
>> +
>> +	return_ACPI_STATUS(AE_NOT_FOUND);
>
> Also, if we already know that SRAT is what we want, I wonder whether
> it'd be simpler to store the location of SRAT somewhere instead of
> trying to be generic with the early processing.

Do you mean get the SRAT's address without touching any ACPI global
variables, such as acpi_gbl_root_table_list ?

The physical addresses of all tables is stored in RSDT (Root System
Description Table), which is the root table. We need to parse RSDT
to get SRAT address.

Using acpi_gbl_root_table_list is very convenient. The initialization
of acpi_gbl_root_table_list is using acpi_os_map_memory(), so it can be
done before init_mem_mapping() and relocate_initrd().

With acpi_gbl_root_table_list initialized, we can iterate it and find
SRAT easily. Otherwise, we have to do the same procedure to parse RSDT,
and find SRAT, which I don't think could be any simpler. I think reuse
the existing acpi_gbl_root_table_list code is better.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3BGGXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:23:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3BGGXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:23:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,620,1355068800"; 
   d="scan'208";a="6699566"
Message-ID: <5113483C.8070509@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 14:22:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com> <20130204152651.2bca8dba.akpm@linux-foundation.org> <5111BE09.2030509@cn.fujitsu.com> <20130206135409.3d8b37f7.akpm@linux-foundation.org>
In-Reply-To: <20130206135409.3d8b37f7.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 14:22:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 14:22:18,
	Serialize complete at 2013/02/07 14:22:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 05:54 AM, Andrew Morton wrote:
> On Wed, 06 Feb 2013 10:20:57 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>>>>
>>>> +	if (!strncmp(p, "acpi", max(4, strlen(p))))
>>>> +		movablemem_map.acpi = true;
>>>
>>> Generates a warning:
>>>
>>> mm/page_alloc.c: In function 'cmdline_parse_movablemem_map':
>>> mm/page_alloc.c:5312: warning: comparison of distinct pointer types lacks a cast
>>>
>>> due to max(int, size_t).
>>>
>>> This is easily fixed, but the code looks rather pointless.  If the
>>> incoming string is supposed to be exactly "acpi" then use strcmp().  If
>>> the incoming string must start with "acpi" then use strncmp(p, "acpi", 4).
>>>
>>> IOW, the max is unneeded?
>>
>> Hi Andrew,
>>
>> I think I made another mistake here. I meant to use min(4, strlen(p)) in
>> case p is
>> something like 'aaa' whose length is less then 4. But I mistook it with
>> max().
>>
>> But after I dig into strcmp() in the kernel, I think it is OK to use
>> strcmp().
>> min() or max() is not needed.
>
> OK, I did that.
>
> But the code still looks a bit more complex than we need.  Could we do
>
> static int __init cmdline_parse_movablemem_map(char *p)
> {
> 	char *oldp;
> 	u64 start_at, mem_size;
>
> 	if (!p)
> 		goto err;
>
> 	/*
> 	 * If user decide to use info from BIOS, all the other user specified
> 	 * ranges will be ingored.
> 	 */
> 	if (!strcmp(p, "acpi")) {
> 		movablemem_map.acpi = true;
> 		if (movablemem_map.nr_map) {
> 			memset(movablemem_map.map, 0,
> 				sizeof(struct movablemem_entry)
> 				* movablemem_map.nr_map);
> 			movablemem_map.nr_map = 0;
> 		}
> 		return 0;
> 	}
>
>
No, I don't think so.

If user specified like this:

1) movablemem_map=aaa@bbb ---------- will be added into array
2) movablemem_map=acpi    ---------- will empty the array
3) movablemem_map=ccc@ddd ---------- will be added into array again (wrong!)

So, we need to code like this:

+	if (!strncmp(p, "acpi", max(4, strlen(p))))
+		movablemem_map.acpi = true;

In this way, 3) movablemem_map=ccc@ddd will not go into this if segment.

+
+	/*
+	 * If user decide to use info from BIOS, all the other user specified
+	 * ranges will be ingored.
+	 */
+	if (movablemem_map.acpi) {
+		if (movablemem_map.nr_map) {
+			memset(movablemem_map.map, 0,
+				sizeof(struct movablemem_entry)
+				* movablemem_map.nr_map);
+			movablemem_map.nr_map = 0;
+		}
+		return 0;
+	}

But it will go into this if segment, and will not add the range into array.

Thanks. :)





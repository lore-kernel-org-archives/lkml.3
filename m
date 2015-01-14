Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbbANIGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:06:33 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55962 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbbANIGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:06:31 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-5d-54b623867e06
Message-id: <54B6237C.5090500@samsung.com>
Date: Wed, 14 Jan 2015 09:06:20 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] kstrdup optimization
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
 <20150113153731.43eefac721964d165396e5af@linux-foundation.org>
In-reply-to: <20150113153731.43eefac721964d165396e5af@linux-foundation.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xa7ptyttCDP5eF7CYs34Nm8WRa9/Z
	LS7/e8NicbbpDZC1aw6bxb01/1kt1h65y27xdMJFNotfy48yWpz/e5zVgctj/s6PjB6bVnWy
	eWz6NInd4861PWweJ2b8ZvFYclPNo2/LKkaPz5vkPDY9ecsUwBnFZZOSmpNZllqkb5fAlXHk
	fx9LwULhinVzfzA3MB7l62Lk5JAQMJF4vGUiO4QtJnHh3nq2LkYuDiGBpYwS9080MUM4nxgl
	mnsnMYJU8QpoSVzd8ZIVxGYRUJVYf/w+mM0moCnxd/NNNhBbVCBC4sOqr2wQ9YISPybfYwGx
	RQR0JVY93wU2lFlgMZPE1rWPgIo4OISBEuvnFkEsa2GUuLjpAthQTgFviZ83OlhAapgF9CTu
	X9QCCTMLyEtsXvOWeQKjwCwkK2YhVM1CUrWAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4m
	RkikfN3BuPSY1SFGAQ5GJR5ehyNbQ4RYE8uKK3MPMUpwMCuJ8KbJbQsR4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwHjA9LL3hNk3b4j+ktb/LCcmsPrcaY25y9Z5aLKLxPqt3OVXtdrE4/z26z+/
	iZ5cvFrDpq5Fj7fk4K05M19+Eg531BT/Nl/j09W53hNva2QsDJP+Fszy137JTOvIjt6QEs4T
	c6etWTNDS6lB/lHo0aSVb5l7pzsnnvGb716+7lXp4a05U593+T5VYinOSDTUYi4qTgQAkqjd
	c3ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 12:37 AM, Andrew Morton wrote:
> On Mon, 12 Jan 2015 10:18:38 +0100 Andrzej Hajda <a.hajda@samsung.com> wrote:
>
>> Hi,
>>
>> kstrdup if often used to duplicate strings where neither source neither
>> destination will be ever modified. In such case we can just reuse the source
>> instead of duplicating it. The problem is that we must be sure that
>> the source is non-modifiable and its life-time is long enough.
>>
>> I suspect the good candidates for such strings are strings located in kernel
>> .rodata section, they cannot be modifed because the section is read-only and
>> their life-time is equal to kernel life-time.
>>
>> This small patchset proposes alternative version of kstrdup - kstrdup_const,
>> which returns source string if it is located in .rodata otherwise it fallbacks
>> to kstrdup.
>> To verify if the source is in .rodata function checks if the address is between
>> sentinels __start_rodata, __end_rodata. I guess it should work with all
>> architectures.
>>
>> The main patch is accompanied by four patches constifying kstrdup for cases
>> where situtation described above happens frequently.
>>
>> As I have tested the patchset on mobile platform (exynos4210-trats) it saves
>> 3272 string allocations. Since minimal allocation is 32 or 64 bytes depending
>> on Kconfig options the patchset saves respectively about 100KB or 200KB of memory.
> That's a lot of memory.  I wonder where it's all going to.  sysfs,
> probably?

Stats from tested platform.
By caller:
  2260 __kernfs_new_node
    631 clk_register+0xc8/0x1b8
    318 clk_register+0x34/0x1b8
      51 kmem_cache_create
      12 alloc_vfsmnt

By string (with count >= 5):
    883 power
    876 subsystem
    135 parameters
    132 device
     61 iommu_group
     44 sclk_mpll
     42 aclk100
     41 driver
     36 sclk_vpll
     35 none
     34 sclk_epll
     34 aclk160
     32 sclk_hdmi24m
     31 xxti
     31 xusbxti
     31 sclk_usbphy0
     30 sclk_hdmiphy
     28 bdi
     28 aclk133
     14 sclk_apll
     14 aclk200
      9 module
      9 fin_pll
      5 div_core2
   


>
> What the heck does (the cheerily undocumented) KERNFS_STATIC_NAME do
> and can we remove it if this patchset is in place?
>
>

The only call path when this flag is set starts from
sysfs_add_file_mode_ns function.
But I guess this function can be called also for non-const names.

Regards
Andrzej



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaFMPJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:09:19 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:22278 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFMPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:09:18 -0400
Message-ID: <1402671597.7963.15.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 1/2] mem-hotplug: Avoid illegal state prefixed with
 legal state when changing state of memory_block.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, tj@kernel.org,
        hpa@zytor.com, mingo@elte.hu, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, hutao@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 13 Jun 2014 08:59:57 -0600
In-Reply-To: <1402027134-14423-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1402027134-14423-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1402027134-14423-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 11:58 +0800, Tang Chen wrote:
> We use the following command to online a memory_block:
> 
> echo online|online_kernel|online_movable > /sys/devices/system/memory/memoryXXX/state
> 
> But, if we do the following:
> 
> echo online_fhsjkghfkd > /sys/devices/system/memory/memoryXXX/state
> 
> the block will also be onlined.
> 
> This is because the following code in store_mem_state() does not compare the whole string,
> but only the prefix of the string.
> 
> store_mem_state()
> {
> 	......
>  328         if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
> 
> Here, only compare the first 13 letters of the string. If we give "online_kernelXXXXXX",
> it will be recognized as online_kernel, which is incorrect.
> 
>  329                 online_type = ONLINE_KERNEL;
>  330         else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))
> 
> We have the same problem here,
> 
>  331                 online_type = ONLINE_MOVABLE;
>  332         else if (!strncmp(buf, "online", min_t(int, count, 6)))
> 
> here,
> 
> (Here is more problematic. If we give online_movalbe, which is a typo of online_movable,
>  it will be recognized as online without noticing the author.)
> 
>  333                 online_type = ONLINE_KEEP;
>  334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))
> 
> and here.
> 
>  335                 online_type = -1;
>  336         else {
>  337                 ret = -EINVAL;
>  338                 goto err;
>  339         }
> 	......
> }
> 
> This patch fix this problem by using sysfs_streq() to compare the whole string.
> 
> Reported-by: Hu Tao <hutao@cn.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



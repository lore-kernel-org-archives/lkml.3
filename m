Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3BRGSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:18:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab3BRGS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:18:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,685,1355068800"; 
   d="scan'208";a="6721919"
Message-ID: <5121C699.2050408@cn.fujitsu.com>
Date: Mon, 18 Feb 2013 14:13:45 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
        Simon Horman <horms@verge.net.au>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: fix functions and variables related to netns_ipvs->sysctl_sync_qlen_max
References: <51131B88.6040809@cn.fujitsu.com> <51132A56.60906@cn.fujitsu.com> <alpine.LFD.2.00.1302070944480.1810@ja.ssi.bg> <20130214142159.d0516a5f.akpm@linux-foundation.org> <alpine.LFD.2.00.1302152304010.1746@ja.ssi.bg>
In-Reply-To: <alpine.LFD.2.00.1302152304010.1746@ja.ssi.bg>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/18 14:14:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/18 14:14:39
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月16日 05:39, Julian Anastasov 写道:
> 
> 	Hello,
> 
> On Thu, 14 Feb 2013, Andrew Morton wrote:
> 
>> On Thu, 7 Feb 2013 10:40:26 +0200 (EET)
>> Julian Anastasov <ja@ssi.bg> wrote:
>>
>>>> Another question about the sysctl_sync_qlen_max:
>>>> This variable is assigned as:
>>>>
>>>> ipvs->sysctl_sync_qlen_max = nr_free_buffer_pages() / 32;
>>>>
>>>> The function nr_free_buffer_pages actually means: counts of pages
>>>> which are beyond high watermark within ZONE_DMA and ZONE_NORMAL.
>>>>
>>>> is it ok to be called here? Some people misused this function because
>>>> the function name was misleading them. I am sorry I am totally not
>>>> familiar with the ipvs code, so I am just asking you about
>>>> this.
>>>
>>> 	Using nr_free_buffer_pages should be fine here.
>>> We are using it as rough estimation for the number of sync
>>> buffers we can use in NORMAL zones. We are using dev->mtu
>>> for such buffers, so it can take a PAGE_SIZE for a buffer.
>>> We are not interested in HIGHMEM size. high watermarks
>>> should have negliable effect. I'm even not sure whether
>>> we need to clamp it for systems with TBs of memory.
>>
>> Using nr_free_buffer_pages() is good-enough-for-now.  There are
>> questions around the name of this thing and its exact functionality and
>> whether callers are using it appropriately.  But if anything is changed
>> there, it will be as part of kernel-wide sweep.
>>
>> One thing to bear in mind is memory hot[un]plug.  Anything which was
>> sized using nr_free_buffer_pages() (or similar) may become
>> inappropriately sized if memory is added or removed.  So any site which
>> uses nr_free_buffer_pages() really should be associated with a hotplug
>> handler and a great pile of code to resize the structure at runtime. 
>> It's pretty ugly stuff :(  I suspect it usually Just Doesn't Matter.
> 
> 	I'll try to think on this hotplug problem
> and also on the si_meminfo usage in net/netfilter/ipvs/ip_vs_ctl.c
> which is quite wrong for systems with HIGHMEM, may be
> we need there a free+reclaimable+file function for
> NORMAL zone.
> 
>> Redarding this patch:
>> net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch and
>> net-fix-functions-and-variables-related-to-netns_ipvs-sysctl_sync_qlen_max.patch
>> are joined at the hip and should be redone as a single patch with a
>> suitable changelog, please.  And with a cc:netdev@vger.kernel.org.
> 
> 	Agreed, Zhang Yanfei and Simon? I'm just not sure,
> may be this combined patch should hit only the
> ipvs->nf->net trees? Or may be net-next, if we don't have
> time for 3.8.
> 

Should I resend the combined patch?

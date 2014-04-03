Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaDCChR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:37:17 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49218 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbaDCChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:37:15 -0400
Message-ID: <1396492623.2913.31.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index
 reflect the start/end section number
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave.hansen@intel.com>
Date: Thu, 03 Apr 2014 10:37:03 +0800
In-Reply-To: <533CBB46.4050800@cn.fujitsu.com>
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
	 <533CBB46.4050800@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040302-2674-0000-0000-00000D74914B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 09:37 +0800, Zhang Yanfei wrote:
> Add ccing
> 
> On 04/02/2014 04:56 PM, Li Zhong wrote:
> > I noticed the phys_index and end_phys_index under 
> > /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> > (for the test machine, one memory block has 8 sections, that is 
> >  sections_per_block equals 8)
> > 
> > # cd /sys/devices/system/memory/memory100/
> > # cat phys_index end_phys_index 
> > 00000064
> > 00000064
> > 
> > Seems they should reflect the start/end section number respectively, which 
> > also matches what is said in Documentation/memory-hotplug.txt
> 
Hi Yanfei, 

Thanks for the review. 

> Indeed. I've noticed this before. The value in 'end_phys_index' doesn't
> match what it really means. But, the name itself is vague, it looks like
> it is the index of some page frame. (we keep this name for compatibility?)

I guess so, Dave just reminded me that the RFC would also break
userspace..

And now my plan is: 
 leave the code unchanged
 update the document, state the end_phys_index/phys_index are the same,
and means the memory block index
 [optional] create two new files start_sec_nr, end_sec_nr if needed

Do you have any other suggestions? 

Thanks, Zhong

> 
> The corresponding member in struct memory_block is:
> 
> struct memory_block {
>         unsigned long start_section_nr;
>         unsigned long end_section_nr;
> ...
> 
> The two members seem to have the right name, and have the right value in kernel.
> 
> 
> > 
> > This patch tries to modify that so the two files could show the start/end
> > section number of the memory block.
> > 
> > After this change, output of the above example looks like:
> > 
> > # cat phys_index end_phys_index 
> > 00000320
> > 00000327
> > 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> >  drivers/base/memory.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index bece691..b10f2fa 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
> >  	struct memory_block *mem = to_memory_block(dev);
> >  	unsigned long phys_index;
> >  
> > -	phys_index = mem->start_section_nr / sections_per_block;
> > +	phys_index = mem->start_section_nr;
> >  	return sprintf(buf, "%08lx\n", phys_index);
> >  }
> >  
> > @@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
> >  	struct memory_block *mem = to_memory_block(dev);
> >  	unsigned long phys_index;
> >  
> > -	phys_index = mem->end_section_nr / sections_per_block;
> > +	phys_index = mem->end_section_nr;
> >  	return sprintf(buf, "%08lx\n", phys_index);
> >  }
> >  
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 



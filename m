Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936781Ab3DIB5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:57:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933403Ab3DIB5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:57:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,435,1363104000"; 
   d="scan'208";a="7018038"
Message-ID: <516375DF.3080602@cn.fujitsu.com>
Date: Tue, 09 Apr 2013 09:58:55 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Christoph Lameter <cl@linux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] mm: vmemmap: add vmemmap_verify check for hot-add
 node/memory case
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQVaByGOTjLVthRkEze_ekXm5LAKgKdHzrD+q1iYmjgZFQ@mail.gmail.com> <20130408135553.2f60518d923b6920bdf1931f@linux-foundation.org>
In-Reply-To: <20130408135553.2f60518d923b6920bdf1931f@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 09:56:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 09:56:07,
	Serialize complete at 2013/04/09 09:56:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 04/09/2013 04:55 AM, Andrew Morton wrote:
> On Mon, 8 Apr 2013 11:40:11 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On Mon, Apr 8, 2013 at 2:56 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>>> In hot add node(memory) case, vmemmap pages are always allocated from other
>>> node,
>>
>> that is broken, and should be fixed.
>> vmemmap should be on local node even for hot add node.
>>
> 
> That would be nice.
> 
> I don't see much value in the added warnings, really.  Because there's
> nothing the user can *do* about them, apart from a) stop using NUMA, b)
> stop using memory hotplug, c) become a kernel MM developer or d) switch
> to Windows.
> 
> 

I agree that we can't do anything helpful to response to such warnings for
the moment, but maybe someone can at least take your c) measure if it's 
what he really cares. ;-)

This patch sent because we found that on a old kernel we get such warnings
but we don't on latest kernel, it appears that it has been fixed by someone
but in fact it is due to sizeof(struct page) is 64bytes aligned now but not
on the old kernel. Now the struct pages for a section is always 2MB in size, 
every time we populate vmemmap for a section we get a new pmd, so the 
vmemmap_verify() check is just ignored. Such phenomenon is misleading.

struct page {
	...
}
#ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
      __aligned(2 * sizeof(unsigned long))
#endif
; 

Anyway the current logic for vmemmap_verify() is broken :(

thanks,
linfeng

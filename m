Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaGaIw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:52:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaGaIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:52:24 -0400
Date: Thu, 31 Jul 2014 16:50:49 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, qiuxishi@huawei.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] not adding modules range to kcore if it's equal to
 vmcore range
Message-ID: <20140731085049.GC4003@dhcp-16-105.nay.redhat.com>
References: <1405212144-2725-1-git-send-email-bhe@redhat.com>
 <20140713010546.GA2832@dhcp-17-102.nay.redhat.com>
 <20140715151600.b561ab770b5b0f9a2200b49f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715151600.b561ab770b5b0f9a2200b49f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 at 03:16pm, Andrew Morton wrote:
> On Sun, 13 Jul 2014 09:05:46 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
> > On some ARCHs modules range is eauql to vmalloc range. E.g on i686
> > "#define MODULES_VADDR   VMALLOC_START"
> > "#define MODULES_END     VMALLOC_END"
> > This will cause 2 duplicate program segments in /proc/kcore, makes
> > user confused. In this patch a judgment added to check if modules
> > range is equal to vmalloc range. If yes, just skip adding the modules
> > range.
> > 
> > ...
> >
> > --- a/fs/proc/kcore.c
> > +++ b/fs/proc/kcore.c
> > @@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(void)
> >  struct kcore_list kcore_modules;
> >  static void __init add_modules_range(void)
> >  {
> > -	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> > -			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> > +	if (MODULES_VADDR != VMALLOC_START) {
> > +		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> > +				MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> > +	}
> >  }
> >  #else
> >  static void __init add_modules_range(void)
> 
> But if some application or script is using the modules range, won't
> this patch cause breakage on some architectures?

Hi Andrew,

As I replied in previous mail, people usually check memory range but
not which entry is available, so this should not cause breakage on the
relevant architectures.

Surely if you don't like it, I am fine too.

Baoquan
Thanks


> 

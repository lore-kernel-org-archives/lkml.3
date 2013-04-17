Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965930Ab3DQHsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:48:07 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:41130 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965738Ab3DQHsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:48:05 -0400
In-Reply-To: <516D9A74.8030109@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OF137D0ABE.5A739596-ON48257B50.002AB95E-48257B50.002AD807@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Wed, 17 Apr 2013 15:47:23 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-17 15:47:18,
	Serialize complete at 2013-04-17 15:47:18
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r3H7lXon018686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave.hansen@linux.intel.com> wrote on 2013/04/17 02:37:40:

> Instead of bothering to store the index, why not just calculate it, 
like:
> 
> On 04/15/2013 08:37 PM, zhang.yi20@zte.com.cn wrote:
> > +static inline int get_page_compound_index(struct page *page)
> > +{
> > +       if (PageHead(page))
> > +               return 0;
> > +       return compound_head(page) - page;
> > +}
> 
> BTW, you've really got to get your mail client fixed.  Your patch is
> still line-wrapped.


I agree that I should calculate the compound index, but refer to 
prep_compound_gigantic_page, I think it may like this:

+static inline int get_page_compound_index(struct page *page)
+{
+       struct page *head_page;
+       if (PageHead(page))
+               return 0;
+
+       head_page = compound_head(page);
+       if (compound_order(head_page) >= MAX_ORDER)
+               return page_to_pfn(page) - page_to_pfn(head_page);
+       else
+               return page - compound_head(page);
+}

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaHVRxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:53:24 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:23078 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaHVRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:53:23 -0400
Message-ID: <1408729387.28990.85.camel@misato.fc.hp.com>
Subject: Re: [Xen-devel] [PATCH RFC 1/3] x86: Make page cache mode a real
 type
From: Toshi Kani <toshi.kani@hp.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Juergen Gross <JGross@suse.com>, stefan.bader@canonical.com,
        x86@kernel.org, ville.syrjala@linux.intel.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Date: Fri, 22 Aug 2014 11:43:07 -0600
In-Reply-To: <53F72856020000780002C93D@mail.emea.novell.com>
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
	 <1408454745-32358-2-git-send-email-jgross@suse.com>
	 <1408562787.28990.65.camel@misato.fc.hp.com> <53F5BC2F.8050609@suse.com>
	 <53F72856020000780002C93D@mail.emea.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 10:24 +0100, Jan Beulich wrote:
> >>> On 21.08.14 at 11:30, <JGross@suse.com> wrote:
> > On 08/20/2014 09:26 PM, Toshi Kani wrote:
> >> On Tue, 2014-08-19 at 15:25 +0200, jgross@suse.com wrote:
> >>> --- a/arch/x86/mm/init.c
> >>> +++ b/arch/x86/mm/init.c
> >>> @@ -27,6 +27,35 @@
> >>>
> >>>   #include "mm_internal.h"
> >>>
> >>> +/*
> >>> + * Tables translating between page_cache_type_t and pte encoding.
> >>> + * Minimal supported modes are defined statically, modified if more supported
> >>> + * cache modes are available.
> >>> + * Index into __cachemode2pte_tbl is the cachemode.
> >>> + * Index into __pte2cachemode_tbl are the caching attribute bits of the pte
> >>> + * (_PAGE_PWT, _PAGE_PCD, _PAGE_PAT) at index bit positions 0, 1, 2.
> >>> + */
> >>> +uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
> >>> +	[_PAGE_CACHE_MODE_WB]		= 0,
> >>> +	[_PAGE_CACHE_MODE_WC]		= _PAGE_PWT,
> >>> +	[_PAGE_CACHE_MODE_UC_MINUS]	= _PAGE_PCD,
> >>> +	[_PAGE_CACHE_MODE_UC]		= _PAGE_PCD | _PAGE_PWT,
> >>> +	[_PAGE_CACHE_MODE_WT]		= _PAGE_PWT,
> >>> +	[_PAGE_CACHE_MODE_WP]		= _PAGE_PWT,
> >>> +};
> >>
> >> I think WT and WP should be set to _PAGE_PCD (UC_MINUS) for safe.
> > 
> > Oh, you are right.
> 
> Actually I suppose the original comment was about WC and WP;
> defaulting WT to _PAGE_PWT seems quite correct to me.

My comment was about WT and WP, whose cache modes are defined here but
are not supported in this patchset.  _PAGE_PWT is used by WC, which has
weakly ordered writes.  WT and WP have strongly ordered writes, so they
should be redirected to UC- for safe.

Thanks,
-Toshi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaDGNYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:24:42 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34209 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaDGNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:24:40 -0400
Date: Mon, 7 Apr 2014 17:24:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc 0/3] Cleaning up soft-dirty bit usage
Message-ID: <20140407132437.GH1444@moon>
References: <20140403184844.260532690@openvz.org>
 <20140407130701.GA16677@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407130701.GA16677@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:07:01PM +0300, Kirill A. Shutemov wrote:
> On Thu, Apr 03, 2014 at 10:48:44PM +0400, Cyrill Gorcunov wrote:
> > Hi! I've been trying to clean up soft-dirty bit usage. I can't cleanup
> > "ridiculous macros in pgtable-2level.h" completely because I need to
> > define _PAGE_FILE,_PAGE_PROTNONE,_PAGE_NUMA bits in sequence manner
> > like
> > 
> > #define _PAGE_BIT_FILE		(_PAGE_BIT_PRESENT + 1)	/* _PAGE_BIT_RW */
> > #define _PAGE_BIT_NUMA		(_PAGE_BIT_PRESENT + 2)	/* _PAGE_BIT_USER */
> > #define _PAGE_BIT_PROTNONE	(_PAGE_BIT_PRESENT + 3)	/* _PAGE_BIT_PWT */
> > 
> > which can't be done right now because numa code needs to save original
> > pte bits for example in __split_huge_page_map, if I'm not missing something
> > obvious.
> 
> Sorry, I didn't get this. How __split_huge_page_map() does depend on pte
> bits order?

__split_huge_page_map
  ...
  for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
    ...
    here we modify with pte bits
    entry = pte_mknuma(entry); --> clean _PAGE_PRESENT and set _PAGE_NUMA

    pte bits must remain valid and meaningful, for example we might
    have set _PAGE_RW here

> >     is it intentional, and @prot_numa argument is supposed to be passed
> >     with prot_numa = 1 one day, or it's leftover from old times?
> 
> I see one more user of change_protection() -- change_prot_numa(), which
> has .prot_numa == 1.

Yeah, thanks, managed to miss this.

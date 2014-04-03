Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaDCTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:09:57 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42961 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaDCTJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:09:55 -0400
Message-Id: <20140403184844.260532690@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 03 Apr 2014 22:48:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, linux-mm@kvack.org
Subject: [rfc 0/3] Cleaning up soft-dirty bit usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! I've been trying to clean up soft-dirty bit usage. I can't cleanup
"ridiculous macros in pgtable-2level.h" completely because I need to
define _PAGE_FILE,_PAGE_PROTNONE,_PAGE_NUMA bits in sequence manner
like

#define _PAGE_BIT_FILE		(_PAGE_BIT_PRESENT + 1)	/* _PAGE_BIT_RW */
#define _PAGE_BIT_NUMA		(_PAGE_BIT_PRESENT + 2)	/* _PAGE_BIT_USER */
#define _PAGE_BIT_PROTNONE	(_PAGE_BIT_PRESENT + 3)	/* _PAGE_BIT_PWT */

which can't be done right now because numa code needs to save original
pte bits for example in __split_huge_page_map, if I'm not missing something
obvious.

Also if we ever redefine the bits above we will need to update PAT code
which uses _PAGE_GLOBAL + _PAGE_PRESENT to make pte_present return true
or false.

Another weird thing I found is the following sequence:

   mprotect_fixup
    change_protection (passes @prot_numa = 0 which finally ends up in)
      ...
      change_pte_range(..., prot_numa)

			if (!prot_numa) {
				...
			} else {
				... this seems to be dead code branch ...
			}

    is it intentional, and @prot_numa argument is supposed to be passed
    with prot_numa = 1 one day, or it's leftover from old times?

Note I've not yet tested the series building it now, hopefully finish
testing in a couple of hours.

Linus, by saying "define the bits we use when PAGE_PRESENT==0 separately
and explicitly" you meant complete rework of the bits, right? Not simply
group them in once place in a header?

	Cyrill

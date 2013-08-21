Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3HUNs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:48:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8857 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3HUNsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:48:25 -0400
X-IronPort-AV: E=Sophos;i="4.89,928,1367971200"; 
   d="scan'208";a="43974639"
Message-ID: <5214C524.1050900@citrix.com>
Date: Wed, 21 Aug 2013 14:48:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        <Xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing
 use
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
and _PTE_PAT.

With a Xen PV guest, the use of the _PTE_PAT will result in the page
having unexpected cachability which will introduce a range of subtle
performance and correctness issues.  Xen programs the entry 4 in the PAT
table with WC so a page that was previously WB will end up as WC.

The use of this bit also appears to preclude the use of (transparent)
huge pages by the application.  It is not clear if there is something
else guaranteeing that that there will be no huge pages.

To fix this regression I suggest one or more of:

1. If no other changes are made, at a mimimum, MEM_SOFT_DIRTY must
require !XEN and possibly !TRANSPARENT_HUGEPAGE and !HUGETLBFS.  This
would prevent this option being enabled on the majority of standard
Linux distributions.

2. Find a different PTE bit to (re)use.

3. Avoid clearing the soft dirty bit when repopulating a swapped out page.

4. Redesign the soft dirty tracking to not require the use of
architecture specific PTE bits.  e.g., by using a shadow set of
structures for the soft dirty bit tracking.

David

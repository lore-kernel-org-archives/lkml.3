Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaFJUZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:25:47 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47832 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbaFJUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:25:46 -0400
Date: Tue, 10 Jun 2014 15:25:42 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
In-Reply-To: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1406101518510.19364@gentwo.org>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Kirill A. Shutemov wrote:

> To be able to split huge page at any point we have to track which tail
> page was pinned. It leads to tricky and expensive get_page() on tail pages
> and also occupy tail_page->_mapcount.

Maybe we should give up the requirement to be able to split a huge page at
any point? This got us into the mess AFAICT. Instead we could use the
locking mechanisms that we have to stop all access to the page and then do
the conversion? Page migration can do that so it should be fine with
refcounting for huge pages exclusively in the head page exactly like a
regular page.

The problem is then dealing with the locations where we now do rely on
the ability to split at "any point" (notion is weird in itself and
suggests issues with synchronization). Use the standard locking schemes
for pages instead?

I thought the idea was that we would modify the relevant code and
that at some point this requirement could go away?

Huge pages (and other larger order pages) will become increasingly
difficult to handle if relevant page state has to be maintained in tail
pages and if it differs significantly from regular pages.


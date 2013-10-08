Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3JHTsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:48:37 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39537 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3JHTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:48:34 -0400
Date: Tue, 8 Oct 2013 14:48:19 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
Message-ID: <20131008194819.GB6129@linux.vnet.ibm.com>
Mail-Followup-To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rik van Riel <riel@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Matt Helsley <matt.helsley@gmail.com>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Michael Roth <mdroth@linux.vnet.ibm.com>,
	Lei Li <lilei@linux.vnet.ibm.com>,
	Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com>
 <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
 <52542F53.4020807@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52542F53.4020807@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100819-1618-0000-0000-000004C16C9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (dave@sr71.net) wrote:
> On 10/07/2013 01:21 PM, Robert C Jennings wrote:
> > +					} else {
> > +						if (vma)
> > +							zap_page_range(vma,
> > +								user_start,
> > +								(user_end -
> > +								 user_start),
> > +								NULL);
> > +						vma = find_vma_intersection(
> > +								current->mm,
> > +								useraddr,
> > +								(useraddr +
> > +								 PAGE_SIZE));
> > +						if (!IS_ERR_OR_NULL(vma)) {
> > +							user_start = useraddr;
> > +							user_end = (useraddr +
> > +								    PAGE_SIZE);
> > +						} else
> > +							vma = NULL;
> > +					}
> 
> This is pretty unspeakably hideous.  Was there truly no better way to do
> this?

I was hoping to find a better way to coalesce pipe buffers and zap
entire VMAs (and it needs better documentation but your argument is with
structure and I agree). I would love suggestions for improving this but
that is not to say that I've abandoned it; I'm still looking for ways
to make this cleaner.

Doing find_vma() on a single page in the VMA rather than on each and
then zapping once provides a 50% runtime reduction for the writer when
tested with a 256MB vmsplice operation.  Based on the result I felt that
coalescing was justfied but the implementation is ugly.


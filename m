Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbbAVX1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:27:34 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34428 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAVX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:27:31 -0500
Date: Thu, 22 Jan 2015 15:27:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Primiano Tucci <primiano@chromium.org>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Petr Cermak <petrcermak@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
In-Reply-To: <CA+yH71fNZSYVf1G+UUp3N6BhPhT0VJ4aGY=uPGbSD2raV55E3Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1501221523390.27807@chino.kir.corp.google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi> <20150114152225.GB31484@google.com> <20150114233630.GA14615@node.dhcp.inet.fi> <alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com>
 <CA+yH71fNZSYVf1G+UUp3N6BhPhT0VJ4aGY=uPGbSD2raV55E3Q@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Primiano Tucci wrote:

> > I think the bigger concern would be that this, and any new line such as
> > resettable_hiwater_rss, invalidates itself entirely.  Any process that
> > checks the hwm will not know of other processes that reset it, so the
> > value itself has no significance anymore.
> >  It would just be the mark since the last clear at an unknown time.
> 
> How is that different from the current logic of clear_refs and the
> corresponding PG_Referenced bit?
> 

If you reset the hwm for a process, rss grows to 100MB, another process 
resets the hwm, and you see a hwm of 2MB, that invalidates the hwm 
entirely.  That's especially true if there's an oom condition that kills a 
process when the rss grew to 100MB but you see a hwm of 2MB and don't 
believe it was possibly the culprit.  The hwm is already defined as the 
highest rss the process has attained, resetting it and trying to make any 
inference from the result is racy and invalidates the actual value which 
is useful.

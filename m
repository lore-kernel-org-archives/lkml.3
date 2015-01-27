Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbbA0AAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:00:36 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52891 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbbA0AA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:00:28 -0500
Date: Mon, 26 Jan 2015 16:00:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Primiano Tucci <primiano@chromium.org>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Petr Cermak <petrcermak@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
In-Reply-To: <CA+yH71e2ewvA41BNyb=TTPn+yx2zWzY6rn09hRVVgWKoeMgwXQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1501261552440.29252@chino.kir.corp.google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi> <20150114152225.GB31484@google.com> <20150114233630.GA14615@node.dhcp.inet.fi> <alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com> <CA+yH71fNZSYVf1G+UUp3N6BhPhT0VJ4aGY=uPGbSD2raV55E3Q@mail.gmail.com>
 <alpine.DEB.2.10.1501221523390.27807@chino.kir.corp.google.com> <CA+yH71e2ewvA41BNyb=TTPn+yx2zWzY6rn09hRVVgWKoeMgwXQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Primiano Tucci wrote:

> > If you reset the hwm for a process, rss grows to 100MB, another process
> > resets the hwm, and you see a hwm of 2MB, that invalidates the hwm
> > entirely.
> 
> Not sure I follow this scenario. Where does the 2MB come from?

It's a random number that the hwm gets reset to after the other process 
clears it.

> How can
> you see a hwm of 2MB, under which conditions? HVM can never be < RSS.
> Again, what you are talking about is the case of two profilers racing
> for using the same interface (hwm).
> This is the same case today of the PG_referenced bit.
> 

PG_referenced bit is not tracking the highest rss a process has ever 
attained.  PG_referenced is understood to be clearable at any time and the 
only guarantee is that it was at least cleared before returning from the 
write.  It could be set again before the write returns as well, but we can 
be sure that it was at least cleared.

With your approach, which completely invalidates the entire purpose of 
hwm, the following is possible:

	process A			process B
	---------			---------
	read hwm = 50MB			read hwm = 50MB
	write to clear hwm
	rss goes to 100MB
					write to clear hwm
					rss goes to 2MB
	read hwm = 2MB			read hwm = 2MB

This is a result of allowing something external (process B) be able to 
clear hwm so that you never knew the value went to 100MB.  That's the 
definition of a race, I don't know how to explain it any better and making 
any connection between clearing PG_referenced and mm->hiwater_rss is a 
stretch.  This approach just makes mm->hiwater_rss meaningless.

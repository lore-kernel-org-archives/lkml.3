Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbbAVAWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:22:22 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36131 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbAVAWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi>
	<20150114152225.GB31484@google.com>
	<20150114233630.GA14615@node.dhcp.inet.fi>
	<alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com>
Date: Thu, 22 Jan 2015 00:22:14 +0000
X-Google-Sender-Auth: nCqIpEOwU2OLlx5AyTkbVIeD3E0
Message-ID: <CA+yH71fNZSYVf1G+UUp3N6BhPhT0VJ4aGY=uPGbSD2raV55E3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
From: Primiano Tucci <primiano@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Petr Cermak <petrcermak@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:58 PM, David Rientjes <rientjes@google.com> wrote:
> I think the bigger concern would be that this, and any new line such as
> resettable_hiwater_rss, invalidates itself entirely.  Any process that
> checks the hwm will not know of other processes that reset it, so the
> value itself has no significance anymore.
>  It would just be the mark since the last clear at an unknown time.

How is that different from the current logic of clear_refs and the
corresponding PG_Referenced bit?

> Userspace can monitor the rss of a
> process by reading /proc/pid/stat, there's no need for the kernel to do
> something that userspace can do.

I disagree here. The driving motivation of this patch is precisely the
opposite. There are peak events that last for very short time (order:
10-100 ms) and are practically invisible from user-space (even doing
something awkward like polling in a tight loop). Concrete examples
are: GPU memory transfers, image decoding, compression /
decompression.
These kinds of tasks, which use scratch buffers for few ms, can create
significant (yet short lasting) memory pressure which is desirable to
monitor.

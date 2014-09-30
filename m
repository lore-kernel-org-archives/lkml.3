Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaI3Fxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:53:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:47559 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaI3Fxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <1412052900-1722-1-git-send-email-danielmicay@gmail.com>
References: <1412052900-1722-1-git-send-email-danielmicay@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 22:53:18 -0700
Message-ID: <CALCETrX6D7X7zm3qCn8kaBtYHCQvdR06LAAwzBA=1GteHAaLKA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: add mremap flag for preserving the old mapping
To: Daniel Micay <danielmicay@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, jasone@canonware.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 9:55 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> This introduces the MREMAP_RETAIN flag for preserving the source mapping
> when MREMAP_MAYMOVE moves the pages to a new destination. Accesses to
> the source location will fault and cause fresh pages to be mapped in.
>
> For consistency, the old_len >= new_len case could decommit the pages
> instead of unmapping. However, userspace can accomplish the same thing
> via madvise and a coherent definition of the flag is possible without
> the extra complexity.

IMO this needs very clear documentation of exactly what it does.

Does it preserve the contents of the source pages?  (If so, why?
Aren't you wasting a bunch of time on page faults and possibly
unnecessary COWs?)

Does it work on file mappings?  Can it extend file mappings while it moves them?

If you MREMAP_RETAIN a partially COWed private mapping, what happens?

Does it work on special mappings?  If so, please prevent it from doing
so.  mremapping x86's vdso is a thing, and duplicating x86's vdso
should not become a thing, because x86_32 in particular will become
extremely confused.

--Andy

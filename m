Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFFXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:16:57 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60270 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaFFXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:16:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1406061549500.9818@eggly.anvils>
References: <20140603042121.GA27177@redhat.com>
	<CALYGNiNV951SnBKdr0PEkgLbLCxy+YB6HJpafRr6CynO+a1sdQ@mail.gmail.com>
	<alpine.LSU.2.11.1406031524470.7878@eggly.anvils>
	<538F121E.9020100@oracle.com>
	<alpine.LSU.2.11.1406061549500.9818@eggly.anvils>
Date: Fri, 6 Jun 2014 16:16:55 -0700
X-Google-Sender-Auth: uYhXv7SOq4P8DcAaHCKU6kI3-Ig
Message-ID: <CA+55aFy939whF-vo+GyOhkyqgOEUGqAt-cmAB2gSOFHKBeGCPA@mail.gmail.com>
Subject: Re: 3.15-rc8 mm/filemap.c:202 BUG
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 4:05 PM, Hugh Dickins <hughd@google.com> wrote:
>
> [PATCH] mm: entry = ACCESS_ONCE(*pte) in handle_pte_fault
>
> Use ACCESS_ONCE() in handle_pte_fault() when getting the entry or orig_pte
> upon which all subsequent decisions and pte_same() tests will be made.
>
> I have no evidence that its lack is responsible for the mm/filemap.c:202
> BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by trinity,
> and I am not optimistic that it will fix it.  But I have found no other
> explanation, and ACCESS_ONCE() here will surely not hurt.

The patch looks obviously correct to me, although like you, I have no
real reason to believe it really fixes anything. But we definitely
should just load it once, since it's very much an optimistic load done
before we take the real lock and re-compare.

I'm somewhat dubious whether it actually would change code generation
- it doesn't change anything with the test-configuration I tried with
- but it's unquestionably a good patch. And hey, maybe some
configurations have sufficiently different code generation that gcc
actually _can_ sometimes do reloads, perhaps explaining why some
people see problems. So it's certainly worth testing even if it
doesn't make any change to code generation with *my* compiler and
config..

          Linus

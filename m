Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaFCPcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:32:52 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49016 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaFCPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140603054434.GB2921@kroah.com>
References: <20140603054434.GB2921@kroah.com>
Date: Tue, 3 Jun 2014 08:32:50 -0700
X-Google-Sender-Auth: q0N3Mr1QS483aTR14IbR2QVDtPk
Message-ID: <CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 10:44 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Bin Wang (1):
>       uio: fix vma io range check in mmap

Greg, this is BS.

If the UIO memory size is smaller than a page, we cannot mmap it
safely, because the mmap will map random memory *after* the memory
area too. This is not like a regular file mapping where the kernel can
just zero-pad up to the end of the page.

We had this bug before (and even worse - it would mmap unaligned IO
structures too, so now the actual mapped address didn't actually
correspond to the returned user mapping address at all), and we fixed
them. See

  7314e613d5ff Fix a few incorrectly checked [io_]remap_pfn_range() calls
  b65502879556 uio: we cannot mmap unaligned page contents

so now you've re-introduced part of the problem, and marked it for stable too.

The commit log shows nothing useful. It basically just says "let's
reintroduce this bug" without even giving an excuse why that would be
a good idea.

And it really _isn't_ a good idea. At least you didn't remove the
alignment check, but the thing is, if a resource is less than a page
in size, it's quite possibly also unaligned, so the fix doesn't even
*fix* anything, except by pure luck. The fact is, memory-mapping
device areas smaller than one page is simply a bad bad idea.

Don't do this shit.

                      Linus

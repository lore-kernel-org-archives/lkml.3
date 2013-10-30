Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3J3Usm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:48:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3J3Usk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:48:40 -0400
Date: Wed, 30 Oct 2013 13:48:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
Message-Id: <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
In-Reply-To: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 10:18:21 +0000 James Hogan <james.hogan@imgtec.com> wrote:

> Commit 3e39c1ab04ba (printk: mark printk_once test variable
> __read_mostly) added __read_mostly to the __print_once bool in the
> printk_once() macro, but __read_mostly is defined in <linux/cache.h>
> which isn't included from <linux/printk.h>. This results in build errors
> like this:
> 
> arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
> arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared
> 
> This is fixed by adding an include of <linux/cache.h> from
> <linux/printk.h> since I don't think printk_once() users should need to
> include <linux/cache.h> for it to work.
> 
> Note that this actually adds a recursive include, since <linux/cache.h>
> includes <linux/kernel.h>, which includes <linux/printk.h>. The actual
> dependencies are all in macros so it doesn't actually seem to result in
> any build failures, but it's clearly less than ideal.

Yitch.

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-metag@vger.kernel.org
> ---
> This build failure was caught in today's linux-next.
> 
> I'm not too keen on this due to the recursive include. Is it better to
> just workaround the problem by including <linux/cache.h> from the .c
> file that fails to build, or should the original patch be removed
> instead?

Well, these patches make the kernel worse.  We should make it better,
not worse.

One approach would be to add a new printk_once.h, which includes
printk.h and cache.h.

I can't immediately think of a nice solution so I guess for now I'll
drop printk-mark-printk_once-test-variable-__read_mostly.patch.

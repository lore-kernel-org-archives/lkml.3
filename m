Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbbANARx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:17:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbbANARw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:17:52 -0500
Date: Tue, 13 Jan 2015 16:17:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Craig Milo Rogers <rogers@isi.edu>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux MM <linux-mm@kvack.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Andreas Mohr <andi@lisas.de>,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/5] kstrdup optimization
Message-Id: <20150113161751.a33361d60cf2627ed079d4bc@linux-foundation.org>
In-Reply-To: <20150114001057.GA30408@isi.edu>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
	<CAMuHMdV74n3v81xaLRDN_Mn_QGg14yUkXNn6JYaGH4MGgLRM2A@mail.gmail.com>
	<20150114001057.GA30408@isi.edu>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 16:10:57 -0800 Craig Milo Rogers <rogers@isi.edu> wrote:

> > As kfree_const() has the exact same signature as kfree(), the risk of
> > accidentally passing pointers returned from kstrdup_const() to kfree() seems
> > high, which may lead to memory corruption if the pointer doesn't point to
> > allocated memory.
> ...
> >> To verify if the source is in .rodata function checks if the address is between
> >> sentinels __start_rodata, __end_rodata. I guess it should work with all
> >> architectures.
> 
> 	kfree() could also check if the region being freed is in .rodata, and
> ignore the call; kfree_const() would not be needed.  If making this check all
> the time leads to a significant decrease in performance (numbers needed here),
> another option is to keep kfree_const() but add a check to kfree(), when
> compiled for debugging, that issues a suitable complaint if the region being
> freed is in .rodata.
> 

Adding overhead to kfree() would be a show-stopper - it's a real
hotpath.

kstrdup_const() is only used in a small number of places.  Just don't
screw it up.


btw, I have vague memories that gcc used to put some strings into .text
under some circumstances.


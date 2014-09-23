Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaIWKKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:10:08 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51717 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaIWKKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:10:06 -0400
Date: Tue, 23 Sep 2014 05:09:59 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Build regressions/improvements in v3.17-rc6 (take two)
Message-ID: <20140923051000.60355643@as>
In-Reply-To: <1411461080-4061-1-git-send-email-geert@linux-m68k.org>
References: <1411461080-4061-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 10:31:20 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> + /scratch/kisskb/src/mm/memcontrol.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 4164:1

Well, this one was educational. It was caused by:

commit 05b8430123359886ef6a4146fba384e30d771b3f
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Wed Aug 6 16:05:59 2014 -0700

    mm: memcontrol: use root_mem_cgroup res_counter
    
This removed the return statement from mem_cgroup_read_u64(). I think
Johannes was assuming that BUG() never returns, but it looks like that
is not true on some archs, especially with CONFIG_BUG disabled. (On x86
it never returns in any case.) The bug was always there - it would have
just returned an uninitialized variable before. Now it returns some
different random value.

I'm not sure what to do here. I really think BUG() should never return
no matter what options are configured. In this case it's no big deal
and I'd just return zero to silence the warning, but a bigger problem
is that there are probably other places assuming BUG() never
returns?

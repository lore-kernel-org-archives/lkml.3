Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3JYISx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:18:53 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:40277 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3JYISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
Date: Fri, 25 Oct 2013 09:18:49 +0100
X-Google-Sender-Auth: udpq2D-v27I7c40sU0WFfHjjI1w
Message-ID: <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 8:25 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>
> On my x86-64 PC (Intel Core i5 2500, 16GB RAM), I have the same 3.11 kernel
> built for the i686 (with PAE) and x86-64 architectures. What's really troubling me
> is that the x86-64 kernel has the following problem:
>
> When I copy large files to any storage device, be it my HDD with ext4 partitions
> or flash drive with FAT32 partitions, the kernel first caches them in memory entirely
> then flushes them some time later (quite unpredictably though) or immediately upon
> invoking "sync".

Yeah, I think we default to a 10% "dirty background memory" (and
allows up to 20% dirty), so on your 16GB machine, we allow up to 1.6GB
of dirty memory for writeout before we even start writing, and twice
that before we start *waiting* for it.

On 32-bit x86, we only count the memory in the low 1GB (really
actually up to about 890MB), so "10% dirty" really means just about
90MB of buffering (and a "hard limit" of ~180MB of dirty).

And that "up to 3.2GB of dirty memory" is just crazy. Our defaults
come from the old days of less memory (and perhaps servers that don't
much care), and the fact that x86-32 ends up having much lower limits
even if you end up having more memory.

You can easily tune it:

    echo $((16*1024*1024)) > /proc/sys/vm/dirty_background_bytes
    echo $((48*1024*1024)) > /proc/sys/vm/dirty_bytes

or similar. But you're right, we need to make the defaults much saner.

Wu? Andrew? Comments?

             Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbbAEPwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:52:23 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60587 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbbAEPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:52:20 -0500
Date: Mon, 5 Jan 2015 15:52:10 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Leon Pollak <leon.pollak@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Old O_DIRECT story
Message-ID: <20150105155210.4ac86388@lxorguk.ukuu.org.uk>
In-Reply-To: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
References: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried in all ways to implement this with mmap(), but it does not success,
> because I did not find a way to mmap() file as O_WRONLY. Mapping as O_RDWR
> makes kernel to pre-fill mapped memory with partition data. So, kernel and
> DMA actually compete on the RAM area to fill it - one with garbage, one
> with actual data. Kernel wins.
> 
> So, how to implement Linus's advice?

Use O_DIRECT. There are lots of problems with the mmap() model, in
particular with how mmu table changes scale to large numbers of CPU
threads (ie they don't).

You would need to modify the kernel to add an madvise type of
soemthing like ZEROFILL (you can't do WRONLY because the x86 CPU can't
really do write only) but then you'd be stuck with only running on the
latest and greatest kernel. A ZEROFILL madvise would at least mean each
time you touched a new page it took a fault and did a 4K clear not a read.

mmap works well if you don't need to change the page permissions or map
new pages all the time. If you have to keep touching the MMU then it gets
ugly because you tend to need to synchronize btween cores.

Alan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3DPLXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:23:11 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:46136 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3DPLXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:23:09 -0400
Message-ID: <516D349A.50106@msgid.tls.msk.ru>
Date: Tue, 16 Apr 2013 15:23:06 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: lkml@tigusoft.pl
CC: linux-kernel@vger.kernel.org
Subject: Re: Very poor latency when using hard drive (raid1)
References: <kkgj31$jc6$1@ger.gmane.org>
In-Reply-To: <kkgj31$jc6$1@ger.gmane.org>
X-Enigmail-Version: 1.6a1pre
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.04.2013 13:59, lkml@tigusoft.pl пишет:
> There are 2 hard drives (normal, magnetic) in software raid 1
> on 3.2.41 kernel.
> 
> When I write into them e.g. using dd from /dev/zero to a local file
> (ext4 on default settings), running 2 dd at once (writing two files) it
> starves all other programs that try to use the disk.
> 
> Running ls on any directory on same disk (same fs btw), takes over half
> minute to execute, same for any other disk touching action.
> 
> Did anyone seen such problem, where too look, what to test?

This is typical, known for many years, issue.

Your dds are run against buffer cache, the same as used by all other
regular accesses.  So once it fills up, cached directories and the
like are thrown away to make room for new cache space.  So once
you need something else, that something needs to be read from disk,
which is busy together with the buffer cache.

> What could solve it (other then ionice on applications that I expect to
> use hard drive)?

Just don't mix these two workloads.  Or, if you really need to transfer
large amount of data, use direct I/O (O_DIRECT) -- for dd it is
iflag=direct or oflag=direct (depending on the I/O direction).

ionice wont help much.

Thanks,

/mjt

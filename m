Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3I2X0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:26:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62477 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3I2X0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:26:33 -0400
Message-ID: <5248B724.8060408@gmail.com>
Date: Mon, 30 Sep 2013 09:26:28 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Check real user/group id for %pK
References: <20130929231531.12932.qmail@science.horizon.com>
In-Reply-To: <20130929231531.12932.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/13 09:15, George Spelvin wrote:
> The basic idea is good, but I'm not sure if this is the correct permission
> check to use.
> 
> After all, a setuid program might also want to give filtered access to
> a /proc file with some %pK values.

Yeah. I'm not sure if this will break some applications (e.g. perf?)
which are expecting to be able to read %pK values if invoked setuid. The
problem is that allowing that can potentially be used to leak
information too.

> 
> The fundamental problem is that %pK is using permissions at the time
> of the read(), while the general Unix rule that setuid programs expect
> is that permission is checked at open() time.  pppd is an example; its
> options_fom_file() function (pppd/options.c:391 in the 2.4.5 release)
> does:
> 
>     euid = geteuid();
>     if (check_prot && seteuid(getuid()) == -1) {
> 	option_error("unable to drop privileges to open %s: %m", filename);
> 	return 0;
>     }
>     f = fopen(filename, "r");
>     err = errno;
>     if (check_prot && seteuid(euid) == -1)
> 	fatal("unable to regain privileges");
> 

Right, so the pppd application is actually doing the correct thing.

> 
> Now the whole struct cred and capability system is something I don't
> really understand, but it is clear from a brief look at the code
> that getting the appropriate credential through the seq_file to
> lib/vsprintf.c:pointer() would be tricky.

:-).

> 
> But it also seems like the Right Thing to do; other fixes seem like
> ineffective kludges.

Will wait and see what others have to say.

(also apologies for the badly formatted initial post. The mail client on
my other machine is apparently not configured properly).

Thanks,
~Ryan



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3I2XRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:17:41 -0400
Received: from science.horizon.com ([71.41.210.146]:27448 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753012Ab3I2XRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:17:38 -0400
Date: 29 Sep 2013 19:15:31 -0400
Message-ID: <20130929231531.12932.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        linux@horizon.com, rmallon@gmail.com
Subject: Re: [PATCH] printk: Check real user/group id for %pK
In-Reply-To: <5248AB37.7000100@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic idea is good, but I'm not sure if this is the correct permission
check to use.

After all, a setuid program might also want to give filtered access to
a /proc file with some %pK values.

The fundamental problem is that %pK is using permissions at the time
of the read(), while the general Unix rule that setuid programs expect
is that permission is checked at open() time.  pppd is an example; its
options_fom_file() function (pppd/options.c:391 in the 2.4.5 release)
does:

    euid = geteuid();
    if (check_prot && seteuid(getuid()) == -1) {
	option_error("unable to drop privileges to open %s: %m", filename);
	return 0;
    }
    f = fopen(filename, "r");
    err = errno;
    if (check_prot && seteuid(euid) == -1)
	fatal("unable to regain privileges");


Now the whole struct cred and capability system is something I don't
really understand, but it is clear from a brief look at the code
that getting the appropriate credential through the seq_file to
lib/vsprintf.c:pointer() would be tricky.

But it also seems like the Right Thing to do; other fixes seem like
ineffective kludges.

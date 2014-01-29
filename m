Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaA2SlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:41:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaA2SlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:41:08 -0500
Date: Wed, 29 Jan 2014 10:41:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Serge Hallyn" <serge.hallyn@canonical.com>,
        "Stephen Warren" <swarren@nvidia.com>, "Jens Axboe" <axboe@kernel.dk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 1/2] init/do_mounts.c: ignore final \n in
 name_to_dev_t
Message-Id: <20140129104106.793524a07e48324a32dc6f06@linux-foundation.org>
In-Reply-To: <20140129182956.14275.72264@capellas-linux>
References: <1380834638-24035-1-git-send-email-sebastian.capella@linaro.org>
	<1380834638-24035-2-git-send-email-sebastian.capella@linaro.org>
	<20131003141523.8b60ab988799af7e2b2c338b@linux-foundation.org>
	<20131003214246.24540.99218@capellas-linux>
	<20131003234735.19051.84583@capellas-linux>
	<20131010175010.17870.58060@capellas-linux>
	<20131022175414.14753.58063@capellas-linux>
	<20140128185926.5312.36635@capellas-linux>
	<20140128125442.4bac748945b404179deb58ba@linux-foundation.org>
	<20140128205830.14275.80319@capellas-linux>
	<20140129182956.14275.72264@capellas-linux>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 10:29:56 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:

> Hi Andrew,
> 
> By the way, I do see a call (sysfs_streq) in use for this purpose
> other places.  Sorry, I didn't find it while looking at the original
> problem.  I'm not sure if this is preferable, but it appears to have
> been added specifically for the strings coming through sysfs.

Yes, I wrote it ;)

I didn't think sysfs_streq() is well suited to this problem.  And the
issue of possibly-null-terminated-strings coming in from userspace is a
common one, so it is desirable that we build up the suite of utilities
to handle this.

There are probably quite a lot of open-coded \n trimming loops which
can be cleaned up using such tools.

	grep -r "if .* == '\\\n'" .

> My preference is copying the string and cleaning it up before passing
> it to internal functions, even though we incur an allocation.

Yes.  Here on the kernel/userspace boundary we are typically running in
GFP_KERNEL context and the code is not performance critical - it is a
good fit.


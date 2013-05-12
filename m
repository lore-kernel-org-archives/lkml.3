Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3ELPh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:37:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab3ELPh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:37:26 -0400
Date: Sun, 12 May 2013 17:37:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: key ffff880436f00330 not in .data!
Message-ID: <20130512153721.GC5589@pd.tnic>
References: <20130509110101.GD27333@pd.tnic>
 <518BB278.7060505@redhat.com>
 <20130509200108.GA17309@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130509200108.GA17309@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 10:01:08PM +0200, Borislav Petkov wrote:
> On Thu, May 09, 2013 at 11:28:08AM -0300, Mauro Carvalho Chehab wrote:
> > Could you please check if ghes_edac also got registered there?

Ok, I got it:

[    5.430408] BUG: key ffff88043c320330 not in .data!
[    5.431043] ------------[ cut here ]------------
[    5.431776] WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x555/0x590()
[    5.432512] DEBUG_LOCKS_WARN_ON(1)

basically means we're using dynamically allocated memory for the
lock_key. And the last can thus disappear, which is Not Good(tm).

This happens because the EDAC instance probing functions do
edac_mc_alloc() to allocate the mci which also contains embedded in it:

	struct bus_type                 bus;

and the bus_register() call in edac_create_sysfs_mci_device() hands down
this struct bus_type to lockdep.

The patch which introduced the bus_register() call in
edac_create_sysfs_mci_device() is

--
commit de3910eb79ac8c0f29a11224661c0ebaaf813039
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Tue Apr 24 15:05:43 2012 -0300

    edac: change the mem allocation scheme to make Documentation/kobject.txt happy
--

which means we need a fix since this affects all edac drivers, not only
sb_edac, as initially surmised.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

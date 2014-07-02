Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaGBNBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:01:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaGBNBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:01:19 -0400
Date: Wed, 2 Jul 2014 15:01:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, akpm@linux-foundation.org,
        andi@firstfloor.org, paulmck@linux.vnet.ibm.com, pavel@ucw.cz,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
In-Reply-To: <20140702134721.00163886@alan.etchedpixels.co.uk>
Message-ID: <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz> <53B3F556.7050002@suse.cz> <20140702123002.GA20071@mtj.dyndns.org> <20140702134721.00163886@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, One Thousand Gnomes wrote:

> > > > https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft
> > > 
> > > Stephen,
> > > 
> > > may I ask you to add the kGraft tree to -next?
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft
> > 
> > Do we have consensus on the approach?  I personally really don't like
> > the fact that it's adding another aspect to kthread management which
> > is difficult to get right and nearly impossible to verify
> > automatically.
> 
> Nor me. I don't see why it can't use the kernel freeze functionality ?

Well, we are, see the patch no. 9. It all boils down basically to

[ ... ]
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 7fd81b8c4897..e08c3bef251b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -61,6 +61,8 @@ static inline bool try_to_freeze_unsafe(void)
 
 static inline bool try_to_freeze(void)
 {
+       kgr_task_safe(current);
+
        if (!(current->flags & PF_NOFREEZE))
                debug_check_no_locks_held();
        return try_to_freeze_unsafe();
[ ... ]


Then there are non-freezable kernel threads. We are currently handling 
those explicitly, but I agree it can be argued that they might not require 
any special handling at all, given they claimed themselves explicitly 
non-freezable.

-- 
Jiri Kosina
SUSE Labs

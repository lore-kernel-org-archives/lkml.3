Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbbAUVjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:39:51 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52217 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbbAUVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:39:42 -0500
Date: Wed, 21 Jan 2015 13:38:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121213859.GA22520@roeck-us.net>
References: <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
 <54BFAA5D.4040108@roeck-us.net>
 <20150121182905.GQ29656@ZenIV.linux.org.uk>
 <54BFF8B3.6060802@roeck-us.net>
 <20150121200626.GR29656@ZenIV.linux.org.uk>
 <54C01418.5060204@roeck-us.net>
 <20150121212833.GS29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121212833.GS29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C01C9D.01C8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:28:33PM +0000, Al Viro wrote:
> On Wed, Jan 21, 2015 at 01:03:20PM -0800, Guenter Roeck wrote:
> > 
> > failing case:
> > 
> > path_lookupat: calling path_init 'usr' flags=40
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=40[50] returned 0
> > walk_component: lookup_fast() returned 1
> > walk_component: lookup_slow() returned 0
> > walk_component: inode=  (null), negative=1
> > do_path_lookup(usr, 0x10)
> > path_lookupat: calling path_init 'usr' flags=50
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=50[50] returned 0
> > mkdir[c74012a0,/kkk] => 0						<==== SIC!
> 
> Cute. 'k' being 0x6b, aka POISON_FREE...  OK, the next question is what's
> been freed under us - I don't believe that it's dentry itself...
> Oh, fuck.  OK, I see what happens.  Look at kern_path_create(); it does
> LOOKUP_PARENT walk, leaving nd->last pointing to the last component of
> the *COPY* of the name it's just created, walked and freed.
> 
Cool.

> OK...  Fortunately, struct nameidata is completely opaque outside of fs/namei.c,
> so we only need to care about a couple of codepaths.
> 
> Folks, could you check if the following on top of linux-next fixes the problem?
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 323957f..cda89c3 100644

Yes, this patch fixes the problem for me.

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3IHEPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 00:15:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45297 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab3IHEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 00:15:50 -0400
X-Sasl-enc: FPQZuKiND0LQj9VgxpmZf3jMq6TeAE9VrzEDTGF15Vuh 1378613749
Message-ID: <1378613746.2642.8.camel@perseus.fritz.box>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>,
        Sage Weil <sage@inktank.com>
Date: Sun, 08 Sep 2013 12:15:46 +0800
In-Reply-To: <20130907173243.GD13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	 <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
	 <20130906210546.GW13318@ZenIV.linux.org.uk>
	 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
	 <20130907000044.GX13318@ZenIV.linux.org.uk>
	 <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
	 <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
	 <20130907030110.GY13318@ZenIV.linux.org.uk>
	 <20130907173243.GD13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-07 at 18:32 +0100, Al Viro wrote:
> On Sat, Sep 07, 2013 at 04:01:10AM +0100, Al Viro wrote:
> > 	* plain seqretry loop (d_lookup(), is_subdir(), autofs4_getpath(),
> > ceph_misc_build_path(), [cifs] build_path_from_dentry(), nfs_path(),
>       _mds_, actually - sorry.
> > [audit] handle_path())
> > 	* try seqretry once, then switch to write_seqlock() (the things
> > that got unified into d_walk())
> > 	* try seqretry three times, then switch to write_seqlock() (d_path()
> > and friends)
> > 	* several pure write_seqlock() users (d_move(), d_set_mounted(),
> > d_materialize_unique())
> 
> BTW, autofs4_getpath() looks really odd:
> static int autofs4_getpath(struct autofs_sb_info *sbi,
>                            struct dentry *dentry, char **name)
> and *name is never modified in it.  Why not simply pass it by value?
> Moreover, I'm not sure I understand what do we need sbi->fs_lock in
> there.  Other than that, it's very close to dentry_path() (well, that
> and different calling conventions).  Ian?

Yes, it is close to dentry_path() but the path functions used to return
the full path to the root, although I don't see where dentry_path() get
the root, mmm ... 

autofs4_getpath() is supposed to return a path relative to the current
dentry.

That goes back to the pseudo direct mounts of autofs version 4 where the
keys could be a relative path.

The fs_lock probably isn't needed. This was a tree of directories and I
didn't want mount requests coming in while I was getting the path, and
didn't want an expire to happen either, although there should only be
one expire process anyway.

Ian



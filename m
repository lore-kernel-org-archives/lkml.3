Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3IGRcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 13:32:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43300 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3IGRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 13:32:48 -0400
Date: Sat, 7 Sep 2013 18:32:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>,
        Sage Weil <sage@inktank.com>, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130907173243.GD13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
 <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
 <20130906210546.GW13318@ZenIV.linux.org.uk>
 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
 <20130907000044.GX13318@ZenIV.linux.org.uk>
 <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
 <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
 <20130907030110.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130907030110.GY13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 04:01:10AM +0100, Al Viro wrote:
> 	* plain seqretry loop (d_lookup(), is_subdir(), autofs4_getpath(),
> ceph_misc_build_path(), [cifs] build_path_from_dentry(), nfs_path(),
      _mds_, actually - sorry.
> [audit] handle_path())
> 	* try seqretry once, then switch to write_seqlock() (the things
> that got unified into d_walk())
> 	* try seqretry three times, then switch to write_seqlock() (d_path()
> and friends)
> 	* several pure write_seqlock() users (d_move(), d_set_mounted(),
> d_materialize_unique())

BTW, autofs4_getpath() looks really odd:
static int autofs4_getpath(struct autofs_sb_info *sbi,
                           struct dentry *dentry, char **name)
and *name is never modified in it.  Why not simply pass it by value?
Moreover, I'm not sure I understand what do we need sbi->fs_lock in
there.  Other than that, it's very close to dentry_path() (well, that
and different calling conventions).  Ian?

ceph_mds_build_path() is similar, but it does kmalloc to store the result
and grabs ->d_lock for ->d_name protection.  This one, BTW, is much more
likely to get stalls - it ends up doing kmalloc on each attempt (after
having calculated the current length).  Bugger if I understand what's wrong
with simply grabbing a page and doing that once - before everything else...

build_path_from_dentry() - same story, might very well have been the source
of ceph_mds_build_path().

nfs_path() - not far from open-coded dentry_path() with some postprocessing,
uses ->d_lock for ->d_name protection.

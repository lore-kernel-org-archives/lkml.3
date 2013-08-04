Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3HDDxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 23:53:48 -0400
Received: from longford.logfs.org ([213.229.74.203]:59960 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3HDDxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 23:53:46 -0400
Date: Sat, 3 Aug 2013 22:21:14 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, Dhaval Giani <dgiani@mozilla.com>,
        Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
        vdjeric@mozilla.com, glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Message-ID: <20130804022114.GA24655@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
 <20130726132034.GB21977@logfs.org>
 <20130804003316.GA19781@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130804003316.GA19781@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 August 2013 20:33:16 -0400, Theodore Ts'o wrote:
> 
> P.P.S.  At least in theory, nothing of what I've described here has to
> be ext4 specific.  We could implement this in the VFS layer, at which
> point not only ext4 would benefit, but also btrfs, xfs, f2fs, etc.

Except for an inode bit that needs to be stored in the filesystem,
agreed.  The ugliness I see is in detecting how to treat the
filesystem at hand.

Filesystems with mandatory compression (jffs2, ubifs,...):
- Just write the file, nothing to do.
Filesystems with optional compression (logfs, ext2compr,...):
- You may or may not want to chattr between file creation and writing
  the payload.
Filesystems without compression (ext[234], xfs,...):
- Just write the file, nothing can be done.
- Alternatively fall back to a userspace version.
Filesystems with optional uncompression (what is being proposed):
- Write the file in compressed form, close, chattr.

I would like to see the compression side done in the kernel as well.
Then we can chattr right after creat() and, if that fails, either
proceed anyway or go to a userspace fallback.  All decisions can be
made early on and we don't have to share the format with lots of
userspace.

Sure, we still have to share the format with fsck and similar
filesystem tools.  But not with installers.

Jörn

--
Man darf nicht das, was uns unwahrscheinlich und unnatürlich erscheint,
mit dem verwechseln, was absolut unmöglich ist.
-- Carl Friedrich Gauß

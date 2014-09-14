Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaINSNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:13:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35501 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaINSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:13:08 -0400
Date: Sun, 14 Sep 2014 19:12:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Seunghun Lee <waydi1@gmail.com>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        jlayton@poochiereds.net, bfields@fieldses.org,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: move getname() from callers to do_mount()
Message-ID: <20140914181259.GQ7996@ZenIV.linux.org.uk>
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
 <1410700510-15408-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410700510-15408-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 10:15:10PM +0900, Seunghun Lee wrote:
> It would make more sense to pass char __user * instead of
> char * in callers of do_mount() and do getname() inside do_mount().
> 
> Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

Applied with one modification: this getname/kern_path/putname is equivalent to
user_path(dir_name, &path) and do_mount() becomes simpler if we use that
instead of not-quite-opencoding it.

Beginning of do_mount() becomes simply
        /* Discard magic */
        if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
                flags &= ~MS_MGC_MSK;

        /* Basic sanity checks */
        if (data_page)
                ((char *)data_page)[PAGE_SIZE - 1] = 0;

        /* ... and get the mountpoint */
        retval = user_path(dir_name, &path);
        if (retval)
                return retval;
that way, and there's no struct filename * to discard on exit; getname and
putname are done inside user_path().

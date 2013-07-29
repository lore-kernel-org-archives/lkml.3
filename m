Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3G2QeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:34:13 -0400
Received: from etezian.org ([198.101.225.253]:60942 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab3G2QeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:34:10 -0400
Date: Mon, 29 Jul 2013 18:35:32 +0200
From: Andi Shyti <andi@etezian.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andi Shyti <andi@etezian.org>, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikko.rapeli@iki.fi, pshilovsky@samba.org
Subject: Re: [PATCH RESEND] cifs: file: initialize oparms.reconnect before
 using it
Message-ID: <20130729163532.GA4254@jack.whiskey>
References: <1375088293-14110-1-git-send-email-andi@etezian.org>
 <20130729093241.437315e1@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729093241.437315e1@corrin.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	oparms.tcon = tcon;
> > +	oparms.cifs_sb = cifs_sb;
> > +	oparms.desired_access = desired_access;
> > +	oparms.create_options = create_options;
> 
> This patch just moves the brokenness around. You're
> setting .desired_access here to an unintialized variable.
> create_options also looks like it may potentially be wrong at this
> point.

Urrrca! This is what I achieve when I do one last fix before
going to sleep.

I spent a bit of time more going through the cifs/smb code and
the most sensful fix looks this

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1e57f36..7e36ae3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -647,6 +647,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flu
                                     oflags, &oplock, &cfile->fid.netfid, xid
                if (rc == 0) {
                        cifs_dbg(FYI, "posix reopen succeeded\n");
+                       oparms.reconnect = true;
                        goto reopen_success;
                }
                /*

There is only one case when reconnect becames false, that is when
open = smb2_open_file and calls SMB2_open() that calls
add_durable_context() that sets reconnect = false with some
nested ifs in between, and still only in case
everything succeeds. We are checking reconnect only for this
case, otherwise we could get rid of the if (oparms.reconnect) and
not falling into the unknown state.

If it makes sense, I can send the above suggestion.

Thanks,
Andi

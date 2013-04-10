Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab3DJQf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:35:27 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:33788 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933460Ab3DJQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:35:25 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 12:35:25 EDT
Message-ID: <516592EF.2080707@us.ibm.com>
Date: Wed, 10 Apr 2013 09:27:27 -0700
From: Frank Filz <ffilzlnx@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Pavel Shilovsky <piastry@etersoft.ru>
CC: Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NFS Mailing list <linux-nfs@vger.kernel.org>,
        wine-devel@winehq.org
Subject: Re: [PATCH v5 1/7] fcntl: Introduce new O_DENY* open flags
References: <1365511227-17626-1-git-send-email-piastry@etersoft.ru>	<1365511227-17626-2-git-send-email-piastry@etersoft.ru>	<20130410071824.5a37cbaf@corrin.poochiereds.net> <CAKywueRw7Oqa_z7yFo9CuoPXxJ3xPmCY0zcJwfxBKqBHNC+4zg@mail.gmail.com>
In-Reply-To: <CAKywueRw7Oqa_z7yFo9CuoPXxJ3xPmCY0zcJwfxBKqBHNC+4zg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 5b86d9ab86744e0a7b9748cdd5dc283d416dc04816f3191cf1bcba94649d402ccf8fb8d33234944992764449e275203c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-nfs-owner@vger.kernel.org wrote on 04/10/2013 06:24:39 AM:
 > 2013/4/10 Jeff Layton <jlayton@poochiereds.net>:
 > > On Tue,  9 Apr 2013 16:40:21 +0400
 > > Pavel Shilovsky <piastry@etersoft.ru> wrote:
 > >
 > >> This patch adds 3 flags:
 > >> 1) O_DENYREAD that doesn't permit read access,
 > >> 2) O_DENYWRITE that doesn't permit write access,
 > >> 3) O_DENYDELETE that doesn't permit delete or rename,
 > >>
 > >> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -
 > >> this change can benefit cifs and nfs modules as well as Samba and
 > >> NFS file servers that export the same directory for Windows clients,
 > >> or Wine applications that access the same files simultaneously.
 > >>
 > >> These flags are only take affect for opens on mounts with 'sharelock'
 > >> mount option. They are translated to flock's flags:
 > >>
 > >> !O_DENYREAD  -> LOCK_READ | LOCK_MAND
 > >> !O_DENYWRITE -> LOCK_WRITE | LOCK_MAND
 > >>
 > >> and set through flock_lock_file on a file. If the file can't be locked
 > >> due conflicts with another open with O_DENY* flags, the -EBUSY error
 > >> code is returned.
 > >>
 > >> Create codepath is slightly changed to prevent data races on
 > >> newely created files: when open with O_CREAT can return with -EBUSY
 > >> error for successfully created files due to a deny lock set by
 > >> another task.
 > >>
 > >
 > > It's good that this is consistent with the new patchset. I'm still not
 > > 100% sure that -EBUSY is the right error return here, but it should at
 > > least help distinguish between "mode bits don't allow me to open" and
 > > "file has share reservation set".
 > >
 > > Heck, since we're departing from POSIX here, maybe we should consider a
 > > new error code altogether? ESHAREDENIED or something?
 >
 > That can make sense. I don't mind to change this part.

I like this return code, it will help user space file servers return the 
correct error to their clients when they depend on the kernel to resolve 
share reservations. Internal to the kernel, having ESHAREDENIED will 
also be helpful to the NFS v4 and NLM code.

Frank

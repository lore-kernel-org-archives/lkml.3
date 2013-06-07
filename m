Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3FGQJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:09:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3FGQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:09:22 -0400
Message-ID: <51B205A1.4040405@canonical.com>
Date: Fri, 07 Jun 2013 11:09:05 -0500
From: Dave Chiluk <chiluk@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Petr Vandrovec <petr@vandrovec.name>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com> <51A918B8.20303@canonical.com> <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com> <51AF9D77.2000901@canonical.com> <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
In-Reply-To: <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------010509010307010801090006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010509010307010801090006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Can't you just use the patch from my original e-mail?  Anyhow I attached
it an already signed-off patch.

Al Viro Can you integrate it now?

Dave.

On 06/07/2013 01:43 AM, Petr Vandrovec wrote:
> On Wed, Jun 5, 2013 at 1:20 PM, Dave Chiluk <chiluk@canonical.com> wrote:
>> Petr do you still have commit rights to ncpfs?  Can you please commit it
>> to upstream or do I have to get Al to do that?
> 
> Hi,
>   only thing I can do is to add
> 
> Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
> 
> on your patch and forward it to Al.  Unfortunately patch below is
> already whitespace-damaged :-(  So you can either send it to me, and
> I'll resend it to Al, or you can do that directly...
> 
> Petr
> 
>> Dave.
>>
>>
>> On 05/31/2013 05:22 PM, Petr Vandrovec wrote:
>>> Looks OK to me.
>>>
>>> As I said elsewhere, I do not use ncpfs for years so I cannot provide
>>> any sensible maintainership for it anymore :-(
>>>
>>> Petr
>>>
>>> On May 31, 2013 2:40 PM, "Dave Chiluk" <chiluk@canonical.com
>>> <mailto:chiluk@canonical.com>> wrote:
>>>
>>>     Any thoughts on this?  NCPFS seems to be the forgotten, left-behind,
>>>     red-headed stepchild of the fs community.
>>>
>>>     Dave.
>>>
>>>     On 05/28/2013 05:50 PM, Dave Chiluk wrote:
>>>     > 1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in
>>>     ncpfs such that
>>>     > directories could no longer be removed.  This was because
>>>     ncp_rmdir checked
>>>     > to see if a dentry could be unhashed before allowing it to be
>>>     removed. Since
>>>     > 1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that
>>>     incremented
>>>     > dentry->d_count causing it to always be greater than 1 unhash
>>>     would always
>>>     > fail.  Thus causing the error path in ncp_rmdir to always be
>>>     taken.  Removing
>>>     > this error path is safe as unhashing is still accomplished by
>>>     calls to dput
>>>     > from vfs_rmdir.
>>>     > ---
>>>     >  fs/ncpfs/dir.c |    9 ---------
>>>     >  1 file changed, 9 deletions(-)
>>>     >
>>>     > diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
>>>     > index 8163260..6792ce1 100644
>>>     > --- a/fs/ncpfs/dir.c
>>>     > +++ b/fs/ncpfs/dir.c
>>>     > @@ -1029,15 +1029,6 @@ static int ncp_rmdir(struct inode *dir,
>>>     struct dentry *dentry)
>>>     >       DPRINTK("ncp_rmdir: removing %s/%s\n",
>>>     >               dentry->d_parent->d_name.name <http://d_name.name>,
>>>     dentry->d_name.name <http://d_name.name>);
>>>     >
>>>     > -     /*
>>>     > -      * fail with EBUSY if there are still references to this
>>>     > -      * directory.
>>>     > -      */
>>>     > -     dentry_unhash(dentry);
>>>     > -     error = -EBUSY;
>>>     > -     if (!d_unhashed(dentry))
>>>     > -             goto out;
>>>     > -
>>>     >       len = sizeof(__name);
>>>     >       error = ncp_io2vol(server, __name, &len, dentry->d_name.name
>>>     <http://d_name.name>,
>>>     >                          dentry->d_name.len, !ncp_preserve_case(dir));
>>>     >
>>>
>>
> 


--------------010509010307010801090006
Content-Type: text/x-patch;
 name="0001-ncpfs-fix-rmdir-returns-Device-or-resource-busy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ncpfs-fix-rmdir-returns-Device-or-resource-busy.patch"

>From 6af7fb5452c6e6edd10316338982ff85ada2cfcf Mon Sep 17 00:00:00 2001
From: Dave Chiluk <chiluk@canonical.com>
Date: Tue, 28 May 2013 16:06:08 -0500
Subject: [PATCH] ncpfs: fix rmdir returns Device or resource busy

1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs such that
directories could no longer be removed.  This was because ncp_rmdir checked
to see if a dentry could be unhashed before allowing it to be removed. Since
1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incremented
dentry->d_count causing it to always be greater than 1 unhash would always
fail.  Thus causing the error path in ncp_rmdir to always be taken.  Removing
this error path is safe as unhashing is still accomplished by calls to dput
from vfs_rmdir.

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
---
 fs/ncpfs/dir.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 8163260..6792ce1 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1029,15 +1029,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	/*
-	 * fail with EBUSY if there are still references to this
-	 * directory.
-	 */
-	dentry_unhash(dentry);
-	error = -EBUSY;
-	if (!d_unhashed(dentry))
-		goto out;
-
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 			   dentry->d_name.len, !ncp_preserve_case(dir));
-- 
1.7.9.5


--------------010509010307010801090006--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaAaVul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:50:41 -0500
Received: from linuxhacker.ru ([217.76.32.60]:46188 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaAaVuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:50:40 -0500
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: multipart/mixed; boundary="Apple-Mail=_6649DF39-E296-4077-8C4B-81087E0826F1"
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140131163231.2585a08d@tlielax.poochiereds.net>
Date: Fri, 31 Jan 2014 16:50:33 -0500
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-Id: <C917C4B9-8BF5-42BB-A396-E799E5A0294B@linuxhacker.ru>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru> <20140131210334.GO10323@ZenIV.linux.org.uk> <A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru> <20140131163231.2585a08d@tlielax.poochiereds.net>
To: Jeff Layton <jlayton@redhat.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_6649DF39-E296-4077-8C4B-81087E0826F1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> Maybe something like this (untested) instead?

I think it's just safe to move the out label up along with the old_path =
freeing.

In all error cases the retry and delegation breaking logic could not be =
triggered
anyway.=20

Something like this (lightly tested):

--Apple-Mail=_6649DF39-E296-4077-8C4B-81087E0826F1
Content-Disposition: attachment;
	filename=0001-vfs-Fix-mountpoint-reference-leakage-in-linkat.patch
Content-Type: application/octet-stream;
	name="0001-vfs-Fix-mountpoint-reference-leakage-in-linkat.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20a3b36802a01f4b89a16c773c0645bf374969970a=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Oleg=20Drokin=20<green@linuxhacker.ru>=0ADate:=20=
Fri,=2031=20Jan=202014=2015:34:05=20-0500=0ASubject:=20[PATCH]=20vfs:=20=
Fix=20mountpoint=20reference=20leakage=20in=20linkat=0A=0ARecent=20=
changes=20to=20retry=20on=20ESTALE=20in=20linkat=0A(commit=20=
442e31ca5a49e398351b2954b51f578353fdf210)=0Aintroduced=20a=20mountpoint=20=
reference=20leak=20and=20a=20small=20memory=0Aleak=20in=20case=20a=20=
filesystem=20link=20operation=20returns=20ESTALE=0Awhich=20is=20pretty=20=
normal=20for=20distributed=20filesystems=20like=0Alustre,=20nfs=20and=20=
so=20on.=0AFree=20old_path=20in=20such=20a=20case.=0AAlso=20fix=20a=20=
similar=20leak=20in=20case=20of=20broken=20delegation.=0A=0A=
Signed-off-by:=20Oleg=20Drokin:=20<green@linuxhacker.ru>=0A---=0A=20=
fs/namei.c=20|=207=20++++---=0A=201=20file=20changed,=204=20=
insertions(+),=203=20deletions(-)=0A=0Adiff=20--git=20a/fs/namei.c=20=
b/fs/namei.c=0Aindex=20bcb838e..cc3c6c4=20100644=0A---=20a/fs/namei.c=0A=
+++=20b/fs/namei.c=0A@@=20-3925,17=20+3925,18=20@@=20retry:=0A=20=09=
error=20=3D=20vfs_link(old_path.dentry,=20new_path.dentry->d_inode,=20=
new_dentry,=20&delegated_inode);=0A=20out_dput:=0A=20=09=
done_path_create(&new_path,=20new_dentry);=0A+out:=0A+=09=
path_put(&old_path);=0A=20=09if=20(delegated_inode)=20{=0A=20=09=09error=20=
=3D=20break_deleg_wait(&delegated_inode);=0A-=09=09if=20(!error)=0A+=09=09=
if=20(!error)=20{=0A=20=09=09=09goto=20retry;=0A+=09=09}=0A=20=09}=0A=20=09=
if=20(retry_estale(error,=20how))=20{=0A=20=09=09how=20|=3D=20=
LOOKUP_REVAL;=0A=20=09=09goto=20retry;=0A=20=09}=0A-out:=0A-=09=
path_put(&old_path);=0A=20=0A=20=09return=20error;=0A=20}=0A--=20=0A=
1.8.5.3=0A=0A=

--Apple-Mail=_6649DF39-E296-4077-8C4B-81087E0826F1--

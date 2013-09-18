Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3IRWNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:13:32 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43730 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3IRWNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:13:30 -0400
Date: Thu, 19 Sep 2013 02:13:04 +0400
From: Andrew Savchenko <bircoph@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        suspend-devel@lists.sourceforge.net
Subject: Re: [BUG] 3.7-rc regression bisected: s2disk fails to resume image:
 Processes could not be frozen, cannot continue resuming
Message-Id: <20130919021304.f99875ea88655f3ded008589@gmail.com>
In-Reply-To: <20130918191607.GO13318@ZenIV.linux.org.uk>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
	<20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
	<20130918135239.GL13318@ZenIV.linux.org.uk>
	<20130918224032.84e09e0c1372dbc51c86ab1e@gmail.com>
	<20130918191607.GO13318@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Sep_2013_02_13_04_+0400_nty3ITOZ+YF2rY.V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Sep_2013_02_13_04_+0400_nty3ITOZ+YF2rY.V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Sep 2013 20:16:07 +0100 Al Viro wrote:
> On Wed, Sep 18, 2013 at 10:40:32PM +0400, Andrew Savchenko wrote:
>=20
> > And from suspend_ioctls.h:
> > #define SNAPSHOT_IOC_MAGIC      '3'
> > #define SNAPSHOT_FREEZE                 _IO(SNAPSHOT_IOC_MAGIC, 1)
> >=20
> > My mistake, should be '3' instead of 3.
>=20
> OK...  The thing to test, then, is what does __usermodehelper_disable()
> return to freeze_processes().  If that's where this -EAGAIN comes from,
> we at least have a plausible theory re what's going on.
>=20
> freeze_processes() uses __usermodehelper_disable() to stop any new userla=
nd
> processes spawned by UMH (modprobe, etc.) and waits for ones it might be
> waiting for to complete.  Then it does try_to_freeze_tasks(), which
> freezes remaining userland, carefully skipping the current thread.
> However, it misses the possibility that current thread might have been
> spawned by something that had been launched by UMH, with UMH waiting
> for it.  Which is the case of everything spawned by linuxrc.
>=20
> I'd try something like diff below, but I'm *NOT* familiar with swsusp at
> all; it's not for mainline until ACKed by swsusp folks.
>=20
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index fb32636..d968882 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -571,7 +571,8 @@ int call_usermodehelper_exec(struct subprocess_info *=
sub_info, int wait)
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	int retval =3D 0;
> =20
> -	helper_lock();
> +	if (!(current->flags & PF_FREEZER_SKIP))
> +		helper_lock();
>  	if (!khelper_wq || usermodehelper_disabled) {
>  		retval =3D -EBUSY;
>  		goto out;
> @@ -611,7 +612,8 @@ wait_done:
>  out:
>  	call_usermodehelper_freeinfo(sub_info);
>  unlock:
> -	helper_unlock();
> +	if (!(current->flags & PF_FREEZER_SKIP))
> +		helper_unlock();
>  	return retval;
>  }
>  EXPORT_SYMBOL(call_usermodehelper_exec);

With this patch and 3.11.1 kernel resume works fine.

Best regards,
Andrew Savchenko

--Signature=_Thu__19_Sep_2013_02_13_04_+0400_nty3ITOZ+YF2rY.V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSOiWFAAoJEFZZU7lTcnVssosP/Az7NwjZm3geDn8vahQowaBP
XVWmks2oLFYMLSMxxUU/bU2bGhkaMmKlXq2IAK0skbvuWJUQbxPnurH+78cGzmvJ
uHmdRKcvzOWRujjvRzoYtquxzJqAfmldlj4NNya0pb7FGBQDuX4ZpoJry1nCUqzw
Z7rsIOluXmO1VdpG6qPswgJBFRWEZQjhpuUEICD38Y0j1osxWbqJ/bUQFI3PiDzQ
9itHrCp11p9qaw92QxevseyvkPPIPUTOPr/Mwqg+y/xekUDG3ROj/CsMEK+WAmOH
QeknC9FBvDc6owiOwbcKiaFa0TvyE98KKf+gt+hZ6ik3dnwHhHQU6pux0srpIaiD
Kvlh+0MqQEMxv5y2VlDIHdhWAlc0njRzUwvvXJBThPsGCN1Hxn9/r4ea31ISLcRP
+W74z9D02C9iAmVK+LHhUjeQA1ZAH/MfPtRn+SbdMHX45WzUkJr4mj3YvDDM+3t1
pqXAMozbe/4p2UwQTgIkenjfzGS0FURauDOR+iKqa6nGiCop761jFuArUsSlaTbe
2XsV3Lou95VQN72xEIOVDMW2iv99qLDTq4W1XJsJIoNQHRG3TdcOX2Z+OAhLneTz
x2XoHVEAcI2MXHeG1BX7DvcMzzzqpJeWrWlI5TpvbVBjqX+agZ3hjMVW3CZ0PPT1
4Xt727V9RJ0sN3ejkuPN
=UCWr
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Sep_2013_02_13_04_+0400_nty3ITOZ+YF2rY.V--

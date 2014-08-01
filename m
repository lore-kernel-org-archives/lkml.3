Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaHAUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:34:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58177 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbaHAUeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:34:03 -0400
Message-ID: <53DBF99D.1050803@gentoo.org>
Date: Fri, 01 Aug 2014 16:33:33 -0400
From: Richard Yao <ryao@gentoo.org>
Reply-To: "kernel@gentoo.org" <kernel@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>
CC: kernel@gentoo.org, mthode@mthode.org, michael@fds-team.de,
        drobbins@funtoo.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] vfs: Respect MS_RDONLY at bind mount creation
References: <1406916744-6634-1-git-send-email-ryao@gentoo.org> <1406916744-6634-2-git-send-email-ryao@gentoo.org> <20140801192017.GC1850@mguzik.redhat.com>
In-Reply-To: <20140801192017.GC1850@mguzik.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OHf7HMiNFv9UeUlkSwJevifOdEg9CLWK7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OHf7HMiNFv9UeUlkSwJevifOdEg9CLWK7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/01/2014 03:20 PM, Mateusz Guzik wrote:
> On Fri, Aug 01, 2014 at 02:12:24PM -0400, Richard Yao wrote:
>> `mount -o bind,ro ...` suffers from a silent failure where the readonl=
y
>> flag is ignored. The bind mount will be created rw whenever the target=

>> is rw. Users typically workaround this by remounting readonly, but tha=
t
>> does not work when you want to define readonly bind mounts in fstab.
>> This is a major annoyance when dealing with recursive bind mounts
>> because the userland mount command does not expose the option to
>> recursively remount a subtree as readonly.
>>
>> Signed-off-by: Richard Yao <ryao@gentoo.org>
>> ---
>>  fs/namespace.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index 182bc41..0d23525 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -1827,11 +1827,12 @@ static bool has_locked_children(struct mount *=
mnt, struct dentry *dentry)
>>   * do loopback mount.
>>   */
>>  static int do_loopback(struct path *path, const char *old_name,
>> -				int recurse)
>> +				unsigned long flags)
>>  {
>>  	struct path old_path;
>> -	struct mount *mnt =3D NULL, *old, *parent;
>> +	struct mount *mnt =3D NULL, *old, *parent, *m;
>>  	struct mountpoint *mp;
>> +	int recurse =3D flags & MS_REC;
>>  	int err;
>>  	if (!old_name || !*old_name)
>>  		return -EINVAL;
>> @@ -1871,6 +1872,10 @@ static int do_loopback(struct path *path, const=
 char *old_name,
>>  		goto out2;
>>  	}
>> =20
>> +	if (flags & MS_RDONLY)
>> +		for (m =3D mnt; m; m =3D (recurse ? next_mnt(m, mnt) : NULL))
>> +			mnt_make_readonly(m);
>> +
>>  	mnt->mnt.mnt_flags &=3D ~MNT_LOCKED;
>> =20
>>  	err =3D graft_tree(mnt, parent, mp);
>> @@ -2444,7 +2449,8 @@ long do_mount(const char *dev_name, const char *=
dir_name,
>>  		retval =3D do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
>>  				    data_page);
>>  	else if (flags & MS_BIND)
>> -		retval =3D do_loopback(&path, dev_name, flags & MS_REC);
>> +		retval =3D do_loopback(&path, dev_name, flags & (MS_REC |
>> +							       MS_RDONLY));
>>  	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE)=
)
>>  		retval =3D do_change_type(&path, flags);
>>  	else if (flags & MS_MOVE)
>=20
> I don't really know this code, but have to ask.
>=20
> Would not it be much better to pass down info about rdonly request to
> copy_tree/clone_mnt (perhaps CL_MOUNT_RDONLY flag or a separate flags
> argument) and handle it there?
>=20
> This would avoid fishy-looking traversal before graft_tree, which even
> if correct should not be necessary.
>=20

I have a nagging feeling that people doing backports will hate me for
adding a power of 2 plus 1 bit, but your suggestion makes this more
readable. I will send v3 after I finish my regression tests.


--OHf7HMiNFv9UeUlkSwJevifOdEg9CLWK7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJT2/mhAAoJECDuEZm+6Exk38IP/03UL46x+LniWZ+2u1dky/mz
vg5ZxThyQgxFeV2vap9br3Ai7CiuYSRhHiJAiv66GofDR1JeRsUexOxSj2hYh7DO
rQfgn7VNZ1nhcMae/UCDI7aI/S5YwMISYIbJ/gDkslt13uJyGhyu+U9p2xC1HMcC
1N5WreyQIo3DSfIS6O7kHTgXdNKn6dgHD6Aat3i0VCBMiQ6c9wXkCigbky+DCBmI
iHo36+zcMm68MK0SuFSol4yDMx2d2/ZEZUvYz2aYU9W8V4EVCIzbu5updVDqI78b
TrthP2drh9T8R9+ucB4H7bAL+PLiNCEHtKj1R9cnNj+aT7M7UxZDen1tyqY+gtIg
14+VQrLjdZMVkOmtHeQ/o87QtXfVe2xfSk1drd6GVeEGjA06Ki3+ihF4RX3mgcYt
1vo481OzajF36Sy3XutPo05l3he5YvjmkQy3WkYXLUe96Xayb0oaZdz8mTT4C9mR
cQfd3XRi/raxfH41ThRM3xG1qzjfURXjWKLSyPeRQdUeSg6ts85xSVmlEVC3d9lM
UmkoMrT10SgznJiCVMVD0FMK3c7YSoJ9uHlmJItRbIuDmE0EI+HQy3Ks5kOHEFF0
o/O32aNQKLLk6/DDXj8zDvuVzUZaQZU50gA6L1fNgh2bywbHc8Roe7/rV9JHp/KI
E55Lh+8fn0P6/DPvmgXr
=VKJQ
-----END PGP SIGNATURE-----

--OHf7HMiNFv9UeUlkSwJevifOdEg9CLWK7--

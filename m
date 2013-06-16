Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3FPArf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 20:47:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44467 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3FPArd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 20:47:33 -0400
Message-ID: <51BD0AFF.8010504@gentoo.org>
Date: Sat, 15 Jun 2013 20:46:55 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130522 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@gentoo.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/2] ocfs2: Fix llseek() semantics and do some cleanup
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org> <1371237814-59365-2-git-send-email-ryao@gentoo.org> <51BBF6FE.6080502@oracle.com>
In-Reply-To: <51BBF6FE.6080502@oracle.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EAWNNIBNFJJKCKPLILXC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EAWNNIBNFJJKCKPLILXC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/15/2013 01:09 AM, Jeff Liu wrote:
> [Add ocfs2-devel to CC-list]
>=20
> Hello Richard,
>=20
> Thanks for your patch.
>=20
> On 06/15/2013 03:23 AM, Richard Yao wrote:
>=20
>> There are multiple issues with the custom llseek implemented in ocfs2 =
for
>> implementing SEEK_HOLE/SEEK_DATA.
>>
>> 1. It takes the inode->i_mutex lock before calling generic_file_llseek=
(), which
>> is unnecessary.
>=20
> Agree, but please see my comments below.
>=20
>>
>> 2. It fails to take the filp->f_lock spinlock before modifying filp->f=
_pos and
>> filp->f_version, which differs from generic_file_llseek().
>>
>> 3. It does a offset > inode->i_sb->s_maxbytes check that permits seeki=
ng up to
>> the maximum file size possible on the ocfs2 filesystem, even when it i=
s past
>> the end of the file. Seeking beyond that (if possible), would return E=
INVAL
>> instead of ENXIO.
>>
>> 4. The switch statement tries to cover all whence values when in reali=
ty it
>> should only care about SEEK_HOLE/SEEK_DATA. Any other cases should be =
passsed
>> to generic_file_llseek().
>=20
> I have another patch set for refactoring ocfs2_file_llseek() but not ye=
t found time
> to run a comprehensive tests.  It can solve the existing issues but als=
o improved the
> SEEK_DATA/SEEK_HOLE for unwritten extents, i.e. OCFS2_EXT_UNWRITTEN.
>=20
> With this change, SEEK_DATA/SEEK_HOLE will go into separate function wi=
th a little code
> duplication instead of the current mix-ups in ocfs2_seek_data_hole_offs=
et(), i.e,=20
>=20
> loff_t ocfs2_file_llseek()
> {
> 	switch (origin) {
>         case SEEK_END:
>         case SEEK_CUR:
>         case SEEK_SET:
>                 return generic_file_llseek(file, offset, origin);
>         case SEEK_DATA:
>                 return ocfs2_seek_data(file, offset);
>         case SEEK_HOLE:
>                 return ocfs2_seek_hole(file, offset);
>         default:
>                 return -EINVAL;
>         }
> }
>=20
> I personally like keeping SEEK_DATA/SEEK_HOLE in switch...case style ra=
ther
> than dealing with them in a condition check block.

I would prefer to see the code structured like this:

loff_t ocfs2_file_llseek()
{
	switch (origin) {
        case SEEK_DATA:
                return ocfs2_seek_data(file, offset);
        case SEEK_HOLE:
                return ocfs2_seek_hole(file, offset);
        default:
                return generic_file_llseek(file, offset, origin);
        }
}

Unfortunately, I just noticed that this code has a problem. In specific,
generic_file_llseek() calls generic_file_llseek_size(), which has a
switch statement for whence that fails to distinguish between SEEK_SET
and invalid whence values. Invalid whence values are mapped to SEEK_SET
instead of returning EINVAL, which is wrong. That issue affects all
filesystems that do not specify a custom llseek() function and it would
affect ocfs2 if my version of the function is used.


------enig2EAWNNIBNFJJKCKPLILXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRvQsCAAoJECDuEZm+6ExksH0QAJsDfVZdQjSBDuC+hjV+ZGvZ
iAmso36jHyb8m/EdgY2Bi4w4SAlQF1Z4FSMFuPTwbSuNlYFgicaKjTyvUzJfuY9w
b9GW5efG0sDB24gqglHCxhUYTWLAjdwO2c0Xw/51rWROr+c4UaQ3cZlVK+/cUV7f
34x92ml4IXGh9IT0rXZYD3MucirUSA5cKvAFVXJ9MhA7KghV59dlJfYMxbBrTgTt
CU1jz5kdcEB1OahXfuRSwLMzp/O1xCOarXTI/EUN9Sm2CDVQn4P08msewpBSX+0j
ro9/hhoIMw5m5sd24XTHJocCPK3RrM4UH3gwxJdQa9DEBqmPRJM49J5x52mltznB
ht9oVD01pc+ojXazdWUSok4EFeQoBiNQGc5cakwpHRhUxmFmYi9t457UrKWY/GTb
In89ZhEY9yF11V6joD1gz0hHa7pVpJyWUJGvk5KoaNwSjIOP+YVMZa2vXjHnBZqJ
6Cvf1uQYVZ/7vISF8MTjG7a5W3TXAKxqnAEQUvuaxc5oJfqibWm6wcrpLijjvwk4
eEFLAFmxvrYqqN52feQDvZrgY7YCc5Vw24/kMwbJh2fi9tvNPC2TIWhIJQOAudOU
zRlS6sZi7f0L34O3xZsJRcCw7tD14Pdtbx/jusx4T94pW+7W8P5acQ7hn1aWxv4v
UKhgmhqmrTJCHmy4CODS
=v3r7
-----END PGP SIGNATURE-----

------enig2EAWNNIBNFJJKCKPLILXC--

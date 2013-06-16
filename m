Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3FPHR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 03:17:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56081 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab3FPHRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 03:17:54 -0400
Message-ID: <51BD6679.2090406@gentoo.org>
Date: Sun, 16 Jun 2013 03:17:13 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130522 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@gentoo.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/2] ocfs2: Fix llseek() semantics and do some cleanup
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org> <1371237814-59365-2-git-send-email-ryao@gentoo.org> <51BBF6FE.6080502@oracle.com> <51BD0AFF.8010504@gentoo.org> <51BD6288.5030901@oracle.com>
In-Reply-To: <51BD6288.5030901@oracle.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2RVNHMTWKAOONLALRGGND"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2RVNHMTWKAOONLALRGGND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/16/2013 03:00 AM, Jeff Liu wrote:
> On 06/16/2013 08:46 AM, Richard Yao wrote:
>=20
>> On 06/15/2013 01:09 AM, Jeff Liu wrote:
>>> [Add ocfs2-devel to CC-list]
>>>
>>> Hello Richard,
>>>
>>> Thanks for your patch.
>>>
>>> On 06/15/2013 03:23 AM, Richard Yao wrote:
>>>
>>>> There are multiple issues with the custom llseek implemented in ocfs=
2 for
>>>> implementing SEEK_HOLE/SEEK_DATA.
>>>>
>>>> 1. It takes the inode->i_mutex lock before calling generic_file_llse=
ek(), which
>>>> is unnecessary.
>>>
>>> Agree, but please see my comments below.
>>>
>>>>
>>>> 2. It fails to take the filp->f_lock spinlock before modifying filp-=
>f_pos and
>>>> filp->f_version, which differs from generic_file_llseek().
>>>>
>>>> 3. It does a offset > inode->i_sb->s_maxbytes check that permits see=
king up to
>>>> the maximum file size possible on the ocfs2 filesystem, even when it=
 is past
>>>> the end of the file. Seeking beyond that (if possible), would return=
 EINVAL
>>>> instead of ENXIO.
>>>>
>>>> 4. The switch statement tries to cover all whence values when in rea=
lity it
>>>> should only care about SEEK_HOLE/SEEK_DATA. Any other cases should b=
e passsed
>>>> to generic_file_llseek().
>>>
>>> I have another patch set for refactoring ocfs2_file_llseek() but not =
yet found time
>>> to run a comprehensive tests.  It can solve the existing issues but a=
lso improved the
>>> SEEK_DATA/SEEK_HOLE for unwritten extents, i.e. OCFS2_EXT_UNWRITTEN.
>>>
>>> With this change, SEEK_DATA/SEEK_HOLE will go into separate function =
with a little code
>>> duplication instead of the current mix-ups in ocfs2_seek_data_hole_of=
fset(), i.e,=20
>>>
>>> loff_t ocfs2_file_llseek()
>>> {
>>> 	switch (origin) {
>>>         case SEEK_END:
>>>         case SEEK_CUR:
>>>         case SEEK_SET:
>>>                 return generic_file_llseek(file, offset, origin);
>>>         case SEEK_DATA:
>>>                 return ocfs2_seek_data(file, offset);
>>>         case SEEK_HOLE:
>>>                 return ocfs2_seek_hole(file, offset);
>>>         default:
>>>                 return -EINVAL;
>>>         }
>>> }
>>>
>>> I personally like keeping SEEK_DATA/SEEK_HOLE in switch...case style =
rather
>>> than dealing with them in a condition check block.
>>
>> I would prefer to see the code structured like this:
>>
>> loff_t ocfs2_file_llseek()
>> {
>> 	switch (origin) {
>>         case SEEK_DATA:
>>                 return ocfs2_seek_data(file, offset);
>>         case SEEK_HOLE:
>>                 return ocfs2_seek_hole(file, offset);
>>         default:
>>                 return generic_file_llseek(file, offset, origin);
>>         }
>> }
>>
>> Unfortunately, I just noticed that this code has a problem. In specifi=
c,
>> generic_file_llseek() calls generic_file_llseek_size(), which has a
>> switch statement for whence that fails to distinguish between SEEK_SET=

>> and invalid whence values. Invalid whence values are mapped to SEEK_SE=
T
>> instead of returning EINVAL, which is wrong. That issue affects all
>> filesystems that do not specify a custom llseek() function and it woul=
d
>> affect ocfs2 if my version of the function is used.
>=20
> Hmm??  Did you mean to say that an invalid whence(i.e, whence > SEEK_MA=
X)
> can be passed into generic_file_llseek()?
> If so, I don't think that is a problem because any invalid whence shoul=
d
> be rejected at the entrance of VFS lseek(2) with EINVAL.
>=20
> Thanks,
> -Jeff
>=20

You are correct. I had not looked there.



------enig2RVNHMTWKAOONLALRGGND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRvWZ/AAoJECDuEZm+6ExkWCgP/2HIkulPwUGcpXdquWGp8zRG
d1iF8DU+Y4NhI6YVFl2XnZYJmFcudscHiCh1YVzr9ogl9sLyFmMgbYLzANdIp5dH
98BevSgdjykCZMxdK2FP47MUG/I5UW0OnniDScFAm0jr3UsGW2sqy+I3WQflHJSN
z4Ga/aoIkI/S5msJppeYwr4icDZFv7vxCwHWVuQXmduvfYvKuvF7kBuLaHefL+9U
30uuKHzyae4UXULwDS0KFX3y01V7psVxlPpyu3D2wTxxz9Y9aNdvumFyar2gf1ue
udS+TA2MSSzNj7L82yT2jzDaBJ58R359ltagpMyT1WkZd2EbeScgz3bv2PnCIaYA
jhz35OTbqShDo3Y9pUqaVzHcf3+K3YGUuF5Mz6BiJ59FrH7SSfS6Yp/z49oQ2yb6
myn9C45rSsgopEXA1B0cPpjlNGaT7rRpMs40iaI2Uyawd774EG9NnocbRw3I+1NM
tLSozkRYoqaBCj9AdAG2XdlaqwxlMBM7/TDklYfj+h1Q2g3jAgcCMgEGZEjY8+8b
C3brC0eEJeYwD8PKuQFz3GYOwlcZE2mpIL1WBMPXi0sqc9UL6ODk6maFy1gOrS0a
nQ9GM/7k6HGL5GB/HCblr1crjbQVoTUXVQNcjio7usQ12a3xUtMJeIoOhgVVAxv2
/DcV3VdFpV0Q+m+9Z0KR
=135+
-----END PGP SIGNATURE-----

------enig2RVNHMTWKAOONLALRGGND--

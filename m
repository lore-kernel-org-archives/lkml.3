Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaAOXcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:32:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaAOXcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:32:31 -0500
Message-ID: <52D719EC.5060604@suse.com>
Date: Wed, 15 Jan 2014 18:29:48 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, reiserfs-devel@vger.kernel.org
Subject: Re: [BUG 3.13.0-rc6] reiserfs possible circular locking dependency
References: <52C70C75.4050502@t-online.de> <CA+55aFxVs_aGnMdcTck3C7AayFrjX=GrFSwmJwiC9q3-3wySgw@mail.gmail.com> <52C733F0.7070103@suse.com>
In-Reply-To: <52C733F0.7070103@suse.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MLhNStKnq4KxMFH7xadBsixIa1G7b6ilb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MLhNStKnq4KxMFH7xadBsixIa1G7b6ilb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 1/3/14, 5:04 PM, Jeff Mahoney wrote:
> On 1/3/14, 2:46 PM, Linus Torvalds wrote:
>> On Fri, Jan 3, 2014 at 11:16 AM, Knut Petersen
>> <Knut_Petersen@t-online.de> wrote:
>>> Rebooting after a power failure on an openSuSE 13.1 system
>>> with kernel 3.13.0-rc6 triggered the attached lockdep warning.
>>
>> Hmm. It seems to be that the *normal* sequence should be:
>>
>>  - get i_mutex, call lookup, which gets sbi->lock (reiserfs_write_lock=
)
>>
>> but in the mounting path, we have special circumstances.
>>
>> That finish_unfinished() function does
>>
>>  - reiserfs_write_lock_nested() .
>>  - remove_save_link
>>  - iput(inode) with the write lock held
>>
>> and that can apparently end up taking i_mutex in open_xa_dir (and then=

>> recursively the write lock, but that's an explicitly recursive lock,
>> so that part should be ok).
>>
>> Now, I don't think this can *really* deadlock with the normal order of=

>> operations, because during mounting there is no other process that can=

>> take those in the reverse order (since the filesystem isn't live), but=

>> I do wonder if we should just release the reiserfs write lock over the=

>> iputs. We release it in other parts anyway (like for the quota off)
>>
>> Jeff, you already touched this exact case in commit d2d0395fd177
>> ("reiserfs: locking, release lock around quota operations") except
>> that was for those quota operation cases.
>>
>> Even if it's not a real problem, making lockdep happy sounds like a
>> good idea. Of course, the trouble is that this code path almost never
>> gets exercised (which is why this hasn't been noticed earlier), so
>> testing...
>>
>> Jeff? Comments?
>=20
> If someone ever invents a time machine, I'd go back to 2004 and tell
> myself to fight harder to make a reiserfs v3.7 with real extended
> attribute items. This code will haunt me to my death.
>=20
> Anyway, yeah. The right thing here is to drop the lock for the iput.
> More than that would be ok too. finish_unfinished happens when the file=

> system goes read-write and that includes the remount path. There can be=

> other users of the file system but it would be a recursive acquire so w=
e
> wouldn't actually deadlock there.
>=20
> I'll work something up over the weekend or on Monday.

As a quick update here, I do have patches to fix this particular issue
but it's tough to depend on xfstests to detect regressions when xfstests
causes other lockdep issues. I'm taking this an an opportunity to clean
up the locking enough to pass xfstests.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--MLhNStKnq4KxMFH7xadBsixIa1G7b6ilb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJS1xnsAAoJEB57S2MheeWy1xYP/2jmxoUUFUZXsfTXNf/15ip+
+tIarP0j3w0UqyJaAG1T5ghnlxTCPzrVGLVPU66cIqc4TPaaWbZd+73epZQNjvEO
Hvp1ZlXZS/kZtyNJ1hiJ5qegwLkthDgAk28Wb0Vhy2xpmqo+TdYWJniMfnclv5ex
bTzL63mt6ctUiNP5Md1jVI4KkrUea6WTahDD7UA6KWqzPf/UXKO9t9AJKIRLvNCI
4IqMwpRZFpIAgYutmOcvmkCH1gUwPPzJP46Odr59/o9RH3YqeZi8bkbaYAeD6kHd
G/542jXlPosdp2I9XeiSoFI3xDePZHCXCUHEUB6Rdg6mqvIDZhWZGJATlIOJx/Lv
98hB/ndP30jfmxqOJbe0m5XupiOytPXDqfInp1+xf7OExb6hcCi0Bb256wUhQe0w
AQu/J/zOlbmKYZRKEk+2SFZ0P0/KMbDO5jdqQZbzec1o7jFNF3g6dVadiBJSqpbH
mDvWxzXdu72S7u8lmPnRN+R0JdRaMqdjzJONr56Lqpn66wP6Ymqp9Qxo1TWnAaaa
lbQQN2Qxrd3j8ahZ5GHLOvRQjygAZ/Wir5T0hjkdUceE8O+QJIX/OIMM+r6ppet2
eVVf8IPD/nWbaBL54yBLwI5UTP3+Ip5OLgGSSNeZw3Az9M1IfyxJ+nxCzfAllYZk
GnE1OJ4jOqh7iEy7A13W
=gBw0
-----END PGP SIGNATURE-----

--MLhNStKnq4KxMFH7xadBsixIa1G7b6ilb--

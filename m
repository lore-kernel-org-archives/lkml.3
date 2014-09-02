Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaIBSBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:01:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:8084 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbaIBSBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:01:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="asc'?scan'208";a="585219386"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] moduleparam: Resolve missing-field-initializer warning
Thread-Topic: [PATCH] moduleparam: Resolve missing-field-initializer warning
Thread-Index: AQHPw4pZzEoPEIDn10CIM676vhmOcJvr7CQAgAKx+AA=
Date: Tue, 2 Sep 2014 18:01:31 +0000
Message-ID: <F8A4F5BF-C490-4099-9360-0C771451FF1D@intel.com>
References: <1409317709-5005-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <87ha0skvrj.fsf@rustcorp.com.au>
In-Reply-To: <87ha0skvrj.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.84]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_F6D90B93-5E52-4B16-A076-2162145D2B91";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_F6D90B93-5E52-4B16-A076-2162145D2B91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Aug 31, 2014, at 5:52 PM, Rusty Russell <rusty@rustcorp.com.au> =
wrote:

> Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:
>> From: Mark Rustad <mark.d.rustad@intel.com>
>>=20
>> Resolve a missing-field-initializer warning, that is produced
>> by every reference to module_param_call, by using designated
>> initialization for the first field. That is enough to silence
>> the complaint.
>>=20
>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>> include/linux/moduleparam.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Strange, I haven't seen this warning.  Compiler version?  And it's =
good
> to quote the error message, so people can google it.

The message is only seen when doing a W=3D2 build. I happened to be =
using gcc 4.8.3, but I think most versions would produce the warning =
when it is enabled. It can either be silenced by using even a single =
designated initializer as I did here, or providing values for all of the =
fields. Because of the number of references to the macro, this change =
silences many warnings in W=3D2 builds.

One instance of the full warning message looks like this:

/home/share/git/nn-mdr/include/linux/moduleparam.h:198:16: warning: =
missing initializer for field =91free=92 of =91struct kernel_param_ops=92 =
[-Wmissing-field-initializers]
  static struct kernel_param_ops __param_ops_##name =3D  \
                ^
/home/share/git/nn-mdr/fs/fuse/inode.c:35:1: note: in expansion of macro =
=91module_param_call=92
 module_param_call(max_user_bgreq, set_global_limit, param_get_uint,
 ^
/home/share/git/nn-mdr/include/linux/moduleparam.h:56:9: note: =91free=92 =
declared here
  void (*free)(void *arg);


> Cheers,
> Rusty.
>=20
>> diff --git a/include/linux/moduleparam.h =
b/include/linux/moduleparam.h
>> index 494f99e..d99a9e9 100644
>> --- a/include/linux/moduleparam.h
>> +++ b/include/linux/moduleparam.h
>> @@ -196,7 +196,7 @@ struct kparam_array
>> /* Obsolete - use module_param_cb() */
>> #define module_param_call(name, set, get, arg, perm)			=
\
>> 	static struct kernel_param_ops __param_ops_##name =3D		=
\
>> -		{ 0, (void *)set, (void *)get };			=
\
>> +		{ .flags =3D 0, (void *)set, (void *)get };		=
\

This could also be resolved by adding a ", NULL" to the initializer =
above instead of the designated initializer. The designated initializer =
means that if additional "optional" fields were to be added in the =
future, this would not have to be touched to avoid generating the =
warning. However you prefer it. If instead you would prefer to designate =
all fields, the formal parameter names would have to change, since get =
and set would get substituted for the field designators .get and .set.

>> 	__module_param_call(MODULE_PARAM_PREFIX,			=
\
>> 			    name, &__param_ops_##name, arg,		=
\
>> 			    (perm) + =
sizeof(__check_old_set_param(set))*0, -1)
>> --=20
>> 1.9.3

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_F6D90B93-5E52-4B16-A076-2162145D2B91
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUBgX6AAoJEDwO/+eO4+5ue3IP/1HLILl1E5m8jdo6XzAfmn27
Hywr2x6emUN3P1MXVyUDiNlZe+Dqrj3D56Gba5h4CTvNUKDCQRaumN3kE57aeCph
TIOep3ROYFLRO/tXR3/EhcDcKtg2aPyDVjmsoijkJVZnnOsorxXwxue+R8F3AuzV
EygHIIvFrhXVV6T3rcGHMHapQjoo29racio1MDBqpCbjbstY3QpJeS6aKm8DPGu7
UPc82uVDJ2wB5KA12tglaDONJ8CPZcTqBBb9ClDEcGmfKqoLlN+3VGJdk9/B5j/m
uS/g28h0O4dF+STdK8pEurriiMEOIQRdhapB8xfZMsRviLjehD6cilaK3sNzZrqL
Nt/0zGRW5aOlDC+G4Y5rrSl0hUmXtVaCXfva6x4JSk9fmeFU1meGrQ4fOThPH79D
jMjTpMrKX+/chx7rNQx7uwAj2dzJQ3vXgEWEPCqKNJl+GqTzSo9Tajj3W//fKH6n
oHmhaqOFl+Ahj/19P2PcOCt2VNL3GW4rpfT3P6nZQ1QwARsbeRg3hfeunamtfHNt
7eBUfGnbHXtWf81DDtLRJBK3SfKB7XlB4yzc0u925eB0LM2WTZ337I1SqYYeNldC
mG2Bemh3/cQkTKF7HWH87aT7RcUMZk6yLFL0IEff/0Mi5QXJ1zY5KxxETgERvxng
/Gmx9KxGTdJi5eSozCYy
=COsy
-----END PGP SIGNATURE-----

--Apple-Mail=_F6D90B93-5E52-4B16-A076-2162145D2B91--
